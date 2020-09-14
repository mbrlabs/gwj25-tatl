class_name GodotHead
extends Spatial

# ---------------------------------------------------------------------------------------
onready var _annim_player: AnimationPlayer = $AnimationPlayer

# ---------------------------------------------------------------------------------------
func _start_talking() -> void:
	_annim_player.play("talk")

# ---------------------------------------------------------------------------------------
func _stop_talking() -> void:
	_annim_player.stop()
