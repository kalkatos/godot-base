---
name: execute-task-game-design
description: 'Execute a Game Design task: write design documentation for game mechanics, level design, or game experience. Use when: the task field is Game Design, writing to .docs/design/, or invoking /execute-task-game-design. Part of the Agentic Gamedev Process production phase.'
user-invocable: true
---

# /execute-task-game-design — Execute a Game Design Task

## Overview

Executes a Game Design task by writing clear, concise, actionable design documentation to `.docs/design/`. Follows the game concept, decisions, glossary, and daily notes. Avoids verbosity.

Part of the Agentic Gamedev Process (Production phase). Typically invoked by `/task-execution`, not directly.

## When to Use

- Task field is **Game Design**.
- The task involves describing game mechanics, level design, systems, or overall game experience.
- Do NOT use for art, UI, programming, or testing tasks.

## Workflow

### 1. Gather Context

Ensure these are loaded (should already be in context from `/task-execution`):

- `.docs/game-concept.md` — the game's vision and core loop.
- `.docs/glossary.md` — use consistent terminology.
- `.docs/decisions.md` — prior decisions that constrain design.
- `.docs/daily/daily_vX.Y.Z.md` — today's notes and focus.

### 2. Understand the Task

From the backlog entry, identify:

- What system, mechanic, or feature is being designed.
- What question the design doc needs to answer.
- If this is a re-execution (NEEDS REVISION), what specific feedback must be addressed.

### 3. Write the Design Document

Create or update a file in `.docs/design/<system_name>_design.md`. Follow these rules:

- **Clear**: Use plain language. Define terms on first use.
- **Concise**: Bullet lists over paragraphs. One concept per bullet.
- **Actionable**: A programmer should be able to implement from this doc.
- **Aligned**: Match terminology from the glossary. Reference the game concept where relevant.

Structure:

```markdown
# [System Name] Design

## Overview
- [1-2 sentences on what this system does]

## Mechanics
- [Bullet list of rules, behaviors, interactions]

## Flow
- [Step-by-step sequence if applicable]

## Integration
- [How this system connects to other systems]

## Open Questions
- [Anything unresolved — flag for later]
```

Avoid adding sections not listed above. Keep it scannable.

### 4. Report Output

Summarize: which design file was created/updated and what was designed.
