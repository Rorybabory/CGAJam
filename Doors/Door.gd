extends Node3D


@export var open_offset: Vector3
@export var open_speed: float
@export var trigger_node: EventNode


var _original_position: Vector3
var _open: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_original_position = position
	trigger_node.event.connect(toggle_door)


func toggle_door() -> void:
	_open = not _open


func _process(delta: float) -> void:
	var target = _original_position + (open_offset if _open else Vector3.ZERO)
	global_position = global_position.move_toward(target, open_speed * delta)
