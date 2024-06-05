extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (Cursor.activeTexture):
		texture = Cursor.activeTexture
	else:
		texture = null
	position = floor(((get_viewport().get_mouse_position())+Vector2(0,30))/4.0)*4.0
	pass
