extends Spatial

const GLOWINESS_INCREASE = 1.0

# ---------------------------------------------------------------------------------------
onready var _fps_label: Label = $UI/MarginContainer/FpsLabel
onready var _player: Player = $Player

# ---------------------------------------------------------------------------------------
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.play_music()

# ---------------------------------------------------------------------------------------
func _process(delta: float) -> void:
	_fps_label.text = str(Engine.get_frames_per_second())
	
	# basic debug stuff
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
	
	# incr/decr glowiness of player
	if Input.is_action_just_pressed("debug_increase_glowiness"):
		_player.glowiness += GLOWINESS_INCREASE
	if Input.is_action_just_pressed("debug_decrease_glowiness"):
		_player.glowiness -= GLOWINESS_INCREASE
		
