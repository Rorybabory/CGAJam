class_name MagnetAttraction
extends Area3D


@export var magnet_power: FloatResource
#@export var magnetize_dot: float
const magnetize_dot: float = 0.75

var magnetizables: Array[Magnetizable] 
var pulling: Magnetizable

@onready var parent: Node3D = get_node("../")

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


func get_cross(magnetizable: Magnetizable) -> float:
	
	var toObject = magnetizable.global_position - parent.global_position
	toObject.y = 0
	var _forward = forward
	_forward.z = 0
	var dot = toObject.normalized().dot(forward.normalized())
	
	return dot


func within_view(magnetizable: Magnetizable) -> bool:
	return get_cross(magnetizable) > magnetize_dot


func by_cross(m1: Magnetizable, m2: Magnetizable) -> bool:
	return get_cross(m2) < get_cross(m1)


func _physics_process(_delta: float) -> void:

	var valid = magnetizables.filter(within_view)
	valid.sort_custom(by_cross)

	if valid.size() == 0:
		return

	if magnet_power.value < 0:

		if not valid.has(pulling):
			pulling = null

		if pulling == null:
			pulling = valid[0]

		if pulling != null:
			pulling._magnet_physics_process(magnet_power.value, global_position, forward)

	else:
		for magnetizable in valid:
			magnetizable._magnet_physics_process(magnet_power.value, global_position, forward)
			


func _process(delta: float) -> void:
	
	var mat = get_node("../Mesh").get_active_material(0)
	
	if (magnet_power.value == 0.0):
		target_color = Color(1,1,1)
	else:
		target_color = Color(1,0,1).lerp(Color(0,1,1), (magnet_power.value + 1.0)/2.0)

	mat.albedo_color = mat.albedo_color.lerp(target_color, delta * 3)

	if magnet_power.value < 0:
		if pulling != null:
			pulling._magnet_process(magnet_power.value, global_position)
	
	else:
		for magnetizable in magnetizables.filter(within_view):
			magnetizable._magnet_process(magnet_power.value, global_position)

