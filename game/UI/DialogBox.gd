class_name DialogBox
extends Control

const DEFAULT_READ_SPEED := 0.02

# ---------------------------------------------------------------------------------------
signal message_displayed
signal message_accepted

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

# ---------------------------------------------------------------------------------------
var _state = State.IDLE
var _confirmation_required := false
var _next_title_index := 0
var _next_content_index := 0
var _next_title: String
var _next_content: String

# ---------------------------------------------------------------------------------------
func _ready():
	_read_timer.wait_time = read_speed

# ---------------------------------------------------------------------------------------
func show_message(title: String, content: String, confirmation_required: bool, speed: float = DEFAULT_READ_SPEED) -> void:
	if _state == State.IDLE:
		_state = State.READING_MESSAGE
		_confirmation_required = confirmation_required
		_label.bbcode_text = ""
		_next_title = title
		_next_content = content
		_next_title_index = 0
		_next_content_index = 0
		_read_timer.start()
	else:
		printerr("YOU should NOT do this!!!")

# ---------------------------------------------------------------------------------------
func _on_ReadTimer_timeout():
	# increment indices n stuff
	if _next_title_index < _next_title.length():
		_next_title_index += 1
	elif _next_content_index < _next_content.length():
		_next_content_index += 1
	else:
		_read_timer.stop()
		emit_signal("message_displayed")
		if _confirmation_required:
			# TODO: handle input
			_state = State.WAITING_FOR_CONFRIMATION
		else:
			_fade_out_timer.start()
	
	# generate text
	var final_text = ""
	if _next_title_index > 0:
		final_text = "[b]" + _next_title.substr(0, _next_title_index+1) + "[/b]\n\n"
	if _next_content_index > 0:
		final_text += _next_content.substr(0, _next_content_index+1)
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