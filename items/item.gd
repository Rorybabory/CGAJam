extends Magnetizable


func _magnet_interact(power: float, position: Vector3) -> void:
	
	var to_magnet = (global_position - position).normalized()
	
	add_constant_central_force(to_magnet * power)
