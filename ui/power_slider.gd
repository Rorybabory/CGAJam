extends VSlider


@export var magnet_power: FloatResource


func _ready() -> void:
	magnet_power.value_changed.connect(set_value_no_signal)


func _on_drag_ended(value_changed: bool) -> void:
	magnet_power.value = value
