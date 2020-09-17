extends RigidBody

var fall_sound: AudioStreamPlayer3D

# ---------------------------------------------------------------------------------------
func _ready():
	fall_sound = AudioStreamPlayer3D.new()
	if randf() < 0.5:
		fall_sound.stream = preload("res://Assets/Audio/brick.ogg")
	else:
		fall_sound.stream = preload("res://Assets/Audio/brick2.ogg")
	fall_sound.bus = Global.AUDIOBUS_AMBIENT_SOUND
	fall_sound.unit_db = 15.0
	add_child(fall_sound)

# ---------------------------------------------------------------------------------------	
func _process(delta):
	if linear_velocity.length() > 20.0:
		if !fall_sound.playing:
			fall_sound.play()
