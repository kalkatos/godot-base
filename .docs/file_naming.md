# File Naming Conventions

## 1. Project Members

FNC-1.1. **Folders:** on the top-level *snake_case*, inside `Game/` *PascalCase*. Examples: Game, Code, Model, Characters under `Game/` vs .agents, .docs, src on the top-level.
FNC-1.2. **Scripts:** snake_case. Example: `combat_controller.gd`
FNC-1.3. **Resources:** snake_case. Example: `fireball_spell.gd`
FNC-1.4. **Scenes:** PascalCase. Example: `DebugCommands.tscn`
FNC-1.5. **Prefabs:** PascalCase. Example: `BaseButton.tscn`
FNC-1.6. **Nodes:** PascalCase. Example: `CanvasLayer` inside `Main.tscn`
FNC-1.7. **Documents:** snake_case. Example: `file_naming.md`
FNC-1.8. **Art Assets:** snake_case. Example: `circle.png`
FNC-1.9. **Sound Assets:** snake_case. Example: `click_button.wav`

## 2. General Rules

FNC-2.1. Start tests with `test_*`
FNC-2.2. Hint the script category when possible. Example: `*_presenter.gd`, `*_controller.gd`, `*_data.gd`, `*_config.gd`
