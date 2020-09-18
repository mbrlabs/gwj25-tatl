class_name Zombie
extends KinematicBody

# ---------------------------------------------------------------------------------------
const ANIM_IDLE = "idle"
const ANIM_WALK = "walk"
const ANIM_ATTACK = "attack"

# ---------------------------------------------------------------------------------------
onready var _anim_player: AnimationPlayer = $zombie/AnimationPlayer
onready var _nav_path_update_timer: Timer = $PathUpdateTimer
onready var _growl_sound: AudioStreamPlayer3D = $GrowlSound
onready var _death_sound: AudioStreamPlayer3D = $DeathSound
onready var _death_particles: CPUParticles = $DeathParticles
onready var _death_timer: Timer = $DeathTimer
onready var _interactable: Interactable = $InteractableArea

# ---------------------------------------------------------------------------------------
export var hostile: bool = false
export var navigation: NodePath
export var player: NodePath
export var dialog_box: NodePath
export var interaction_overlay: NodePath
export var min_speed := 1.0
export var max_speed := 3.0
export var life := 45

# ---------------------------------------------------------------------------------------
var _path_nodes := []
var _path_node_index := 0
var _player: Spatial
var _navigation: Navigation
var _speed: float = 1.0
var _dead := false
var _attacking := false

# ---------------------------------------------------------------------------------------
func _ready():
	# FIXME: ../ is an ugly hack. Apperently these node paths are relative and you have to manually
	# update them if you want to pass them down/up the hirachy
	_interactable.dialog_box = "../"+dialog_box
	_interactable.interact_overlay = "../"+interaction_overlay
	
	_anim_player.get_animation(ANIM_IDLE).loop = true
	_anim_player.get_animation(ANIM_WALK).loop = true
	_anim_player.play(ANIM_IDLE)
	_anim_player.advance(rand_range(0, 10))
	_speed = rand_range(min_speed, max_speed)
	
	if !player.is_empty():
		_player = get_node(player)
	if !navigation.is_empty():
		_navigation = get_node(navigation)
	if hostile:
		_nav_path_update_timer.start()

# ---------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if _dead:
		return
	
	if life <= 0:
		_dead = true
		_death_sound.play()
		_death_particles.emitting = true
		_death_timer.start()
		$zombie.hide()
	
	if hostile:
		if _nav_path_update_timer.is_stopped():
			_nav_path_update_timer.start()
		if !_attacking && _anim_player.current_animation != ANIM_WALK:
			_anim_player.play(ANIM_WALK, 0.5, _speed)
			_anim_player.advance(rand_range(0, 10))
		if !_growl_sound.playing:
			_growl_sound.unit_size = 0.1
			_growl_sound.play()
			$Tween.interpolate_property(_growl_sound, "unit_size", _growl_sound.unit_size, 2.0, .5)
			$Tween.start()
		
		# turn towards player
		look_at(_player.global_transform.origin, Vector3.UP)
		rotation.x = 0
		rotation.z = 0
		
		# move towards player
		if _path_node_index < _path_nodes.size():
			var dir: Vector3 = _path_nodes[_path_node_index] - global_transform.origin
			if dir.length() < 1:
				_path_node_index += 1
			else:
				move_and_slide(dir.normalized()*_speed*1.33, Vector3.UP)
		
		# attack?
		if global_transform.origin.distance_to(_player.global_transform.origin) < 3.0:
			_attacking = true
			if _anim_player.current_animation != ANIM_ATTACK:
				_anim_player.play(ANIM_ATTACK)
		else:
			_attacking = false

# ---------------------------------------------------------------------------------------
func _on_PathUpdateTimer_timeout():
	_path_nodes = _navigation.get_simple_path(global_transform.origin, _player.global_transform.origin)
	_path_node_index = 0

# ---------------------------------------------------------------------------------------
func _on_DeathTimer_timeout():
	queue_free()
