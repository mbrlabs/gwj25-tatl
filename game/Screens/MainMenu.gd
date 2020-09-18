extends Spatial

# ---------------------------------------------------------------------------------------
const ROTATE_SPEED = 0.05

# ---------------------------------------------------------------------------------------
onready var _start_timer: Timer = $StartTimer
onready var _fade_background: ColorRect = $UI/FadeBackgroud
onready var _ui_container: MarginContainer = $UI/MarginContainer
onready var _ui_hover_sound: AudioStreamPlayer = $UI/HoverSound
onready var _ui_click_sound: AudioStreamPlayer = $UI/ClickSound
onready var _about_screen: AboutScreen = $UI/AboutScreen

# ---------------------------------------------------------------------------------------
var _start_requested := false
var _fade_in_done := false

# ---------------------------------------------------------------------------------------
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	Global.play_music()
	
	_fade_background.modulate.a = 1.0
	_ui_container.modulate.a = 0.0

# ---------------------------------------------------------------------------------------
func _process(delta):
	$Player.rotate_y(-ROTATE_SPEED*delta)
	if _start_requested:
		_fade_background.modulate.a += 1.0*delta
		_ui_container.modulate.a -= 1.0*delta
	if !_fade_in_done:
		_fade_background.modulate.a -= 1.0*delta
		_ui_container.modulate.a += 1.0*delta
		if _ui_container.modulate.a >= 0.99:
			_fade_in_done = true
			_fade_background.modulate.a = 0.0
			_ui_container.modulate.a = 1.0

# ---------------------------------------------------------------------------------------
func _on_ButtonStartGame_pressed():
	_ui_click_sound.play()
	_start_timer.start()
	_start_requested = true

# ---------------------------------------------------------------------------------------
func _on_ButtonQuit_pressed():
	get_tree().quit()

# ---------------------------------------------------------------------------------------
func _on_ButtonAbout_pressed():
	_ui_click_sound.play()
	_about_screen.toggle()

# ---------------------------------------------------------------------------------------
func _on_StartTimer_timeout():
	get_tree().change_scene("res://Game.tscn")

# ---------------------------------------------------------------------------------------
func _on_ButtonStartGame_mouse_entered():
	_ui_hover_sound.play()

# ---------------------------------------------------------------------------------------
func _on_ButtonAbout_mouse_entered():
	_ui_hover_sound.play()

# ---------------------------------------------------------------------------------------
func _on_ButtonQuit_mouse_entered():
	_ui_hover_sound.play()
