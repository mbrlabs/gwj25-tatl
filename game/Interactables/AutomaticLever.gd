extends Interactable

# ---------------------------------------------------------------------------------------
export var automatic_door: NodePath
export var close_time: float = 2.0

var _is_activated := false

# ---------------------------------------------------------------------------------------
func _ready():
	$ResetTimer.wait_time = close_time

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return !_is_activated

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	activate()
	_is_activated = true

# ---------------------------------------------------------------------------------------
func _on_ResetTimer_timeout():
	$AnimationPlayer.play("deactivate")
	_is_activated = false

# ---------------------------------------------------------------------------------------
func activate() -> void:
	get_node(automatic_door).open_door(close_time)
	$AnimationPlayer.play("activate")
	$ResetTimer.start()
