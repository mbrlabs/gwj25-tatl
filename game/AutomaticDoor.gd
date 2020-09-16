extends Interactable

# ---------------------------------------------------------------------------------------
var _dialog = "That thing is massive steel. I can't get through and i'm sure even the Godot-Cannon won't leave a skratch"

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	get_node(dialog_box).show_message("Tatl:", _dialog, true)
