class_name TooltipControl
extends ClampedControl
## ClampedControl implementation for a tooltip, with open/close animations.

@export var panel_bg: Control
@export var content: Control

var _main_tween: Tween
var _is_open: bool = false


func _ready ():
	panel_bg.visible = false


func open ():
	_is_open = true
	panel_bg.visible = true
	panel_bg.scale = Vector2(0.1, 0.1)
	panel_bg.modulate.a = 1.0
	content.modulate.a = 0.0
	if _main_tween and _main_tween.is_valid():
		_main_tween.kill()
	_main_tween = create_tween()
	_main_tween.tween_property(panel_bg, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT)
	_main_tween.tween_property(content, "modulate:a", 1.0, 0.2)


func close ():
	_is_open = false
	panel_bg.modulate.a = 1.0
	if _main_tween and _main_tween.is_valid():
		_main_tween.kill()
	_main_tween = create_tween()
	_main_tween.tween_property(panel_bg, "modulate:a", 0.0, 0.2)
	await _main_tween.finished
	if _is_open:
		return
	panel_bg.visible = false
