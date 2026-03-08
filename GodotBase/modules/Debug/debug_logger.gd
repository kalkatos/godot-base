extends Logger
## Custom Logger that intercepts all print/push_warning/push_error calls
## and displays them in the in-game debug panel's RichTextLabel.
## Registered via OS.add_logger() from debug_commands.gd.

var debug_text: RichTextLabel


func setup (rich_text_label: RichTextLabel) -> void:
	debug_text = rich_text_label


func _log_message (message: String, error: bool) -> void:
	if debug_text == null:
		return
	if error:
		_append_text.call_deferred("[color=red]%s[/color]" % message.strip_edges())
	else:
		_append_text.call_deferred(message.strip_edges())


func _log_error (function: String, file: String, line: int, code: String, rationale: String, editor_notify: bool, error_type: int, script_backtraces: Array[ScriptBacktrace]) -> void:
	if debug_text == null:
		return
	var detail := rationale if rationale != "" else code
	var location := "%s:%d in %s" % [file.get_file(), line, function]
	var text := "%s (%s)" % [detail, location]
	match error_type:
		Logger.ERROR_TYPE_WARNING:
			_append_text.call_deferred("[color=yellow]%s[/color]" % text)
		_:
			_append_text.call_deferred("[color=red]%s[/color]" % text)


func _append_text (text: String) -> void:
	if debug_text == null:
		return
	debug_text.newline()
	debug_text.append_text(text)
