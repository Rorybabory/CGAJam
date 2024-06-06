class_name MagnetAttraction
extends Area3D


@export var magnet_power: FloatResource

var magnetizables: Array[Magnetizable] 

var target_color = Color(1,1,1)
func _on_body_entered(body: Node3D) -> void:
	if body is Magnetizable:
		magnetizables.append(body)


func _on_body_exited(body: Node3D) -> void:

	if not body is Magnetizable:
		return

	var index = magnetizables.find(body)
	
	if index != -1:
		magnetizables.remove_at(index)
		body._stop_magnet_interact()


func _physics_process(delta: float) -> void:
	for magnetizable in magnetizables:
		magnetizable._magnet_physics_process(magnet_power.value, global_position, -get_global_transform().basis.z)


func _process(delta: float) -> void:
	var mat = get_node("../Mesh").get_active_material(0)
	if (magnet_power.value == 0.0):
		target_color = Color(1,1,1)
	else:
		target_color = Color(1,0,1).lerp(Color(0,1,1), (magnet_power.value + 1.0)/2.0)
	mat.albedo_color = mat.albedo_color.lerp(target_color, delta * 3)
	print("Mesh Color: " + str(mat.albedo_color))
	for magnetizable in magnetizables:
		magnetizable._magnet_process(magnet_power.value, global_position)
