class_name MagnetAttraction
extends Area3D


@export var magnet_power: FloatResource

var magnetizables: Array[Magnetizable] 

func _on_body_entered(body: Node3D) -> void:
	if body is Magnetizable:
		magnetizables.append(body)


func _on_body_exited(body: Node3D) -> void:
	
	var index = magnetizables.find(body)
	
	if index != -1:
		magnetizables.remove_at(index)



func _physics_process(delta: float) -> void:
	for magnetizable in magnetizables:
		magnetizable._magnet_interact(magnet_power.value, global_position)
