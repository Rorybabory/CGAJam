extends Sprite3D

var interval : float = randf_range(0.1, 0.5)
var timer : float = 0.0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer += delta
	if (timer > interval):
		timer = 0
		interval = randf_range(0.1, 0.5)
		flip_h = not flip_h
	pass
