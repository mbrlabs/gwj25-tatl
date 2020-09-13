class_name Player
extends KinematicBody

# ---------------------------------------------------------------------------------------
const ROTATION_SPEED = 4.0
const HOVER_TRESHHOLD = 0.05

# ---------------------------------------------------------------------------------------
enum MovementState {
	IDLE,
	ACCELERATING,
	MOVING
}

# ---------------------------------------------------------------------------------------
export var evirorment: Environment 
export var input_enabled := true
export(float, 0.0, 1.0) var glowiness = 1.0 setget _set_glowiness
export var mouse_sensitivity := 1.0
export var camera_zoom_increments := 0.1
export var camera_max_zoom_increments := 10
export var camera_lag := 8.0
export var speed := 5.0
export var acceleration_factor := 20.0
export var deceleration_factor := 4.0
export var gravity := 1.5
export var hover_strength := 4.0
export var hover_height := 1.0

# ---------------------------------------------------------------------------------------
onready var _sound_move: AudioStreamPlayer3D = $MoveSound
onready var _sound_turn: AudioStreamPlayer3D = $TurnSound
onready var _gimbal: Spatial = $Gimbal
onready var _camera: Camera = $Gimbal/Camera
onready var _actual_orb: Spatial = $CollisionShape
onready var _orb_mesh: Spatial = $CollisionShape/MeshInstance
onready var _raycast_down: RayCast = $RayCastDown
onready var _raycast_up: RayCast = $RayCastUp
onready var _dir_light: DirectionalLight = $Gimbal/Camera/DirectionalLight

# ---------------------------------------------------------------------------------------
var _base_ambient_light: float
var _base_dir_light_energy: float
var _base_player_emission: float

var _mouse_movement: Vector2
var _velocity: Vector3
var _camera_lag_velocity: Vector3
var _movement_state = MovementState.IDLE
var _turn_accumulator := 0.0

# ---------------------------------------------------------------------------------------
func _ready():
	_camera.environment = evirorment
	_base_dir_light_energy = _dir_light.light_energy 
	_base_player_emission = _orb_mesh.material_override.get_shader_param("emission_energy")
	
# ---------------------------------------------------------------------------------------
func _set_glowiness(new_glowiness: float) -> void:
	glowiness = new_glowiness
	_dir_light.light_energy = _base_dir_light_energy * glowiness
	_orb_mesh.material_override.set_shader_param("emission_energy", _base_player_emission*glowiness)
	
# ---------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	var prev_velocity = _velocity
	
	# do input and calc move velocity
	var move_velocity: Vector3
	if input_enabled:
		_aim_camera(delta)
		move_velocity = _get_move_velocity(delta)
	_apply_camera_lag(delta)
	move_velocity = _apply_hover(move_velocity)
	
	# move
	_velocity = move_and_slide(move_velocity, Vector3.UP)
	
	# TODO: clean this up!
	# crappy movment state management
	if _movement_state == MovementState.IDLE && _velocity.length() > prev_velocity.length():
		_movement_state = MovementState.ACCELERATING
	elif _movement_state == MovementState.ACCELERATING:
		if !_sound_move.playing: _sound_move.play()
		_movement_state = MovementState.MOVING
	elif _movement_state == MovementState.MOVING:
		_turn_accumulator += (1.0 - _velocity.normalized().dot(prev_velocity.normalized()))
		if _turn_accumulator >= 0.033 && !_sound_turn.playing:
			_sound_turn.play()
			_turn_accumulator = 0.0
		var vel_length = _velocity.length()
		if vel_length < prev_velocity.length() && vel_length <  0.5:
			_movement_state = MovementState.IDLE
	
# ---------------------------------------------------------------------------------------
func _input(e: InputEvent) -> void:
	if input_enabled && e is InputEventMouseMotion:
		_mouse_movement += e.relative

# ---------------------------------------------------------------------------------------
func _get_move_velocity(delta: float) -> Vector3:
	var direction := _get_move_direction()
	var target := direction * speed
	var move_velocity = Vector3(_velocity.x, 0, _velocity.z)
	var acceleration = deceleration_factor
	if direction.dot(move_velocity) > 0:
		acceleration = acceleration_factor
	move_velocity = move_velocity.linear_interpolate(target, acceleration * delta)
	return move_velocity

# ---------------------------------------------------------------------------------------
func _apply_hover(move_velocity: Vector3) -> Vector3:
	var down_distance := _ray_col_dist(_raycast_down)
	var down_delta := hover_height - down_distance
	if abs(down_delta) > HOVER_TRESHHOLD:
		if down_delta < 0:
			move_velocity.y = down_delta * gravity
		else:
			move_velocity.y = down_delta * hover_strength
	else:
		move_velocity.y = 0
	return move_velocity

# ---------------------------------------------------------------------------------------
func _apply_camera_lag(delta: float) -> void:
	var direction := _get_move_direction()
	var target := direction * speed
	var move_velocity = Vector3(_camera_lag_velocity.x, 0, _camera_lag_velocity.z)
	var acceleration = deceleration_factor
	if direction.dot(move_velocity) > 0:
		acceleration = acceleration_factor
	acceleration *= 0.25
	_camera_lag_velocity = move_velocity.linear_interpolate(target, acceleration * delta)
	_gimbal.translation = - (move_velocity * delta * camera_lag)
	
# ---------------------------------------------------------------------------------------
func _aim_camera(delta: float) -> void:
	if _mouse_movement.length() > 0:
		_gimbal.rotate_y(-deg2rad(_mouse_movement.x * delta * mouse_sensitivity * ROTATION_SPEED))
		_gimbal.rotate_object_local(Vector3(1, 0, 0), deg2rad(-_mouse_movement.y * delta * mouse_sensitivity * ROTATION_SPEED))
	_mouse_movement = Vector2()

# ---------------------------------------------------------------------------------------
func _ray_col_dist(ray: RayCast) -> float:
	if !ray.is_colliding():
		return hover_height
	return ray.global_transform.origin.distance_to(ray.get_collision_point())

# ---------------------------------------------------------------------------------------
func _get_move_direction() -> Vector3:
	var direction := Vector3(0, 0, 0)
	var cam_basis = _camera.get_global_transform().basis
	if Input.is_action_pressed("move_forward"):
		direction -= cam_basis.z
	if Input.is_action_pressed("move_backward"):
		direction += cam_basis.z
	if Input.is_action_pressed("move_left"):
		direction -= cam_basis.x
	if Input.is_action_pressed("move_right"):
		direction += cam_basis.x
	return direction.normalized()
	
# ---------------------------------------------------------------------------------------
func _on_TurnAccumulatorResetTimer_timeout():
	_turn_accumulator = 0.0
