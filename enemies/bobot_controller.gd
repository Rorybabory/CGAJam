extends CharacterBody3D


@export var speed: float
@export var target: Node3D
@export var agent: NavigationAgent3D
@export var death_event: EventNode


func _ready() -> void:
	death_event.event.connect(die)


func _physics_process(delta: float) -> void:
	
	agent.target_position = target.global_position
	
	var current_position = global_position
	var next_position = agent.get_next_path_position()
	var direction = (next_position - current_position).normalized()

	velocity = direction * speed
	
	move_and_slide()


func die() -> void:
	queue_free()
