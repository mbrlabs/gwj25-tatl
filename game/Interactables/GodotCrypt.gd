extends Interactable

# ---------------------------------------------------------------------------------------
onready var _head: GodotHead = $GodotHead
onready var _godot_talk_sound: AudioStreamPlayer = $GodotTalk
onready var _camera_shake_timer: Timer = $CameraShakeTimer
onready var _particles: CPUParticles = $GodotHead/CPUParticles

# ---------------------------------------------------------------------------------------
const T = "Tatl:"
const C = "Spirit of Godot:"
var _dialogs = [
	[T, "Hmm, that thing looks important. I wonder what happens if i touch that... ARGHHHH, IT MOVED!"],
	[C, "What is this? Who disturbes my sleep? Oh..you are a faerie. Forgive me my manners, i am the Spirit of Godot. What are you doing this far away from home?"],
	[T, "I don't know, i'm completly lost! One moment i was at home and in the other i found myself here..."],
	[C, "Indeed, this is the Forest of Darkness where the light never shines...no place for a fearie. But i will help you! I grant you the mighty force of the Godot-Cannon."],
	[C, "You will have to transform yourself into the Godot-Form to be able to use it. Press the [Right Mouse Button] to start the transformation."],
	[C, "Great. Now you can use the Godot-Cannon with the [Left Mouse Button]. Note however, that this form also makes you slower."],
	[C, "To transform back, simply press the [Right Mouse Button] again."],
	[T, "Wooooo, thank you so much! I guess this will come in handy."],
	[C, "You're welcome little faerie. I still have to warn you though: there a beings in this world, that can be extremly dangerous. Normally they are quite peacful, but..."],
	[C, "DO NOT try to talk to them or even attack them...they don't like that. I will go back to sleep now. Good luck to you."],
]
var _dialog_index := 0

# ---------------------------------------------------------------------------------------
func _ready() -> void:
	pass

# ---------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	pass

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return Global.state == Global.State.CRYPT

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	Global.state = Global.State.PRE_CASTLE
	DialogBox.connect("message_confirmed", self, "_on_DialogBox_message_confirmed")
	var msg = _dialogs[_dialog_index]
	DialogBox.show_message(msg[0], msg[1], true)
	_dialog_index += 1
	$ActivationSound.play()
	_head._start_talking()
	_camera_shake_timer.start()

# ---------------------------------------------------------------------------------------
func _on_DialogBox_message_confirmed() -> void:
	if _dialog_index == 1:
		$CrowSoundTimer.start()
	
	if _dialog_index == 3:
		$CrowSoundTimer2.start()
	
	# godot talks
	match _dialog_index:
		1, 3, 8:
			start_talking(true)
		4, 5, 6, 9:
			start_talking(false)
		0, 2, 7:
			stop_talking()
	
	if _dialog_index < _dialogs.size():
		if _dialog_index == 3:
			Global.buffed_form_unlocked = true
		var msg = _dialogs[_dialog_index]
		DialogBox.show_message(msg[0], msg[1], true)
		_dialog_index += 1
	else:
		stop_talking()
		_godot_talk_sound.stop()
		DialogBox.disconnect("message_confirmed", self, "_on_DialogBox_message_confirmed")

# ---------------------------------------------------------------------------------------
func start_talking(fade_in: bool = false) -> void:
	if !_godot_talk_sound.playing:
		_godot_talk_sound.play()
	if fade_in:
		_godot_talk_sound.volume_db = -30
		$Tween.interpolate_property(_godot_talk_sound, "volume_db", -30, 0, .5)
		$Tween.start()
	_head._start_talking()

# ---------------------------------------------------------------------------------------
func stop_talking() -> void:
	$Tween.interpolate_property(_godot_talk_sound, "volume_db", _godot_talk_sound.volume_db, -30, .5)
	$Tween.start()
	_head._stop_talking()

# ---------------------------------------------------------------------------------------
func _on_CrowSoundTimer_timeout():
	$CrowSound.play()

# ---------------------------------------------------------------------------------------
func _on_CrowSoundTimer2_timeout():
	$CrowSound2.play()

# ---------------------------------------------------------------------------------------
func _on_CameraShakeTimer_timeout():
	get_viewport().get_camera().add_trauma(0.5)

# ---------------------------------------------------------------------------------------
func _on_ParticlesActivationArea_body_entered(body: PhysicsBody):
	if body.collision_layer == 1:
		_particles.emitting = true
		
# ---------------------------------------------------------------------------------------
func _on_ParticlesActivationArea_body_exited(body: PhysicsBody):
	if body.collision_layer == 1:
		_particles.emitting = false
