extends Node

var saved_dict := {}

func _ready() -> void:
	saved_dict = JSON.parse_string(load_from_file()) as Dictionary

func save (key: String, value: Variant):
	saved_dict[key] = value
	save_to_file(JSON.stringify(saved_dict))

func load (key: String, default_value: Variant) -> Variant:
	if !has_value(key):
		return default_value
	return saved_dict[key]

func has_value (key: String) -> bool:
	return saved_dict.has(key)

func save_to_file(content: String):
	var file = FileAccess.open("user://save_game.dat", FileAccess.WRITE)
	file.store_string(content)

func load_from_file() -> String:
	var file = FileAccess.open("user://save_game.dat", FileAccess.READ)
	var content = file.get_as_text()
	return content
