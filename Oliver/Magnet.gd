extends Node3D


@export var input: Input_Service
@export var power_per_scroll: float
@export var mouse_delta__power: float
@export var label: Label


@export var power: ResourceFloat
var _mouse_delta: Vector2


func _input(event: InputEvent) -> void:

	if event.is_action("scroll_down"):
		power.value -= power_per_scroll 

	if event.is_action("scroll_up"):
		power.value += power_per_scroll


func _process(delta: float) -> void:
	label.text = "_power is " + str(power.value)

	position += Vector3(_mouse_delta.x, -_mouse_delta.y, 0) * delta * mouse_delta__power

