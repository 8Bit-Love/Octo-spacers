extends Control

@onready var animation_player: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.animation_finished.connect(_on_animation_finished)


func _on_animation_finished(animation_name: StringName) -> void:
	if animation_name == &"launch_intro":
		get_tree().change_scene_to_file("res://scenes/boot/LoadingScreen.tscn")
