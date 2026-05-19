# AGENTS.md

This file helps AI coding agents become productive quickly in this repository.

## Project Snapshot

- Engine: Godot 4.x (project config currently targets feature `4.6` in `<ProjectName>/project.godot`)
- Project root for Godot: `<ProjectName>/` (template default: `GodotBase/`)
- Main scene: configured by UID in `<ProjectName>/project.godot`
- Code conventions source of truth: `.agents/rules/directives.md`

Template note:
- When this template is renamed for a new game, replace `<ProjectName>` with the new root folder name.

## Where To Work

- Game-specific logic: `<ProjectName>/Game/`
- Reusable, game-agnostic systems: `<ProjectName>/Modules/`
- Third-party addons/plugins: `<ProjectName>/addons/`

Policy:
- Prefer implementing game behavior in `Game/`.
- Modify `Modules/` carefully (shared utilities).
- Avoid editing `addons/` unless the task explicitly requires it.

## Core Architectural Rules

Follow `.agents/rules/directives.md`.

High-value files:
- `.agents/rules/directives.md`
- `<ProjectName>/Game/Globals/signal_bus.gd`
- `<ProjectName>/Game/Globals/global.gd`
- `<ProjectName>/Game/Code/Model/enums.gd`

## Conventions To Preserve

- GDScript style in this repo commonly uses a space before `(` in function declarations/calls where already established; keep local file style consistent.
- Signal naming: `_on_*`
- Emitter helpers: `emit_on_*`
- Keep domain enums centralized in `<ProjectName>/Game/Code/Model/enums.gd` (`Enums.*`).

## Autoload Awareness

Autoloads are defined in `<ProjectName>/project.godot` (for example `SignalBus`, `Global`, `Storage`, `Pooler`, `AudioController`, `Analytics`, `Debug`).

When changing systems that emit signals or mutate shared state:
- Inspect emit functions in `<ProjectName>/Game/Globals/signal_bus.gd` for side effects.
- Check consumers before changing signal payloads.

## Run and Test

From `<ProjectName>/`:

- Open/run project in editor:
  - `godot4 --path .`
- Headless run (when available in your local Godot install):
  - `godot4 --headless --path .`

Testing:
- GUT is included under `<ProjectName>/addons/gut/`.
- CLI entrypoint is `res://addons/gut/cli/gut_cli.gd`.
- If a test task is requested, prefer project-specific test config when present (for example `.gutconfig.json`), otherwise use GUT CLI options.

## Agent Workflow Tips

- For behavior bugs, trace signal flow first (`SignalBus` -> controllers -> views).
- For balance/content tweaks, prefer data/resources in `Game/_GameDesign/` over hardcoding.
- Keep edits minimal and scoped; do not refactor across layers unless requested.
