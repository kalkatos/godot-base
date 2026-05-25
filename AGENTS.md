# AGENTS.md

This file helps AI coding agents become productive quickly in this repository.

## Project Snapshot

- A Godot 4.x game project. (Currently 4.6)
- Project root for Godot: `src/`
- Folder for game-specific documentation and instructions: `.docs/`. Notify the user if any of the following are missing:
  - `.docs/game-concept.md`: Elevator pitch, player fantasy, core mechanics, unique features.
  - `.docs/glossary.md`: Definitions for key domain terms and concepts.
  - `.docs/milestones.md`: Definitions of major features and development phases.
  - `.docs/roadmap.md`: Daily task list derived from milestones, with clear and concise descriptions.

## Where To Work

- Data objects, configs: `src/Game/_GameDesign/`
- Game-specific code: `src/Game/Code/`
- Art assets, audio: `src/Game/Art/`
- Reusable scenes, prefabs: `src/Game/Prefabs/`
- Game scenes: `src/Game/Scenes/`
- Reusable, game-agnostic systems: `src/Modules/`
- Third-party addons/plugins: `src/addons/`

## Policy

- Prefer implementing game behavior in `src/Game/`.
- Modify `src/Modules/` carefully (shared utilities).
- Avoid editing `src/addons/` unless the task explicitly requires it.

## Core Rules

Rules the agent must follow when working on tasks. These rules are non-negotiable and must be adhered to in order to maintain code quality, consistency, and project organization.
  - `.agents/rules/coding-standards.md` for code style and standards.
  - `.agents/rules/agent-workflow.md` for common workflows and gotchas to avoid.
  - `.agents/rules/screen-creation.md` for specific guidelines on creating UI screens and scenes.
  - `.agents/rules/architecture.md` TBD

## Run and Test

From `src/` run:
```powershell
& 'C:\Program Files\Godot\Godot_console.exe' --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -ginclude_subdirs -gexit -glog=1
```

Testing:
- GUT is included under `src/addons/gut/`.
- CLI entrypoint is `res://addons/gut/cli/gut_cli.gd`.
- If a test task is requested, prefer project-specific test config when present (for example `.gutconfig.json`), otherwise use GUT CLI options.
