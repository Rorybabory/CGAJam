extends CharacterBody3D


@export var speed: float
@export var target: Node3D
@export var agent: NavigationAgent3D
@export var death_event: EventNode
@export var walkInterval: float = 1.0
enum states {STANDING, WALKING, ATTACKING}

var currentState = states.WALKING
var stateTimer : float = 0.0
var sprites = {
	"standing" = preload("res://enemies/bobot_sprites/standing.png"), 
	"walking" = preload("res://enemies/bobot_sprites/walking.png"), 
	"attack1" = preload("res://enemies/bobot_sprites/attack1.png"), 
	"attack2" = preload("res://enemies/bobot_sprites/attack2.png"), 
	"attack3" = preload("res://enemies/bobot_sprites/attack3.png")
}


func _ready() -> void:
	death_event.event.connect(die)


func _physics_process(delta: float) -> void:
	
	agent.target_position = target.global_position
	
	var current_position = global_position
	var next_position = agent.get_next_path_position()
	var direction = (next_position - current_position).normalized()

	velocity = direction * speed
	
	move_and_slide()

func _process(delta):
	stateTimer += delta
	match (currentState):
		states.STANDING:
			pass
		states.WALKING:
			$Sprite3D.texture = sprites["walking"]
			if (stateTimer > walkInterval):
				stateTimer = 0
			$Sprite3D.flip_h = stateTimer < (walkInterval/2.0)
		states.ATTACKING:
			pass

func die() -> void:
	queue_free()
