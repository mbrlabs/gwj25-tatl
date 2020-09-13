class_name DestructibleFrontGate
extends Interactable

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
onready var _collsion_shape_intact: CollisionShape = $StaticBody/CollisionShape_intact
onready var _collsion_shape_broken: CollisionShape = $StaticBody/CollisionShape_broken

# ---------------------------------------------------------------------------------------
var _state = State.OK

# ---------------------------------------------------------------------------------------
func _ready() -> void:
	pass

# ---------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	pass

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return Global.state != Global.State.INTRO

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	var dbox := get_node(dialog_box) as DialogBox
	if Global.state == Global.State.PRE_CRYPT:
		dbox.show_message("Tatl", "That gate looks pretty tough. I don't think i can get through it :(", false)
	
# ---------------------------------------------------------------------------------------
func _play_desctruction_effects() -> void:
	pass

# ---------------------------------------------------------------------------------------
func _smash_it() -> void:
	match _state:
		State.OK:
			_gate_model_ok.hide()
			_gate_model_damaged.show()
			_play_desctruction_effects()
		State.DAMAGED:
			_gate_model_damaged.hide()
			_gate_model_broken.show()
			_collsion_shape_intact.disabled = true
			_collsion_shape_broken.disabled = false
			_play_desctruction_effects()
		State.BROKEN:
			printerr("This should not happen")
