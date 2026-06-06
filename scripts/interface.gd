extends Control


@onready var inventory_panel: Control = $InventoryPanel

func _ready() -> void:
	inventory_panel.visible = false

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		GameState.inventory_open = not GameState.inventory_open
		inventory_panel.visible = GameState.inventory_open
