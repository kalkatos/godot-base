extends Zone

class_name Hand

@export var bend: Curve
@export var bend_height: float = 1.0
@export var distance: float = 3.0
@export var max_angle: float = 15.0

func _organize ():
	var count = get_child_count()
	if count == 0:
		return
	var total_width = (count - 1) * distance
	var start_x = -total_width / 2
	for i in range(count):
		var card = get_child(i)
		var t = float(i) / max(1, count - 1)
		var pos_x = start_x + (i * distance)
		var pos_y = 0.0
		if bend:
			pos_y = bend.sample(t) * bend_height
		card.global_position = Vector3(pos_x, pos_y, 0)
		var angle = lerp(max_angle, -max_angle, t)
		card.rotation_degrees = Vector3(0, 0, angle)
