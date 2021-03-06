extends Interactable

# ---------------------------------------------------------------------------------------
export var grave_text: String

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return Global.state != Global.State.INTRO

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	DialogBox.show_message("It says:", grave_text, false, 2.0)
