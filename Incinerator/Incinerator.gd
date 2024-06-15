extends Node3D

var timer : float = 0.0
var timerTarget : float = 0.5
var lightValue : float = 15
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if (timer > timerTarget):
		timer = 0
		timerTarget = randf_range(0.04, 0.3)
		lightValue = randf_range(8, 30)
	$Light.light_energy = lerpf($Light.light_energy, lightValue, delta * 8)
	pass


func _on_trigger_body_entered(body):
	if (body.is_in_group("Garbage")):
		$Explosion.pitch_scale = randf_range(0.6, 1.2)
		$Explosion.play()
		body.queue_free()
		$Light.light_energy = 280
		
	pass # Replace with function body.
