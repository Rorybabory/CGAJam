extends Node3D


@export var powerPerScroll: float
@export var label: Label


var power: float


func _unhandled_input(event: InputEvent) -> void:

	if event.is_action("scroll_down"):
		power -= powerPerScroll

	if event.is_action("scroll_up"):
		power += powerPerScroll


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	label.text = "power is " + str(power)
