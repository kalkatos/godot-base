class_name HttpSender
extends AnalyticsSender

const URL: String = "https://playcard8887.azurewebsites.net/api/SendEvent"
const HEADERS: Array[String] = ["Content-Type: application/json"]


func send (key: String, value: String):
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
