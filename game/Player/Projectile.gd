class_name Projectile
extends MeshInstance

const SPEED := 100
var direction: Vector3
var start_position: Vector3

func _ready() -> void:
	global_transform.origin = start_position

func _physics_process(delta: float) -> void:
	translate(SPEED*delta*direction)
		
func _on_AutodestroyTimer_timeout():
	queue_free()
