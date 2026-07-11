---
name: sprint
description: 'Define sprint tasks in the Agentic Gamedev Process. Use when: planning sprint tasks, starting a new sprint, re-planning mid-sprint scope, invoking /sprint, or filling in the backlog for the current sprint.'
argument-hint: '[optional: sprint number, e.g. "v1.2"]'
user-invocable: true
---

# /sprint — Define Sprint Tasks

## Overview

Defines the tasks for the current sprint through a guided interview. Tasks are tagged by field (Game Design, Art, UI, Programming, Testing) and written to `backlog.md`. The sprint's name and goal in `roadmap.md` are filled in if they're still placeholders. Sprint transitions are logged in `project-state.md`'s History section.

Part of the Agentic Gamedev Process (Production phase). The user is the gatekeeper — no files are written without explicit confirmation.

## When to Use

- User invokes `/sprint` to define the current sprint's tasks
- `project-state.md` shows `Sprint: Undefined` — time to plan the first sprint of a milestone
- User wants to re-plan mid-sprint ("adjust scope")
- User asks to "start the next sprint" or "define sprint tasks"
- Do NOT use for defining sprint names/goals at the milestone level — that's `/milestone`

## Workflow

### 1. Load Context

- Read `.docs/project-state.md` to determine the current milestone and sprint.
- Read `.docs/roadmap.md` for the sprint's name, goal, and the milestone's definition of done.
- Read `.docs/game-concept.md` for the game vision.
- Read `.docs/glossary.md` for term consistency.
- Read `.docs/backlog.md` to check if tasks already exist for this sprint.

### 2. Determine the Sprint Target

Check `project-state.md`:

- **`Sprint: Undefined`** → The milestone has no active sprint yet. Locate the first sprint under the current milestone in `roadmap.md`. This is the sprint to plan.

- **`Sprint: vX.Y [Name]`** → A sprint is already active. Ask:

> "Sprint vX.Y [Name] is already active. Start a **new sprint** (vX.Y+1) or **redefine** this one?"

If the user chooses to redefine, keep the same version number and overwrite the existing backlog section. If starting new, advance to the next sprint in `roadmap.md`.

If the target sprint doesn't exist in `roadmap.md` yet, ask:

> "Sprint vX.Y isn't in the roadmap yet. Add it now?"

If yes, collect the sprint name and goal, add it under the current milestone in `roadmap.md`, then proceed to task gathering. If no, suggest running `/milestone` to define sprint structure first.

### 3. Fill In Sprint Name and Goal (If Placeholder)

Read the target sprint from `roadmap.md`. If the name or goal is still a placeholder (`TBD`, `[[Name]]`, `[[...]]`, etc.):

> "This sprint doesn't have a name yet. What should we call it?"

Then:

> "What must be demonstrable by the end of this sprint? What's the goal?"

Use the milestone's definition of done to keep the goal aligned. If the sprint already has a name and goal, confirm them briefly and move on.

### 4. Interview — Define Sprint Tasks

Use the grill-me approach. Ask questions ONE AT A TIME. Recommend an answer with each.

#### Step A — Frame with the Milestone

Reference the current milestone to guide task brainstorming. Use these prompts based on the milestone:

| Milestone | Framing Prompt |
|-----------|---------------|
| Core Loop | "What are the minimal mechanics needed for a playable skeleton? What single action-feedback loop defines this game?" |
| Vertical Slice | "What 3-5 minutes of gameplay best demonstrates the game's potential? What gets polished and what stays placeholder?" |
| MVP | "What must exist before a stranger can play this without hand-holding? What's the minimum onboarding, content, and win/lose state?" |
| Alpha | "What content is still missing? Which systems need balancing? What's blocking the game from being feature-complete?" |
| Beta | "What bugs, performance issues, and rough edges remain? What needs final polish before it's shippable?" |
| Launch | "What final checks, store page assets, build configuration, and release steps are left?" |
| Project Setup | "What scaffolding and documentation is needed before development can begin?" |

#### Step B — Handle Existing Tasks (Re-plan Only)

If re-planning an existing sprint and `backlog.md` already has unfinished tasks (`[ ]`), present them as a starting point:

> "This sprint already has N unfinished tasks: [list them]. Keep, modify, or drop each?"

Let the user decide per task. Completed tasks (✅) are preserved automatically — only ask about them if the user explicitly wants to revisit finished work.

#### Step C — Gather New Tasks

For each task the user proposes, ask:

1. **Field:** "What field does this belong to? Game Design, Art, UI, Programming, or Testing?"
   - Recommend a field based on the task description. Let the user confirm or override.

2. **Description:** "What does 'done' look like for this task? Is there a specific deliverable?"

Stop when the user says the sprint is covered. There is no minimum or maximum task count — define as many as the sprint needs.

### 5. Review Before Writing

Present the sprint plan summarized under the Unassigned pool:

```
## Sprint vX.Y: [Name]
**Goal:** [What must be demonstrable]

### Unassigned
- [ ] [Task Name] (Game Design): [Description]
- [ ] [Task Name] (Art): [Description]
- [ ] [Task Name] (UI): [Description]
- [ ] [Task Name] (Programming): [Description]
- [ ] [Task Name] (Testing): [Description]
```

Tasks are grouped by field within Unassigned for readability. Day sub-sections are added later by `/daily`.

Ask: "Does this look right? Adjust anything?"

Iterate until confirmed. Do NOT write files until the user approves.

### 6. Write Documents

Once confirmed:

**Update `backlog.md`:**
- `backlog.md` contains ONLY the current sprint's tasks. When starting a **new** sprint (not a re-plan):
  1. Save a copy of the current backlog to `.docs/backlogs/backlog-vX.Y.md` for archival (create the directory if needed).
  2. Remove all previous sprint sections before writing the new one.
- Write tasks under `### Unassigned`, grouped by field in order: Game Design, Art, UI, Programming, Testing. Day sub-sections are added later by `/daily`.
- Format:
  ```
  ## Sprint vX.Y: [Name]
  **Goal:** [Goal]

  ### Unassigned
  - [ ] [Task Name] (Game Design): [Description]
  - [ ] [Task Name] (Programming): [Description]
  ...
  ```
- If redefining an existing sprint, preserve completed tasks (✅) unless the user explicitly asks to drop them. Preserve existing day sub-sections — only rewrite the Unassigned pool.

**Update `roadmap.md`:**
- Fill in the sprint name and goal if they were placeholders.
- Move the `=== WE ARE HERE ===` marker under the target sprint.
- Do NOT write tasks into the roadmap — tasks live exclusively in `backlog.md`.

**Update `project-state.md`:**
- Set `Sprint:` to the current sprint (e.g., `v1.1 Player Movement`).
- Set `Day:` to `Undefined` (day planning is `/daily`'s job).
- Append a transition entry to the History section:

```
---
**[vX.Y Name] — Started [YYYY-MM-DD]**
N tasks across M fields. Goal: [sprint goal].
```

Skip the History entry on re-plan (not a new sprint start).

### 7. Report Completion

Summarize what was written and suggest the next step:

> "Sprint vX.Y [Name] is planned with N tasks. Ready for `/daily` to assign the first day's work."
