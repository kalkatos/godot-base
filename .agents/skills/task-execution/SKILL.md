---
name: task-execution
description: 'Execute a single task from the daily backlog, auto-review it, and loop until approved. Use when: invoking /task-execution, running the next task for the day, fixing a NEEDS REVISION task, or continuing the execute→review→fix loop. Part of the Agentic Gamedev Process production phase.'
argument-hint: '[vX.Y.Z.W or empty for next unchecked]'
user-invocable: true
---

# /task-execution — Execute a Task

## Overview

Orchestrates the execution of a single task from the daily backlog: identifies the task, dispatches to the correct `/execute-task-*` skill for the field, then invokes `/task-review` for a verdict. If the verdict is NEEDS REVISION, re-executes with the review feedback — up to 3 attempts. If APPROVED, reports completion.

Part of the Agentic Gamedev Process (Production phase). Runs entirely in one session — no hand-offs.

## When to Use

- User invokes `/task-execution vX.Y.Z.W` to execute a specific task.
- User invokes `/task-execution` (no version) to pick up the first unchecked task from today.
- A task has a NEEDS REVISION verdict and needs fixing.
- User says "continue", "next task", or "execute the next one".

## Workflow

### 1. Load Context

Read these files to establish context:

- `.docs/project-state.md` — current milestone, sprint, day.
- `.docs/backlog.md` — task definitions and day assignments.
- `.docs/game-concept.md` and `.docs/glossary.md` — design alignment.
- `.docs/decisions.md` — prior decisions.
- `.docs/daily/daily_vX.Y.Z.md` — today's notes (if exists).
- `.agents/rules/file-naming.md` — if creating new files.

### 2. Identify the Task

#### If a version number is provided (`/task-execution vX.Y.Z.W`)

- Search `backlog.md` for the line containing `vX.Y.Z.W -`. Each task is tagged inline by `/daily`: `- [ ] vX.Y.Z.W - Task description`.
- If found, extract the task description and its parent field heading.
- If not found, report: "Task vX.Y.Z.W not found in backlog."

#### If no version number is provided

- Read today's day section in `backlog.md` (from `project-state.md`).
- Find the first line matching `- [ ] vX.Y.Z.W -`.
- If none found: "No unchecked tasks for today. Run `/daily` to plan more."
- Confirm with user: "Execute [task description]? (vX.Y.Z.W)"

### 3. Check for Existing Review

Check `.docs/reviews/review_vX.Y.Z.W.md`:

- **No review file** → Fresh execution. Proceed to step 4.
- **Latest verdict is NEEDS REVISION** → Load the review feedback. Proceed to step 4 with feedback as additional context.
- **Latest verdict is APPROVED** → Warn: "This task was already approved. Re-execute anyway?" If yes, proceed. If no, stop.

### 4. Determine the Field

Read the parent field heading above the version-tagged task in `backlog.md`. The field is one of:

- **Game Design** → dispatch to `/execute-task-game-design`
- **Art** → dispatch to `/execute-task-art`
- **UI** → dispatch to `/execute-task-ui`
- **Programming** → dispatch to `/execute-task-programming`
- **Testing** → dispatch to `/execute-task-testing`

### 5. Execute the Task

Dispatch to the appropriate `/execute-task-*` skill with:

- The task description from the backlog.
- The version number `vX.Y.Z.W`.
- Review feedback (if this is a re-execution after NEEDS REVISION).
- Project context already loaded in step 1.

The execute skill produces the output (files created/updated). Do not gate or review yet — just execute.

### 6. Review the Task

Immediately invoke the `/task-review` logic:

- Review the completed work against the three lenses: Completeness, Correctness, Alignment.
- Write verdict to `.docs/reviews/review_vX.Y.Z.W.md`.
- Count prior NEEDS REVISION verdicts for this task.

**If APPROVED:**
- Mark the task as `[x]` in `backlog.md`.
- Report: "Task vX.Y.Z.W approved. Ready for next `/task-execution`."

**If NEEDS REVISION (attempt < 3):**
- Load the review feedback and loop back to step 5 (re-execute with feedback).
- Report: "vX.Y.Z.W needs revision (attempt N/3). Re-executing with feedback."

**If NEEDS REVISION (attempt >= 3):**
- Stop. Do NOT loop.
- Report: "vX.Y.Z.W reached 3 NEEDS REVISION verdicts. Stopping — please provide guidance."

### 7. Report Completion

Summarize: task version, description, field, verdict, files changed.
