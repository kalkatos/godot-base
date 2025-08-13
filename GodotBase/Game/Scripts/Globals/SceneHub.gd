extends Node

signal on_scene_loaded(scene_name: String)

@export var scenes: Dictionary[String, PackedScene] = {}

func load_scene(scene_name: String) -> void:
	if SceneHub.scenes.has(scene_name):
		get_tree().change_scene_to_packed(scenes[scene_name])
		SceneHub.on_scene_loaded.emit(scene_name)
		emit_signal(on_scene_loaded.get_name(), scene_name)
	else:
		Debug.log_error("Scene '%s' not found in SceneHub." % scene_name)
