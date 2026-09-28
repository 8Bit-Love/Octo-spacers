extends Control


@onready var close_button: TextureButton = $Background/Close

var is_animating := false
var click_sound: AudioStreamPlayer


func _ready() -> void:
	visible = false

	# Create click sound player
	click_sound = AudioStreamPlayer.new()
	click_sound.stream = load("res://assets/sfx/clic.mp3")
	add_child(click_sound)

	print("=== CREDITS MENU ===")
	print("Close: ", close_button)
	print("Click sound: ", click_sound.stream)

	if close_button:
		close_button.pressed.connect(_on_close_pressed)
	else:
		print("❌ CLOSE BUTTON NOT FOUND!")


func _play_click() -> void:
	if click_sound and click_sound.stream:
		click_sound.play()


func open_window() -> void:
	if is_animating:
		return

	print("🔥 CREDITS MENU OPEN CALLED")

	_play_click()

	is_animating = true
	visible = true

	modulate.a = 0.0
	scale = Vector2(0.82, 0.82)

	var tween := create_tween()

	tween.tween_property(
		self,
		"modulate:a",
		1.0,
		0.12
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"scale",
		Vector2(1.06, 1.06),
		0.22
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"scale",
		Vector2(1.0, 1.0),
		0.12
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	await tween.finished

	is_animating = false


func _on_close_pressed() -> void:
	if is_animating:
		return

	print("🔥 CREDITS CLOSE PRESSED")

	_play_click()

	is_animating = true

	var tween := create_tween()

	tween.tween_property(
		self,
		"scale",
		Vector2(0.90, 0.90),
		0.16
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)

	tween.parallel().tween_property(
		self,
		"modulate:a",
		0.0,
		0.12
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)

	await tween.finished

	visible = false
	is_animating = false
