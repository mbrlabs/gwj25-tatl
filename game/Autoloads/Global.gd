extends Node

# ---------------------------------------------------------------------------------------
const AUDIOBUS_MUSIC = "Music"
const AUDIOBUS_SOUND = "Sound"
const AUDIOBUS_AMBIENT_SOUND = "AmbientSound"
const AUDIOBUS_PLAYER_SOUND = "PlayerSound"

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
