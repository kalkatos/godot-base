---
name: execute-task-art
description: 'Execute an Art task: identify needed art assets, create placeholder assets, and update the art assets doc. Use when: the task field is Art, creating placeholder graphics, or invoking /execute-task-art. Part of the Agentic Gamedev Process production phase.'
user-invocable: true
---

# /execute-task-art — Execute an Art Task

## Overview

Executes an Art task by identifying art assets needed, creating placeholder assets, and documenting them in `.docs/art-assets.md`. Uses the placeholder creator agent for image generation.

Part of the Agentic Gamedev Process (Production phase). Typically invoked by `/task-execution`, not directly.

## When to Use

- Task field is **Art**.
- The task involves creating placeholder art, identifying visual/audio assets, or updating the art asset inventory.
- Do NOT use for game design, UI, programming, or testing tasks.

## Workflow

### 1. Gather Context

Ensure these are loaded (should already be in context from `/task-execution`):

- `.docs/game-concept.md` — visual style and tone.
- `.docs/art-assets.md` — existing asset inventory (create from template if missing).
- `.docs/daily/daily_vX.Y.Z.md` — today's notes.
- If this is a re-execution (NEEDS REVISION), what specific feedback must be addressed.

### 2. Identify Needed Assets

From the task description, determine:

- What visual assets are needed (sprites, icons, backgrounds, tiles, UI elements, etc.).
- What audio assets are needed (SFX, music, ambience).
- Dimensions, style, and format for each.

### 3. Ensure Art Assets Doc Exists

If `.docs/art-assets.md` does not exist, create it using the template in `.agents/templates/`. If no template exists, create a minimal version:

```markdown
# Art Assets

## Characters
| Asset | Description | Status | Path |
|-------|-------------|--------|------|

## Environment
| Asset | Description | Status | Path |
|-------|-------------|--------|------|

## UI
| Asset | Description | Status | Path |
|-------|-------------|--------|------|

## Audio
| Asset | Description | Status | Path |
|-------|-------------|--------|------|
```

### 4. Create Placeholder Assets

For each identified asset:

- If `.agents/agents/ph-creator.agent.md` exists, use the placeholder creator agent to generate placeholder `.png` images.
- Otherwise, create minimal placeholder images directly: a solid-color rectangle with the asset name rendered as text, saved as `.png`.
- Save to `src/Game/Art/` following file naming conventions (`.agents/rules/file-naming.md`).
- Add each asset to `.docs/art-assets.md` with description, status (`placeholder`), and path.

### 5. Report Output

Summarize: which assets were created and where, and what was added to `.docs/art-assets.md`.
