# The camera shake based on: https://pastebin.com/pjxjqyrK
class_name TatlCamera
extends Camera

# ---------------------------------------------------------------------------------------
export var decay_rate := 0.4
export var max_yaw := 0.05
export var max_pitch := 0.05
export var max_roll := 0.1
export var max_offset := 0.2

# ---------------------------------------------------------------------------------------
var _start_position: Vector3
var _start_rotation: Vector3
var _trauma: float

# ---------------------------------------------------------------------------------------
func add_trauma(amount: float):
	_trauma = min(_trauma + amount, 1)

# ---------------------------------------------------------------------------------------
func _ready():
	_start_position = translation
	_start_rotation = rotation
	_trauma = 0.0

# ---------------------------------------------------------------------------------------
func _process(delta: float):
	if _trauma > 0:
		_decay_trauma(delta)
		_apply_shake()

# ---------------------------------------------------------------------------------------
func _decay_trauma(delta: float):
	var change = decay_rate * delta
	_trauma = max(_trauma - change, 0)

# ---------------------------------------------------------------------------------------
func _apply_shake():
	var shake := _trauma * _trauma
	var yaw := max_yaw * shake * rand_range(-1.0, 1.0)
	var pitch := max_pitch * shake * rand_range(-1.0, 1.0)
	var roll := max_roll * shake * rand_range(-1.0, 1.0)
	var dx := max_offset * shake * rand_range(-1.0, 1.0)
	var dy := max_offset * shake * rand_range(-1.0, 1.0)
	var dz := max_offset * shake * rand_range(-1.0, 1.0)
	translation = _start_position + Vector3(dx, dy, dz)
	rotation = _start_rotation + Vector3(pitch, yaw, roll)
