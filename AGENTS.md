# AGENTS.md

This file helps AI coding agents become productive quickly in this repository.

## Project Snapshot

- A Godot 4.x game project. (Currently 4.6)
- Project root for Godot: `src/`
- Folder for game-specific documentation and instructions: `.docs/`.
- Important files that describe the project, its current state, and future plans:
  - `.docs/game-concept.md`: Elevator pitch, player fantasy, core mechanics, unique features.
  - `.docs/glossary.md`: Definitions for key domain terms and concepts.
  - `.docs/roadmap.md`: Definitions of major features and development phases.
  - `.docs/backlog.md`: Daily task list derived from milestones, with clear and concise descriptions.
  - `.docs/decisions.md`: Record of key decisions, rationale, and alternatives considered.
- If the files above are missing or incomplete, notify the user that they are important and they should prioritize creating and filling them in before proceeding with other tasks.
- Create those files lazily — only when you have something to write by using their templates in `.agents/docs/`.

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
- Avoid editing `.agents/` unless the task explicitly requires it (agent definitions, skills, rules, etc.).

## Core Rules

Rules you must follow when working on tasks. These rules are non-negotiable and must be adhered to in order to maintain code quality, consistency, and project organization.
  - Coding Standards: `.agents/rules/coding-standards.md` for code style and standards.
  - Agent workflow and gotchas are folded into `.agents/rules/coding-standards.md` and `.agents/rules/architecture.md`.
  - Screen Creation: `.agents/rules/screen-creation.md` for specific guidelines on creating UI screens and scenes.
  - Architecture: `.agents/rules/architecture.md` TBD

## Interview

When a document or task requires you to run an Interview, follow these guidelines:
  - Ask the user questions relentlessly about every aspect of the topic until reaching a shared understanding.
  - Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.
  - For each question, provide your recommended answer.
  - Use the `AskUserQuestion` tool.
  - Use free-text prompts for more exploratory questions that require nuance.
  - Do not make assumptions about the user's needs or preferences without explicit confirmation. Always ask for clarification if something is unclear.
  - Write down key insights from the interview after each question.

## Run and Test

On Windows:
```bash
cd src && 'C:\Program Files\Godot\Godot_console.exe' --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -ginclude_subdirs -gexit -glog=1
```

On Linux:
```bash
cd src && '/usr/local/bin/godot' --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -ginclude_subdirs -gexit -glog=1
```

Testing:
- GUT is included under `src/addons/gut/`.
- CLI entrypoint is `res://addons/gut/cli/gut_cli.gd`.
- If a test task is requested, prefer project-specific test config when present (for example `.gutconfig.json`), otherwise use GUT CLI options.

## Tools

- Use the placeholder creator agent in `.agents/agents/ph-creator.agent.md` to generate placeholder `.png` images, placeholder icons, mockup tiles, dummy graphics, HUD graphics, or any graphic asset from a short prompt. For example: "Character named Joseph", "Gold HUD icon", "Background image of a library", "Enemy sprite for a zombie", "Icon for the Fireball spell".

## Glossary

- The glossary document (`.docs/glossary.md`) defines key terms and concepts for the project.
- Update it throughout development as new terms arise or existing ones evolve.
- Always use terms consistent with the terms in the glossary.
- When building a response, if the user, in their request, referred to an item that is defined in the glossary but they use a different term, add a short glossary note. For example, if the user says "Change the project status to Core Game Loop", perform the request without getting in the way, but add a notification "Glossary note: 'Project Status' -> 'Project State', 'Core Game Loop' -> 'Core Loop'".
