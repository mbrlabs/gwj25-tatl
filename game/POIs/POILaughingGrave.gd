extends POIArea

# ---------------------------------------------------------------------------------------
func _is_triggerable() -> bool:
	return Global.state != Global.State.INTRO

# ---------------------------------------------------------------------------------------
func _get_dialog_title() -> String:
	return "Tatl:"

# ---------------------------------------------------------------------------------------
func _get_dialog_message() -> String:
	return "Damn, it's creppy AF here..."
