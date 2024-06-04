class_name InputService
extends Service


signal input(event: InputEvent)


func _input(event: InputEvent) -> void:
	input.emit(event)
