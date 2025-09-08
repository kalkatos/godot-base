extends Node
## All signals here must start with '_on_' to be auto-connected to SignalBus

# ███████████████████████████████  S Y S T E M S  █████████████████████████████████

signal _on_music_volume_set (value: float)
func emit_on_music_volume_set (value: float):
	Global.music_volume = value
	if SignalBus != self:
		_on_music_volume_set.emit(value)
	SignalBus._on_music_volume_set.emit(value)


signal _on_sfx_volume_set (value: float)
func emit_on_sfx_volume_set (value: float):
	Global.sfx_volume = value
	if SignalBus != self:
		_on_sfx_volume_set.emit(value)
	SignalBus._on_sfx_volume_set.emit(value)


signal _on_settings_panel (open: bool)
func emit_on_settings_panel (open: bool):
	Global.settings_panel_open = open
	if SignalBus != self:
		_on_settings_panel.emit(open)
	SignalBus._on_settings_panel.emit(open)


# ███████████████████████████████  R E A D Y  ███████████████████████████████████

func _ready ():
	if self == SignalBus:
		return
	for sig in get_signal_list():
		if not sig.name.begins_with('_'):
			break
		for connection in get_signal_connection_list(sig.name):
			SignalBus.connect(sig.name, connection.callable)
