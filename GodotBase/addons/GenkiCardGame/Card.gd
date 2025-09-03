@icon("uid://cahitwf3e4b12")
@tool
class_name Card
extends Draggable

@export var data: CardData:
	set(new_data):
		data = new_data
		_setup(new_data)
@export var field_views: Dictionary[String, Node]

@export_group("References")
@export var front: Node3D
@export var back: Node3D

var is_highlighted: bool = false

var is_face_up: bool:
	get: return global_basis.z.dot(Vector3.UP) >= 0

var _values: Dictionary[String, Variant]
var _drag_rotation_vector: Vector3
var _camera_face_down_direction: Vector3
var _drag_quat: Quaternion
var _front_highlight_tween: Tween
var _back_highlight_tween: Tween

const FACE_UP = Quaternion(-0.7071, 0, 0, 0.7071)
const FACE_DOWN = Quaternion(0.0, 0.7071, -0.7071, 0.0)


func _ready () -> void:
	super()
	_values = {}
	var camera = get_viewport().get_camera_3d()
	if not camera:
		Debug.log_error("No camera 3D found in the current viewport.")
		return
	_drag_rotation_vector = camera.basis.z


func set_data (data_: CardData) -> void:
	data = data_
	_setup(data)


func set_field_value (key: String, value: Variant):
	_values[key] = value
	if field_views.has(key):
		_update_view(key, value, field_views[key])


func set_highlight (on: bool) -> void:
	if on == is_highlighted:
		return
	if on:
		if _is_being_dragged:
			return
		if _front_highlight_tween:
			_front_highlight_tween.kill()
		_front_highlight_tween = create_tween()
		_front_highlight_tween.tween_property(front, "position", Vector3(0, 0, Global.highlight_height), 0.2)
		_front_highlight_tween.parallel().tween_property(front, "scale", Vector3(1.1, 1.1, 1.1), 0.2)
		if _back_highlight_tween:
			_back_highlight_tween.kill()
		_back_highlight_tween = create_tween()
		_back_highlight_tween.tween_property(back, "position", Vector3(0, 0, -Global.highlight_height), 0.2)
		_back_highlight_tween.parallel().tween_property(back, "scale", Vector3(1.1, 1.1, 1.1), 0.2)
		is_highlighted = true
	else:
		if _front_highlight_tween:
			_front_highlight_tween.kill()
		_front_highlight_tween = create_tween()
		_front_highlight_tween.tween_property(front, "position", Vector3(0, 0, 0), 0.2)
		_front_highlight_tween.parallel().tween_property(front, "scale", Vector3(1, 1, 1), 0.2)
		if _back_highlight_tween:
			_back_highlight_tween.kill()
		_back_highlight_tween = create_tween()
		_back_highlight_tween.tween_property(back, "position", Vector3(0, 0, 0), 0.2)
		_back_highlight_tween.parallel().tween_property(back, "scale", Vector3(1, 1, 1), 0.2)
		is_highlighted = false


func set_face (up: bool) -> void:
	if up:
		quaternion = FACE_UP
	else:
		quaternion = FACE_DOWN


func flip () -> void:
	Debug.logm("Flipping card %s" % [name])
	var up = not is_face_up
	var target_quaternion = FACE_UP if up else FACE_DOWN
	var start_position = global_position
	var subtween = create_tween()
	subtween.tween_property(self, "global_position", start_position + Vector3(0, 1.5, 0), 0.1)
	subtween.tween_property(self, "global_position", start_position, 0.1)
	var tween = create_tween()
	tween.tween_subtween(subtween)
	tween.parallel().tween_property(self, "quaternion", target_quaternion, 0.2)
	tween.finished.connect(_handle_flip_finished)


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


func _hover_entered ():
	set_highlight(true)


func _hover_exited ():
	set_highlight(false)


func _begin_drag (_mouse_position: Vector2):
	set_highlight(false)
	var camera = get_viewport().get_camera_3d()
	_drag_quat = Quaternion(get_parent().global_basis.z, _drag_rotation_vector)


func _drag (_mouse_position: Vector2):
	quaternion = quaternion.slerp(_drag_quat, _begin_drag_lerp)


func _end_drag (_mouse_position: Vector2):
	pass


func _click (_mouse_position: Vector2):
	pass


func _handle_flip_finished () -> void:
	pass
