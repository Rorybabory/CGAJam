extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Light.light_energy = lerpf($Light.light_energy, 15, delta * 8)
	pass


func _on_trigger_body_entered(body):
	if (body.is_in_group("Garbage")):
		$Explosion.pitch_scale = randf_range(0.6, 1.2)
		$Explosion.play()
		body.queue_free()
		$Light.light_energy = 180
	pass # Replace with function body.
