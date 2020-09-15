extends MeshInstance

func disable() -> void:
	material_override.albedo_color.a = 0.2

func enable() -> void:
	material_override.albedo_color.a = 1.0
