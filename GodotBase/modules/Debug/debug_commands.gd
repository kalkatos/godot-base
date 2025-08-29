@tool
extends CanvasLayer

@export var debug_text: RichTextLabel
@export var input_text: LineEdit

var is_open: bool = false
var commands: Dictionary[String, Callable] = {}


func _ready() -> void:
	input_text.text_submitted.connect(_handle_text_submitted)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_cancel"):
		is_open = !is_open
		visible = is_open
		if is_open:
			input_text.grab_focus()


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
	var has_params = text.find(" ") != -1
	if has_params:
		var split = text.split(" ")
		var func_name = split[0]
		var params = split.slice(1, split.size())
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


func _handle_text_submitted (text: String) -> void:
	call_command(text)


func _grab_focus_back () -> void:
	visible = false
	visible = true
	input_text.grab_focus()
