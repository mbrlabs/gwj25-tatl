extends Interactable

signal the_end

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return Global.state != Global.State.THE_END

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	Global.state = Global.State.THE_END
	$ActivationParticles.emitting = true
	$AnimationPlayer.play("boom")
	$AmbientActivationSound.play()
	$AmbientActivationSound2Timer.start()
	var dbox := get_node(dialog_box) as DialogBox
	dbox.show_message("Tatl: ", "Nice, we found a Light portal. I go now, goodbye. The end", true)

# ---------------------------------------------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("the_end")

# ---------------------------------------------------------------------------------------
func _on_AmbientActivationSound2Timer_timeout():
	$AmbientActivationSound2.play()
