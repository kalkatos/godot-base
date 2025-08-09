extends SignalBase

class_name SignalString

signal on_emitted_with_param (value: String)

@export var value : String

func emit_with_param (value_param: String):
	value = value_param
	emit_signal(on_emitted_with_param.get_name(), value)
