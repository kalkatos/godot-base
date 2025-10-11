class_name ResourceValueLabel
extends Node

@export var target: Node
@export var resource: Resource
@export var property_name: String = ""
@export var prefix: String = ""
@export var suffix: String = ""


func setup () -> void:
	if not target or not resource or property_name == "":
		return
	if not target.has_method("set_text"):
		Debug.log_warning("Target node does not have set_text method")
		return
	if property_name == "":
		Debug.log_warning("Property name is empty")
		return
	if not resource.get_property_list().any(func(p): return p.name == property_name):
		Debug.log_warning("Resource does not have property: %s" % property_name)
		return
	var value = resource.get(property_name)
	target.set_text("%s%s%s" % [prefix, str(value), suffix])
