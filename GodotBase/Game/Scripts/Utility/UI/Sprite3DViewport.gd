@tool
extends Sprite3D

class_name Sprite3DViewport

@export var vp: SubViewport

func _ready() -> void:
	texture = vp.get_texture()
