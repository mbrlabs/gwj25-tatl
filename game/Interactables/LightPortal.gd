extends Interactable

signal the_end

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	$ActivationParticles.emitting = true
	$AnimationPlayer.play("boom")
	var dbox := get_node(dialog_box) as DialogBox
	dbox.show_message("Tatl: ", "Nice, we found a Light portal. I go now, goodbye. The end", true)

# ---------------------------------------------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("the_end")
