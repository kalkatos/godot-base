class_name HttpSender
extends AnalyticsSender

var url: String = "https://myanalyticsserver.com/submit_event"
var headers: Array[String] = ["Content-Type: application/json"]


func send (key: String, value: Variant) -> void:
	var data = {
		"PlayerId": Analytics.player_id,
		"Key": key,
		"Value": value,
	}
	var request = HTTPRequest.new()
	add_child(request)
	request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	request.request_completed.connect(func (_x, _y, _z, _w): request.queue_free())
	Debug.logm("Sending event: %s with value %s" % [key, str(value)])


func send_unique (key: String, value: Variant, id: String) -> void:
	var data = {
		"PlayerId": Analytics.player_id,
		"Key": key,
		"Value": value,
		"ForcePartitionKey": id,
	}
	var request = HTTPRequest.new()
	add_child(request)
	request.request(url, headers, HTTPClient.METHOD_POST, JSON.stringify(data))
	request.request_completed.connect(func (_x, _y, _z, _w): request.queue_free())
	Debug.logm("Sending event: %s with value %s and id %s" % [key, str(value), id])
