class_name Utils
## Collection of global static utility functions for common operations like raycasting, animations, and string checks.
extends Node

static var tween_map: Dictionary = {}


## Performs a bounce-like scale animation on a node, ensuring thread-safe tween management.
static func bounce_scale (node: Node, target_scale: Vector3, total_duration: float) -> Tween:
	# Kill existing scale tween for this node if it's currently running
	if tween_map.has(node):
		var tween_data = tween_map[node]
		var old_tween = tween_data[0]
		if old_tween and old_tween.is_valid():
			node.scale = tween_data[1]
			old_tween.kill()
		tween_map.erase(node)
	var starting_scale = node.scale
	var tween = node.create_tween()
	# Handle both 2D (Vector2) and 3D (Vector3) target scales
	if node is Node2D or node is Control:
		tween.tween_property(node, "scale", Vector2(target_scale.x, target_scale.y), total_duration / 2)
	else:
		tween.tween_property(node, "scale", target_scale, total_duration / 2)
	tween.tween_property(node, "scale", starting_scale, total_duration / 2)
	tween_map[node] = [tween, starting_scale]
	return tween


## Performs a 3D raycast from a starting point to an end point with a specific collision mask.
static func raycast (from: Vector3, to: Vector3, mask: int = 1) -> Dictionary:
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collide_with_areas = true
	query.collision_mask = mask
	return Global.get_world_3d().direct_space_state.intersect_ray(query)


## Casts a ray from the mouse position and returns the first encountered instance of a specific type.
static func raycast_first_instance (mouse_pos: Vector2, type: Variant, exception: Node3D = null, mask: int = 1) -> Variant:
	var camera = Global.get_viewport().get_camera_3d()
	var from = camera.project_ray_origin(mouse_pos)
	var ray = camera.project_ray_normal(mouse_pos)
	var to = from + ray * 100.0
	# Attempt multiple raycasts in case of overlapping colliders
	for i in range(5):
		var hit_info = raycast(from, to, mask)
		if hit_info:
			if hit_info.has("collider"):
				var collider = hit_info["collider"]
				if not collider:
					return null
				if is_instance_of(collider, type) and (not exception or collider != exception):
					return collider
			# If no match, continue ray from hit position
			from = hit_info["position"]
			to = from + ray * 100.0
	return null


## Checks if a string follows the conventional translation key format ($KEY_NAME$).
static func is_translation_key (text: String) -> bool:
	if text.is_empty():
		return false
	return text.begins_with("$") and text.ends_with("$")
