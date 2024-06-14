extends Node

@onready var root : RigidBody3D = get_node("../")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if (root == null):
		print("Small Robot has non-rigidbody parent")
		return
	
	pass
