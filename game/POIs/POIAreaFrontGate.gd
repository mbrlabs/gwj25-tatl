extends POIArea

# ---------------------------------------------------------------------------------------
func _is_dialog_confirmation_required() -> bool:
	return false

# ---------------------------------------------------------------------------------------
func _is_triggerable() -> bool:
	return Global.state != Global.State.INTRO

# ---------------------------------------------------------------------------------------
func _get_dialog_title() -> String:
	return "Gandalf"

# ---------------------------------------------------------------------------------------
func _get_dialog_message() -> String:
	return "You shall not pass!"
