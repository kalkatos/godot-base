class_name AnalyticsSender
extends Node
## Base class for sender implementations

signal on_initialized

const PLAYER_ID_KEY: String = "PlayerId"

var is_initialized: bool
var player_id: String


func _ready() -> void:
	initialize()


func initialize ():
	player_id = Storage.load(PLAYER_ID_KEY, "")
	if player_id.is_empty():
		player_id = str(randi())
		Storage.save(PLAYER_ID_KEY, player_id)
		Debug.logm("Setup as player id: " + player_id)
	is_initialized = true
	on_initialized.emit()


func send (key: String, value: String):
	Debug.logm("Sending (FAKE) event: %s with value %s" % [key, value])


func send_unique (key: String, value: String, id: String):
	Debug.logm("Sending (FAKE) unique event: %s with value %s and id %s" % [key, value, id])
