class_name HttpSender
extends AnalyticsSender

const URL: String = "https://playcard8887.azurewebsites.net/api/SendEvent"
const PLAYER_ID_KEY: String = "PlayerId"
const HEADERS: Array[String] = ["Content-Type: application/json"]

var player_id: String


func initialize ():
	player_id = Storage.load(PLAYER_ID_KEY, "")
	if player_id.is_empty():
		player_id = str(randi())
		Storage.save(PLAYER_ID_KEY, player_id)
		Debug.logm("Setup as player id: " + player_id)
	super()


func send (key: String):
	_send_any(key, "")


func send_str (key: String, value: String):
	_send_any(key, value)


func send_num (key: String, num: float):
	_send_any(key, str(num))


func _send_any (key: String, value: String):
	var data = JSON.stringify({
		PLAYER_ID_KEY: player_id,
		"Key": key,
		"Value": value
	})
	var request = HTTPRequest.new()
	add_child(request)
	request.request(URL, HEADERS, HTTPClient.METHOD_POST, data)
	request.request_completed.connect(func (_x, _y, _z, _w): request.queue_free())
	Debug.logm("Sending event: %s with value %s" % [key, value])
