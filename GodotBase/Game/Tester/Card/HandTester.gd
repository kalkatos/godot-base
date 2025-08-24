extends Hand

class_name HandTester

var counter := 0
var prefab: Node

func _ready () -> void:
	for card in get_children():
		counter += 1
		card.get_node("Front/SubViewport/RichTextLabel").text = str(counter)

func _input (event: InputEvent) -> void:
	if event is InputEventKey and !event.echo and event.pressed:
		if event.keycode == KEY_SPACE:
			Debug.logm("Shuffling")
			shuffle()
			_organize()
		elif event.keycode == KEY_D:
			Debug.logm("Adding")
			if !prefab:
				prefab = get_last()
			var new_card = prefab.duplicate()
			add_item(new_card)
			counter += 1
			new_card.get_node("Front/SubViewport/RichTextLabel").text = str(counter)
			_organize()
		elif event.keycode == KEY_S:
			_organize()
	elif event.is_action_pressed("click") \
	and get_child_count() > 0:
		var card = get_last()
		remove_item(card)
		card.create_tween().tween_property(card, "global_position", InputController.mouse_to_world_position(event.position), 0.2)
		_organize()
