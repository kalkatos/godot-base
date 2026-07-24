extends Node
## All signals here must start with '_on_' to be auto-connected to SignalBus

# ███████████████████████████████  S Y S T E M S  █████████████████████████████████

signal _on_music_volume_set (value: float)
func emit_on_music_volume_set (value: float):
	if SignalBus != self:
		_on_music_volume_set.emit(value)
	SignalBus._on_music_volume_set.emit(value)


signal _on_sfx_volume_set (value: float)
func emit_on_sfx_volume_set (value: float):
	if SignalBus != self:
		_on_sfx_volume_set.emit(value)
	SignalBus._on_sfx_volume_set.emit(value)

# ███████████████████████████████  T R A N S I T I O N S  █████████████████████████████████

## Requests a scene change; origin_scene identifies the caller, data carries routing info.
signal _on_scene_transition_requested (origin_scene: Enums.SceneName, data: String)
## Requests a scene change; origin_scene identifies the caller, data carries routing info.
func emit_scene_transition_requested (origin_scene: Enums.SceneName, data: String) -> void:
	if SignalBus != self:
		_on_scene_transition_requested.emit(origin_scene, data)
	SignalBus._on_scene_transition_requested.emit(origin_scene, data)


## Fires after a scene transition has finished loading; scene and data match the original request.
signal _on_scene_transition_completed (scene: Enums.SceneName, data: String)
## Fires after a scene transition has finished loading; scene and data match the original request.
func emit_scene_transition_completed (scene: Enums.SceneName, data: String) -> void:
	if SignalBus != self:
		_on_scene_transition_completed.emit(scene, data)
	SignalBus._on_scene_transition_completed.emit(scene, data)

# ███████████████████████████████  T O O L T I P  █████████████████████████████████

## Requests a tooltip to be shown with the given text.
signal _on_show_tooltip (hint: String)
## Requests a tooltip to be shown with the given text.
func emit_show_tooltip (hint: String) -> void:
	if SignalBus != self:
		_on_show_tooltip.emit(hint)
	SignalBus._on_show_tooltip.emit(hint)


## Requests any currently visible tooltip to be hidden.
signal _on_hide_tooltip ()
## Requests any currently visible tooltip to be hidden.
func emit_hide_tooltip () -> void:
	if SignalBus != self:
		_on_hide_tooltip.emit()
	SignalBus._on_hide_tooltip.emit()

# ███████████████████████████████  R E A D Y  ███████████████████████████████████

func _ready ():
	if self == SignalBus:
		return
	for sig in get_signal_list():
		if not sig.name.begins_with('_'):
			break
		for connection in get_signal_connection_list(sig.name):
			SignalBus.connect(sig.name, connection.callable)
