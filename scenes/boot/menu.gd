extends Node2D

@onready var black_fade: ColorRect = $BlackFade
@onready var cover_art: TextureRect = $CoverArt
@onready var menu_music: AudioStreamPlayer2D = $MenuMusic


func _ready() -> void:
	# Start completely black
	black_fade.visible = true
	black_fade.modulate.a = 1.0

	# Start music almost silent
	menu_music.volume_db = 16.0
	menu_music.play()

	# Give the scene a tiny moment to settle
	await get_tree().create_timer(0.15).timeout

	_start_menu_reveal()


func _start_menu_reveal() -> void:
	var reveal := create_tween()

	# Slowly reveal the artwork
	reveal.tween_property(
		black_fade,
		"modulate:a",
		0.0,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	# Music fades in at the same time
	var music_fade := create_tween()

	music_fade.tween_property(
		menu_music,
		"volume_db",
		0.0,
		2.5
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
