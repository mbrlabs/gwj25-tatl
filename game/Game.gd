extends Spatial

const GLOWINESS_INCREASE = 1.0

# ---------------------------------------------------------------------------------------
enum IntroLevel {
	HELLO,
	MOVEMENT,
	ABILITIES,
	GOOD_LUCK,
	DONE
}

# ---------------------------------------------------------------------------------------
onready var _fps_label: Label = $UI/MarginContainer/FpsLabel
onready var _player: Player = $Player
onready var _dialog_box: DialogBox = $UI/DialogBox

# ---------------------------------------------------------------------------------------
var _intro_dialogs = {
	IntroLevel.HELLO: "Hello, my name is Tatl ;) I am a fairy from the Godot forest and i think i'm lost! I have no idea how i got here. Can you help me get out of this dark place?",
	IntroLevel.MOVEMENT: "Thanks! You can control me with WASD or Arrow Keys. Use your Mouse to look around.",
	IntroLevel.ABILITIES: "I can also push myself pretty high into the air if you hold down your left mouse button. Try it!",
	IntroLevel.GOOD_LUCK: "Great! So go on now and save my ass :)" 
}
var _intro_lvl = IntroLevel.HELLO

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

# ---------------------------------------------------------------------------------------
func _on_DialogStartTimer_timeout():
	_dialog_box.show_message("Tatl:", _intro_dialogs[_intro_lvl], true)

# ---------------------------------------------------------------------------------------
func _on_DialogBox_message_confirmed():
	match _intro_lvl:
		IntroLevel.HELLO:
			_intro_lvl = IntroLevel.MOVEMENT
		IntroLevel.MOVEMENT:
			_intro_lvl = IntroLevel.ABILITIES
		IntroLevel.ABILITIES:
			_intro_lvl = IntroLevel.GOOD_LUCK
		IntroLevel.GOOD_LUCK:
			_intro_lvl = IntroLevel.DONE
	
	if _intro_lvl != IntroLevel.DONE:
		_dialog_box.show_message("Tatl:", _intro_dialogs[_intro_lvl], true)
