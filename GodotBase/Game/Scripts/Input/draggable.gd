extends InputDetector

class_name Draggable

func _mouse_enter () -> void:
	Debug.logm("Mouse ENTER " + str(self))
	Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)


func _mouse_exit () -> void:
	Debug.logm("Mouse EXIT " + str(self))
	if !_is_dragging:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)


func _begin_drag ():
	Input.set_default_cursor_shape(Input.CURSOR_MOVE)
	Debug.logm("Drag BEGIN")


func _drag (event: InputEventMouseMotion):
	var mouse_pos = event.position
	var ray_origin = _camera.project_ray_origin(mouse_pos)
	var ray_dir = _camera.project_ray_normal(mouse_pos)
	var point = _plane.intersects_ray(ray_origin, ray_dir)
	if point:
		global_position = point


func _end_drag ():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	Debug.logm("Drag END")
