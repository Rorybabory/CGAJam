extends Magnetizable


const magnetized_damping: float = 10
const magnet_force: float = 300


func _magnet_interact(power: float, position: Vector3) -> void:
	
	var to_magnet = (global_position - position).normalized()
	
	linear_damp = abs(power) * magnetized_damping
	
	apply_central_force(to_magnet * power * magnet_force)


func _stop_magnet_interact() -> void:
	linear_damp = 0
