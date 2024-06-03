class_name Player
extends CharacterBody3D

var _mouse_position : Vector2 = Vector2(0,0)
var _mouse_velocity : Vector2 = Vector2(0,0)
var dragging : bool = false

var SPEED = 12
var ROTATE_SPEED = 8

@onready var cameraHeight = $Node3D/Camera3D.position.y
var cameraOffset = 0.0

var moveTimer = 0.0

func _ready():
	pass

func normalized_mouse():
	var mousePos = _mouse_position

	mousePos /= get_viewport().get_visible_rect().size


	mousePos.x = clamp(mousePos.x, 0.0, 1.0)
	mousePos.y = clamp(mousePos.y, 0.0, 1.0)

	return mousePos;
	pass

func _input(event):
	if event is InputEventMouseMotion and dragging:
		_mouse_velocity = event.relative
	if (event is InputEventMouse):
		_mouse_position = event.position

	if event.is_action_pressed("action"):
		if (normalized_mouse().x <= 0 or normalized_mouse().x >= 1 or
			normalized_mouse().y <= 0 or normalized_mouse().y >= 1):
				return
		dragging = true;
	elif event.is_action_released("action"):
		dragging = false;
		_mouse_velocity = Vector2(0,0)


func _process(delta):
	var target_velocity = Vector3(0,0,0)
	var mousePos = normalized_mouse()
	if (dragging):
		var offset = -(mousePos.x-0.5);
		if (abs(offset) > 0.1):
			if (mousePos.y < 0.85):
				rotate(Vector3(0,1,0), offset * delta * ROTATE_SPEED)
			else:
				var right = -transform.basis.x;
				target_velocity = Vector3(right.x, 0, right.z) * delta * offset * SPEED * 500
				moveTimer += delta * 30
				cameraOffset += sin(moveTimer) * delta * (mousePos.y-0.85) * 4.0
				pass
		if (mousePos.y < 0.15):
				var forward = -transform.basis.z;
				target_velocity = Vector3(forward.x, 0, forward.z) * delta * (0.15-mousePos.y) * SPEED * 1000
				moveTimer += delta * 30
				cameraOffset += sin(moveTimer) * delta * (0.15-mousePos.y) * 8.0
		if (mousePos.y > 0.85 and abs(offset) < 0.1):
				var forward = -transform.basis.z;
				target_velocity = Vector3(forward.x, 0, forward.z) * delta * (mousePos.y-0.85) * -SPEED * 1000
				moveTimer += delta * 30
				cameraOffset += sin(moveTimer) * delta * (mousePos.y-0.85) * 8.0
	velocity = velocity.lerp(target_velocity, delta * 5)

	$Node3D/Camera3D.position.y = cameraHeight+cameraOffset

	move_and_slide();
	print("dragging: " + str(dragging) + " | x: " + str(mousePos.x) + " y: " + str(mousePos.y) + " | x vel: " + str(_mouse_velocity.x) + " y vel: " + str(_mouse_velocity.y))
	pass