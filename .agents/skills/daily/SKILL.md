---
name: daily
description: 'Plan the day''s work in the Agentic Gamedev Process. Use when: starting a new day of development, assigning sprint tasks to a day, invoking /daily, or checking yesterday''s progress before planning today.'
argument-hint: '[day number]'
user-invocable: true
---

# /daily — Plan the Day

## Overview

Assigns sprint backlog tasks to a new day through a guided interview. Checks yesterday's completion status, auto-carries unfinished work, lets the user pick tasks from the Unassigned pool, and writes the day plan to `backlog.md`, `project-state.md`, and a daily log. Automatically invokes `/daily-review` for a second pass.

Part of the Agentic Gamedev Process (Production phase). Every run starts a new day. The user is the gatekeeper.

## When to Use

- User invokes `/daily` to start a new day of work
- User asks "what should I work on today?"
- Do NOT use for sprint-level planning — that's `/sprint`

## Workflow

### 1. Load Context

- Read `.docs/project-state.md` for current milestone, sprint, day.
- Read `.docs/roadmap.md` for sprint goal and milestone definition of done.
- Read `.docs/backlog.md` for current sprint tasks and day assignments.
- Read `.docs/game-concept.md` and `.docs/glossary.md` for term consistency.
- Check `.docs/daily/` for the previous day's log (if any).

### 2. Determine the New Day Number

Read `Day:` from `project-state.md`:

- **`Day: Undefined`** → Day 1. First day of the sprint.
- **`Day: vX.Y.Z`** → Next day is `vX.Y.Z+1`. Always advance — every run is a new day.

### 3. Gate Check — Yesterday's Tasks

If a previous day exists (not Day 1), check the previous day's tasks in `backlog.md`:

- List each task from yesterday and ask: "Done?"
- Mark completed tasks as `[x]` (✅ in review summary).
- Unfinished tasks are auto-carried to today's plan. The user can drop or defer any during task selection.

Summarize the gate check concisely in the daily log under "Progress Since Last Daily."

### 4. Interview — Pick Today's Tasks

#### Step A — Present Available Tasks

Show the sprint's Unassigned pool plus any auto-carried tasks:

> "**Auto-carried from yesterday:** [list unfinished tasks]"
> "**Unassigned sprint tasks:** [list, grouped by field]"

#### Step B — User Selects

Ask: "Which tasks for today?" Recommend based on sprint goal and field dependency order (Game Design → Art → UI → Programming → Testing). Keep it brief.

For each selected task, confirm the field tag. No need for long descriptions — they're already in the backlog.

Stop when the user says the day is planned. Don't over-plan — a day should have a realistic workload.

### 5. Review

Present the day plan in field order, with each task assigned a W number (sequential across all fields):

```
## Day vX.Y.Z

### Game Design
- [ ] vX.Y.Z.1 - Design combat system

### Art
- [ ] vX.Y.Z.2 - Create player sprite placeholder
...
```

Ask: "Ready to commit?"

### 6. Write Documents

**Update `backlog.md`:**
- Move selected tasks from `### Unassigned` into a new `### Day vX.Y.Z` sub-section.
- Assign each task a W number (starting at 1, sequential across all fields in the day). Write as: `- [ ] vX.Y.Z.W - Task description`.
- Move auto-carried tasks from yesterday's day sub-section into today's. Re-number them with today's version (new W numbers).
- Mark yesterday's completed tasks as `[x]`.

**Update `project-state.md`:**
- Set `Day:` to `vX.Y.Z`.

**Create `.docs/daily/daily_vX.Y.Z.md`:**
Use the daily report template. Fill concisely — avoid verbosity:

- **Current Context**: milestone, sprint, phase, day.
- **Progress Since Last Daily**: gate check results (completed / carried over). For Day 1, note "First day of sprint."
- **Blockers**: ask the user. If none, state "No blockers."
- **Today's Focus**: the selected tasks, ordered by field.
- **Decisions Made Today**: any decisions from the interview.
- **Backlog Update**: N tasks moved from Unassigned, M carried over.
- **Notes & Observations**: brief context if relevant.

### 7. Run Daily Review

Immediately invoke the `/daily-review` logic:

1. Read the daily log just written.
2. Review tasks for feasibility, dependencies, and priority.
3. Flag any concerns: too many tasks, missing dependencies, tasks out of order.
4. If issues found, present them and let the user adjust (loop back to step 4).
5. Append review feedback to the daily log under a `## Review` section.
6. Update `backlog.md` if tasks changed during review.

### 8. Report Completion

> "Day vX.Y.Z planned: N tasks. Ready for `/task-execution`."
