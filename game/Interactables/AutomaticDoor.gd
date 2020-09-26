class_name AutomaticDoor
extends Interactable

# ---------------------------------------------------------------------------------------
var _dialog_castle = "That thing is massive! I can't get through it and i'm sure even the Godot-Cannon won't leave a skratch."
var _dialog_mountain = "I guess there is no way back now..."
var _door_open := false

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return !_door_open

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	if Global.state == Global.State.MONTAIN:
		DialogBox.show_message("Tatl:", _dialog_mountain, false, 2)
	else:
		DialogBox.show_message("Tatl:", _dialog_castle, false, 2)

# ---------------------------------------------------------------------------------------
func open_door(close_time: float) -> void:
	$CloseTimer.wait_time = close_time
	$CloseTimer.start()
	$AnimationPlayer.play("open")
	$AudioStreamPlayer3D.play()
	_door_open = true

# ---------------------------------------------------------------------------------------
func _on_CloseTimer_timeout():
	$AnimationPlayer.play("close")
	$AudioStreamPlayer3D.play()
	_door_open = false
