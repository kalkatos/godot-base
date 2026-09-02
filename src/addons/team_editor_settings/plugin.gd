@tool
extends EditorPlugin

const SETTING_PREFIX: String = "team_editor_settings/"
const APPLY_PORT: String = SETTING_PREFIX + "apply_lsp_port"
const LSP_PORT: String = SETTING_PREFIX + "lsp_port"
const APPLY_ACCENT: String = SETTING_PREFIX + "apply_accent_color"
const ACCENT_COLOR: String = SETTING_PREFIX + "accent_color"

const EDITOR_PORT_SETTING: String = "network/language_server/remote_port"
const EDITOR_ACCENT_SETTING: String = "interface/theme/accent_color"
const EDITOR_COLOR_PRESET_SETTING: String = "interface/theme/color_preset"
const EDITOR_FOLLOW_SYSTEM_THEME_SETTING: String = "interface/theme/follow_system_theme"

const DEFAULT_LSP_PORT: int = 6005
const DEFAULT_ACCENT_COLOR: Color = Color(0.337, 0.62, 1.0)


func _enter_tree () -> void:
	if _register_project_settings():
		ProjectSettings.save()
	_apply_project_settings_to_editor()


func _register_project_settings () -> bool:
	var registered_any: bool = false
	registered_any = _register_setting(APPLY_PORT, TYPE_BOOL, true) or registered_any
	registered_any = _register_setting(LSP_PORT, TYPE_INT, DEFAULT_LSP_PORT) or registered_any
	registered_any = _register_setting(APPLY_ACCENT, TYPE_BOOL, true) or registered_any
	registered_any = _register_setting(ACCENT_COLOR, TYPE_COLOR, DEFAULT_ACCENT_COLOR) or registered_any
	return registered_any


func _register_setting (name: String, value_type: int, default_value: Variant) -> bool:
	if ProjectSettings.has_setting(name):
		return false
	ProjectSettings.set_setting(name, default_value)
	ProjectSettings.add_property_info({"name": name, "type": value_type})
	return true


func _apply_project_settings_to_editor () -> void:
	var editor_settings: EditorSettings = get_editor_interface().get_editor_settings()
	if ProjectSettings.get_setting(APPLY_PORT):
		var port: int = ProjectSettings.get_setting(LSP_PORT)
		if editor_settings.get_setting(EDITOR_PORT_SETTING) != port:
			editor_settings.set_setting(EDITOR_PORT_SETTING, port)
	if ProjectSettings.get_setting(APPLY_ACCENT):
		var accent_color: Color = ProjectSettings.get_setting(ACCENT_COLOR)
		if editor_settings.get_setting(EDITOR_ACCENT_SETTING) != accent_color:
			_apply_accent_color(editor_settings, accent_color)


func _apply_accent_color (editor_settings: EditorSettings, accent_color: Color) -> void:
	if editor_settings.get_setting(EDITOR_FOLLOW_SYSTEM_THEME_SETTING):
		editor_settings.set_setting(EDITOR_FOLLOW_SYSTEM_THEME_SETTING, false)
	if editor_settings.get_setting(EDITOR_COLOR_PRESET_SETTING) != "Custom":
		editor_settings.set_setting(EDITOR_COLOR_PRESET_SETTING, "Custom")
	editor_settings.set_setting(EDITOR_ACCENT_SETTING, accent_color)