class_name FunctionsSender
extends HttpSender

const URLS_FILE_PATH: String = "res://Game/Settings/urls.json"


func _ready () -> void:
	if FileAccess.file_exists(URLS_FILE_PATH):
		var file := FileAccess.open(URLS_FILE_PATH, FileAccess.READ)
		var json := JSON.parse_string(file.get_as_text())
		if json:
			if json.has("SendEvent"):
				url = json["SendEvent"]
				initialize()
				return
	Debug.log_warning("URLs file not found or invalid, using default URL")
	