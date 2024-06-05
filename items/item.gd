extends Magnetizable


const snap_distance: float = 1
const magnetized_damping: float = 10
const magnet_force: float = 100


func _magnet_physics_process(power: float, position: Vector3) -> void:

	var to_magnet: Vector3 = global_position - position
	
	linear_damp = abs(power) * magnetized_damping

	apply_central_force(to_magnet * power * magnet_force)


func _magnet_process(power: float, position: Vector3) -> void:

	var to_magnet: Vector3 = global_position - position

	freeze = to_magnet.length() < snap_distance and power < 0
	if freeze:
		global_position = position
	


func _stop_magnet_interact() -> void:
	linear_damp = 0
