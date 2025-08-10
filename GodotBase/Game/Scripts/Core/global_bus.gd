extends Node

# All signals here must start with undescore '_'
signal _on_button_pressed
signal _on_game_started
signal _name_changed (new_name: String)

func emit_name_changed (new_name: String):
	_name_changed.emit(new_name)
	GlobalBus._name_changed.emit(new_name)

func emit_on_game_started ():
	_on_game_started.emit()
	GlobalBus._on_game_started.emit()

func emit_on_button_pressed ():
	_on_button_pressed.emit()
	GlobalBus._on_button_pressed.emit()


func _ready ():
	if self == GlobalBus:
		return
	for sig in get_signal_list():
		if not sig.name.begins_with('_'):
			break
		for connection in get_signal_connection_list(sig.name):
			GlobalBus.connect(sig.name, connection.callable)
