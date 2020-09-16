extends Interactable

# ---------------------------------------------------------------------------------------
var _dialog = "That thing is massive! I can't get through it and i'm sure even the Godot-Cannon won't leave a skratch"

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	#get_node(dialog_box).show_message("Tatl:", _dialog, true)
	open_door()

# ---------------------------------------------------------------------------------------
func open_door() -> void:
	$CloseTimer.start()
	$AnimationPlayer.play("open")

# ---------------------------------------------------------------------------------------
func _on_CloseTimer_timeout():
	$AnimationPlayer.play("close")
