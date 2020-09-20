extends Interactable

# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	var zombie = get_parent()
	if zombie.is_in_group("mystery_zombie"):
		return true
	return zombie.is_in_group("zombie") && !zombie.hostile && !Global.zombies_hostile
	
# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	if get_parent().is_in_group("mystery_zombie"):
		get_node(dialog_box).show_message("Cloaked figure:", ". . .", false, 1.5)
	elif !Global.zombies_hostile:
		Global.zombies_hostile = true
		for z in get_tree().get_nodes_in_group("zombie"):
			z.hostile = true
