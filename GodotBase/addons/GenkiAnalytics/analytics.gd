extends Node

@export var debug_mode: bool = false
@export var sender: AnalyticsSender

static var player_id: String


func _enter_tree() -> void:
	if OS.has_feature("editor") and not debug_mode:
		Debug.logm("Analytics module disabled in editor")
		return
	player_id = Storage.load("player_id", "")
	if player_id.is_empty():
		player_id = str(randi())
		Storage.save("player_id", player_id)
		Debug.logm("Setup as player id: " + player_id)
	else:
		Debug.logm("Loaded player id: " + player_id)


func send_event (key: String):
	if _is_initialized():
		sender.send(key, "")


func send_event_with_string (key: String, value: String):
	if _is_initialized():
		sender.send(key, value)


func send_event_with_number (key: String, num: float):
	if _is_initialized():
		sender.send(key, num)


func send_unique_event (key: String, opt_value: Variant = null):
	if _is_initialized():
		sender.send_unique(key, opt_value, key)


func send_one_shot_event (key: String, opt_value: Variant = null):
	if not _is_initialized():
		return
	if Storage.has_value(key):
		return
	Storage.save(key, opt_value)
	sender.send(key, opt_value)


func _is_initialized () -> bool:
	if OS.has_feature("editor") and not debug_mode:
		return false
	if sender and sender.is_initialized:
		return true
	Debug.log_warning("Analytics module is not initialized. Nothing will be sent")
	return false
