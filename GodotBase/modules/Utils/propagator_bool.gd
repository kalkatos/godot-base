class_name PropagatorBool
extends Node

signal on_inverted_bool (value: bool)


func emit_inverted (value: bool) -> void:
	on_inverted_bool.emit(!value)
