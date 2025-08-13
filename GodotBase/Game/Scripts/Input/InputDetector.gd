extends Area3D

class_name InputDetector

var _plane: Plane
var _is_dragging: bool
var _camera: Camera3D

func _input (event: InputEvent) -> void:
	if !_is_dragging:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			_end_drag()
			_is_dragging = false
	elif event is InputEventMouseMotion:
		_drag(event)

func _input_event (camera: Camera3D, event: InputEvent, _event_position: Vector3,
			_normal: Vector3, _shape_idx: int) -> void:
	if event is not InputEventMouseButton or event.button_index != MOUSE_BUTTON_LEFT:
		return
	if !_is_dragging:
		_camera = camera
		_plane = Plane(_camera.transform.basis.z, Vector3.ZERO)
	if event.pressed:
		if !_is_dragging:
			_is_dragging = true
			_begin_drag()
	elif event.is_released():
		if _is_dragging:
			_end_drag()
			_is_dragging = false

func _mouse_enter () -> void:
	pass

func _mouse_exit () -> void:
	pass

func _begin_drag ():
	pass

func _drag (_event: InputEventMouseMotion):
	pass

func _end_drag ():
	pass
