class_name CharacterSelectPresenter
extends Node


func emit_character_selected (character_index: int) -> void:
	SignalBus.emit_scene_transition_requested(Enums.SceneName.CHARACTER_SELECT, str(character_index))
