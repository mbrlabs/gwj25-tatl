extends RigidBody

var fall_sound: AudioStreamPlayer3D

# ---------------------------------------------------------------------------------------
func _ready():
	$Area.connect("area_entered", self, "_on_area_entered")
	fall_sound = AudioStreamPlayer3D.new()
	fall_sound.stream = preload("res://Assets/Audio/rock.ogg")
	fall_sound.bus = Global.AUDIOBUS_AMBIENT_SOUND
	fall_sound.unit_size = 4
	add_child(fall_sound)

# ---------------------------------------------------------------------------------------	
func _on_area_entered(area) -> void:
	if !fall_sound.playing:
		fall_sound.play()
		
# ---------------------------------------------------------------------------------------	
func _process(delta):
	if linear_velocity.length() > 12.0:
		if !fall_sound.playing:
			fall_sound.play()
