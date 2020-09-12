extends Node

# ---------------------------------------------------------------------------------------
export var initial_wait_time: float = 4.0
export var wait_time: float = 4.0
export var listener: NodePath

# ---------------------------------------------------------------------------------------
var _sound_sources = []
var _initial_timer: Timer
var _timer: Timer
var _listener: Spatial

# ---------------------------------------------------------------------------------------
func _ready() -> void:
	# get our sound sources
	for c in get_children():
		if c is AudioStreamPlayer3D:
			_sound_sources.append(c)
	
	# one-shot initial timer
	_initial_timer = Timer.new()
	_initial_timer.wait_time = initial_wait_time
	_initial_timer.one_shot = true
	_initial_timer.autostart = true
	_initial_timer.connect("timeout", self, "_play_closest_sound_source")
	add_child(_initial_timer)
	
	# create the recurring timer
	_timer = Timer.new()
	_timer.wait_time = wait_time
	_timer.one_shot = false
	_timer.autostart = true
	_timer.connect("timeout", self, "_play_closest_sound_source")	
	add_child(_timer)

# ---------------------------------------------------------------------------------------
func _play_closest_sound_source() -> void:
	var target = get_node(listener)
	if target != null:
		var nearest: AudioStreamPlayer3D
		var nearest_dist: float = 1000000
		for s in _sound_sources:
			var dist = target.global_transform.origin.distance_to(s.global_transform.origin)
			if dist < nearest_dist:
				nearest = s
				nearest_dist = dist
		nearest.play()
