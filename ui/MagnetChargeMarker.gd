extends Sprite2D


@export var power: FloatResource
@export var vertical_range: float


func _ready() -> void:
	power.value_changed.connect(on_power_changed)
	update_position(0)


func on_power_changed(value: float) -> void:
	update_position(value)


func update_position(power: float) -> void:
	position = Vector2(position.x, -vertical_range * power)
