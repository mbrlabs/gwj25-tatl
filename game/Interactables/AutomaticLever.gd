extends Interactable

# ---------------------------------------------------------------------------------------
export var automatic_door: NodePath
export var close_time: float = 2.0

# ---------------------------------------------------------------------------------------
func _ready():
	$ResetTimer.wait_time = close_time

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	activate()

# ---------------------------------------------------------------------------------------
func _on_ResetTimer_timeout():
	$AnimationPlayer.play("deactivate")

# ---------------------------------------------------------------------------------------
func activate() -> void:
	get_node(automatic_door).open_door(close_time)
	$AnimationPlayer.play("activate")
	$ResetTimer.start()
