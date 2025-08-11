extends CanvasLayer

@export var debug_text: RichTextLabel
@export var input_text: LineEdit

var is_open: bool = false

func _ready() -> void:
	input_text.text_submitted.connect(_handle_text_submitted)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("toggle_debug"):
		if is_open:
			debug_text.visible = false
			input_text.visible = false
		else:
			debug_text.visible = true
			input_text.visible = true
		is_open = !is_open

func _handle_text_submitted (text: String):
	input_text.clear()
	logm("Function executed: " + text)

func logm (msg: String):
	print(msg)
	debug_text.newline()
	debug_text.append_text(msg)

func log_warning (msg: String):
	push_warning(msg)
	debug_text.newline()
	debug_text.append_text("[color=red]%s[/color]" % msg)

func log_error (msg: String):
	push_error(msg)
	debug_text.newline()
	debug_text.append_text("[color=yellow]%s[/color]" % msg)
