---
name: execute-task-ui
description: 'Execute a UI task: create wireframes then implement UI screens, menus, or HUDs as .tscn files. Use when: the task field is UI, building screens/menus/HUDs, or invoking /execute-task-ui. Part of the Agentic Gamedev Process production phase.'
user-invocable: true
---

# /execute-task-ui — Execute a UI Task

## Overview

Executes a UI task by first creating wireframes, then implementing screens, menus, or HUDs as `.tscn` scene files. Follows the screen creation rules. Does NOT write code — this is scene creation only.

Part of the Agentic Gamedev Process (Production phase). Typically invoked by `/task-execution`, not directly.

## When to Use

- Task field is **UI**.
- The task involves creating or updating UI screens, menus, HUDs, or overlays.
- Do NOT use for game design, art, programming, or testing tasks.

## Workflow

### 1. Gather Context

Ensure these are loaded (should already be in context from `/task-execution`):

- `.docs/game-concept.md` — visual tone and player experience.
- `.docs/glossary.md` — consistent terminology for UI labels.
- `.docs/decisions.md` — prior UI/UX decisions.
- `.docs/daily/daily_vX.Y.Z.md` — today's notes.
- `.agents/rules/screen-creation.md` — screen/scene creation guidelines.
- `.agents/rules/file-naming.md` — naming conventions.
- If this is a re-execution (NEEDS REVISION), what specific feedback must be addressed.

### 2. Create Wireframes

Before building scenes, describe the layout:

- What elements are on screen and their spatial relationships.
- Navigation flow: what leads to what.
- States: empty, loading, error, populated.
- Use ASCII diagrams or simple descriptions — no need for graphic tools.

Present the wireframe to the user for a quick sanity check before proceeding to implementation.

### 3. Implement the Scene

Create or update `.tscn` files in `src/Game/Scenes/` or `src/Game/Prefabs/`:

- Follow `.agents/rules/screen-creation.md` strictly.
- Use PascalCase for scene and prefab file names.
- Use PascalCase for node names within scenes.
- Structure nodes logically: root container → layout → child elements.
- Use built-in Godot UI nodes (Control, Panel, VBoxContainer, HBoxContainer, Button, Label, etc.).

Do NOT write GDScript code. This step is scene creation only — programming comes later via `/execute-task-programming`.

### 4. Report Output

Summarize: which `.tscn` files were created/updated and what screens they represent.
