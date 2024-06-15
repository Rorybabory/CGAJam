extends Node

@onready var root : RigidBody3D = get_node("../")
@onready var player : CharacterBody3D = get_node("../../Player")

var active : bool = false
var speed : float = 6.0
var onFloor : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
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
