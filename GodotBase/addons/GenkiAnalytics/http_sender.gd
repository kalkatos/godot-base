class_name HttpSender
extends AnalyticsSender

const URL: String = "https://playcard8887.azurewebsites.net/api/SendEvent"
const HEADERS: Array[String] = ["Content-Type: application/json"]


func send (key: String, value: String) -> void:
	var data = {
		PLAYER_ID_KEY: player_id,
		"Key": key,
		"Value": value,
	}
	var request = HTTPRequest.new()
	add_child(request)
	request.request(URL, HEADERS, HTTPClient.METHOD_POST, JSON.stringify(data))
	request.request_completed.connect(func (_x, _y, _z, _w): request.queue_free())
	Debug.logm("Sending event: %s with value %s" % [key, value])


func send_unique (key: String, value: String, id: String) -> void:
	var data = {
		PLAYER_ID_KEY: player_id,
		"Key": key,
		"Value": value,
		"ForcePartitionKey": id,
	}
	var request = HTTPRequest.new()
	add_child(request)
	request.request(URL, HEADERS, HTTPClient.METHOD_POST, JSON.stringify(data))
	request.request_completed.connect(func (_x, _y, _z, _w): request.queue_free())
	Debug.logm("Sending event: %s with value %s and id %s" % [key, value, id])
