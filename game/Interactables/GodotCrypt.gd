extends Interactable

# ---------------------------------------------------------------------------------------
onready var _head: GodotHead = $GodotHead
onready var _godot_talk_sound: AudioStreamPlayer3D = $GodotTalk

# ---------------------------------------------------------------------------------------
const T = "Tatl:"
const C = "Spirit of Godot:"
var _dialogs = [
	[T, "Hmm, that thing looks important. I wonder what happens if i touch that... ARGHHHH, IT MOVED!"],
	[C, "What is this? Who disturbes my sleep? Oh..you are a faerie. Forgive me my manners, i am the Spirit of Godot. What are you doing this far away from home?"],
	[T, "I don't know. I'm completly lost :("],
	[C, "Indeed...you are. But i will help you! I grant you the mighty force of the Godot-Cannon."],
	[C, "You will have to transform yourself into the Godot form to be able to use it. Press the [Right Mouse Button] to start the transformation."],
	[C, "Great. Now you can use the Godot-Cannon with the [Left Mouse Button]. Note however, that this form also makes you slower."],
	[C, "To transform back, simply press the right mouse button again."],
	[T, "Wow, thank you so much!"],
	[C, "You're welcome little faerie. I'll go back to sleep now. Good luck!"]
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
	return Global.state == Global.State.PRE_CRYPT

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	get_node(dialog_box).connect("message_confirmed", self, "_on_DialogBox_message_confirmed")
	Global.state = Global.State.PUZZLE_1
	var db := get_node(dialog_box) as DialogBox
	var msg = _dialogs[_dialog_index]
	db.show_message(msg[0], msg[1], true)
	_dialog_index += 1

# ---------------------------------------------------------------------------------------
func _on_DialogBox_message_confirmed() -> void:
	if _dialog_index == 1:
		_godot_talk_sound.play()
		$CrowSoundTimer.start()
		pass
		# TODO make the screen shake
	
	if _dialog_index == 3:
		$CrowSoundTimer2.start()
	
	# godot talks
	match _dialog_index:
		1, 3, 4, 5, 6, 8:
			_head._start_talking()
			$GodotTalkFadeAnimator.play("fade_in")
		0, 2, 7:
			_head._stop_talking()
			$GodotTalkFadeAnimator.play("fade_out")
	
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
