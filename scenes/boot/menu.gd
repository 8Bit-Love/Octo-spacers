extends Node2D


@onready var black_fade: ColorRect = $BlackFade
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic
@onready var play_button: TextureButton = $Play
@onready var play_menu: Control = $PlayMenu


func _ready() -> void:
	black_fade.visible = true
	black_fade.modulate.a = 1.0

	menu_music.volume_db = -40.0
	menu_music.play()

	play_button.pressed.connect(_on_play_pressed)

	await get_tree().create_timer(0.15).timeout
	_start_menu_reveal()


func _start_menu_reveal() -> void:
	var reveal := create_tween()

	reveal.tween_property(
		black_fade,
		"modulate:a",
		0.0,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	var music_fade := create_tween()

	music_fade.tween_property(
		menu_music,
		"volume_db",
		0.0,
		2.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)


func _on_play_pressed() -> void:
	print("PLAY BUTTON PRESSED")
	play_menu.open_window()
