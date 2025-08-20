## General purpose pooler for any node that extends Node2D, Node3D or Control
extends Node

var _pool_container: Dictionary[int, Pool]

func notify_finished (item: PoolItem):
	var id = item.original_id
	if !_pool_container.has(id):
		Debug.log_error("Something went wrong, pool container does not have id: " + str(id))
		return
	var pool = _pool_container[id]
	var index = pool.busy.find(item)
	if index < 0:
		Debug.log_error("Something went wrong, item is not in busy list")
	else:
		pool.busy.remove_at(index)
	Debug.logm("Recycling item " + str(item.number))
	pool.available.insert(0, item)

func get_new (original: Node) -> Node:
	var id = original.get_instance_id()
	if !_pool_container.has(id):
		_pool_container[id] = Pool.new(original)
	var other = _pool_container[id].get_new()
	return other

class Pool:
	var original_id: int
	var prefab: Node
	var available: Array[PoolItem]
	var busy: Array[PoolItem]
	var count: int

	func _init (original: Node):
		original_id = original.get_instance_id()
		prefab = original.duplicate()
		count = 1

	func get_new () -> Node:
		if available.size() == 0:
			return create_new()
		var item = null
		for i in range(available.size() - 1, -1, -1):
			item = available[i]
			available.remove_at(i)
			if !item or !item.instance:
				continue
			break
		if item:
			Debug.logm("Reusing item: " + str(item.number))
			busy.append(item)
		else:
			return create_new()
		return item.instance
	
	func create_new () -> Node:
		var new_obj = prefab.duplicate()
		var new_item = PoolItem.new(new_obj, original_id)
		busy.append(new_item)
		count += 1
		new_item.number = count
		Debug.logm("New instance count: " + str(count))
		return new_obj

class PoolItem:
	var instance: Node
	var original_id: int
	var number: int

	func _init (_instance: Node, _id: int):
		instance = _instance
		original_id = _id
		instance.visibility_changed.connect(_handle_visibility_changed)
	
	func _handle_visibility_changed ():
		if !instance.visible:
			Pooler.notify_finished(self)
