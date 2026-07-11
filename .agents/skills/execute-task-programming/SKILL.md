---
name: execute-task-programming
description: 'Execute a Programming task: write GDScript code following coding standards and architecture rules. Use when: the task field is Programming, writing game logic, creating prefabs with code, or invoking /execute-task-programming. Part of the Agentic Gamedev Process production phase.'
user-invocable: true
---

# /execute-task-programming — Execute a Programming Task

## Overview

Executes a Programming task by writing clean, maintainable GDScript code. Follows coding standards and architecture rules. Creates and uses prefabs where appropriate.

Part of the Agentic Gamedev Process (Production phase). Typically invoked by `/task-execution`, not directly.

## When to Use

- Task field is **Programming**.
- The task involves writing game logic, systems, controllers, utilities, or any `.gd` files.
- Do NOT use for game design, art, UI, or testing tasks.

## Workflow

### 1. Gather Context

Ensure these are loaded (should already be in context from `/task-execution`):

- `.docs/game-concept.md` — the game's vision.
- `.docs/glossary.md` — consistent terminology.
- `.docs/decisions.md` — prior architecture decisions.
- `.docs/design/<system_name>_design.md` — if a design doc exists for this system.
- `.docs/daily/daily_vX.Y.Z.md` — today's notes.
- `.agents/rules/coding-standards.md` — code style and standards.
- `.agents/rules/architecture.md` — project architecture guidelines.
- `.agents/rules/file-naming.md` — naming conventions.
- If this is a re-execution (NEEDS REVISION), what specific feedback must be addressed.

### 2. Understand the Task

From the backlog entry and any design docs:

- What code files need to be created or modified.
- What behavior needs to be implemented.
- What dependencies exist (other systems, scenes, assets).

### 3. Write the Code

Create or update `.gd` files in `src/Game/Code/`:

- Use `snake_case` for script file names (e.g., `combat_controller.gd`).
- Hint the script category when possible: `*_controller.gd`, `*_presenter.gd`, `*_data.gd`, `*_config.gd`.
- Follow `.agents/rules/coding-standards.md` for style.
- Follow `.agents/rules/architecture.md` for structure and patterns.
- Write clean, self-documenting code. Avoid verbose comments.
- Create prefabs in `src/Game/Prefabs/` if the code is coupled to a reusable scene.

Key guidelines:

- Prefer `src/Game/Code/` for game-specific code.
- Modify `src/Modules/` carefully (shared utilities).
- Avoid editing `src/addons/` unless the task explicitly requires it.
- Use static typing (`: int`, `: String`, etc.) where possible.
- Use `class_name` for reusable classes.

### 4. Report Output

Summarize: which `.gd` files were created/updated, which prefabs (if any) were added, and what behavior was implemented.
