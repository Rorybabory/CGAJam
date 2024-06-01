extends Node3D

@onready var camera = $mainViewport/GameView/Viewport/Level/Camera3D

func _input(event):
	camera._input(event)
