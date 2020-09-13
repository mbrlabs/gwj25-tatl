extends Interactable

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return Global.state != Global.State.INTRO

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	$AudioStreamPlayer.play()
	var dbox := get_node(dialog_box) as DialogBox
	dbox.show_message("Creepy grave:", "Laughing...", false)
