---
trigger: always_on
---

# <GAME_NAME> Directives

## Folder Structure
- `Game/Art/_Placeholder/`: New art assets.
- `Game/Code/`: `Model/` (Pure Data), `View/` (Presentation), `Control/` (Orchestration).
- `Game/Globals/`: Autoloads like `SignalBus` and `Global`.
- `Game/Prefabs/`: Reusable `.tscn` components.
- `Game/Scenes/`: Top-level game states.
- `Game/_GameDesign/`: `.tres` data.

## Core Rules
1. **MVC**: Model defines data (no logic). View renders/reacts (no data mod). Control joins them.
2. **Signals**: Use `SignalBus` for ALL cross-node communication.
3. **Hierarchy**: "Access Down, Signal Up" (Parents use `@export` for children; children use signals for parents).
4. **DRY**: Factor out repeated code. Avoid hardcoding; use `_GameDesignResources`.
5. **UI**: UI will be updated ONLY via signal_bus.gd signals. Do not create a script for any UI screen or element.

## Coding Conventions
- **Methods**: `func name (param: type) -> void:` (Always space before parenthesis).
- **Body**: No blank lines within methods.
- **Naming**:
    - Signals: `_on_signal_name` | Emit: `emit_signal_name`
- **Enums**: Use `Enums.Name.VALUE` (from `enums.gd`).
- **Nodes**: Use `@export` references, not `get_node()`.
- **Blank Lines**: No blank lines within methods. Two blank lines before each method declaration. One blank line between variable declarations of different kinds (e.g. @export vars and private vars).

## Global Autoloads
| Name | Path | Purpose |
|------|------|---------|
| `Storage` | `Modules/Storage/storage.gd` | Save/Load |
| `SignalBus` | `Game/Globals/signal_bus.gd` | Communication Hub |
| `Debug` | `Game/Debug/DebugCommands.tscn` | Dev Console |
| `Pooler` | `Modules/Utils/pooler.gd` | Object Pooling |
| `AudioController`| `Modules/Audio/AudioController.tscn` | SFX/Music |
| `Global` | `Game/Globals/Global.tscn` | Config & Runtime State |
| `Analytics` | `addons/genki-analytics/Analytics.tscn`| Tracking |
| `InputController`| `Modules/` | Input Layer |
