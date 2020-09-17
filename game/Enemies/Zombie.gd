extends KinematicBody

# ---------------------------------------------------------------------------------------
const ANIM_IDLE = "idle"
const ANIM_WALK = "walk"

# ---------------------------------------------------------------------------------------
onready var _anim_player: AnimationPlayer = $zombie/AnimationPlayer
onready var _nav_path_update_timer: Timer = $PathUpdateTimer
onready var _growl_sound: AudioStreamPlayer3D = $GrowlSound

# ---------------------------------------------------------------------------------------
export var hostile: bool = false
export var just_looking_around := true
export var speed: float = 2.0
export var navigation: NodePath
export var player: NodePath

# ---------------------------------------------------------------------------------------
var _path_nodes := []
var _path_node_index := 0
var _player: Player
var _navigation: Navigation

# ---------------------------------------------------------------------------------------
func _ready():
	_anim_player.get_animation(ANIM_IDLE).loop = true
	_anim_player.get_animation(ANIM_WALK).loop = true
	_anim_player.play(ANIM_IDLE)
	_anim_player.advance(rand_range(0, 10))
	
	if !player.is_empty():
		_player = get_node(player)
	if !navigation.is_empty():
		_navigation = get_node(navigation)
	if hostile:
		_nav_path_update_timer.start()

# ---------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	if hostile:
		if _anim_player.current_animation != ANIM_WALK:
			_anim_player.play(ANIM_WALK, 0.5, speed)
			_anim_player.advance(rand_range(0, 10))
		if !_growl_sound.playing:
			_growl_sound.play()
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
				move_and_slide(dir.normalized()*speed*1.33, Vector3.UP)

# ---------------------------------------------------------------------------------------
func _on_PathUpdateTimer_timeout():
	_path_nodes = _navigation.get_simple_path(global_transform.origin, _player.global_transform.origin)
	_path_node_index = 0
