tool
extends StaticBody

const A = [0.0, 0.0]
const B = [0.0, 0.5]
const C = [0.5, 0.0]
const D = [0.5, 0.5]
const UV_MAP = [B, A, A, A, A, A, C, C, C, D, D, D]
const PI2 = 6.28319

onready var _mm: MultiMeshInstance = $Chunk/GrassMultiMesh
onready var _base_mesh: MeshInstance = $Chunk

export var grass_count: int = 200

func _ready():
	_mm.multimesh = MultiMesh.new()
	_mm.multimesh.transform_format = MultiMesh.TRANSFORM_3D
	_mm.multimesh.custom_data_format = MultiMesh.CUSTOM_DATA_FLOAT
	_mm.multimesh.instance_count = grass_count
	_mm.multimesh.mesh = preload("res://Props/Grass/grass.obj")
	_mm.multimesh.visible_instance_count  = grass_count
	
	var aabb_size = _base_mesh.get_aabb().size
	var pos = _mm.transform.origin
	
	var min_x = pos.x - (aabb_size.x / 2.0)
	var max_x = pos.x + (aabb_size.x / 2.0)
	var min_z = pos.z + (aabb_size.z / 2.0)
	var max_z = pos.z - (aabb_size.z / 2.0)
	
	for i in grass_count:
		var x = rand_range(min_x, max_x)
		var z = rand_range(min_z, max_z)
		var scl = rand_range(0.66, 1.0)
		var uvs := int(rand_range(0, UV_MAP.size()))
		var basis = _mm.transform.scaled(Vector3(scl, scl, scl)).rotated(Vector3.UP, rand_range(-1, 1)*PI2).basis
		_mm.multimesh.set_instance_transform(i, Transform(basis, Vector3(x, 0, z)))
		_mm.multimesh.set_instance_custom_data(i, Color(
			0.5+randf()*0.5, # random value; used for per-instance-randomness on x-axis wind movement
			0.5+randf()*0.5, # random value; used for per-instance-randomness on z-axis wind movement
			UV_MAP[uvs][0],	 # x-UV coordinate
			UV_MAP[uvs][1]	 # z-UV coordinate
		))
