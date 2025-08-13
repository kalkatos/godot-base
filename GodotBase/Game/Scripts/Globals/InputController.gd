extends Node

## Gizmo to initialize the drag plane (origin is global_position and normal is basis Y)
@export var drag_plane_gizmo: Marker3D

var plane: Plane
var is_dragging: bool = false

func _ready ():
    plane = Plane(drag_plane_gizmo.basis.y, drag_plane_gizmo.global_position)
