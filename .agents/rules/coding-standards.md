---
trigger: always_on
---

# Directives and coding conventions for this Godot game

- Scope: These directives apply to GDScript files (`.gd`) and scene wiring in `.tscn` files.

CS-01. **Methods**: `func name (param: type) -> void:` (Always space before parenthesis).
CS-02. **Body**: No blank lines within methods.
CS-03. **Naming**:
	- Signals: `_on_signal_name` | Emit: `emit_signal_name` | Handler: `_handle_signal_name`
CS-04. **Enums**: All global enums must exist in `src/Game/Globals/enums.gd` and be accessed via `Enums.EnumName.VALUE`.
CS-05. **Nodes**: Use `@export` references for child nodes. `get_node()` is allowed only for dynamic/runtime-instanced nodes when exported references are not feasible. Verify scene wiring before code changes; broken NodePath references and renamed nodes are frequent root causes.
CS-06. **Load at Runtime**: Never use runtime load references with `load()` or `preload()`. Always use exported references for scenes, scripts, and resources.
CS-07. **Signals**: Use `SignalBus` for cross-system communication. For scene-local interactions, use in-scene signals and hookups.
	- For behavior bugs, trace signal flow first (`SignalBus` -> controllers -> views).
	- When changing systems that emit signals or mutate shared state:
		- Inspect emit functions in `src/Game/Globals/signal_bus.gd` for side effects.
		- Check consumers before changing signal payloads.
	- Preserve backward compatibility for signals unless a breaking change is explicitly requested.
	- For pooled or dynamically spawned nodes, verify signal connections/disconnections to avoid duplicate callbacks.
CS-08. **Config**: Avoid hardcoding values. Use `src/Game/Code/Model/Config/<system_name>_config.gd` script and a `Game/_GameDesign/Config/<SystemName>Config.tscn` scene to store configurable values. Prefer storing gameplay, balance, and content-tuning values in `Game/_GameDesign/` resources rather than script constants.
CS-09. **UI**: Never create UI elements like Controls, Buttons, and Containers via code. Instead, create a single child object in the scene that will serve as a prefab for other identical elements within that container. To populate the list, use the template below:
```gdscript
@export var container: Control # A reference to the container that will have at least one template child
func populate (data_list: Array) -> void:
	var views = container.get_children() # OR container.get_children().map(func(element): element as CustomViewType)
	if views.is_empty():
		return
	var count = max(data_list.size(), views.size())
	for i in range(count):
		while views.size() <= i:
			var new_view = views[0].duplicate()
			container.add_child(new_view)
			views.append(new_view)
		var current_view = views[i]
		var is_active = i < data_list.size()
		current_view.visible = is_active
		if not is_active:
			continue
		# Setup `current_view` with data from `data_list[i]`
```
CS-09-A. **Workflow / Testing**: Prefer deterministic repro steps for bugs (fixed seed, fixed scene, minimal setup) before implementing a fix. Run relevant GUT tests after behavior changes; add a focused regression test when fixing a bug.
CS-09-B. **Addons**: Avoid editing `addons/` unless the task explicitly targets third-party/plugin behavior.
CS-10. **DRY**: Factor out repeated code into reusable methods or utilities.
CS-11. **Inferred Assignment Operator**: NEVER use `:=` (inferred type assignment). Use instead either: 
  - Explicit type: `var my_var: Type = value`
  - Cast to type: `var my_var = value as Type`
  - No type: `var my_var = value`

## Global Autoloads
| Name | Path | Purpose |
|------|------|---------|
| `Storage` | `Modules/Storage/storage.gd` | Save/Load |
| `SignalBus` | `Game/Globals/signal_bus.gd` | Communication Hub |
| `Debug` | `Game/Debug/DebugCommands.tscn` | Dev Console |
| `Pooler` | `Modules/Utils/pooler.gd` | Object Pooling |
| `AudioController` | `Modules/Audio/AudioController.tscn` | SFX/Music |
| `Global` | `Game/Globals/Global.tscn` | Global holder object |
| `Analytics` | `addons/genki-analytics/Analytics.tscn` | Tracking |

- If touching autoload/singleton behavior, check initialization order assumptions and avoid circular dependencies.
