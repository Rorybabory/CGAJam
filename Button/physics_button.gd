extends Area3D


@export var press_animator: AnimationPlayer
@export var event_node: EventNode

var pressing: Array[Node3D]


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Button Pressers"):
		pressing.append(body)
		update_animation()


func _on_body_exited(body: Node3D) -> void:

	var index = pressing.find(body)

	if index != -1:
		pressing.remove_at(index)
		update_animation()


#func _ready() -> void:
	#press_animator.play("press")
	#press_animator.speed_scale = 0


func update_animation() -> void:
	if pressing.size() > 0:
		press_animator.play("press", -1, 1)
		event_node.event.emit()
	else:
		press_animator.play("press", -1, -1, true)
		event_node.event.emit()
