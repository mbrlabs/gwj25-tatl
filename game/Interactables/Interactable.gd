class_name Interactable
extends Area

# ---------------------------------------------------------------------------------------
export var dialog_box: NodePath
export var interact_overlay: NodePath
export var interaction_prompt: String = "Press [E] to interact"
export var one_shot: bool = false
export var disabled: bool = false

# ---------------------------------------------------------------------------------------
var _already_interacted_once := false
var _player_in_interactable_area := false
var _interacted_by_player_without_leaving_area := false

# ---------------------------------------------------------------------------------------
func _ready() -> void:
	connect("body_entered", self, "_on_body_entered")
	connect("body_exited", self, "_on_body_exited")
	
# ---------------------------------------------------------------------------------------
func _is_interactable() -> bool:
	return true

# ---------------------------------------------------------------------------------------
func _on_body_entered(body: PhysicsBody) -> void:
	if !disabled && body && body.collision_layer == 1:
		_player_in_interactable_area = true
		if _is_interactable():
			if !one_shot || (one_shot && !_already_interacted_once):
				var overlay = get_node(interact_overlay)
				overlay.set_text(interaction_prompt)
				overlay.show()

# ---------------------------------------------------------------------------------------
func _on_body_exited(body) -> void:
	if !disabled && body.collision_layer == 1:
		_player_in_interactable_area = false
		_interacted_by_player_without_leaving_area = false
		get_node(interact_overlay).hide()

# ---------------------------------------------------------------------------------------
func _input(event: InputEvent) -> void:
	if _is_interactable() && !disabled && _player_in_interactable_area && !_interacted_by_player_without_leaving_area:
		if event.is_action_released("interact"):
			if !one_shot || (one_shot && !_already_interacted_once):
				get_node(interact_overlay).hide()
				_already_interacted_once = true
				_interacted_by_player_without_leaving_area = true
				_on_interact()

# ---------------------------------------------------------------------------------------
func _on_interact() -> void:
	pass
