extends Control

# ---------------------------------------------------------------------------------------
onready var _progress_bar: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar
onready var _label: Label = $MarginContainer/VBoxContainer/Label

# ---------------------------------------------------------------------------------------
export var player: NodePath

# ---------------------------------------------------------------------------------------
func _ready():
	var p = get_node(player)
	_progress_bar.max_value = Player.MAX_ABILITY_POWER
	_progress_bar.value = p.get_ability_power()

# ---------------------------------------------------------------------------------------
func _process(delta: float):
	var p = get_node(player)
	if p.get_form() == Player.Form.BUFFED:
		_label.text = "Godot-Cannon"
	else:
		_label.text = "Super-Hover"
	
	_progress_bar.value = p.get_ability_power()
	if _progress_bar.value == _progress_bar.max_value:
		hide()
	else:
		show()
