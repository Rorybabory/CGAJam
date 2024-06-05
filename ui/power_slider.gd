extends VSlider


@export var magnet_power: FloatResource


func _ready() -> void:
	magnet_power.value_changed.connect(set_value_no_signal)


func set_slider_value(new_value: float) -> void:
	set_value_no_signal(new_value)


func _on_value_changed(value: float) -> void:
	magnet_power.value = value
