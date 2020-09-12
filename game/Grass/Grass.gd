tool
extends MeshInstance

const A = [0.0, 0.0]
const B = [0.0, 0.5]
const C = [0.5, 0.0]
const D = [0.5, 0.5]
const UV_MAP = [B, A, A, A, A, A, C, C, C, D, D, D]
const PI2 = 6.28319

onready var mm: MultiMeshInstance = $GrassMultiMesh
export var grass_count: int = 128

func _ready():
	mm.multimesh.instance_count = grass_count
	mm.multimesh.visible_instance_count = grass_count
	
	var aabb_size = get_aabb().size
	var pos = mm.transform.origin
	
	var min_x = pos.x - (aabb_size.x / 2.0)
	var max_x = pos.x + (aabb_size.x / 2.0)
	var min_z = pos.z + (aabb_size.z / 2.0)
	var max_z = pos.z - (aabb_size.z / 2.0)
	
	for i in range(grass_count):
		var x = rand_range(min_x, max_x)
		var z = rand_range(min_z, max_z)
		var scl = rand_range(0.66, 1.0)
		var uvs: int = rand_range(0, UV_MAP.size())
		var basis = mm.transform.scaled(Vector3(scl, scl, scl)).rotated(Vector3.UP, rand_range(-1, 1)*PI2).basis
		mm.multimesh.set_instance_transform(i, Transform(basis, Vector3(x, 0, z)))
		mm.multimesh.set_instance_custom_data(i, Color(
			0.5+randf()*0.5, # random value; used for per-instance-randomness on x-axis wind movement
			0.5+randf()*0.5, # random value; used for per-instance-randomness on z-axis wind movement
			UV_MAP[uvs][0],	 # x-UV coordinate
			UV_MAP[uvs][1]	 # z-UV coordinate
		))
