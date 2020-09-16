extends Interactable

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	var dbox := get_node(dialog_box) as DialogBox
	dbox.show_message("Tatl: ", "Nice, we found a Light portal. I go now, goodbye. The end", true)
