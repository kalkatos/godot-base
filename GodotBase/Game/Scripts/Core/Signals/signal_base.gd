extends Resource

class_name SignalBase

signal on_emitted

func emit ():
	emit_signal(on_emitted.get_name())
