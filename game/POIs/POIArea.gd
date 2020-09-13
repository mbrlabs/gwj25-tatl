class_name POIArea
extends Area

export var dialog_box: NodePath

# ---------------------------------------------------------------------------------------
func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")

# ---------------------------------------------------------------------------------------
func _get_dialog_message() -> String:
	return ""

# ---------------------------------------------------------------------------------------
func _get_dialog_title() -> String:
	return ""

# ---------------------------------------------------------------------------------------
func _is_dialog_confirmation_required() -> bool:
	return false

# ---------------------------------------------------------------------------------------
func _on_body_entered(body) -> void:
	if body is KinematicBody:
		var box := get_node(dialog_box) as DialogBox
		box.show_message(
			_get_dialog_title(), 
			_get_dialog_message(), 
			_is_dialog_confirmation_required()
		)
