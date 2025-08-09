extends Node

signal on_button_pressed
signal change_name (new_name: String)
signal game_started
signal coins_changed (val: int)
signal on_combat_started
signal on_myloot_gained
signal bye_bye (pas: float)
signal on_combat_finished
signal on_card_added

func emit_on_card_added ():
	on_card_added.emit()
	GlobalBus.on_card_added.emit()

func emit_on_combat_finished ():
	on_combat_finished.emit()
	GlobalBus.on_combat_finished.emit()


func emit_bye_bye (pas: float):
	bye_bye.emit(pas)
	GlobalBus.bye_bye.emit(pas)



func emit_on_myloot_gained ():
	on_myloot_gained.emit()
	GlobalBus.on_myloot_gained.emit()


func emit_on_combat_started ():
	on_combat_started.emit()
	GlobalBus.on_combat_started.emit()


func _ready ():
	if self == GlobalBus:
		return
	for sig in get_signal_list():
		if sig.name == "ready":
			break
		for connection in get_signal_connection_list(sig.name):
			GlobalBus.connect(sig.name, connection.callable, CONNECT_PERSIST)

func emit_on_button_pressed ():
	on_button_pressed.emit()
	GlobalBus.on_button_pressed.emit()

func emit_change_name (new_name: String):
	change_name.emit(new_name)
	GlobalBus.change_name.emit(new_name)

func emit_game_started ():
	game_started.emit()
	GlobalBus.game_started.emit()

func emit_coins_changed (val: int):
	coins_changed.emit(val)
	GlobalBus.coins_changed.emit(val)
