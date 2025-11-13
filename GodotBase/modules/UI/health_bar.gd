class_name HealthBar
extends Control

@export var delayed_bar: Range
@export var real_bar: Range

var update_tween: Tween


func set_value (new_value: float) -> void:
	delayed_bar.value = real_bar.value
	real_bar.value = new_value
	if update_tween:
		update_tween.kill()
	update_tween = create_tween()
	update_tween.tween_property(delayed_bar, "value", new_value, 0.5)
