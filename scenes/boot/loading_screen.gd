extends Node2D

@onready var loading_bar: TextureProgressBar = $Background/TextureProgressBar
@onready var heart: Control = $Heart
@onready var glitch: ColorRect = $Glitch
@onready var complete_sound: AudioStreamPlayer2D = $CompleteSound
@onready var black_fade: ColorRect = $BlackFade


func _ready() -> void:
	# Initial state
	loading_bar.value = 0.0

	heart.visible = false

	glitch.visible = false
	glitch.modulate.a = 1.0
	glitch.color = Color.TRANSPARENT

	# Black overlay starts invisible
	black_fade.visible = true
	black_fade.modulate.a = 0.0

	# Start animations
	_start_loading_sequence()
	_start_neon_pulse()


# --------------------------------------------------
# LOADING BAR
# --------------------------------------------------

func _start_loading_sequence() -> void:
	var tween := create_tween()

	# Smooth 0% → 100%
	tween.tween_property(
		loading_bar,
		"value",
		100.0,
		4.0
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	tween.finished.connect(_on_loading_finished)


# --------------------------------------------------
# COMPLETION
# --------------------------------------------------

func _on_loading_finished() -> void:
	# Show the heart
	heart.visible = true

	# Start tiny and invisible
	heart.scale = Vector2(0.1, 0.1)
	heart.modulate.a = 0.0

	var heart_tween := create_tween()

	# Fade in + pop
	heart_tween.parallel().tween_property(
		heart,
		"modulate:a",
		1.0,
		0.25
	).set_trans(Tween.TRANS_SINE)

	heart_tween.parallel().tween_property(
		heart,
		"scale",
		Vector2(1.15, 1.15),
		0.35
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	# Settle
	heart_tween.tween_property(
		heart,
		"scale",
		Vector2(1.0, 1.0),
		0.18
	).set_trans(Tween.TRANS_SINE)

	# Tiny pause after heart
	heart_tween.tween_interval(0.15)

	# Completion sound
	complete_sound.play()

	# Tiny dramatic pause
	heart_tween.tween_interval(0.25)

	# Start glitch
	heart_tween.tween_callback(_glitch)


# --------------------------------------------------
# AGGRESSIVE GLITCH
# --------------------------------------------------

func _glitch() -> void:
	glitch.visible = true
	glitch.color = Color.TRANSPARENT

	# 8 rapid-fire glitch bursts
	for burst in range(8):
		_create_glitch_burst()

		await get_tree().create_timer(0.08).timeout

	# Final massive bursts
	_create_glitch_burst()
	_create_glitch_burst()

	# Let final pieces exist briefly
	await get_tree().create_timer(0.12).timeout

	# Clean everything
	for child in glitch.get_children():
		child.queue_free()

	glitch.visible = false

	# NOW transition into cinematic black
	_black_fade()


# --------------------------------------------------
# AGGRESSIVE GLITCH BURST
# --------------------------------------------------

func _create_glitch_burst() -> void:
	var pieces := randi_range(25, 45)

	for i in range(pieces):
		var piece := ColorRect.new()

		var width := randf_range(40.0, 700.0)
		var height := randf_range(4.0, 35.0)

		# Occasionally create huge horizontal slices
		if randf() < 0.15:
			width = randf_range(700.0, 1800.0)
			height = randf_range(5.0, 45.0)

		var x := randf_range(-100.0, 1920.0 - width + 100.0)
		var y := randf_range(0.0, 1080.0 - height)

		piece.position = Vector2(x, y)
		piece.size = Vector2(width, height)

		var glitch_colors := [
			Color(1.0, 0.0, 0.55, 0.95),
			Color(1.0, 0.05, 0.85, 0.95),
			Color(0.75, 0.0, 1.0, 0.95),
			Color(1.0, 0.0, 0.3, 0.9),
			Color(0.9, 0.4, 1.0, 0.9),
			Color.WHITE
		]

		piece.color = glitch_colors[randi() % glitch_colors.size()]
		piece.mouse_filter = Control.MOUSE_FILTER_IGNORE

		glitch.add_child(piece)

		# Violent horizontal displacement
		var original_x := piece.position.x
		var offset_x := randf_range(-250.0, 250.0)

		var piece_tween := create_tween()

		piece_tween.tween_property(
			piece,
			"position:x",
			original_x + offset_x,
			0.025
		).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)

		piece_tween.tween_property(
			piece,
			"modulate:a",
			0.0,
			0.10
		)

		piece_tween.tween_callback(piece.queue_free)


# --------------------------------------------------
# NEON PULSE
# --------------------------------------------------

func _start_neon_pulse() -> void:
	var pulse := create_tween()
	pulse.set_loops()

	pulse.tween_property(
		loading_bar,
		"modulate",
		Color(1.15, 0.85, 1.15, 1.0),
		0.7
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	pulse.tween_property(
		loading_bar,
		"modulate",
		Color.WHITE,
		0.7
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

# --------------------------------------------------
# CINEMATIC BLACK
# --------------------------------------------------

func _black_fade() -> void:
	black_fade.visible = true
	black_fade.modulate.a = 0.0

	var fade_tween := create_tween()

	# Very fast snap into darkness
	fade_tween.tween_property(
		black_fade,
		"modulate:a",
		1.0,
		0.08
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)

	# Hold the darkness
	fade_tween.tween_interval(0.5)

	# Move into the Main Menu
	fade_tween.tween_callback(_open_main_menu)


# --------------------------------------------------
# OPEN MAIN MENU
# --------------------------------------------------

func _open_main_menu() -> void:
	get_tree().change_scene_to_file("res://scenes/boot/Menu.tscn")
