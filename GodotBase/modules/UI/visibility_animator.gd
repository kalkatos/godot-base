class_name VisibilityAnimator
extends Control

@export var target: Control
@export var start_active: bool
@export var deactivate_on_end: bool = true
@export var animation_time: float = 0.3

var is_showing: bool = false


func _ready () -> void:
	if not target.is_node_ready():
		await target.ready
	is_showing = target.visible and not is_zero_approx(target.modulate.a)
	target.visible = start_active


func animate_visibility (active: bool):
	if active:
		if is_showing:
			return
		is_showing = true
		target.modulate.a = 0.0
		target.visible = true
		var tween_on = create_tween()
		tween_on.tween_property(target, "modulate:a", 1.0, animation_time)
		return
	if not is_showing:
		return
	is_showing = false
	target.modulate.a = 1.0
	var tween_off = create_tween()
	tween_off.tween_property(target, "modulate:a", 0.0, animation_time)
	if deactivate_on_end:
		await tween_off.finished
		target.visible = false
