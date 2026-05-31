extends RigidBody3D

const FOOD_MAP = {
	preload("res://assets/food/raw/DrumstickRaw.fbx"):	preload("res://assets/food/cooked/DrumstickCooked.fbx"),
	preload("res://assets/food/raw/FishFilletRaw.fbx"):	preload("res://assets/food/cooked/FishFilletCooked.fbx"),
	preload("res://assets/food/raw/SteakRaw.fbx"):		preload("res://assets/food/cooked/SteakCooked.fbx"),
	# preload("res://assets/food/raw/WholeBirdRaw.fbx"):	preload("res://assets/food/cooked/WholeBirdCooked.fbx"),
}

@export var raw_scene: PackedScene
@export var cook_time: float = 8.0
@export var is_cooked: bool = false

@onready var _audio := $AudioStreamPlayer3D
@onready var _collision := $CollisionShape3D

var cook_progress: float = 0.0


func _ready() -> void:
	if raw_scene:
		add_child(raw_scene.instantiate())


func start_cooking() -> void:
	if not _audio.playing:
		_audio.play()


func stop_cooking() -> void:
	_audio.stop()


func swap_to_cooked() -> void:
	if is_cooked:
		return

	if not FOOD_MAP.has(raw_scene):
		push_error("No cooked version found for: " + str(raw_scene.resource_path))
		return

	is_cooked = true
	_audio.stop()

	for child in get_children():
		if child == _audio or child == _collision:
			continue
		child.queue_free()

	add_child(FOOD_MAP[raw_scene].instantiate())
