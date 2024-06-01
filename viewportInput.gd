extends Node3D

@onready var camera = $mainViewport/GameView/Viewport/Level/Player

func _input(event):
	camera._input(event)
