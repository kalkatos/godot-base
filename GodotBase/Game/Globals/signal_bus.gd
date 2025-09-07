extends Node

# All signals here must start with undescore '_'
signal _on_music_volume_set (value: float)
signal _on_sfx_volume_set (value: float)
signal _on_settings_panel (open: bool)


func emit_on_settings_panel (open: bool):
	if SignalBus != self:
		_on_settings_panel.emit(open)
	SignalBus._on_settings_panel.emit(open)


func emit_on_sfx_volume_set (value: float):
	if SignalBus != self:
		_on_sfx_volume_set.emit(value)
	SignalBus._on_sfx_volume_set.emit(value)


func emit_on_music_volume_set (value: float):
	if SignalBus != self:
		_on_music_volume_set.emit(value)
	SignalBus._on_music_volume_set.emit(value)


func _ready ():
	if self == SignalBus:
		return
	for sig in get_signal_list():
		if not sig.name.begins_with('_'):
			break
		for connection in get_signal_connection_list(sig.name):
			SignalBus.connect(sig.name, connection.callable)
