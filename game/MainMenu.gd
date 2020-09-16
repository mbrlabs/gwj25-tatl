extends Spatial

# ---------------------------------------------------------------------------------------
const ROTATE_SPEED = 0.05

# ---------------------------------------------------------------------------------------
onready var _start_timer: Timer = $StartTimer
onready var _background: ColorRect = $UI/Background
onready var _ui_container: MarginContainer = $UI/MarginContainer

# ---------------------------------------------------------------------------------------
var start_requested := false

# ---------------------------------------------------------------------------------------
func _process(delta):
	$Player.rotate_y(-ROTATE_SPEED*delta)
	if start_requested:
		_background.modulate.a += 1.0*delta
		_ui_container.modulate.a -= 1.0*delta

# ---------------------------------------------------------------------------------------
func _on_ButtonStartGame_pressed():
	_start_timer.start()
	start_requested = true

# ---------------------------------------------------------------------------------------
func _on_ButtonQuit_pressed():
	get_tree().quit()

# ---------------------------------------------------------------------------------------
func _on_ButtonAbout_pressed():
	pass

# ---------------------------------------------------------------------------------------
func _on_StartTimer_timeout():
	get_tree().change_scene("res://Game.tscn")
