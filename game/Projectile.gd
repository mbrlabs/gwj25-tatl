class_name Projectile
extends Area

const SPEED := 15.0
var direction: Vector3
var start_position: Vector3
var my_transform: Transform

func _ready() -> void:
	global_transform.origin = start_position

func _physics_process(delta: float) -> void:
	#direction += Vector3(rand_range(-0.01, 0.01), rand_range(-0.01, 0.01), rand_range(-0.01, 0.01))
	translate(SPEED*delta*direction)

func _on_Projectile_body_entered(body):
	if !(body is KinematicBody):
		#print(body.get_path())
		queue_free()
		
func _on_AutodestroyTimer_timeout():
	queue_free()
