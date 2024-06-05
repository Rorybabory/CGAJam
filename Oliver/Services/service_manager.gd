extends Node


@export var services: Array[Service]


func _process(delta: float) -> void:
	for service in services:
		service._process(delta)


func _input(event: InputEvent) -> void:
	for service in services:
		service._input(event)
