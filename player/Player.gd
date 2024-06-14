class_name Player
extends CharacterBody3D

signal mouse_changed(mousePosition : Vector2);

var test_object = preload("res://Sprites/test_object.tscn")



var dragging : bool = false

var VERTICAL_TILT_RANGE = 30
var SPEED = 4
var ROTATE_SPEED = 8
var GRAVITY = -9.81

var target_velocity = Vector2(0,0)

@onready var cameraHeight = $CameraPivot/Camera3D.position.y
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

func pickupObject():
	var from = $CameraPivot/Camera3D.project_ray_origin(get_viewport().get_mouse_position())
	var to = from + $CameraPivot/Camera3D.project_ray_normal(get_viewport().get_mouse_position()) * 1000
	var query = PhysicsRayQueryParameters3D.create(from, to)
	var result = get_world_3d().direct_space_state.intersect_ray(query)
	if (result):
		if (result.collider.is_in_group("Pickupable")):
			#print("hit object: " + result.collider.name)
			result.collider.queue_free()
			Cursor.activeTexture = result.collider.get_node("Sprite").texture
			Cursor.holdingObject = true
	#print(Cursor.testStr)
func throwObject():
	Cursor.holdingObject = false
	Cursor.activeTexture = null
	var instance = test_object.instantiate()
	get_node("../").add_child(instance)
	var normal_vector = $CameraPivot/Camera3D.project_ray_normal(get_viewport().get_mouse_position())
	var cam_origin = $CameraPivot/Camera3D.global_position
	instance.global_position = cam_origin + normal_vector * 5
	instance.linear_velocity = normal_vector * 10
	
func handle_input(delta):
	#if mouse down and inside viewport
	if (Input.is_action_just_pressed("action") and 
		(mousePos.x > 0 and mousePos.x < 1 and
		 mousePos.y > 0 and mousePos.y < 1)):
		dragging = true
		#print("started dragging at pos: " + str(mousePos) )
	if (Input.is_action_just_released("action")):
		dragging = false
	if (Input.is_action_just_pressed("pickup")):
		if (not Cursor.holdingObject):
			pickupObject()
		#else:
			#throwObject()
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
				target_velocity = Vector3(forward.x, 0, forward.z) * delta * (mousePos.y-0.6) * -SPEED * 1000
				moveTimer += delta * 30
				cameraOffset += sin(moveTimer) * delta * (mousePos.y-0.6) * 8.0
		
func _process(delta):
	target_velocity = Vector3(0,0,0)
	normalized_mouse()

	if (not is_on_floor()):
		velocity.y += GRAVITY
	else:
		velocity.y = 0
	handle_input(delta)

	velocity.x = lerp(velocity.x, target_velocity.x, delta * 5)
	velocity.z = lerp(velocity.z, target_velocity.z, delta * 5)
	
	$CameraPivot/Camera3D.position.y = cameraHeight+cameraOffset
	if (velocity.length() < 2):
		cameraOffset = lerpf(cameraOffset, 0.0, delta * 10.0)

	
	var tilt_percent = $"CameraPivot/Magnet Arm".vertical_percent
	$CameraPivot.rotation_degrees.x = VERTICAL_TILT_RANGE * (tilt_percent - 0.5)


	move_and_slide();
	pass
