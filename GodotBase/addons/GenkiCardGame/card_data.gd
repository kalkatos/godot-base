class_name CardData
extends Resource

@export var fields: Dictionary[String, Variant]

var name: String:
	get: return resource_path.get_file().trim_suffix('.tres')
