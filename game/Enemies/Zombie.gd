extends Spatial

# ---------------------------------------------------------------------------------------
const ANIM_IDLE = "idle"

# ---------------------------------------------------------------------------------------
onready var _anim_player: AnimationPlayer = $AnimationPlayer

# ---------------------------------------------------------------------------------------
export var hostile: bool = false

# ---------------------------------------------------------------------------------------
func _ready():
	_anim_player.get_animation(ANIM_IDLE).loop = true
	_anim_player.play(ANIM_IDLE)
	_anim_player.advance(rand_range(0, 10))
