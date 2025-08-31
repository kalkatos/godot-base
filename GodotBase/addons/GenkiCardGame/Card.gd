@icon("uid://dpf762npkqnp5")
@tool
class_name Card
extends Node3D

@export var data: CardData:
	set(new_data):
		data = new_data
		_setup(new_data)
@export var field_views: Dictionary[String, Node]

var _values: Dictionary[String, Variant]


func set_field_value (key: String, value: Variant):
	_values[key] = value
	if field_views.has(key):
		_update_view(key, value, field_views[key])


func _setup (_data: CardData):
	if not _data:
		return
	for key in _data.fields:
		set_field_value(key, _data.fields[key])


func _update_view (key: String, value: Variant, node: Node):
	if value is bool:
		node.visible = value
		return
	var node_class = node.get_class()
	match node_class:
		"Label", "Label3D", "RichTextLabel":
			node.text = value
		"Sprite2D", "Sprite3D", "TextureRect", "NinePatchRect":
			node.texture = value
		_:
			Debug.log_error("Treatment for field view with key %s and class %s is not implemented." % [key, node_class])
