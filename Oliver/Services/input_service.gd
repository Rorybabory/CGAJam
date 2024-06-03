class_name Input_Service
extends Service


@export var value: float


signal mouse_motion(event: InputEventMouseMotion)


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouse_motion.emit(event)
