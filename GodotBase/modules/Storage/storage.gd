extends Node

signal on_value_saved (key: String, value: Variant)

const SAVE_NAME: String = "save_game"

var saved_dict := {}
var save_name: String = "user://%s.data" % SAVE_NAME


func _ready () -> void:
	var serialized = load_from_file()
	if serialized.is_empty():
		saved_dict = {}
	else:
		saved_dict = JSON.parse_string(serialized) as Dictionary


func save (key: String, value: Variant):
	saved_dict[key] = value
	save_to_file(JSON.stringify(saved_dict))
	on_value_saved.emit(key, value)


func load (key: String, default_value: Variant) -> Variant:
	if not has_value(key):
		return default_value
	return saved_dict[key]


func has_value (key: String) -> bool:
	return saved_dict.has(key)


func save_to_file (content: String):
	var file = FileAccess.open(save_name, FileAccess.WRITE)
	file.store_string(content)


func load_from_file () -> String:
	var file = FileAccess.open(save_name, FileAccess.READ)
	if not file:
		return "";
	var content = file.get_as_text()
	return content
