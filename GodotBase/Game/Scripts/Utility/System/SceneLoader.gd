extends Node

class_name SceneLoader

@export_file("*.tscn") var scene: String

func load_scene ():
	if !scene:
		Debug.log_error("No scene provided.")
		return
	get_tree().change_scene_to_file(scene)
