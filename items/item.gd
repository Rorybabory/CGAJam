extends Magnetizable


const snap_distance: float = 1
const magnetized_damping: float = 10
const magnet_force: float = 10

var magnet_velocity : Vector3 = Vector3(0,0,0)


func _integrate_forces(state):
	linear_velocity += magnet_velocity
	#linear_velocity += state.total_gravity
	

func _magnet_physics_process(power: float, position: Vector3, direction: Vector3) -> void:

	var to_magnet: Vector3 = (global_position - position).normalized()
	
	if (power > 0):
		to_magnet = direction
	linear_damp = abs(power) * magnetized_damping
	var distance_percent = (25.0-global_position.distance_to(position))/25.0
	magnet_velocity = to_magnet * power * magnet_force * distance_percent
	
func _magnet_process(power: float, position: Vector3) -> void:
	var to_magnet: Vector3 = global_position - position

	freeze = to_magnet.length() < snap_distance and power < 0

	if freeze:
		global_position = position


func _stop_magnet_interact() -> void:
	linear_damp = 0
	freeze = false
	magnet_velocity = Vector3.ZERO
