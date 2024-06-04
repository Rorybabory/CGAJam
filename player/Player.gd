class_name Player
extends CharacterBody3D

signal mouse_changed(mousePosition : Vector2);

var _mouse_position : Vector2 = Vector2(0,0)
var _mouse_velocity : Vector2 = Vector2(0,0)
var dragging : bool = false

var SPEED = 4
var ROTATE_SPEED = 8
var GRAVITY = -9.81

var target_velocity = Vector2(0,0)

@onready var cameraHeight = $Node3D/Camera3D.position.y
var cameraOffset = 0.0

var moveTimer = 0.0

var mousePos = Vector2(0,0)

func _ready():
	pass

func normalized_mouse():
	mousePos = get_viewport().get_mouse_position()

	mousePos /= get_viewport().get_visible_rect().size


	mousePos.x = clamp(mousePos.x, 0.0, 1.0)
	mousePos.y = clamp(mousePos.y, 0.0, 1.0)
	mouse_changed.emit(mousePos)


func _input(event):
	pass
	#if event.is_action_pressed("action"):
		#if (mousePos.x <= 0 or mousePos.x >= 1 or
			#mousePos.y <= 0 or mousePos.y >= 1):
				#return
		#dragging = true;
	#elif event.is_action_released("action"):
		#dragging = false;
		#_mouse_velocity = Vector2(0,0)


func handle_input(delta):
	#if mouse down and inside viewport
	if (Input.is_action_just_pressed("action") and 
		(mousePos.x > 0 and mousePos.x < 1 and
		 mousePos.y > 0 and mousePos.y < 1)):
		dragging = true
		print("started dragging at pos: " + str(mousePos) )
	if (Input.is_action_just_released("action")):
		dragging = false
		
	
	if (dragging):
		var offset = -(mousePos.x-0.5);
		#print("offset: " + str(offset))
		if (offset > 0.1):
			offset -= 0.1
		elif (offset < -0.1):
			offset += 0.1
		if (abs((mousePos.x-0.5)) > 0.1):
			if (mousePos.y < 0.85):
				rotate(Vector3(0,1,0), offset * delta * ROTATE_SPEED)
			else:
				var right = -transform.basis.x;
				target_velocity = Vector3(right.x, 0, right.z) * delta * offset * SPEED * 500
				moveTimer += delta * 30
				cameraOffset += sin(moveTimer) * delta * (mousePos.y-0.85) * 4.0
				pass
		if (mousePos.y < 0.4):
				var forward = -transform.basis.z;
				target_velocity = Vector3(forward.x, 0, forward.z) * delta * (0.4-mousePos.y) * SPEED * 1000
				moveTimer += delta * 30
				cameraOffset += sin(moveTimer) * delta * (0.15-mousePos.y) * 8.0
		if (mousePos.y > 0.6 and abs((mousePos.x-0.5)) < 0.1):
				var forward = -transform.basis.z;
				target_velocity = Vector3(forward.x, 0, forward.z) * delta * (mousePos.y-0.85) * -SPEED * 1000
				moveTimer += delta * 30
				cameraOffset += sin(moveTimer) * delta * (mousePos.y-0.85) * 8.0
		
func _process(delta):
	target_velocity = Vector3(0,0,0)
	normalized_mouse()

	if (not is_on_floor()):
		velocity.y += GRAVITY
	handle_input(delta)

	velocity.x = lerp(velocity.x, target_velocity.x, delta * 5)
	velocity.z = lerp(velocity.z, target_velocity.z, delta * 5)
	
	$Node3D/Camera3D.position.y = cameraHeight+cameraOffset

	move_and_slide();
	pass
