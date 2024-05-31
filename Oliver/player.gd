extends CharacterBody3D

@export var curve: Curve

@export var head: Node3D

@export var move_distance: float
@export var move_time: float

var direction: Vector3
var move_start: Vector3
var move_end: Vector3

var turn_start: Vector3
var turn_end: Vector3

var move_percent: float

var state: State
enum State {
	IDLE,
	MOVING,
	TURNING,
}


func set_state(new_state: State):
	state = new_state


func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	direction = Vector3.FORWARD


func _physics_process(delta):

	match state:

		State.IDLE:

			# Rotate left
			if Input.is_action_just_pressed("move_left"):
				turn_start = direction
				turn_end = direction.rotated(Vector3.UP, deg_to_rad(90))
				move_percent = 0
				set_state(State.TURNING)

			# Rotate right
			if Input.is_action_just_pressed("move_right"):
				turn_start = direction
				turn_end = direction.rotated(Vector3.UP, deg_to_rad(-90))
				move_percent = 0
				set_state(State.TURNING)

			# Move forward
			if Input.is_action_just_pressed("move_up"):
				move_start = transform.origin
				move_end = transform.origin + direction * move_distance
				move_percent = 0
				set_state(State.MOVING)

			# Move backward
			if Input.is_action_just_pressed("move_down"):
				move_start = transform.origin
				move_end = transform.origin - direction * move_distance
				move_percent = 0
				set_state(State.MOVING)

			velocity = Vector3.ZERO

		State.MOVING:

			move_percent += delta / move_time
			var target = lerp(move_start, move_end, curve.sample(move_percent))

			velocity = (target - transform.origin) / delta

			# Return to idle
			if move_percent >= 1.0:
				set_state(State.IDLE)

		State.TURNING:

			move_percent += delta / move_time
			direction = turn_start.slerp(turn_end, curve.sample(move_percent))

			if move_percent >= 1.0:
				set_state(State.IDLE)

	move_and_slide()

	# Rotate head towards direction
	head.global_basis = Basis.looking_at(direction)


func _on_wall_detection_body_entered(body: Node3D) -> void:
	pass
	#if state is State.
#
