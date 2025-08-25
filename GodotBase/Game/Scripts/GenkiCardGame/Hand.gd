class_name Hand
extends Zone

@export var bend: Curve
@export var bend_height: float = 1.0
@export var distance: float = 3.0
@export var max_angle: float = 15.0
@export var max_width: float = 15.0
@export var count_reference: int = 5


func _organize ():
	_organize_option(false)


func _organize_option (snap: bool):
	var count = get_child_count()
	if count == 0:
		return
	var used_distance = distance
	var used_height = lerp(0.0, bend_height, min(1.0, float(count - 1) / count_reference))
	var used_angle = lerp(0.0, max_angle, min(1.0, float(count - 1) / count_reference))
	var total_width = (count - 1) * distance
	if total_width > max_width:
		total_width = max_width
		used_distance = max_width / (count - 1)
	var start_x = -total_width / 2
	for i in range(count):
		var card = get_child(i)
		var t = float(i) / max(1, count - 1)
		var pos_x = start_x + (i * used_distance)
		var pos_y = 0.0
		if bend:
			pos_y = bend.sample(t) * used_height
		var target_pos = Vector3(pos_x, pos_y, 0)
		var angle = lerp(used_angle, -used_angle, t)
		var target_rot = Vector3(0, 0, angle)
		if snap:
			card.position = target_pos
			card.rotation_degrees = target_rot
		else:
			var tween = card.create_tween()
			tween.tween_property(card, "position", target_pos, 0.2)
			tween.parallel().tween_property(card, "rotation_degrees", target_rot, 0.2)
