extends Node
## Global utility for object pooling, supporting Node2D, Node3D, and Control nodes.
## Automatically manages object lifecycle based on visibility changes.

var _pool_container: Dictionary[int, Pool]


## Notifies the pooler that an item has finished its task and is available for reuse.
func notify_finished (item: PoolItem) -> void:
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
	# Insert at the beginning for Most Recently Used strategy
	pool.available.insert(0, item)


## Retrieves a new or recycled instance of the provided original node.
func get_new (original: Node) -> Node:
	var id = original.get_instance_id()
	if !_pool_container.has(id):
		_pool_container[id] = Pool.new(original)
	var other = _pool_container[id].get_new()
	return other


## Represents a pool of instances for a specific original node.
class Pool:
	var original_id: int
	var prefab: Node
	var available: Array[PoolItem]
	var busy: Array[PoolItem]
	var count: int


	## Initializes a pool using the original node as a template.
	func _init (original: Node) -> void:
		original_id = original.get_instance_id()
		prefab = original.duplicate()
		count = 1


	## Returns an available node from the pool or creates a new one if necessary.
	func get_new () -> Node:
		if available.size() == 0:
			return create_new()
		var item = null
		# Iterate backwards to find a valid pooled item
		for i in range(available.size() - 1, -1, -1):
			item = available[i]
			available.remove_at(i)
			if !item or !item.instance:
				continue
			break
		if item:
			busy.append(item)
		else:
			return create_new()
		return item.instance


	## Internally instantiates a new node from the template and wraps it in a PoolItem.
	func create_new () -> Node:
		var new_obj = prefab.duplicate()
		var new_item = PoolItem.new(new_obj, original_id)
		busy.append(new_item)
		count += 1
		new_item.number = count
		return new_obj


## Wrapper for an individual instance within a pool, tracking its lifecycle.
class PoolItem:
	var instance: Node
	var original_id: int
	var number: int


	## Connects to the instance's visibility signal to automatically handle recycling.
	func _init (_instance: Node, _id: int) -> void:
		instance = _instance
		original_id = _id
		instance.visibility_changed.connect(_handle_visibility_changed)

	
	## Internal handler triggered when an instance is hidden, signalling it's ready for recycling.
	func _handle_visibility_changed () -> void:
		if !instance.visible:
			Pooler.notify_finished(self)
