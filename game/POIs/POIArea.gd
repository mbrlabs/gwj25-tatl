class_name POIArea
extends Area

# ---------------------------------------------------------------------------------------
export var one_shot: bool = false
export var disabled: bool = false

# ---------------------------------------------------------------------------------------
var _already_triggered_once := false

# ---------------------------------------------------------------------------------------
func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

# ---------------------------------------------------------------------------------------
func _is_triggerable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _get_dialog_message() -> String:
	return ""

# ---------------------------------------------------------------------------------------
func _get_dialog_title() -> String:
	return ""

# ---------------------------------------------------------------------------------------
func _on_body_entered(body) -> void:
	if _is_triggerable() && !disabled && body is Player:
		if !one_shot || (one_shot && !_already_triggered_once):
			_already_triggered_once = true
			DialogBox.show_message(
				_get_dialog_title(), 
				_get_dialog_message(), 
				false
			)
