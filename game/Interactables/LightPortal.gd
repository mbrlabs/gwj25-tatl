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
var _dialogs = [
	"Now will you look at that!",
	"That's a freaking Light Portal! That explains why there are these crystals all over the place. It's probably also the reason why I ended up here.",
	"You see, Light Portals are Fae-made. We use them to travel to other worlds far beyond our own. This one must be malefunctening though. Let me have a look...",
	"... ... ...",
	"Ah, fixed it! The humidity here must have caused a short circuit in the lightning network. Easy peasy ;)",
	"Anyway, thank you for helping me! I wouldn't have made it without you.",
	"I have to go home now. Goodbye, friend!"
]
var _dialog_index := 0

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return Global.state != Global.State.THE_END

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	DialogBox.connect("message_confirmed", self, "_on_DialogBox_message_confirmed")
	Global.state = Global.State.THE_END
	Global.buffed_form_unlocked = false
	
	DialogBox.show_message("Tatl:", _dialogs[0], true)
	_dialog_index += 1

# ---------------------------------------------------------------------------------------
func _on_DialogBox_message_confirmed() -> void:
	# start end sequence
	if _dialog_index < _dialogs.size():
		DialogBox.show_message("Tatl:", _dialogs[_dialog_index], true)
		_dialog_index += 1
	else:
		_particles_animator.play("boom")
		_activation_particles.emitting = true
		_activation_sound.play()
		_ambient_activation_sound.play()
		_quake_sound.play()
		_ambient_sound_timer.start()
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
