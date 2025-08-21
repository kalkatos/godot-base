extends Zone

class_name ZoneTester

func _input (event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_SPACE:
			Debug.logm("Shuffling")
			shuffle()
			_position_cards()
		elif event.keycode == KEY_D:
			Debug.logm("Organizing")
			_position_cards()
	elif event.is_action_pressed("click") \
	and get_child_count() > 0:
		var first_child = get_child(0)
		remove_item(first_child)
		first_child.create_tween().tween_property(first_child, "global_position", InputController.mouse_to_world_position(event.position), 0.2)
		_position_cards()
	
func _position_cards ():
	for i in range(get_child_count()):
		var child = get_child(i)
		child.global_position = Vector3(-6 + 3 * i, 0, 0)
