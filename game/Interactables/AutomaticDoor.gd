class_name AutomaticDoor
extends Interactable

# ---------------------------------------------------------------------------------------
var _dialog = "That thing is massive! I can't get through it and i'm sure even the Godot-Cannon won't leave a skratch"

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	get_node(dialog_box).show_message("Tatl:", _dialog, true)

# ---------------------------------------------------------------------------------------
func open_door(close_time: float) -> void:
	$CloseTimer.wait_time = close_time
	$CloseTimer.start()
	$AnimationPlayer.play("open")
	$AudioStreamPlayer3D.play()

# ---------------------------------------------------------------------------------------
func _on_CloseTimer_timeout():
	$AnimationPlayer.play("close")
	$AudioStreamPlayer3D.play()
