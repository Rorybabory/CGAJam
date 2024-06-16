extends Node


@export var level_scene_parent: Node

@export var start_scene: PackedScene

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_pressed() -> void:
	var scene_instance = start_scene.instantiate()
	level_scene_parent.add_child(scene_instance)
	queue_free()


func _on_exit_pressed() -> void:
	get_tree().quit()
