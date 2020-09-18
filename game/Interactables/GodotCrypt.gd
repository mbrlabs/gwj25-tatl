extends Interactable

# ---------------------------------------------------------------------------------------
onready var _head: GodotHead = $GodotHead
onready var _godot_talk_sound: AudioStreamPlayer = $GodotTalk
onready var _camera_shake_timer: Timer = $CameraShakeTimer

# ---------------------------------------------------------------------------------------
const T = "Tatl:"
const C = "Spirit of Godot:"
var _dialogs = [
	[T, "Hmm, that thing looks important. I wonder what happens if i touch that... ARGHHHH, IT MOVED!"],
	[C, "What is this? Who disturbes my sleep? Oh..you are a faerie. Forgive me my manners, i am the Spirit of Godot. What are you doing this far away from home?"],
	[T, "I don't know. I'm completly lost :("],
	[C, "Indeed, this is the Forest of Darkness where the light never shines...no place for a fearie. But i will help you! I grant you the mighty force of the Godot-Cannon."],
	[C, "You will have to transform yourself into the Godot-Form to be able to use it. Press the [Right Mouse Button] to start the transformation."],
	[C, "Great. Now you can use the Godot-Cannon with the [Left Mouse Button]. Note however, that this form also makes you slower."],
	[C, "To transform back, simply press the [Right Mouse Button] again."],
	[T, "Wow, thank you so much!"],
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
	get_node(dialog_box).connect("message_confirmed", self, "_on_DialogBox_message_confirmed")
	Global.state = Global.State.PRE_CASTLE
	var db := get_node(dialog_box) as DialogBox
	var msg = _dialogs[_dialog_index]
	db.show_message(msg[0], msg[1], true)
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
		1, 3, 4, 5, 6, 8, 9:
			_head._start_talking()
			_godot_talk_sound.play()
		0, 2, 7:
			_head._stop_talking()
			_godot_talk_sound.stop()
	
	var db := get_node(dialog_box) as DialogBox
	if _dialog_index < _dialogs.size():
		if _dialog_index == 3:
			Global.buffed_form_unlocked = true
		var msg = _dialogs[_dialog_index]
		db.show_message(msg[0], msg[1], true)
		_dialog_index += 1
	else:
		_head._stop_talking()
		_godot_talk_sound.stop()
		db.disconnect("message_confirmed", self, "_on_DialogBox_message_confirmed")
		
# ---------------------------------------------------------------------------------------
func _on_CrowSoundTimer_timeout():
	$CrowSound.play()

# ---------------------------------------------------------------------------------------
func _on_CrowSoundTimer2_timeout():
	$CrowSound2.play()

# ---------------------------------------------------------------------------------------
func _on_CameraShakeTimer_timeout():
	get_viewport().get_camera().add_trauma(0.5)
