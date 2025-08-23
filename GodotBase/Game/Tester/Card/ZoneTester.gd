extends Hand

class_name ZoneTester

var counter := 5

func _ready () -> void:
	pass

func _input (event: InputEvent) -> void:
	if event is InputEventKey and !event.echo and event.pressed:
		if event.keycode == KEY_SPACE:
			Debug.logm("Shuffling")
			shuffle()
			_organize()
		elif event.keycode == KEY_D:
			Debug.logm("Adding")
			var new_card = get_last().duplicate()
			add_item(new_card)
			counter += 1
			new_card.get_node("SubViewport/RichTextLabel").text = str(counter)
			_organize()
		elif event.keycode == KEY_S:
			_organize()
	elif event.is_action_pressed("click") \
	and get_child_count() > 0:
		var card = get_last()
		remove_item(card)
		card.create_tween().tween_property(card, "global_position", InputController.mouse_to_world_position(event.position), 0.2)
		_organize()
