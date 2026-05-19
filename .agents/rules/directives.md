---
trigger: always_on
---

# Directives for this Godot Game Code

## Folder Structure
- `Game/_GameDesign/`: `.tres` data.
- `Game/_GameDesign/Config`: `.tscn` for configurable variables.
- `Game/Art/`: For art assets, models, images, materials, shaders, etc.
- `Game/Code/`: `Model/` (Pure Data), `View/` (Presentation), `Control/` (Orchestration).
- `Game/Globals/`: Autoloads like `SignalBus` and `Global`.
- `Game/Prefabs/`: Reusable `.tscn` components.
- `Game/Scenes/`: Top-level game states.

## Core Rules
1. **MVC**: Model defines data (no logic). View renders/reacts (no data mod). Control joins them.
2. **Signals**: Use `SignalBus` for cross-system communication.
3. **Hierarchy**: Parents use `@export` for children; children use in-scene signals for parents.
4. **DRY**: Factor out repeated code.
5. **UI**: Use in order:
  A. In-scene signal hookups first for screen-local interactions.
  B. SignalBus only when receiver is outside the scene subtree or must survive scene transitions.
6. **Config**: Avoid hardcoding; use `Code/Model/Config/<system_name>_config.gd` script and a `_GameDesign/Config/<SystemName>Config.tscn` scene to store configurable values.
7. **Lists**: When creating a list of UI elements updated by a list, always create a single child object that will serve as prefab for other identical elements within that container. Do NOT create UI elements like Controls, Buttons, and Containers via code. To populate the list use the template below:
```gdscript
@export var container: Control # A reference to the container that will have at least one template child
func populate (data_list: Array) -> void:
	var views = container.get_children() # OR container.get_children().map(func(element): element as CustomViewType)
	var count = max(data_list.size(), views.size())
	for i in count:
		while views.size() <= i:
			views.append(views[0].duplicate())
		var current_view = views[i]
		var is_active = i < data_list.size()
		current_view.visible = is_active
		if not is_active:
			continue
		# Setup `current_view` with data from `data_list[i]`
```

## Coding Conventions
- **Methods**: `func name (param: type) -> void:` (Always space before parenthesis).
- **Body**: No blank lines within methods.
- **Naming**:
    - Signals: `_on_signal_name` | Emit: `emit_signal_name` | Handler: `_handle_signal_name`
- **Enums**: Use `Enums.Name.VALUE` (from `enums.gd`).
- **Nodes**: Use `@export` references, not `get_node()`.
- **Blank Lines**: No blank lines within methods. Two blank lines before each method declaration. One blank line between variable declarations of different kinds (e.g. @export vars and private vars).
- **Inferred Assignment Operator**: NEVER use the inferred assignment operator anywhere. (AKA walrus operator, colon-equals, or := )

## Global Autoloads
| Name | Path | Purpose |
|------|------|---------|
| `Storage` | `Modules/Storage/storage.gd` | Save/Load |
| `SignalBus` | `Game/Globals/signal_bus.gd` | Communication Hub |
| `Debug` | `Game/Debug/DebugCommands.tscn` | Dev Console |
| `Pooler` | `Modules/Utils/pooler.gd` | Object Pooling |
| `AudioController` | `Modules/Audio/AudioController.tscn` | SFX/Music |
| `Global` | `Game/Globals/Global.tscn` | Config & Runtime State |
| `Analytics` | `addons/genki-analytics/Analytics.tscn` | Tracking |
