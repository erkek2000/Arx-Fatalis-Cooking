extends Node

signal inventory_toggled(is_open: bool)
signal pause_toggled(is_paused: bool)

var inventory_open: bool = false :
	set(value):
		inventory_open = value
		inventory_toggled.emit(value)
		_update_mouse_mode()

var paused: bool = false :
	set(value):
		paused = value
		get_tree().paused = value
		pause_toggled.emit(value)
		_update_mouse_mode()

func _update_mouse_mode() -> void:
	Input.set_mouse_mode(
		Input.MOUSE_MODE_VISIBLE if (inventory_open or paused)
		else Input.MOUSE_MODE_CAPTURED
	)
