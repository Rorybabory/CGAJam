extends Sprite2D
var mousePos = Vector2(0,0)
var cursorTextures = {
	"forward" : preload("res://Cursor/forward.png"),
	"backward" : preload("res://Cursor/backward.png"),
	"strafe_left" : preload("res://Cursor/strafe_left.png"),
	"strafe_right" : preload("res://Cursor/strafe_right.png"),
	"turn_left_run" : preload("res://Cursor/turn_left_run.png"),
	"turn_right_run" : preload("res://Cursor/turn_right_run.png"),
	"turn_right" : preload("res://Cursor/turn_right.png"),
	"turn_left" : preload("res://Cursor/turn_left.png"),
}

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	pass # Replace with function body.
func normalized_mouse():
	mousePos = get_viewport().get_mouse_position()
	
	mousePos *= Vector2(320.0/288.0, 200.0/168.0)

	mousePos /= get_viewport().get_visible_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	normalized_mouse()
	if (Cursor.activeTexture):
		texture = Cursor.activeTexture
		scale = Vector2(4,4)
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		if (mousePos.x > 1.0 or mousePos.y > 1.0):
			texture = null;
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		elif (mousePos.x < 0.4 and mousePos.y > 0.85):
			texture = cursorTextures["strafe_left"]
		elif (mousePos.x > 0.6 and mousePos.y > 0.85):
			texture = cursorTextures["strafe_right"]
		elif (mousePos.x < 0.4 and mousePos.y < 0.4):
			texture = cursorTextures["turn_left_run"]
		elif (mousePos.x > 0.6 and mousePos.y < 0.4):
			texture = cursorTextures["turn_right_run"]
		elif (mousePos.x > 0.6):
			texture = cursorTextures["turn_right"]
		elif (mousePos.x < 0.4):
			texture = cursorTextures["turn_left"]
		elif (mousePos.y < 0.4):
			texture = cursorTextures["forward"]
		elif (mousePos.y > 0.4):
			texture = cursorTextures["backward"]
		
		scale = Vector2(2,2)
	position = floor(((get_viewport().get_mouse_position())+Vector2(0,16))/4.0)*4.0
	#print(str(mousePos))
	pass
