extends Node

func _ready() -> void:
	GlobalBus._on_button_pressed.connect(_handle_button_pressed)

func _handle_button_pressed ():
	Debug.log_msg("Test")
