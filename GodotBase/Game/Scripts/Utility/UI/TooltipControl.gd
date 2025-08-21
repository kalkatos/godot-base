extends ClampedControl

class_name TooltipControl

@export var panel_bg: Panel
@export var content: Control

func _ready ():
	panel_bg.visible = false

func open ():
	panel_bg.visible = true
	panel_bg.scale = Vector2.ZERO
	panel_bg.modulate.a = 1.0
	content.modulate.a = 0.0
	var open_tween := create_tween()
	open_tween.tween_property(panel_bg, "scale", Vector2.ONE, 0.2).set_ease(Tween.EASE_OUT)
	open_tween.tween_property(content, "modulate:a", 1.0, 0.2)

func close ():
	panel_bg.modulate.a = 1.0
	await create_tween().tween_property(panel_bg, "modulate:a", 0.0, 0.2).finished
	panel_bg.visible = false
