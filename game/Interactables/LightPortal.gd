extends Interactable

signal the_end

# ---------------------------------------------------------------------------------------
onready var _activation_particles: CPUParticles = $ActivationParticles
onready var _particles_animator: AnimationPlayer = $AnimationPlayer
onready var _ambient_activation_sound: AudioStreamPlayer = $AmbientActivationSound
onready var _ambient_activation_sound2: AudioStreamPlayer = $AmbientActivationSound2
onready var _activation_sound: AudioStreamPlayer = $ActivationSound
onready var _quake_sound: AudioStreamPlayer = $EarthquakeSound
onready var _ambient_sound_timer: Timer = $AmbientActivationSound2Timer
onready var _shake_timer: Timer = $ShakeTimer

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return Global.state != Global.State.THE_END

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	Global.state = Global.State.THE_END
	Global.buffed_form_unlocked = false
	
	_particles_animator.play("boom")
	_activation_particles.emitting = true
	_activation_sound.play()
	_ambient_activation_sound.play()
	_quake_sound.play()
	_ambient_sound_timer.start()
	
	var dbox := get_node(dialog_box) as DialogBox
	dbox.show_message("Tatl: ", "Nice, we found a Light portal. I go now, goodbye. The end", true)
	
	get_viewport().get_camera().add_trauma(0.25)
	_shake_timer.start()

# ---------------------------------------------------------------------------------------
func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("the_end")

# ---------------------------------------------------------------------------------------
func _on_AmbientActivationSound2Timer_timeout():
	_ambient_activation_sound2.play()

# ---------------------------------------------------------------------------------------
func _on_ShakeTimer_timeout():
	if Global.state == Global.State.THE_END:
		get_viewport().get_camera().add_trauma(0.11)
