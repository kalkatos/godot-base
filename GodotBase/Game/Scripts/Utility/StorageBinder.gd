extends Node

class_name StorageBinder

signal on_value_changed (value: Variant)

@export var key: String

func _ready() -> void:
	Storage.on_value_saved.connect(_handle_value_changed)
	if Storage.has_value(key):
		on_value_changed.emit(Storage.saved_dict[key])

func _exit_tree () -> void:
	Storage.on_value_saved.disconnect(_handle_value_changed)

func _handle_value_changed (key_: String, value: Variant):
	if key_ != key:
		return
	on_value_changed.emit(value)
