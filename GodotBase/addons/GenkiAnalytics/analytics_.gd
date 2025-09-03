extends Node

@export var debug_mode: bool = false
@export var sender: AnalyticsSender


func _ready() -> void:
	if OS.has_feature("editor") and not debug_mode:
		Debug.logm("Analytics module disabled in editor")
		queue_free()
		return
	if not sender.is_initialized:
		await sender.on_initialized
	send_event("session_started")


func _notification (what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST and _is_initialized():
		send_event("session_ended")


func send_event (key: String):
	if _is_initialized():
		sender.send(key, "")


func send_event_with_string (key: String, value: String):
	if _is_initialized():
		sender.send(key, value)


func send_event_with_number (key: String, num: float):
	if _is_initialized():
		sender.send(key, str(num))


func send_unique_event (key: String, opt_value: String = ""):
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
