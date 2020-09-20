class_name DialogBox
extends Control

const DEFAULT_READ_SPEED := 0.02
const DEFAULT_FADE_OUT_TIME := 3.5

# ---------------------------------------------------------------------------------------
signal message_displayed
signal message_confirmed

# ---------------------------------------------------------------------------------------
enum State {
	IDLE,
	READING_MESSAGE,
	WAITING_FOR_CONFRIMATION,
}

# ---------------------------------------------------------------------------------------
export var read_speed: float = DEFAULT_READ_SPEED

# ---------------------------------------------------------------------------------------
onready var _label: RichTextLabel = $MarginContainer/Panel/MarginContainer/RichTextLabel
onready var _read_timer: Timer = $ReadTimer
onready var _fade_out_timer: Timer = $FadeOutTimer
onready var _read_sound: AudioStreamPlayer = $ReadSound
onready var _confirm_sound: AudioStreamPlayer = $ConfirmSound
onready var _continue_label: Label = $ContinueLabel
onready var _continue_label_anim: AnimationPlayer = $ContinueLabel/AnimationPlayer

# ---------------------------------------------------------------------------------------
var _state = State.IDLE
var _confirmation_required := false
var _read_index := 0
var _title: String
var _message: String

# ---------------------------------------------------------------------------------------
func _ready():
	_read_timer.wait_time = read_speed

# ---------------------------------------------------------------------------------------
func show_message(title: String, msg: String, confirmation_required: bool, wait_time: float = DEFAULT_FADE_OUT_TIME) -> void:
	if _state != State.WAITING_FOR_CONFRIMATION:
		_fade_out_timer.stop()
		_state = State.READING_MESSAGE
		_confirmation_required = confirmation_required
		_label.bbcode_text = ""
		_title = title
		_message = msg
		_read_index = 0
		_fade_out_timer.wait_time = wait_time
		_read_timer.start()
	#printerr("Called show_message while not in IDLE state. Check it in DialogBox.gd!")

# ---------------------------------------------------------------------------------------
func _input(e: InputEvent) -> void:
	if e.is_action_released("dialog_confirm"):
		if _state == State.WAITING_FOR_CONFRIMATION:
			_confirm_sound.play()
			_label.bbcode_text = ""
			_state = State.IDLE
			_continue_label.hide()
			emit_signal("message_confirmed")
		elif _state == State.READING_MESSAGE:
			_read_index = _message.length() - 1
	
# ---------------------------------------------------------------------------------------
func _on_ReadTimer_timeout():
	# increment indices n stuff
	if _read_index < _message.length():
		_read_index += 1
	else:
		_read_timer.stop()
		emit_signal("message_displayed")
		if _confirmation_required:
			_state = State.WAITING_FOR_CONFRIMATION
			_continue_label.show()
			_continue_label_anim.play("blink")
		else:
			_fade_out_timer.start()
	
	# generate text
	var final_text = ""
	if !_title.empty():
		final_text = "[b]" + _title + "[/b]\n\n"
	if _read_index > 0:
		final_text += _message.substr(0, _read_index+1)
	_label.bbcode_text = final_text
	
	# play clicking sound
	if _read_timer.wait_time < 0.05:
		if final_text.length() % 4 == 0:
			_read_sound.play()
	elif _read_timer.wait_time < 0.1:
		if final_text.length() % 2 == 0:
			_read_sound.play()
	else:
		_read_sound.play()

# ---------------------------------------------------------------------------------------
func _on_FadeOutTimer_timeout():
	_state = State.IDLE
	_label.bbcode_text = ""
