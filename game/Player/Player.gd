class_name Player
extends KinematicBody

# ---------------------------------------------------------------------------------------
const ProjectileFactory = preload("res://Player/Projectile.tscn")

# ---------------------------------------------------------------------------------------
const ANIM_IDLE := "idle"
const ANIM_BUFFED_TO_NORMAL := "buffed_to_normal"
const ANIM_NORMAL_TO_BUFFED := "normal_to_buffed"
const ROTATION_SPEED := 4.0
const HOVER_TRESHHOLD := 0.05
const SUPERSPEED_SOUND_TRESHHOLD := 6.0
const HOVER_HEIGHT_NORMAL := 1.0
const HOVER_HEIGHT_NORMAL_SUPERSPEED := 2.0
const HOVER_HEIGHT_BUFFED := 1.75
const SPEED_SCALE_NORMAL := 1.0
const SPEED_SCALE_NORMAL_SUPERSPEED := 2.0
const SPEED_SCALE_BUFFED := 0.5
const MAX_ABILITY_POWER := 200

# ---------------------------------------------------------------------------------------
enum Form {
	NORMAL,
	BUFFED
}

enum MovementState {
	IDLE,
	ACCELERATING,
	MOVING
}

# ---------------------------------------------------------------------------------------
onready var _sound_move: AudioStreamPlayer3D = $MoveSound
onready var _sound_turn: AudioStreamPlayer3D = $TurnSound
onready var _sound_superspeed: AudioStreamPlayer3D = $SuperspeedSound
onready var _sound_cannon: AudioStreamPlayer = $GodotCannonmSound
onready var _ability_cooldown_timer: Timer = $AbilityCooldownTimer
onready var _gimbal: Spatial = $Gimbal
onready var _camera: Camera = $Gimbal/Camera
onready var _orb_mesh: MeshInstance = $MeshInstance
onready var _raycast_down: RayCast = $RayCastDown
onready var _raycast_up: RayCast = $RayCastUp
onready var _raycast_gun: RayCast = $Gimbal/Camera/GunRayCast
onready var _dir_light: DirectionalLight = $Gimbal/Camera/DirectionalLight
onready var _transformation_anim_player: AnimationPlayer = $AnimationPlayerTransformation
onready var _collision_shape_normal: CollisionShape = $CollisionShapeNorrmal
onready var _collision_shape_buffed: CollisionShape = $CollisionShapeBuffed
onready var _projectiles_container: Node = $Projectiles
onready var _gun_impact_particles: CPUParticles = $Node/RaygunImpactParticles
onready var _crosshair: Spatial = $Gimbal/Camera/GunRayCast/Crosshair

# ---------------------------------------------------------------------------------------
export var evirorment: Environment 
export var input_enabled := true
export(float, 0.0, 1.0) var glowiness = 1.0 setget _set_glowiness
export var mouse_sensitivity := 1.0
export var camera_zoom_increments := 0.1
export var camera_max_zoom_increments := 10
export var camera_lag := 8.0
export var speed := 5.0
export var speed_scale := 1.0
export var acceleration_factor := 20.0
export var deceleration_factor := 4.0
export var gravity := 1.5
export var hover_strength := 4.0
export var hover_height := 1.0

# ---------------------------------------------------------------------------------------
var _base_ambient_light: float
var _base_dir_light_energy: float
var _base_player_emission: float
var _form = Form.NORMAL
var _mouse_movement: Vector2
var _velocity: Vector3
var _camera_lag_velocity: Vector3
var _movement_state = MovementState.IDLE
var _turn_accumulator := 0.0
var _is_transforming := false
var _ability_power := MAX_ABILITY_POWER
var _is_ability_cooldown_active := false

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
func get_ability_power() -> int:
	return _ability_power

# ---------------------------------------------------------------------------------------
func get_form() -> int:
	return _form

# ---------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	var prev_velocity = _velocity
	
	# do input and calc move velocity
	_handle_mode()
	var move_velocity: Vector3
	if input_enabled:
		_aim_camera(delta)
		if !_is_transforming:
			move_velocity = _get_move_velocity(delta)
			_apply_camera_lag(delta)
	move_velocity = _apply_hover(move_velocity)
	
	# move
	_velocity = move_and_slide(move_velocity, Vector3.UP)
	_handle_movement_state(prev_velocity)
	
	# form transformation
	if input_enabled && !_is_transforming && Global.buffed_form_unlocked:
		_handle_transformation()
	
# ---------------------------------------------------------------------------------------
func _input(e: InputEvent) -> void:
	if input_enabled && e is InputEventMouseMotion:
		_mouse_movement += e.relative

# ---------------------------------------------------------------------------------------
func _handle_mode() -> void:
	if _form == Form.NORMAL:
		# player just moves faster
		if Input.is_action_pressed("special_ability") && _ability_power > 0:
			speed_scale = SPEED_SCALE_NORMAL_SUPERSPEED
			hover_height = HOVER_HEIGHT_NORMAL_SUPERSPEED
			_ability_power -= 1
			if _ability_power == 0:
				_is_ability_cooldown_active = true
				_ability_cooldown_timer.start()
		elif Input.is_action_just_released("special_ability"):
			_is_ability_cooldown_active = true
			_ability_cooldown_timer.start()
		else:
			speed_scale = SPEED_SCALE_NORMAL
			hover_height = HOVER_HEIGHT_NORMAL
			if !_is_ability_cooldown_active:
				_ability_power = min(_ability_power+1, MAX_ABILITY_POWER)
	if _form == Form.BUFFED:
		# aim with crosshair
		var dist = _raycast_gun.global_transform.origin.distance_to(_raycast_gun.get_collision_point())
		if dist < 10.0:
			var offset = _raycast_gun.global_transform.basis.z
			_crosshair.global_transform.origin = _raycast_gun.get_collision_point() + offset
		else:
			var offset = _raycast_gun.global_transform.basis.z*12
			_crosshair.global_transform.origin = _raycast_gun.global_transform.origin - offset

		if _ability_power <= 0:
			_crosshair.disable()
		else:
			_crosshair.enable()
		if Input.is_action_pressed("special_ability") && _ability_power > 0:
			var projectile := ProjectileFactory.instance() as Projectile
			# projectile start position
			projectile.start_position = _raycast_gun.global_transform.origin
			#projectile.start_position -= _raycast_gun.global_transform.basis.z * 2.0
			var offset = 0.25
			var pos_offset = Vector3(
				rand_range(-offset, offset), 
				rand_range(-offset, offset), 
				rand_range(-offset, offset)
			)
			projectile.start_position += pos_offset
			
			# aim and fire
			projectile.direction = -_raycast_gun.global_transform.basis.z
			_projectiles_container.add_child(projectile)
			
			# check for collsion and show impact effect
			if _raycast_gun.is_colliding():
				_gun_impact_particles.emitting = true
				_gun_impact_particles.global_transform.origin = _raycast_gun.get_collision_point()
				_gun_impact_particles.global_transform.basis = _raycast_gun.global_transform.basis
			else:
				_gun_impact_particles.emitting = false
				
			# decrease power
			_ability_power -= 2
			if _ability_power <= 0:
				_is_ability_cooldown_active = true
				_ability_cooldown_timer.start()
			
			if !_sound_cannon.playing:
				_sound_cannon.play()
		elif Input.is_action_just_released("special_ability"):
			_gun_impact_particles.emitting = false
			_is_ability_cooldown_active = true
			_ability_cooldown_timer.start()
			_sound_cannon.stop()
		else:
			_sound_cannon.stop()
			_gun_impact_particles.emitting = false
			if !_is_ability_cooldown_active:
				_ability_power = min(_ability_power+2, MAX_ABILITY_POWER)
				
# ---------------------------------------------------------------------------------------
func _handle_movement_state(pre_move_velocity: Vector3) -> void:
	match _movement_state:
		MovementState.IDLE:
			if _velocity.length() > pre_move_velocity.length():
				_movement_state = MovementState.ACCELERATING
		MovementState.ACCELERATING:
			if !_sound_move.playing:
				_sound_move.play()
			_movement_state = MovementState.MOVING
		MovementState.MOVING:
			# turn sound logic
			_turn_accumulator += (1.0 - _velocity.normalized().dot(pre_move_velocity.normalized()))
			if _turn_accumulator >= 0.033 && !_sound_turn.playing:
				_sound_turn.play()
				_turn_accumulator = 0.0
			var vel_length = _velocity.length()
			if vel_length < pre_move_velocity.length() && vel_length <  0.5:
				_movement_state = MovementState.IDLE

			# superspeed sound logic
			var sound_scale = SUPERSPEED_SOUND_TRESHHOLD - _velocity.length()
			if sound_scale < 0:
				_sound_superspeed.unit_db = 4
			else:
				_sound_superspeed.unit_db = -SUPERSPEED_SOUND_TRESHHOLD * sound_scale

# ---------------------------------------------------------------------------------------
func _get_move_velocity(delta: float) -> Vector3:
	var direction := _get_move_direction()
	var target := direction * speed * speed_scale
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
func _custom_tackle_movement_along_camera_axis(length: float) -> void:
	pass

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
func _handle_transformation() -> void:
	if Input.is_action_just_pressed("change_form"):
		_ability_power = MAX_ABILITY_POWER
		_is_ability_cooldown_active = false
		_ability_cooldown_timer.stop()
		
		_is_transforming = true
		if _form == Form.NORMAL:
			_crosshair.show()
			_form = Form.BUFFED
			if Global.god_mode_enabled:
				speed_scale = 2.5
				hover_height = 8.0
			else:
				speed_scale = SPEED_SCALE_BUFFED
				hover_height = HOVER_HEIGHT_BUFFED
			_transformation_anim_player.play(ANIM_NORMAL_TO_BUFFED)
		else:
			_crosshair.hide()
			_form = Form.NORMAL
			speed_scale = SPEED_SCALE_NORMAL
			hover_height = HOVER_HEIGHT_NORMAL
			_transformation_anim_player.play(ANIM_BUFFED_TO_NORMAL)

# ---------------------------------------------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	match anim_name:
		ANIM_NORMAL_TO_BUFFED:
			_collision_shape_normal.disabled = true
			_collision_shape_buffed.disabled = false
			_is_transforming = false
		ANIM_BUFFED_TO_NORMAL:
			_collision_shape_normal.disabled = false
			_collision_shape_buffed.disabled = true
			_is_transforming = false
	
# ---------------------------------------------------------------------------------------
func _on_TurnAccumulatorResetTimer_timeout():
	_turn_accumulator = 0.0

# ---------------------------------------------------------------------------------------
func _on_AbilityCooldownTimer_timeout():
	_is_ability_cooldown_active = false
