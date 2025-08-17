extends Node

@export var draggable: Draggable

var _drag_start_pos: Vector3

func _ready ():
	if !draggable:
		draggable = $Draggable
	draggable.on_begin_drag.connect(_handle_begin_drag)
	draggable.on_end_drag.connect(_handle_end_drag)

func _handle_begin_drag (_mouse_position: Vector2):
	Debug.logm("begin_drag in CardView")
	_drag_start_pos = self.global_position

func _handle_end_drag (_mouse_position: Vector2):
	Debug.logm("end_drag in CardView")
	create_tween().tween_property(self, "global_position", _drag_start_pos, 0.2)