extends Magnetizable


const snap_distance: float = 1
const magnetized_damping: float = 10
const magnet_force: float = 6.5

var magnet_velocity : Vector3 = Vector3(0,0,0)

var lastFreeze = false

func is_damaging() -> bool:
	return damaging

var damaging: bool


func _integrate_forces(_state):
	linear_velocity += magnet_velocity
	#linear_velocity += state.total_gravity
	

func _magnet_physics_process(power: float, target_pos: Vector3, direction: Vector3) -> void:
	var to_magnet: Vector3 = (global_position - target_pos).normalized()
	
	if (power > 0):
		to_magnet = direction
		
	linear_damp = abs(power) * magnetized_damping
	var distance_percent = (25.0-global_position.distance_to(target_pos))/25.0
	magnet_velocity = to_magnet * power * magnet_force * distance_percent
	
	damaging = power > 0
	
func _magnet_process(power: float, target_pos : Vector3) -> void:
	var to_magnet: Vector3 = global_position - target_pos

	freeze = to_magnet.length() < snap_distance and power < 0

	if (freeze == true and lastFreeze == false):
		Console.message("PICKED UP OBJECT")
	elif (freeze == false and lastFreeze == true):
		Console.message("THROW OBJECT")

	if freeze:
		global_position = target_pos
		linear_velocity = Vector3.ZERO
	lastFreeze = freeze

func _stop_magnet_interact() -> void:
	linear_damp = 0
	freeze = false
	magnet_velocity = Vector3.ZERO
	damaging = false
