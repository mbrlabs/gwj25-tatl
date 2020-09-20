extends Interactable

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	$AnimationPlayer.play("open")
	$AudioStreamPlayer.play()
	get_node(dialog_box).show_message("Tatl:", "Hmm, that's weird...", false, 2)
