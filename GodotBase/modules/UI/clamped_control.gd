class_name ClampedControl
extends Control
## Control implementation that allows setting its position clamped to the screen bounds, with pivot ratio support.

@export var target: Control
@export_range(0.0, 1.0) var pivot_ratio_x: float = 0.0
@export_range(0.0, 1.0) var pivot_ratio_y: float = 0.0

var offset_from_ratio: Vector2:
	get:
		if !target:
			target = self
		return -Vector2(target.size.x * pivot_ratio_x, target.size.y * pivot_ratio_y)


## Applies a position to the target control while accounting for pivot ratio offsets.
func set_position_offset (new_position: Vector2):
	if not target:
		target = self
	target.position = new_position + offset_from_ratio


## Clamps the given position to screen bounds and applies it to the target control.
func set_position_screen_clamped (new_position: Vector2):
	new_position = get_position_screen_clamped(new_position)
	set_position_offset(new_position)


## Calculates a screen-clamped version of the provided position based on the target's size and pivot.
func get_position_screen_clamped (new_position: Vector2) -> Vector2:
	if not target:
		target = self
	var screen_size = get_window().content_scale_size
	new_position.x = clamp(new_position.x, target.size.x * pivot_ratio_x, screen_size.x - target.size.x * (1 - pivot_ratio_x))
	new_position.y = clamp(new_position.y, target.size.y * pivot_ratio_y, screen_size.y - target.size.y * (1 - pivot_ratio_y))
	return new_position


## Recalculates the internal pivot offset based on current dimensions and pivot ratios.
func update_pivot_offset ():
	pivot_offset = Vector2(size.x * pivot_ratio_x, size.y * pivot_ratio_y)
