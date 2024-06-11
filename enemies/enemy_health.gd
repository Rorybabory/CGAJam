extends Area3D


@export var max_health: int
@export var current_health: int
@export var death_event: EventNode


func _ready() -> void:
	current_health = max_health


func _on_body_entered(body: Node3D) -> void:

	if current_health <= 0:
		return

	if body.is_in_group("Damages") and body.has_method("is_damaging") and body.is_damaging():
		current_health -= 1

		if current_health <= 0:
			death_event.event.emit()
