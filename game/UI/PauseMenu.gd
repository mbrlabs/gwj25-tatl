class_name PauseMenu
extends Control

# ---------------------------------------------------------------------------------------
signal unpaused

# ---------------------------------------------------------------------------------------
onready var _sensitivity_label: Label = $MarginContainer/ColorRect/VBoxContainer/MouseSensitivityLabel
onready var _sensitivity_slider: HSlider = $MarginContainer/ColorRect/VBoxContainer/MouseSensitivitySlider
onready var _anim_player: AnimationPlayer = $SlideAnimationPlayer
var handle_input := false

# ---------------------------------------------------------------------------------------
func _ready():
	_sensitivity_label.text = "Mouse sensitivity: " + str(Global.mouse_sensitivity)
	_sensitivity_slider.value = Global.mouse_sensitivity

# ---------------------------------------------------------------------------------------
func _process(delta):
	if handle_input && Input.is_action_just_pressed("pause") && get_tree().paused:
		get_tree().paused = false
		emit_signal("unpaused")
	handle_input = true

# ---------------------------------------------------------------------------------------
func slide_in() -> void:
	_anim_player.play("slide_in")
	$ClickSound.play()

# ---------------------------------------------------------------------------------------
func slide_out() -> void:
	_anim_player.play("slide_out")
	$ClickSound.play()

# ---------------------------------------------------------------------------------------
func _on_MouseSensitivitySlider_value_changed(value):
	_sensitivity_label.text = "Mouse sensitivity: " + str(value)
	Global.mouse_sensitivity = value

# ---------------------------------------------------------------------------------------
func _on_ContinueButton_pressed():
	$ClickSound.play()
	get_tree().paused = false
	emit_signal("unpaused")

# ---------------------------------------------------------------------------------------
func _on_ContinueButton_mouse_entered():
	$HoverSound.play()

# ---------------------------------------------------------------------------------------
func _on_QuitButton_mouse_entered():
	$HoverSound.play()

# ---------------------------------------------------------------------------------------
func _on_QuitButton_pressed():
	Global.reset()
	get_tree().paused = false
	get_tree().change_scene("res://Screens/MainMenu.tscn")
