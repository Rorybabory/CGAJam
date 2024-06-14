extends Node3D


@export var power_per_scroll: float
@export var mouse_delta_power: Vector2
@export var arm_range_min: Vector3
@export var arm_range_max: Vector3
@export var power: FloatResource
@export var input_service: InputService
@export var cursor_raycast: RayCast3D
@export var magnet_cast_position: Vector2Resource


var vertical_percent: float:
	get: 
		return inverse_lerp(arm_range_min.y, arm_range_max.y, position.y)


func _ready() -> void:
	input_service.input_received.connect(on_input_received)


func _physics_process(_delta: float) -> void:
	var cast_point = cursor_raycast.get_collision_point()
	var camera = get_viewport().get_camera_3d()
	var screen_point = camera.unproject_position(cast_point)
	magnet_cast_position.value = screen_point


func on_input_received(event: InputEvent):
	scroll_input(event)
	drag_input(event)


func scroll_input(event: InputEvent) -> void:

	var scroll_target = (
		1 if event.is_action("scroll_up")
		else -1 if event.is_action("scroll_down")
		else 0
	)

	# no scrolling
	if scroll_target == 0:
		return

	if Input.is_action_pressed("magnet_drag"):
		scroll_target = arm_range_max.z if scroll_target < 0 else arm_range_min.z
		position.z = move_toward(position.z, scroll_target, power_per_scroll)
	else:
		power.value = move_toward(power.value, scroll_target, power_per_scroll)


func drag_input(event: InputEvent):

	if not event is InputEventMouseMotion or not Input.is_action_pressed("magnet_drag"):
		return

	var _mouse_delta = event.relative
	var delta =  Vector2(_mouse_delta.x, -_mouse_delta.y) * mouse_delta_power

	var target = Vector2(
		arm_range_min.x if delta.x < 0 else arm_range_max.x,
		arm_range_min.y if delta.y < 0 else arm_range_max.y
	)

	position.x = move_toward(position.x, target.x, abs(delta.x))
	position.y = move_toward(position.y, target.y, abs(delta.y))
