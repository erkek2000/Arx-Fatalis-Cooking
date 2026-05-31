extends Area3D

@export var cook_force: float = 1.0
@export var min_distance: float = 0.5

var _cooking: Dictionary = {}
var _shape_node: CollisionShape3D = null


func _ready() -> void:
	for child in get_children():
		if child is CollisionShape3D:
			_shape_node = child
			break

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	for body in get_overlapping_bodies():
		_on_body_entered(body)


func _process(delta: float) -> void:
	var origin: Vector3 = _shape_node.global_position if _shape_node else global_position
	var radius: float = _get_radius()

	for body in _cooking.keys():
		if not is_instance_valid(body):
			_cooking.erase(body)
			continue

		if body.is_cooked:
			continue

		var dist: float = origin.distance_to(body.global_position)
		var t: float = clampf(1.0 - ((dist - min_distance) / (radius - min_distance)), 0.0, 1.0)
		var rate: float = cook_force * t

		body.cook_progress += delta * rate

		if body.cook_progress >= body.cook_time:
			body.swap_to_cooked()
			_cooking.erase(body)


func _on_body_entered(body: Node) -> void:
	if not body.has_method("swap_to_cooked"):
		return

	if body.is_cooked:
		return

	if body in _cooking:
		return

	_cooking[body] = true
	body.start_cooking()
	print("Started cooking: ", body.name)


func _on_body_exited(body: Node) -> void:
	if not body in _cooking:
		return

	_cooking.erase(body)
	body.stop_cooking()
	print("Food left before finishing: ", body.name)


func get_cook_progress(body: Node) -> float:
	if not body.has_method("swap_to_cooked"):
		return 0.0

	if body.is_cooked:
		return 1.0

	return clampf(body.cook_progress / body.cook_time, 0.0, 1.0)


func _get_radius() -> float:
	if _shape_node and _shape_node.shape is SphereShape3D:
		var s := _shape_node.global_transform.basis.get_scale()
		return _shape_node.shape.radius * maxf(s.x, maxf(s.y, s.z))
	return 1.0
