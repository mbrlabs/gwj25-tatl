extends Spatial

# ---------------------------------------------------------------------------------------
const ROTATE_SPEED = 0.05

# ---------------------------------------------------------------------------------------
onready var _start_timer: Timer = $StartTimer
onready var _background: ColorRect = $UI/Background
onready var _ui_container: MarginContainer = $UI/MarginContainer
onready var _about_anim: AnimationPlayer = $UI/AboutAnimationPlayer
onready var _ui_hover_sound: AudioStreamPlayer = $UI/HoverSound
onready var _ui_click_sound: AudioStreamPlayer = $UI/ClickSound

# ---------------------------------------------------------------------------------------
var _start_requested := false
var _about_open := false

# ---------------------------------------------------------------------------------------
func _ready():
	Global.play_music()

# ---------------------------------------------------------------------------------------
func _process(delta):
	$Player.rotate_y(-ROTATE_SPEED*delta)
	if _start_requested:
		_background.modulate.a += 1.0*delta
		_ui_container.modulate.a -= 1.0*delta

# ---------------------------------------------------------------------------------------
func _on_ButtonStartGame_pressed():
	_ui_click_sound.play()
	_start_timer.start()
	_start_requested = true
	if _about_open:
		_about_anim.play("slide_out_about")

# ---------------------------------------------------------------------------------------
func _on_ButtonQuit_pressed():
	get_tree().quit()

# ---------------------------------------------------------------------------------------
func _on_ButtonAbout_pressed():
	_ui_click_sound.play()
	if _about_open:
		_about_anim.play("slide_out_about")
	else:
		_about_anim.play("slide_in_about")
	_about_open = !_about_open

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
