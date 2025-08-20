extends Node2D

@export var damage_number: PackedScene

var _instance: DamageNumber

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if !_instance:
			_instance = damage_number.instantiate() as DamageNumber
			add_child(_instance)
			_instance.owner = self
			Debug.logm("Instantiated " + str(_instance))
		_instance.play("123", event.position)
