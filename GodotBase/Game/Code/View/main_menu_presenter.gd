class_name MainMenuPresenter
extends Node


func emit_play_button_pressed () -> void:
	SignalBus.emit_scene_transition_requested(Enums.SceneName.MAIN_MENU, "new_game")