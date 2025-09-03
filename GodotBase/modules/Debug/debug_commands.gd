@tool
extends CanvasLayer

@export var debug_text: RichTextLabel
@export var input_text: LineEdit

var is_open: bool = false
var commands: Dictionary[String, Callable] = {}
var last_commands: Array[String]
var last_index: int


func _ready () -> void:
	input_text.text_submitted.connect(_handle_text_submitted)
	add_command("time", _set_time_scale)
	add_command("fps", _set_fps)


func _unhandled_input (event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	if event.is_action_released("ui_cancel"):
		is_open = !is_open
		visible = is_open
		if is_open:
			input_text.grab_focus()
	elif is_open and last_commands.size() > 0:
		if event.keycode == KEY_UP:
			last_index = clamp(last_index - 1, -last_commands.size(), -1)
			input_text.text = last_commands[last_index]
		elif event.keycode == KEY_DOWN:
			last_index = clamp(last_index + 1, -last_commands.size(), 0)
			if last_index == 0:
				input_text.text = ""
			else:
				input_text.text = last_commands[last_index]


func logm (msg: String) -> void:
	print(msg)
	debug_text.newline()
	debug_text.append_text(msg)


func log_warning (msg: String) -> void:
	push_warning(msg)
	debug_text.newline()
	debug_text.append_text("[color=yellow]%s[/color]" % msg)


func log_error (msg: String) -> void:
	push_error(msg)
	debug_text.newline()
	debug_text.append_text("[color=red]%s[/color]" % msg)


func add_command (func_name: String, callable: Callable) -> void:
	commands[func_name] = callable


func call_command (text: String) -> void:
	input_text.clear()
	_register_command_executed(text)
	var has_params = text.find(" ") != -1
	if has_params:
		var split = text.split(" ")
		var func_name = split[0]
		var str_params = split.slice(1, split.size())
		var params = []
		for p in str_params:
			if p == str(true):
				params.append(true)
			elif p == str(false):
				params.append(false)
			elif p.is_valid_int():
				params.append(p.to_int())
			elif p.is_valid_float():
				params.append(p.to_float())
			else:
				params.append(p)
		if commands.has(func_name):
			commands[func_name].callv(params)
			logm("Function executed: " + func_name + " with params: " + str(params))
		else:
			log_warning("Command not found: " + func_name)
	elif commands.has(text):
		if commands[text].get_argument_count() > 0:
			log_warning("Command requires parameters: " + text)
		else:
			commands[text].call()
			logm("Function executed: " + text)
	else:
		log_warning("Command not found: " + text)
	call_deferred("_grab_focus_back")


static func call_command_static (text: String) -> void:
	Debug.call_command(text)


func _register_command_executed (text: String) -> void:
	if not last_commands.has(text):
		last_commands.append(text)


func _handle_text_submitted (text: String) -> void:
	call_command(text)


func _grab_focus_back () -> void:
	visible = false
	visible = true
	input_text.grab_focus()


func _set_time_scale (value: float) -> void:
	value = clamp(value, 0.0, 3.0)
	Engine.time_scale = value


func _set_fps (value: int) -> void:
	value = max(0, value)
	Engine.max_fps = value
