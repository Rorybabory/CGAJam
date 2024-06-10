class_name Vector2Resource
extends Resource

@export var _value: Vector2

var value: Vector2:
	get:
		return _value
	set(value):
		_value = value
		value_changed.emit(value)


signal value_changed(new_value: Vector2)
