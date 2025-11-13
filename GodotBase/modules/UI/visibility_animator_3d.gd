class_name VisibilityAnimator3D
extends Node3D

signal finished

@export var targets: Array[SpriteBase3D]
@export var target_alpha: float = 1.0
@export var start_active: bool
@export var deactivate_on_end: bool = true
@export var animation_time: float = 0.3

var is_showing: bool = false


func _ready () -> void:
	var starting_alpha = target_alpha if start_active else 0.0
	for target in targets:
		is_showing = start_active
		target.modulate.a = starting_alpha
		target.visible = start_active


func animate_visibility (activate: bool):
	if activate:
		if is_showing:
			return
		is_showing = true
		for target in targets:
			target.modulate.a = 0.0
			target.visible = true
			var tween_on = target.create_tween()
			tween_on.tween_property(target, "modulate:a", target_alpha, animation_time)
			await tween_on.finished
			finished.emit()
		return
	if not is_showing:
		return
	is_showing = false
	for target in targets:
		target.modulate.a = target_alpha
		var tween_off = target.create_tween()
		tween_off.tween_property(target, "modulate:a", 0.0, animation_time)
		await tween_off.finished
		finished.emit()
		if deactivate_on_end:
			target.visible = false
