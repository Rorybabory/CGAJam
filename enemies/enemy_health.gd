extends Area3D


@export var max_health: int
@export var current_health: int
@export var death_event: EventNode
signal health_damaged
signal health_died

func _ready() -> void:
	current_health = max_health


func _on_body_entered(body: Node3D) -> void:

	if current_health <= 0:
		return

	if body.is_in_group("Damages") and body.has_method("is_damaging") and body.is_damaging():
		current_health -= 1
		health_damaged.emit()
		body.queue_free()
		if current_health <= 0:
			Console.message("ENEMY KILLED")
			health_died.emit()
			death_event.event.emit()
