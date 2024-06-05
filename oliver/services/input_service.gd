class_name InputService
extends Service


signal input_received(event: InputEvent)


func _input(event: InputEvent) -> void:
	input_received.emit(event)
