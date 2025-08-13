extends Node

## Gizmo to initialize the drag plane (origin is global_position and normal is basis Y)
@export var drag_plane_gizmo: Marker3D

signal on_mouse_enter_draggable(draggable: Draggable, input_info: InputEventMouse)
signal on_mouse_exit_draggable(draggable: Draggable, input_info: InputEventMouse)
signal on_begin_drag(draggable: Draggable, input_info: InputEventMouse)
signal on_drag(draggable: Draggable, input_info: InputEventMouse)
signal on_end_drag(draggable: Draggable, input_info: InputEventMouse)

var plane: Plane
var input_info: InputEventMouse

var _draggable: Draggable

var is_dragging: bool = false:
	get:
		return _draggable != null

func _ready ():
	if drag_plane_gizmo:
		plane = Plane(drag_plane_gizmo.basis.y, drag_plane_gizmo.global_position)

func _input (event: InputEvent) -> void:
	if event is InputEventMouse:
		input_info = event
		if event is InputEventMouseMotion:
			if is_dragging:
				drag(_draggable)    

func mouse_enter (draggable: Draggable) -> void:
	Debug.logm("Mouse ENTER on draggable: " + str(draggable))
	on_mouse_enter_draggable.emit(draggable, input_info)

func mouse_exit (draggable: Draggable) -> void:
	Debug.logm("Mouse EXIT on draggable: " + str(draggable))
	on_mouse_exit_draggable.emit(draggable, input_info)

func begin_drag (draggable: Draggable) -> void:
	Debug.logm("Drag BEGIN on draggable: " + str(draggable))
	on_begin_drag.emit(draggable, input_info)
	_draggable = draggable

func drag (draggable: Draggable) -> void:
	if !is_dragging:
		return
	draggable._drag(input_info.position)
	on_drag.emit(draggable, input_info)
	
func end_drag (draggable: Draggable) -> void:
	if !is_dragging:
		return
	_draggable = null
	Debug.logm("Drag END on draggable: " + str(draggable))
	on_end_drag.emit(draggable, input_info)

func mouse_position_to_world_position (mouse_position: Vector2) -> Vector3:
	var camera = get_viewport().get_camera_3d()
	if !plane:
		plane = Plane(camera.basis.z, Vector3.ZERO)
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_dir = camera.project_ray_normal(mouse_position)
	var point = plane.intersects_ray(ray_origin, ray_dir)
	if point:
		return point
	Debug.log_warning("No intersection found with the drag plane (%s)." % str(plane))
	return Vector3.ZERO
