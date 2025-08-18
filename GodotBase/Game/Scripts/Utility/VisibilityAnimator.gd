extends Control

class_name VisibilityAnimator

@export var start_active: bool
@export var target: Control
@export var animation_time: float = 0.3

func _ready () -> void:
	if !target.is_node_ready():
		await target.ready
	target.visible = start_active

func animate_visibility (active: bool):
	if active:
		var tween = create_tween()
		target.modulate.a = 0.0
		target.visible = true
		tween.tween_property(target, "modulate:a", 1.0, animation_time)
	else:
		var tween = create_tween()
		target.modulate.a = 1.0
		tween.tween_property(target, "modulate:a", 0.0, animation_time)
		await tween.finished
		target.visible = false
