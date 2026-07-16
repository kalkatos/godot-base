## Manages scene transitions across the game with fade in/out effects. Listens for scene_transition_requested from any scene controller and determines which scene to load based on the origin and data provided. Hybrid presenter+controller.
class_name TransitionPresenter
extends Control

@export var fade_rect: ColorRect
@export_category("Scenes")
@export var main_menu_scene: PackedScene
@export var gameplay_scene: PackedScene
@export var character_select_scene: PackedScene

var _current_scene: Node = null
var _current_scene_name: Enums.SceneName = Enums.SceneName.MAIN_MENU
var _current_scene_data: String = ""
var _is_transitioning: bool = false


func _ready () -> void:
	SignalBus._on_scene_transition_requested.connect(_handle_scene_transition_requested)
	fade_rect.visible = true
	fade_rect.modulate.a = 1.0
	_handle_scene_transition_requested(Enums.SceneName.NONE, "")
	_fade_in()


func _exit_tree () -> void:
	SignalBus._on_scene_transition_requested.disconnect(_handle_scene_transition_requested)


func _handle_scene_transition_requested (origin_scene: Enums.SceneName, data: String) -> void:
	if _is_transitioning:
		return
	var target_scene = _resolve_target_scene(origin_scene, data) as PackedScene
	_transition_to(target_scene)


func _resolve_target_scene (origin_scene: Enums.SceneName, data: String) -> PackedScene:
	match origin_scene:
		Enums.SceneName.NONE:
			_current_scene_name = Enums.SceneName.MAIN_MENU
			_current_scene_data = data
			return main_menu_scene
		Enums.SceneName.MAIN_MENU:
			match data:
				"new_game":
					_current_scene_name = Enums.SceneName.CHARACTER_SELECT
					_current_scene_data = data
					return character_select_scene
				"continue":
					_current_scene_name = Enums.SceneName.GAMEPLAY
					_current_scene_data = data
					return gameplay_scene
		Enums.SceneName.CHARACTER_SELECT:
			_current_scene_name = Enums.SceneName.GAMEPLAY
			_current_scene_data = data
			return gameplay_scene
		Enums.SceneName.GAMEPLAY:
			_current_scene_name = Enums.SceneName.MAIN_MENU
			_current_scene_data = data
			return main_menu_scene
	push_error("TransitionPresenter: Unhandled scene transition request from '%s' with data '%s'" % [Enums.SceneName.keys()[origin_scene], data])
	_current_scene_name = Enums.SceneName.MAIN_MENU
	_current_scene_data = data
	return main_menu_scene


func _transition_to (scene: PackedScene) -> void:
	print("Transitioning to scene '%s' with data '%s'" % [Enums.SceneName.keys()[_current_scene_name], _current_scene_data])
	_is_transitioning = true
	var fade_out_duration: float = 4.0 if _current_scene_data == "act_complete" else 0.4
	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1.0, fade_out_duration)
	await tween.finished
	if _current_scene:
		_current_scene.queue_free()
		_current_scene = null
	_load_scene(scene)
	SignalBus.emit_scene_transition_completed(_current_scene_name, _current_scene_data)
	tween = create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 0.4)
	await tween.finished
	_is_transitioning = false


func _load_scene (scene: PackedScene) -> void:
	print("Loading scene '%s'" % [scene.resource_path])
	_current_scene = scene.instantiate()
	add_child(_current_scene)
	move_child(_current_scene, 0)


func _fade_in () -> void:
	var tween := create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0.0, 0.4)
