@tool
extends EditorPlugin

const CUSTOM_TYPE_NAME := "DamageNumber"

func _enter_tree() -> void:
	add_custom_type(CUSTOM_TYPE_NAME, "Control", preload("DamageNumber.gd"), _get_plugin_icon())

func _exit_tree() -> void:
	remove_custom_type(CUSTOM_TYPE_NAME)

func _get_plugin_icon () -> Texture2D:
	return EditorInterface.get_editor_theme().get_icon("Label", "EditorIcons")
