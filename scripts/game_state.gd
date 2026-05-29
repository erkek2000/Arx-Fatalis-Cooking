extends Node

signal inventory_toggled(is_open: bool)

var inventory_open: bool = false :
	set(value):
		inventory_open = value
		Input.set_mouse_mode(
			Input.MOUSE_MODE_VISIBLE if value
			else Input.MOUSE_MODE_CAPTURED
		)
		inventory_toggled.emit(value)
