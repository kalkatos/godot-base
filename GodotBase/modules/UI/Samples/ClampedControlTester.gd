extends Control

@export var control: TooltipControl

var is_open: bool


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if not is_open:
			Debug.logm("Opening")
			control.set_position_screen_clamped(event.position)
			control.open()
			is_open = true
		else:
			control.close()
			is_open = false
