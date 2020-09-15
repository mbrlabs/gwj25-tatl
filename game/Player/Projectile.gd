class_name Projectile
extends MeshInstance

const SPEED := 100
var direction: Vector3
var start_position: Vector3

func _ready() -> void:
	global_transform.origin = start_position

func _physics_process(delta: float) -> void:
	translate(SPEED*delta*direction)

func _on_Area_body_entered(body):
	if body is RigidBody:
		body.apply_central_impulse(direction*64)
		
func _on_AutodestroyTimer_timeout():
	queue_free()
