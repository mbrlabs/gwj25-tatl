extends Spatial

# ---------------------------------------------------------------------------------------
enum IntroLevel {
	HELLO,
	MOVEMENT,
	ABILITIES,
	GOOD_LUCK,
	DONE
}

# ---------------------------------------------------------------------------------------
onready var _fps_label: Label = $UI/DebugContainer/FpsLabel
onready var _player: Player = $Player
onready var _pause_menu: PauseMenu = $UI/PauseMenu
onready var _end_overlay: TheEndOverlay = $UI/TheEndOverlay

# ---------------------------------------------------------------------------------------
var _intro_dialogs = {
	IntroLevel.HELLO: "Hello, my name is Tatl. I am a faerie from the Forest of Light. I don't know what happend, but i suddenly woke up in this otherworldly place. Can you help me find my way home again?",
	IntroLevel.MOVEMENT: "Thanks! You can control me with [WASD] or [Arrow Keys]. Use your [Mouse] to look around.",
	IntroLevel.ABILITIES: "I can also super-hover if you hold down your [Left Mouse Button] while moving. Try it!",
	IntroLevel.GOOD_LUCK: "Great! So go on now and save me. ;)"
}
var _intro_lvl = IntroLevel.HELLO

# ---------------------------------------------------------------------------------------
func _ready():
	if Global.DEBUG:
		$UI/DebugContainer.show()
	
	DialogBox.connect("message_confirmed", self, "_on_DialogBox_message_confirmed")
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	Global.play_music()

# ---------------------------------------------------------------------------------------
func _process(delta: float) -> void:
	if Global.DEBUG:
		_fps_label.text = str(Engine.get_frames_per_second())
	
	if Input.is_action_just_pressed("pause") && !get_tree().paused && Global.state != Global.State.THE_END:
		_pause_menu.handle_input = false
		_pause()
	
	# basic debug stuff
	if Global.DEBUG:
		if Input.is_action_just_pressed("debug_reload"):
			Global.reset()
			get_tree().reload_current_scene()

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
			Global.state = Global.State.CRYPT
			DialogBox.disconnect("message_confirmed", self, "_on_DialogBox_message_confirmed")
	
	if _intro_lvl != IntroLevel.DONE:
		DialogBox.show_message("Tatl:", _intro_dialogs[_intro_lvl], true)

# ---------------------------------------------------------------------------------------
func _on_IntroStartTimer_timeout():
	DialogBox.show_message("Tatl:", _intro_dialogs[_intro_lvl], true)

# ---------------------------------------------------------------------------------------
func _on_ExitCastleStateArea_body_entered(body):
	if body is Player:
		Global.state = Global.State.MONTAIN

# ---------------------------------------------------------------------------------------
func _on_PauseMenu_unpaused():
	_unpause()

# ---------------------------------------------------------------------------------------
func _pause() -> void:
	get_tree().paused = true
	_pause_menu.slide_in()
	_player.input_enabled = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

# ---------------------------------------------------------------------------------------
func _unpause() -> void:
	_pause_menu.slide_out()
	_player.input_enabled = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# ---------------------------------------------------------------------------------------
func _on_LightPortal_the_end():
	_end_overlay.show_end_screen()
