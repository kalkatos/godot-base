extends Node3D

class_name Zone

signal on_item_added (item: Node)
signal on_item_removed (item: Node)
signal on_shuffled

func add_item (item: Node):
	var item_parent = item.get_parent()
	if item_parent:
		if item_parent is Zone:
			item_parent.notify_item_removed(item)
		item.reparent(self)
	else:
		add_child(item)
	_item_added(item)
	on_item_added.emit(item)

func insert_item (index: int, item: Node):
	add_item(item)
	move_child(item, index)

func remove_item (item: Node):
	item.reparent(get_tree().root)
	_item_removed(item)
	on_item_removed.emit(item)

func notify_item_removed (item: Node):
	remove_item(item)

func shuffle ():
	var children = get_children()
	children.shuffle()
	var i = 0
	for child in children:
		move_child(child, i)
		i += 1
	on_shuffled.emit()

func find (item: Node):
	return get_children().find(item)

func has (item: Node):
	get_children().has(item)

func _item_added (_item: Node):
	pass

func _item_removed (_item: Node):
	pass

func _shuffled ():
	pass
