extends Node

# All signals here must start with undescore '_'
signal _on_button_pressed
signal _on_str_changed (new_str: String)
signal _on_music_volume_set (value: float)
signal _on_sfx_volume_set (value: float)
signal _on_settings_panel (open: bool)

func emit_on_settings_panel (open: bool):
	_on_settings_panel.emit(open)
	SignalBus._on_settings_panel.emit(open)

func emit_on_sfx_volume_set (value: float):
	_on_sfx_volume_set.emit(value)
	SignalBus._on_sfx_volume_set.emit(value)

func emit_on_music_volume_set (value: float):
	_on_music_volume_set.emit(value)
	SignalBus._on_music_volume_set.emit(value)

func emit_on_str_changed (new_str: String):
	_on_str_changed.emit(new_str)
	SignalBus._on_str_changed.emit(new_str)

func emit_on_button_pressed ():
	_on_button_pressed.emit()
	SignalBus._on_button_pressed.emit()

func _ready ():
	if self == SignalBus:
		return
	for sig in get_signal_list():
		if not sig.name.begins_with('_'):
			break
		for connection in get_signal_connection_list(sig.name):
			SignalBus.connect(sig.name, connection.callable)
