class_name AnalyticsSender
extends Node
## Base class for sender implementations

signal on_initialized

var is_initialized: bool


func _ready() -> void:
	initialize()


func initialize ():
	is_initialized = true
	on_initialized.emit()


func send (_key: String):
	pass


func send_str (_key: String, _str: String):
	pass


func send_num (_key: String, _num: float):
	pass
