@icon("uid://djlh8cto0xekt")
class_name Stack
extends Zone

@export var direction: Vector3 = Vector3.UP
@export var distance: float


func _organize ():
	var i = 0
	for child in get_children():
		child.global_position = global_position + distance * i * direction
		i += 1
