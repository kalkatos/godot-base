extends Node

signal handle_signal
signal handle_signal_str (value: String)

@export var sig : SignalBase
@export var sig_str : SignalString

func _ready ():
	if sig:
		sig.on_emitted.connect(_handle_signal)
	if sig_str:
		sig_str.on_emitted_with_param.connect(_handle_signal_str)

func _handle_signal ():
	emit_signal(handle_signal.get_name())

func _handle_signal_str (value : String):
	emit_signal(handle_signal_str.get_name(), value)
