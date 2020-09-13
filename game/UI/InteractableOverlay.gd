class_name InteractableOverlay
extends Control

onready var _label: Label = $MarginContainer/Label

func set_text(text: String) -> void:
	_label.text = text
