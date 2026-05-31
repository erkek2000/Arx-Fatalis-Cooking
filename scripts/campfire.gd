extends Node3D

# --- Cooking ---
@export var cook_force: float = 1.0
@export var min_distance: float = 0.5

# --- Light flicker ---
@export_group("Light Energy")
@export var energy_min: float = 1.2
@export var energy_max: float = 2.8

@export_group("Light Range")
@export var range_min: float = 4.0
@export var range_max: float = 7.0

@export_group("Light Color")
@export var color_cool: Color = Color(1.0, 0.3, 0.02)
@export var color_hot:  Color = Color(1.0, 0.85, 0.35)

@export_group("Flicker")
@export var flicker_speed: float = 2.4

@onready var _light        = $OmniLight3D
@onready var _cooking_area = $CookingArea


func _ready() -> void:
	_cooking_area.cook_force    = cook_force
	_cooking_area.min_distance  = min_distance

	_light.energy_min    = energy_min
	_light.energy_max    = energy_max
	_light.range_min     = range_min
	_light.range_max     = range_max
	_light.color_cool    = color_cool
	_light.color_hot     = color_hot
	_light.flicker_speed = flicker_speed
