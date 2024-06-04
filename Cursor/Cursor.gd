extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass # Replace with function body.

func _input(event):
	if (event is InputEventMouseMotion):
		position = floor(event.position/2.0) * 2.0
		
		print("cursor pos:" + str(position) + " mouse position: " + str(event.position))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
