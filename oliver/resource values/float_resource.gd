class_name FloatResource
extends Resource

@export var _value: float

var value: float:
	get:
		return _value
	set(value):
		_value = value
		value_changed.emit(value)


signal value_changed(new_value: float)
