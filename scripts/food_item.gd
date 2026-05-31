extends RigidBody3D

enum FoodType { DRUMSTICK, FISH_FILLET, STEAK, WHOLE_BIRD }

const COLLISION_NODES = {
	FoodType.DRUMSTICK:		"CollisionShapeDrumstick",
	FoodType.FISH_FILLET:	"CollisionShapeFishFillet",
	FoodType.STEAK:			"CollisionShapeSteak",
	FoodType.WHOLE_BIRD:	"CollisionShapeWholeBird",
}

const RAW_NODES = {
	FoodType.DRUMSTICK:		"DrumstickRaw",
	FoodType.FISH_FILLET:	"FishFilletRaw",
	FoodType.STEAK:			"SteakRaw",
	FoodType.WHOLE_BIRD:	"WholeBirdRaw",
}

const COOKED_NODES = {
	FoodType.DRUMSTICK:		"DrumstickCooked",
	FoodType.FISH_FILLET:	"FishFilletCooked",
	FoodType.STEAK:			"SteakCooked",
	FoodType.WHOLE_BIRD:	"WholeBirdCooked",
}

@export var food_type: FoodType = FoodType.DRUMSTICK
@export var cook_time: float = 8.0
@export var is_cooked: bool = false

@onready var _audio := $AudioStreamPlayer3D

var cook_progress: float = 0.0


func _ready() -> void:
	# Hide all visuals and disable all collisions
	for node_name in RAW_NODES.values():
		get_node_or_null(node_name).hide()
	for node_name in COOKED_NODES.values():
		get_node_or_null(node_name).hide()
	for child in get_children():
		if child is CollisionShape3D:
			child.disabled = true

	# Show the right raw visual and enable the right collision
	get_node(RAW_NODES[food_type]).show()
	get_node(COLLISION_NODES[food_type]).disabled = false


func start_cooking() -> void:
	if not _audio.playing:
		_audio.play()


func stop_cooking() -> void:
	_audio.stop()


func swap_to_cooked() -> void:
	if is_cooked:
		return

	is_cooked = true
	_audio.stop()

	get_node(RAW_NODES[food_type]).hide()
	get_node(COOKED_NODES[food_type]).show()
