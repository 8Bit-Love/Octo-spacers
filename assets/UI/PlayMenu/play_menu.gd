extends Control


@onready var close_button: TextureButton = find_child("Close", true, false) as TextureButton
@onready var new_game_button: TextureButton = find_child("NewGame", true, false) as TextureButton
@onready var continue_button: TextureButton = find_child("Continue", true, false) as TextureButton


func _ready() -> void:
	visible = false

	print("=== PLAY MENU ===")
	print("Close: ", close_button)
	print("NewGame: ", new_game_button)
	print("Continue: ", continue_button)

	if close_button:
		close_button.pressed.connect(_on_close_pressed)

	if new_game_button:
		new_game_button.pressed.connect(_on_new_game_pressed)

	if continue_button:
		continue_button.pressed.connect(_on_continue_pressed)


func open_window() -> void:
	print("🔥 PLAY MENU OPEN CALLED")
	visible = true


func _on_close_pressed() -> void:
	print("🔥 CLOSE PRESSED")
	visible = false


func _on_new_game_pressed() -> void:
	print("🔥 NEW GAME PRESSED")


func _on_continue_pressed() -> void:
	print("🔥 CONTINUE PRESSED")
