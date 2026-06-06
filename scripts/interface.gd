extends Control


@onready var inventory_panel: Control = $InventoryPanel
@onready var pause_menu = $PauseMenu
@onready var resume_button = $PauseMenu/VBoxContainer/ResumeButton
@onready var quit_button = $PauseMenu/VBoxContainer/QuitButton


func _ready() -> void:
	GameState.inventory_toggled.connect(_on_inventory_toggled)
	GameState.pause_toggled.connect(_on_pause_toggled)
	process_mode = Node.PROCESS_MODE_ALWAYS

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("inventory"):
		GameState.inventory_open = not GameState.inventory_open
	elif event.is_action_pressed("pause_menu"):
		GameState.paused = not GameState.paused
	

func _on_inventory_toggled(is_open: bool) -> void:
	inventory_panel.visible = is_open


func _on_pause_toggled(is_paused: bool) -> void:
	pause_menu.visible = is_paused


func _on_resume_button_pressed() -> void:
	GameState.paused = false

func _on_quit_button_pressed() -> void:
	get_tree().quit()
