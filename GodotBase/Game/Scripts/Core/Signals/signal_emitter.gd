extends Node

class_name SignalEmitter

@export var sig : SignalBase
@export var sig_str : SignalString
@export var value_str : String

func emit ():
	sig.emit()

func emit_with_string (value : String):
	sig_str.emit_with_param(value)
