extends POIArea

const REPLIES = [
	"I don't want to go into THAT forest. It looks dangerous...",
	"No, it's dangerous! There must be another way home.",
	"Nope, still not going in there."
]
var _reply_index = 0

# ---------------------------------------------------------------------------------------
func _is_triggerable() -> bool:
	return Global.state != Global.State.INTRO

# ---------------------------------------------------------------------------------------
func _get_dialog_title() -> String:
	return "Tatl:"

# ---------------------------------------------------------------------------------------
func _get_dialog_message() -> String:
	var reply = REPLIES[_reply_index]
	_reply_index += 1
	if _reply_index == REPLIES.size(): 
		_reply_index = 0
	return reply
