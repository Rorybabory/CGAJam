extends Camera3D

var _mouse_position : Vector2 = Vector2(0,0)

var dragging : bool = false

func _ready():
	pass

func _input(event):
	if event is InputEventMouseMotion and dragging:
		_mouse_position = event.relative

	if event.is_action_pressed("action"):
		dragging = true;
	elif event.is_action_released("action"):
		dragging = false;
		_mouse_position = Vector2(0,0)

	
func _process(delta):
	print("dragging: " + str(dragging) + " | x: " + str(_mouse_position.x) + " y: " + str(_mouse_position.y))
	pass
