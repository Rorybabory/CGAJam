class_name MagnetAttraction
extends Area3D


@export var magnet_power: FloatResource
#@export var magnetize_dot: float
const magnetize_dot: float = 0.75

var magnetizables: Array[Magnetizable] 
var pulling: Magnetizable


var forward: Vector3:
	get: 
		return -get_global_transform().basis.z

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


func within_view(object: Magnetizable) -> bool:
	
	var toObject = object.global_position - global_position
	var dot = toObject.normalized().dot(forward)
	
	print(dot)
	
	return dot > magnetize_dot


func _physics_process(delta: float) -> void:

	var valid = magnetizables.filter(within_view)
	print(valid.size())

	if valid.size() == 0:
		return

	if magnet_power.value > 0:
		for magnetizable in valid:
			magnetizable._magnet_physics_process(magnet_power.value, global_position, forward)
			global_rotation

	else:
		if pulling == null and valid.size() > 0:
			pulling = valid[0]
		
		if pulling != null:
			pulling._magnet_physics_process(magnet_power.value, global_position, forward)


func _process(delta: float) -> void:
	var mat = get_node("../Mesh").get_active_material(0)
	if (magnet_power.value == 0.0):
		target_color = Color(1,1,1)
	else:
		target_color = Color(1,0,1).lerp(Color(0,1,1), (magnet_power.value + 1.0)/2.0)
	mat.albedo_color = mat.albedo_color.lerp(target_color, delta * 3)
	#print("Mesh Color: " + str(mat.albedo_color))
	for magnetizable in magnetizables:
		magnetizable._magnet_process(magnet_power.value, global_position)
