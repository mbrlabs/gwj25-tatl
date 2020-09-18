class_name AboutScreen
extends Control

# ---------------------------------------------------------------------------------------
onready var _tween: Tween = $Tween
var is_open

# ---------------------------------------------------------------------------------------
func _ready():
	rect_position = _get_target_slide_pos()

# ---------------------------------------------------------------------------------------
func toggle() -> void:
	if is_open:
		slide_out()
	else:
		slide_in()

# ---------------------------------------------------------------------------------------
func slide_in() -> void:
	is_open = true
	rect_position = _get_target_slide_pos()
	_tween.interpolate_property(self, "rect_position", rect_position, Vector2.ZERO, 0.33, Tween.TRANS_CIRC, Tween.EASE_OUT)
	_tween.start()
	
# ---------------------------------------------------------------------------------------
func slide_out() -> void:
	is_open = false
	rect_position = Vector2.ZERO
	_tween.interpolate_property(self, "rect_position", rect_position, _get_target_slide_pos(), 0.2)
	_tween.start()
	
# ---------------------------------------------------------------------------------------
func _get_target_slide_pos() -> Vector2:
	var res = Global.get_resolution()
	return Vector2(0, -res.y)
