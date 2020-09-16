extends Node

# ---------------------------------------------------------------------------------------
const AUDIOBUS_MUSIC = "Music"
const AUDIOBUS_SOUND = "Sound"
const AUDIOBUS_AMBIENT_SOUND = "AmbientSound"
const AUDIOBUS_PLAYER_SOUND = "PlayerSound"

# ---------------------------------------------------------------------------------------
enum State {
	INTRO,	# this is the tutorial sequence (3-4 dialogs of Tatl to player)
	CRYPT,	# this is time of exploration until the player gets the ability from the crypt
	PRE_CASTLE, # this is the time before the player breaks through the castle front door
	CASTLE,	# this is the time inside the castle
	MONTAIN,# this is when the player gets through the castle exit
}

# ---------------------------------------------------------------------------------------
var state = State.INTRO
var buffed_form_unlocked := false
var god_mode_enabled := false

# ---------------------------------------------------------------------------------------
var _music: AudioStreamPlayer

# ---------------------------------------------------------------------------------------
func _ready():
	_music = AudioStreamPlayer.new()
	_music.stream = preload("res://Common/Audio/OtherWorlds-03.ogg")
	_music.bus = AUDIOBUS_MUSIC
	add_child(_music)

# ---------------------------------------------------------------------------------------
func mute_audiobus(bus_name: String, mute: bool = true):
	var sound_bus_idx = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(sound_bus_idx, mute)

# ---------------------------------------------------------------------------------------
func play_music(play: bool = true) -> void:
	_music.play()
