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
		DialogBox.show_message("Cloaked figure:", ". . .", false, 1.5)
	elif !Global.zombies_hostile:
		DialogBox.show_message("Tatl:", "Oops...", false, 2)
		Global.zombies_hostile = true
		for z in get_tree().get_nodes_in_group("zombie"):
			z.hostile = true
