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


func send (key: String, value: Variant):
	Debug.logm("Sending (FAKE) event: %s with value %s" % [key, str(value)])


func send_unique (key: String, value: Variant, id: String):
	Debug.logm("Sending (FAKE) unique event: %s with value %s and id %s" % [key, str(value), id])
