extends Node

# All signals here must start with undescore '_'
signal _on_button_pressed
signal _on_str_changed (new_str: String)

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
