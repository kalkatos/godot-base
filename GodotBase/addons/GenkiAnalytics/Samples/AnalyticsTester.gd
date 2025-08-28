extends Node

func _ready() -> void:
	# Connect to signal
	# SignalBus._on_settings_panel.connect(_handle_settings_panel)
	pass


func _handle_settings_panel (open: bool):
	# Send event
	if (open):
		Analytics.send_event("settings_opened")
