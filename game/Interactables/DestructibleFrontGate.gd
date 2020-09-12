class_name DestructibleFrontGate
extends Spatial

# ---------------------------------------------------------------------------------------
enum State {
	OK,
	DAMAGED,
	BROKEN
}

# ---------------------------------------------------------------------------------------
onready var _gate_model_ok: Spatial = $CastleFrontGate
onready var _gate_model_damaged: Spatial = $CastleFrontGateDamaged
onready var _gate_model_broken: Spatial = $CastleFrontGateBroken
onready var _destruction_particles: CPUParticles = $DesctructionParticles

# ---------------------------------------------------------------------------------------
var _state = State.OK

# ---------------------------------------------------------------------------------------
func _ready() -> void:
	pass

# ---------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	pass

# ---------------------------------------------------------------------------------------
func _play_desctruction_effects() -> void:
	pass

# ---------------------------------------------------------------------------------------
func smash_it() -> void:
	match _state:
		State.OK:
			_gate_model_ok.hide()
			_gate_model_damaged.show()
			_play_desctruction_effects()
		State.DAMAGED:
			_gate_model_damaged.hide()
			_gate_model_broken.show()
			_play_desctruction_effects()
		State.BROKEN:
			printerr("This should not happen")
