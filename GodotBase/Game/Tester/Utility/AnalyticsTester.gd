extends Node

func _ready() -> void:
	SignalBus._on_settings_panel.connect(_handle_settings_panel)


func _handle_settings_panel (open: bool):
	if (open):
		Analytics.send_event("settings_opened")
