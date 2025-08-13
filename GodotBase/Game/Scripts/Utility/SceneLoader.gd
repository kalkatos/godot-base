extends Node

@export var default_scene: String = ""

func load_default_scene():
    if default_scene.is_empty():
        Debug.log_error("No default scene name provided.")
        return
    load_scene(default_scene)

func load_scene(scene: String) -> void:
    SceneHub.load_scene(scene)
