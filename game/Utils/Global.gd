extends Node

# ---------------------------------------------------------------------------------------
const AUDIOBUS_MASTER = "Master"
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
	THE_END,# this is when the player gets through the castle exit	
}

# ---------------------------------------------------------------------------------------
var state = State.INTRO
var buffed_form_unlocked := true
var god_mode_enabled := false
var mouse_sensitivity := 50
var zombies_hostile := false

# ---------------------------------------------------------------------------------------
var _music: AudioStreamPlayer
var _music_tween: Tween

# ---------------------------------------------------------------------------------------
func _ready():
	_music = AudioStreamPlayer.new()
	_music.stream = preload("res://Assets/Audio/OtherWorlds-03.ogg")
	_music.bus = AUDIOBUS_MUSIC
	add_child(_music)
	
	_music_tween = Tween.new()
	add_child(_music_tween)

# ---------------------------------------------------------------------------------------
func mute_audiobus(bus_name: String, mute: bool = true):
	var sound_bus_idx = AudioServer.get_bus_index(bus_name)
	AudioServer.set_bus_mute(sound_bus_idx, mute)

# ---------------------------------------------------------------------------------------
func play_music(play: bool = true) -> void:
	if play:
		if !_music.playing:
			_music.volume_db = -35
			_music_tween.interpolate_property(_music, "volume_db", _music.volume_db, 0, 1.2)
			_music_tween.start()
			_music.play()
	else:
		_music.stop()

# ---------------------------------------------------------------------------------------
func reset() -> void:
	state = State.INTRO
	buffed_form_unlocked = false
	zombies_hostile = false

# ---------------------------------------------------------------------------------------
func get_resolution() -> Vector2:
	return Vector2(1920, 1080)
