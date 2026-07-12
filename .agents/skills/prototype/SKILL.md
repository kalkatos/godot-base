---
name: prototype
description: 'Build a fast, throwaway Godot prototype to test a mechanic, validate a hypothesis, explore feel, or capture findings. Use when: building a playable to answer a risk from risks.md, exploring a core mechanic, iterating on game feel, or invoking /prototype. Part of the Agentic Gamedev Process pre-production phase. Runs after /risk-assessment (optional) and before /milestone.'
argument-hint: '[mechanic or hypothesis to prototype, e.g., "double-jump feel" or "combat loop"]'
user-invocable: true
---

# /prototype — Rapid Gameplay Prototyping

## Overview

Builds a fast, simple, throwaway Godot prototype to test a mechanic, validate a hypothesis, explore feel, or capture findings. Prototypes live in `.prototypes/<slug>/` — fully self-contained, no coding standards, no tests. Each prototype produces a playable scene and a report following `.agents/templates/prototype-report.md`.

Part of the Agentic Gamedev Process (Pre-production phase). Runs after `/risk-assessment` (if used) and before `/milestone`.

## When to Use

- User invokes `/prototype` with or without a specific target
- A risk from `.docs/risks.md` needs to be tested
- A core mechanic needs to be explored before committing to production
- Game feel needs iteration and validation
- Do NOT use during Production phase — prototypes are pre-production only

## Core Rules

- **Godot only.** All prototypes are built as Godot scenes + scripts. No HTML, no paper, no external tools.
- **No coding standards.** Prototypes are throwaway. One monolithic `.gd` script + one `.tscn` scene is the norm. Architecture, naming conventions, and code quality rules do not apply.
- **No tests.** The "test" is the user running the prototype and the report capturing findings. GUT test cases for prototype code are wasted effort.
- **Everything self-contained.** All files for one prototype live in `.prototypes/<slug>/` — code, scene, assets, and report.
- **Single-shot.** Each invocation builds one prototype and writes one report. To iterate, the user invokes `/prototype` again with the same target.

## Output Structure

```
.prototypes/<slug>/
├── report.md          # Filled prototype-report template
├── <slug>.tscn        # Godot scene
├── <slug>.gd          # Monolithic script (attached to scene root)
└── assets/            # Placeholder art/audio (optional)
```

Create the `.prototypes/` directory at project root if it doesn't exist.

## Workflow

### 1. Determine What to Prototype

Three entry points, in priority order:

**A) User specified a target.** If the user invoked `/prototype "double-jump feel"` or similar, use that directly. Skip to step 2.

**B) Risks document exists.** Read `.docs/risks.md`. Pick the highest-priority risk that hasn't been prototyped yet. Confirm with the user: "Risk 1 is '[name]'. Prototype that?"

**C) Fallback — ask based on game concept.** Read `.docs/game-concept.md`. Present the core mechanics and ask: "Which mechanic do you want to prototype first?"

### 2. Define the Hypothesis

Formulate a single, falsifiable hypothesis. This is the north star for the prototype. Use the format from the risks template:

> "If the player [action], will they [feel/experience] — evidenced by [observable signal]?"

If coming from a risk, reuse the prototype question from `risks.md`. If the user specified a target without a formal risk, craft the hypothesis together:

- Ask: "What's the one thing we need to learn from this prototype?"
- Ask: "What would make this a success? What would make it a failure?"

Confirm the hypothesis before building anything.

### 3. Scope to Minimum Viable Slice

Ruthlessly cut scope. The prototype should be the smallest playable that answers the hypothesis.

- One scene maximum
- One mechanic — not a system, not a level, not a feature
- Placeholder art only (rectangles, circles, solid colors)
- No menus, no save/load, no polish
- If it takes more than one session to build, it's too big

Ask: "What's the absolute minimum that answers the question? What can we cut?"

### 4. Build the Prototype

Build in `.prototypes/<slug>/`:

1. **Create the folder structure** (see Output Structure above)
2. **Generate placeholder assets** if needed — use the `ph-creator` agent for any graphic assets. Keep it crude: colored rectangles, simple sprites.
3. **Create the scene** (`.tscn`) — a single root node with the prototype name
4. **Write the script** (`.gd`) — attach to the scene root. Single file, no modules, no helpers. Hardcode values. Write fast, not clean.
5. **Verify it runs.** Use the headless Godot command to confirm no syntax errors and the scene loads:

```bash
cd src && '<godot>' --headless --path . --check-only
```

If it doesn't run, fix it. A prototype that doesn't run is worthless.

### 5. Write the Report

Read `.agents/templates/prototype-report.md`. Fill all sections:

- **Hypothesis** — the question from step 2
- **Riskiest Assumption Tested** — from `risks.md` or the scoping conversation
- **Approach** — what was built, shortcuts taken, why Godot
- **Result** — observations from running the prototype (the AI should run it headless or describe expected behavior; the user plays it and provides feedback)
- **Metrics** — fill what's known; leave playtester-dependent fields blank for the user to complete
- **Recommendation** — PROCEED / PIVOT / KILL based on what was learned

Write to `.prototypes/<slug>/report.md`. Do NOT update `project-state.md`, `backlog.md`, or any other process file — prototypes are pre-production and self-contained.

### 6. Report Completion

Return a summary including:

- What was built and where
- The hypothesis and preliminary verdict
- Path to the report
- If risks exist: "Next risk in priority order is [name]. Run `/prototype` to test it."
- If iterating: "Run `/prototype` again with the same target to iterate on findings."

## Common Pitfalls

1. **Over-scoping.** Building a full game instead of testing one mechanic. If the prototype has more than one scene or script file, it's too big.
2. **Premature polish.** Adding menus, UI, animations, or real art. Prototypes use colored rectangles until the hypothesis is answered.
3. **No hypothesis.** Building without a clear question. "Let's see what happens" is not a hypothesis.
4. **Applying production rules.** Using coding standards, architecture patterns, or GUT tests on throwaway code. Don't.
5. **Putting prototypes in `src/Game/`.** Prototypes go in `.prototypes/` — they are not part of the game project.
6. **Skipping the report.** The prototype code is throwaway; the report is the permanent deliverable.
