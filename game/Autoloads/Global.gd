extends Node

# ---------------------------------------------------------------------------------------
const AUDIOBUS_MUSIC = "Music"
const AUDIOBUS_SOUND = "Sound"
const AUDIOBUS_AMBIENT_SOUND = "AmbientSound"
const AUDIOBUS_PLAYER_SOUND = "PlayerSound"

# ---------------------------------------------------------------------------------------
enum State {
	INTRO,		# this is the tutorial with the 3-4 dialogs
	PRE_CRYPT,	# this is time of exploration until the player gets the ability from the crypt
	PUZZLE_1,	# this is the time before the player uses the new ability to break through the door
}

# ---------------------------------------------------------------------------------------
var state = State.INTRO

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
