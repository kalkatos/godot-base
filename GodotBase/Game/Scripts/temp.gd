extends Node

@export var sig : SignalBase

func _ready ():
	await get_tree().create_timer(3.0).timeout
