class_name LevelSelectPresenter
extends Node

# TODO: Implement all the logic for a generic level select scene

func emit_level_selected (level_index: int) -> void:
	SignalBus.emit_scene_transition_requested(Enums.SceneName.LEVEL_SELECT, str(level_index))
