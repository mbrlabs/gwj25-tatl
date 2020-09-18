class_name TheEndOverlay
extends Control

# ---------------------------------------------------------------------------------------
func show_end_screen() -> void:
	show()
	$AnimationPlayer.play("fade_in")

# ---------------------------------------------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fade_in":
		$Timer.start()
	elif anim_name == "fade_out":
		Global.reset()
		get_tree().change_scene("res://Screens/MainMenu.tscn")

# ---------------------------------------------------------------------------------------
func _on_Timer_timeout():
	$AnimationPlayer.play("fade_out")
