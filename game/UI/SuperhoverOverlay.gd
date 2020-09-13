extends Control

# ---------------------------------------------------------------------------------------
onready var _progress_bar: ProgressBar = $MarginContainer/VBoxContainer/ProgressBar

# ---------------------------------------------------------------------------------------
export var player: NodePath

func _ready():
	var p = get_node(player)
	_progress_bar.max_value = Player.MAX_SUPERSPEED_POWER
	_progress_bar.value = p.get_superhover_power()

# ---------------------------------------------------------------------------------------
func _process(delta: float):
	_progress_bar.value = get_node(player).get_superhover_power()
	if _progress_bar.value == _progress_bar.max_value:
		hide()
	else:
		show()
