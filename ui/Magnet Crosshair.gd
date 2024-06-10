extends Sprite2D


@export var magnet_cast_position: Vector2Resource


func _ready() -> void:
	magnet_cast_position.value_changed.connect(on_magnet_cast_position_changed)


func on_magnet_cast_position_changed(value: Vector2) -> void:
	global_position = Vector2(value.x, value.y)
