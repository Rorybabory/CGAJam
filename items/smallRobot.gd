extends Node

@onready var root : RigidBody3D = get_node("../")
@onready var player : CharacterBody3D = get_node("../../Player")

var mainTexture = preload("res://Sprites/rover.png")
var sleepTexture = preload("res://Sprites/rover_sleep.png")

var active : bool = false
var speed : float = 6.0
var onFloor : bool = false

var asleep : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("../Sprite3D").texture = sleepTexture
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (asleep):
		get_node("../Sprite3D").texture = sleepTexture
		if (player.global_position.distance_squared_to(root.global_position) < 50):
			asleep = false
			get_node("../SecurityAudio").play()
		return
	else:
		get_node("../Sprite3D").texture = mainTexture
	if (root == null):
		print("Small Robot has non-rigidbody parent")
		return
	var direction : Vector3 = Vector3(1,0,0)
	
	direction = (player.global_position - root.global_position).normalized()
	
	var vel : Vector3 = (direction * speed)
	
	if (get_node("../FloorCheck").is_colliding() and root.magnet_velocity.length() < 1.0):
		root.linear_velocity = Vector3(vel.x, root.linear_velocity.y, vel.z)
	
	pass


func _on_floor_check_body_entered(body):
	onFloor = true


func _on_floor_check_body_exited(body):
	onFloor = false
