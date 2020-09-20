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
onready var _collsion_shape_broken: CollisionPolygon = $StaticBody/CollisionShape_broken

# ---------------------------------------------------------------------------------------
export var required_projectile_count_per_stage: int = 120

# ---------------------------------------------------------------------------------------
var _state = State.OK
var projectile_count := 0

# ---------------------------------------------------------------------------------------
func _ready() -> void:
	pass

# ---------------------------------------------------------------------------------------
func _physics_process(delta: float) -> void:
	pass

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return Global.state == Global.State.PRE_CASTLE || Global.state == Global.State.CRYPT

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	var dbox := get_node(dialog_box) as DialogBox
	if Global.state == Global.State.CRYPT:
		dbox.show_message("Tatl:", "That gate looks pretty tough. I don't think i can get through it :(", false)
	if Global.state == Global.State.PRE_CASTLE:
		if _state == State.OK:
			dbox.show_message("Tatl:", "I wonder what the Godot-Cannon does to that gate...", false)
		if _state == State.DAMAGED:
			dbox.show_message("Tatl:", "I'm almost through it. One more time!", false)

# ---------------------------------------------------------------------------------------
func _on_DestructibleFrontGate_area_entered(area: Area):
	if _state != State.BROKEN && area.collision_layer == 16: # TODO: clean this up! layer 16 area projectils
		projectile_count += 1
		if projectile_count >= required_projectile_count_per_stage:
			$DestructionSound.play()
			_destruction_particles.emitting = true
			projectile_count = 0
			match _state:
				State.OK:
					_state = State.DAMAGED
					_gate_model_ok.hide()
					_gate_model_damaged.show()
				State.DAMAGED:
					Global.state = Global.State.CASTLE
					_state = State.BROKEN
					_gate_model_damaged.hide()
					_gate_model_broken.show()
					_collsion_shape_intact.disabled = true
					_collsion_shape_broken.disabled = false
					var dbox := get_node(dialog_box)
					dbox.show_message("Tatl:", "Alright, we're through. Let's see what's inside.", false)
