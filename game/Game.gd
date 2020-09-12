extends Spatial

onready var _player: Player = $Player

# ---------------------------------------------------------------------------------------
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# ---------------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_reload"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("debug_exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("debug_toggle_input"):
		if _player.input_enabled:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else: 
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		_player.input_enabled = !_player.input_enabled
