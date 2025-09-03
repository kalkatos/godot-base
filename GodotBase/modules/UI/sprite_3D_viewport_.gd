@tool
class_name Sprite3DViewport
extends Sprite3D

@export var vp: SubViewport


func _ready() -> void:
	texture = vp.get_texture()
