---
name: milestone
description: 'Start a new milestone in the Agentic Gamedev Process. Use when: defining milestone sprints, transitioning to a new development phase (Core Loop, Vertical Slice, MVP, Alpha, Beta, Launch), updating roadmap.md and project-state.md, or invoking /milestone.'
argument-hint: '[milestone number or name, e.g. "v1 Core Loop"]'
user-invocable: true
---

# /milestone — Start a New Milestone

## Overview

Starts a new milestone in the Agentic Gamedev Process. Through a guided interview, confirms the milestone target, validates phase ordering, defines sprints with goals, and writes to `roadmap.md`, `project-state.md`, and `decisions.md`.

Part of the Agentic Gamedev Process (Production phase). The user is the gatekeeper — no files are written without explicit confirmation.

## When to Use

- User invokes `/milestone` with a target milestone
- User asks to "start the next milestone" or "define milestone sprints"
- Transitioning between major development phases
- Do NOT use for defining sprint tasks — that's `/sprint`

## Workflow

### 1. Load Context

- Read `.docs/roadmap.md` to check existing milestones and sprints.
- Read `.docs/project-state.md` to determine the current milestone.
- Read `.docs/game-concept.md` for the game vision (to align sprint goals).
- Read `.docs/glossary.md` for term consistency.
- Read `.docs/decisions.md` for prior decisions that may influence scope.

### 2. Determine Target Milestone

If the user provided a milestone, use it. If not, ask: "Which milestone are you targeting?"

Map the user's input to the rigid milestone list:

| # | Milestone |
|---|-----------|
| 0 | Project Setup |
| 1 | Core Loop |
| 2 | Vertical Slice |
| 3 | MVP |
| 4 | Alpha |
| 5 | Beta |
| 6 | Launch |

### 3. Validate Phase Ordering

Milestones are sequential and cumulative. Check that the target milestone follows the current one in `project-state.md`:

- If the target is the **next** milestone in sequence → proceed.
- If the target **skips** one or more milestones → flag: "Milestone vX [Name] hasn't been completed yet. Start there first?"
- If the target is the **same** as current → flag: "Already on vX [Name]. Did you mean to redefine its sprints?"
- If the target is **before** current → flag: "vX [Name] has already passed. Did you mean to go back?"

The user may override any warning — they are the gatekeeper. But the warning must be shown.

### 4. Check for Existing Definition

If `roadmap.md` already has sprints defined for the target milestone, ask:

> "vX [Name] already has N sprints defined. Redefine from scratch or refine the existing plan?"

Act accordingly:
- **Redefine**: Wipe existing sprints for that milestone, start fresh.
- **Refine**: Keep existing sprints, let the user add/remove/reorder.

### 5. Interview — Define Milestone Sprints

Use the grill-me approach. Ask questions ONE AT A TIME. Recommend an answer with each.

**Step A — Definition of Done:**

> "What does 'done' for vX [Name] look like? What must be demonstrable by the end of this milestone?"

This becomes the milestone's exit criteria. Write it down — it anchors all sprint planning.

A good definition of done is **testable** — the agent should push back on vague answers. Use the guideline:

| Weak | Strong |
|------|--------|
| "Combat works" | "The player can move, shoot, and defeat one enemy type in a single-room arena" |
| "The game is playable" | "A full run from start screen to death/win screen with placeholder assets" |
| "UI is done" | "Main menu, pause screen, and HUD are implemented as navigable scenes" |

If the answer is vague, follow up: "How would you know it's done? What would you see/hear/do to confirm?"

**Step B — Work backwards to sprints:**

Starting from the definition of done, ask:

> "What intermediate deliverables prove progress toward this goal? What's the first thing the player (or you) should be able to do?"

Use these per-milestone prompts to guide the conversation:

| Milestone | Key framing prompts |
|-----------|---------------------|
| Core Loop | "What are the minimal mechanics needed for a playable skeleton? What single action-feedback loop defines this game?" |
| Vertical Slice | "What 3-5 minutes of gameplay best demonstrates the game's potential? What gets polished and what stays placeholder?" |
| MVP | "What must exist before a stranger can play this without hand-holding? What's the minimum onboarding, content, and win/lose state?" |
| Alpha | "What content is still missing? Which systems need balancing? What's blocking the game from being feature-complete?" |
| Beta | "What bugs, performance issues, and rough edges remain? What needs final polish before it's shippable?" |
| Launch | "What final checks, store page assets, build configuration, and release steps are left?" |

For each proposed sprint, ask:

1. **Goal:** "What must be demonstrable by the end of this sprint?"
2. **Dependencies:** "Does this sprint depend on anything from a previous sprint?"
3. **Order:** "Should this come before or after the other sprints we've defined?"

Stop when the user says the milestone is covered. Remind them: "We have N sprints so far. Does this cover the definition of done, or should we add more?"

There is no minimum or maximum sprint count — define as many as the milestone needs.

### 6. Review Before Writing

Present the full milestone plan as a summary:

```
## vX: [Milestone Name]
**Definition of Done:** [exit criteria]

### Sprint vX.1: [Name]
**Goal:** [What must be demonstrable]

### Sprint vX.2: [Name]
**Goal:** [What must be demonstrable]

[...]
```

Ask: "Does this look right? Adjust anything?"

Iterate until confirmed. Do NOT write files until the user approves.

### 7. Write Documents

Once confirmed:

**Update `roadmap.md`:**
- Add the milestone section with sprints following the roadmap template format (`.agents/templates/roadmap-template.md`).
- Move the `=== WE ARE HERE ===` marker to the new milestone so it always reflects the active milestone from `project-state.md`. This applies even when going back to redefine a past milestone.

**Update `project-state.md`:**
- Set `Milestone:` to the new milestone (e.g., `v1 Core Loop`).
- Set `Sprint:` to `Undefined` (sprint planning is `/sprint`'s job).
- Set `Day:` to `Undefined`.

**Append to `decisions.md`:**
- Add a decision entry for the milestone transition:

```
**[Milestone Started: vX Name]**
**What:** Started milestone vX [Name]. Definition of done: [exit criteria].
**Why:** [Reason for transitioning — based on interview context].
**When:** [YYYY-MM-DD], vX: [Name], Sprint: N/A.
**Alternatives Considered:** Remaining on previous milestone; skipping to a later milestone.
```

### 8. Report Completion

Summarize what was written and suggest the next step:

> "Milestone vX [Name] is set with N sprints. Ready for `/sprint` to define the first sprint's tasks."
