extends Interactable

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	var zombie = get_parent()
	return zombie.is_in_group("zombie") && !zombie.hostile && !Global.zombies_hostile
	
# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	if !Global.zombies_hostile:
		Global.zombies_hostile = true
		for z in get_tree().get_nodes_in_group("zombie"):
			z.hostile = true
