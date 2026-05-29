extends CharacterBody3D

## Movement
@export var walk_speed: float = 5.0
@export var sprint_speed: float = 9.0
@export var jump_velocity: float = 5.0
@export var acceleration: float = 10.0
@export var friction: float = 12.0

## Mouse look
@export var mouse_sensitivity: float = 0.002

## Gravity (uses project default if 0)
@export var gravity_scale: float = 1.0

@onready var cam: Camera3D = $Camera3D

var _gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _unhandled_input(event: InputEvent) -> void:
	if GameState.inventory_open:
		return
		
	if event is InputEventMouseMotion:
		_handle_mouse_look(event.relative)

	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	if Input.is_action_just_pressed("ui_cancel") and \
			Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_movement(delta)
	move_and_slide()


# ── Private helpers ──────────────────────────────────────────────────────────

func _handle_mouse_look(relative: Vector2) -> void:
	# Rotate the body left / right
	rotate_y(-relative.x * mouse_sensitivity)
	# Tilt the camera up / down, clamped to avoid flipping
	cam.rotate_x(-relative.y * mouse_sensitivity)
	cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-89.0), deg_to_rad(89.0))


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= _gravity * gravity_scale * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


func _handle_movement(delta: float) -> void:
	var speed: float = sprint_speed \
		if Input.is_action_pressed("sprint") \
		else walk_speed

	# Build wish direction in local space, then transform to world space
	var input_dir := Input.get_vector(
		"move_left", "move_right",
		"move_forward", "move_back"
	)
	var wish_dir := (
		transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)
	).normalized()

	if wish_dir != Vector3.ZERO:
		velocity.x = move_toward(velocity.x, wish_dir.x * speed, acceleration * delta)
		velocity.z = move_toward(velocity.z, wish_dir.z * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0.0, friction * delta)
		velocity.z = move_toward(velocity.z, 0.0, friction * delta)
