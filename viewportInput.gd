extends Node3D

@onready var camera = $Viewport/Camera3D

func _input(event):
	camera._input(event)
