---
name: daily
description: "Use when you need to run a daily check-in during Production phase. @Elk (producer): reviews progress, identifies blockers, plans today's focus, writes daily_<sprint>.<day>.md (with backlog), and creates a PR for senior review. Includes game design blocking analysis and field-based task categorization. After seniors review, @Elk runs /wrap-up-daily to incorporate feedback and dispatch field tasks."
version: 4.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, production, management, daily-report, backlog]
    related_skills: [milestone, identify-art-assets, identify-sound-assets, review-pr, wrap-up-daily]
---

# /daily — Daily Check-in & Backlog

## Overview

This skill runs the daily check-in during Production phase. As **@Elk (producer)**, you review progress, identify blockers, plan today's focus, write the daily report (including the backlog with task assignments), create a PR for senior review, incorporate review feedback by updating the document, and dispatch tasks to agents via kanban after the PR is approved and merged.

This is step 7 of the Dian Agentic Gamedev Process (Production phase daily loop).

## Naming Convention

All daily artifacts use the **sprint+day** convention (dot-separated), sourced from the `Day` field in `.docs/project-state.md`:

| Artifact | Pattern | Example |
|---|---|---|
| Daily report file | `.docs/daily/daily_<sprint>.<day>.md` | `daily_v1.1.1.md` |
| PR branch | `daily/<day>` | `daily/v1.1.1` |
| Commit message | `daily: <day> — <milestone> / <sprint>` | `daily: v1.1.1 — Core Loop / Combat Simulator` |
| Backlog task ID | `<sprint>.<day>.<task_seq>` | `v1.1.1.1`, `v1.1.1.2` |
| project-state.md Day field | `<sprint>.<day>` | `v1.1.1` |

The day number increments sequentially within a sprint (first daily of sprint v1.1 = day 1 → `v1.1.1`, second = day 2 → `v1.1.2`, etc.).

## When to Use

- Daily, at the start of the work session during Production phase
- When the user wants to review progress and plan the day
- Do NOT use during Pre-production (the daily loop is Production only)
- Do NOT use to handle post-review updates — that's `/wrap-up-daily`

## Workflow

### 0. Check for Existing Daily PR First

Before assuming a new daily is needed, check if an existing daily PR is still open:

```bash
# Read Day from .docs/project-state.md (e.g. v1.1.1), then:
gh pr list --head daily/<day> --state OPEN --json number,title,reviews
```

If a PR exists:
- **No reviews yet:** Skip to step 12 (dispatch senior review tasks for the existing PR).
- **Has reviews with feedback to address:** Run `/wrap-up-daily` — do not create a fresh daily.
- **No PR but a daily document exists for today:** The PR may have been created from a different branch or worktree. Check what branch the daily was committed on and update that branch — do not create a duplicate PR.
- **No PR and no daily document for today:** Continue with step 1 (create a new daily).

### 1. Check Prerequisites

Verify these files exist. If any are missing, redirect to `/milestone` and exit:
- `.docs/project-state.md`
- `.docs/roadmap.md`

### 2. Load Current State

- Read `.docs/project-state.md` for current milestone, sprint, and day.
- Read the most recent daily report if one exists (glob `.docs/daily/daily_*.md`, picks newest).
- Read `.docs/game-concept.md` and `.docs/roadmap.md` for context.
- Read `.docs/milestone-memo-*.md` if one exists for this milestone.

- **Update `.docs/project-state.md`:** After determining today's day number (increment from the previous daily or start at day 1 for a new sprint), update the `Day` field in `.docs/project-state.md` to the new value (e.g., `v1.1.2`). This keeps project-state.md always reflecting the current day being started.

### 3. Review Progress

- Review the previous daily report (if it exists) and compare against the current sprint goals in roadmap.md.
- Check which tasks from the previous day were completed and which were not.
- If the sprint goals are fully met, suggest moving to the next milestone via `/milestone`.

### 4. Identify Blockers

Ask the user:

> "What's blocking progress right now? Are there any tasks you couldn't complete, dependencies that haven't arrived, or technical issues slowing you down?"

Also check for process-level blockers per PROCESS.md Failure & Pivot:
- **Sprint overrun** — has the current sprint dragged past its expected duration? If so, propose a scope cut or sprint split.
- **Unresponsive agent** — has any agent missed a full daily cycle without completing their assigned kanban tasks? If so, reassign or escalate to the user.
- **PR stuck in revision** — if any agent's PR has been marked NEEDS REVISION twice, escalate to the user for a decision.

Record all blockers with specific details — what's blocked, why, and what's needed to resolve it.

### 5. Plan Today's Focus

Work with the user to determine the top 3 priorities for today:

> "Based on the current sprint and backlog, here's what I suggest for today: [list 3 tasks]. Does this look right? What would you change?"

Confirm the plan with the user.

### 6. Check Backlog for Pre-Existing Tasks

Before defining new tasks, read `.docs/backlog.md` and check if today's day already has tasks scoped there (e.g., `### Day 2 — Turn Engine` with `v1.1.2.x` entries). If tasks exist:
- Present them as the starting point for today's focus
- Let the user adjust (add, remove, refine) rather than redefining from scratch
- Only define net-new tasks if the user wants something beyond what's already scoped

If no tasks exist for today, proceed to define them fresh.

### 7. Define or Refine the Backlog

Based on the approved focus (and any pre-existing backlog tasks), define or refine specific, assigned tasks:

- `[Capy]` — game design tasks (Track A — always first)
- `[Angel]` — core programming tasks (Track B1)
- `[Jack]` — UI/GUI development tasks (Track B1)
- `[Imp]` — testing/QA tasks (Track B1, after Angel+Jack)
- `[Fairy]` — art direction tasks (Track B2, only if sprint has visual deliverables)
- `[Levi]` — sound design tasks (Track B2, only if sprint has audio deliverables)

Each task must have:
- **Clear owner persona**
- **Specific description** of what "done" looks like
- **Achievable scope** — completable in a few hours to one day
- **Field tag** — `[design]`, `[prog]`, `[art]`, or `[sound]`

#### Field Categorization

Group tasks by field. The four fields and their track alignment per PROCESS.md:

| Field | Track | Workers | Blocked by Game Design? |
|-------|-------|---------|-------------------------|
| `design` | Track A | Capy | N/A (always runs first) |
| `prog` | Track B1 | Angel, Jack, Imp | Yes — if game design tasks are blocking |
| `art` | Track B2 | Fairy | No — runs in parallel with B1 |
| `sound` | Track B2 | Levi | No — runs in parallel with B1 |

#### Game Design Blocking Analysis

For each game design task (`[Capy]`), determine whether it is **blocking** or **non-blocking** for Track B1:

- **Blocking** — the task documents features that programming/UI need before execution (new mechanics, rule changes, system architecture, data model changes). Track B1 MUST wait for this game design PR to be approved before starting.
- **Non-blocking** — the task covers areas that don't affect today's code work (lore, narrative, future concepts, polish notes). Track B1 can start in parallel.

The daily report must state explicitly in the "Today's Focus" section:
> "Game design **[blocks / does not block]** today's programming work."

If ANY game design task is blocking, the entire `design` field blocks Track B1. If all game design tasks are non-blocking, Track B1 starts immediately in parallel with Track A.

### 8. Update the Standalone Backlog

After defining tasks in the daily document, also update `.docs/backlog.md` with the new day's tasks under the current sprint section. `.docs/backlog.md` contains ONLY the current sprint's tasks (previous sprints are archived by `/milestone` to `.docs/backlog-<old-sprint>.md`). Each day gets a `### Day N — Title` subsection with its tasks. This is a main-branch file — commit and push directly to `main` after the daily document PR is created (see step 5b).

#### Step 3b: Sync decisions to decisions.md

After updating the daily document, also propagate the "Decisions Made Today" entries into `.docs/decisions.md`. Read the existing file, then append any new decisions (de-duplicating against existing entries by name). Each decision must follow the template:

- **What:** Clear description
- **Why:** Rationale
- **When:** Date, current milestone, current sprint
- **Alternatives Considered:** If any

**IMPORTANT: `.docs/decisions.md` is a main-branch file.** It is NOT tracked on the daily PR branch (which typically only carries `daily_<day>.md` and `project-state.md`). Do NOT include decisions.md in the PR branch commit — instead, commit and push it directly to `main` as a separate step (see step 5).

This ensures the permanent decision log stays in sync with daily outcomes and isn't locked inside individual daily reports.

#### Step 4: Populate Missing Documents
- `.docs/game-concept.md`
- `.docs/roadmap.md`
- `.docs/glossary.md`

If conflicts are detected, notify the user and ask if they want to update the documents.

### 10. Write the Daily Report

Read the template at `.agents/docs/templates/daily-report-template.md` and fill in every section. Write to `.docs/daily/daily_<sprint>.<day>.md` where `<sprint>.<day>` matches the Day field from `project-state.md` (e.g. `v1.1.1`).

The report includes:
- Current context (milestone, sprint, phase, day count)
- Progress since last daily (with task statuses)
- Blockers
- Today's focus (3 items)
- **Today's backlog** — assigned tasks with clear owners
- Decisions made today
- Team assignments summary
- Notes and observations

### 11. Create PR for Senior Review

Create a GitHub PR for the daily document. **Follow the UNIVERSAL-RULES.md gh auth procedure:**
1. Source your profile's `.env`: `source /home/hermes/.hermes/profiles/elk/.env`
2. Run the auth script: `source /home/hermes/.hermes/bin/gh_auth.sh`
3. Then use `gh pr create`

```bash
git checkout -b daily/<day>
git add .docs/daily/daily_<sprint>.<day>.md
git commit -m "daily: <day> — <milestone> / <sprint>"
git push origin daily/<day>
gh pr create --title "Daily: <day> — <milestone> / <sprint>" --body "..."
```

### 12. Dispatch Senior Review Tasks

After creating the daily PR, dispatch two kanban review tasks — one for @Griffin (senior programmer) and one for @Hag (senior game designer) — so they each review and comment on the PR. These are independent tasks (no parent-child linking needed — they can run in parallel).

Use the hermes CLI (NOT `delegate_task` — subagents don't have `kanban_create`):

```bash
# Capture the PR number from the gh pr create output
PR_NUMBER=<from gh pr create>

# Dispatch to Griffin
/app/venv/bin/hermes -p elk kanban create \
  "Review daily <day>: <milestone> / <sprint> — Senior Programmer" \
  --assignee griffin \
  --skill review-pr \
  --tenant mahou \
  --json \
  --body "## Senior Programmer Review: Daily <day>

**PR:** https://github.com/kalkatos/mahou/pull/$PR_NUMBER
**Daily doc:** .docs/daily/daily_<day>.md

### What to review
- Are the technical priorities correct for this day?
- Are blockers being addressed appropriately?
- Is the pace sustainable?
- Are any architectural decisions from the daily report sound?

### Output
- Post a review comment on the PR with APPROVED or NEEDS REVISION
- kanban_complete with verdict in metadata and summary"

# Dispatch to Hag
/app/venv/bin/hermes -p elk kanban create \
  "Review daily <day>: <milestone> / <sprint> — Senior Game Designer" \
  --assignee hag \
  --skill review-pr \
  --tenant mahou \
  --json \
  --body "## Senior Game Designer Review: Daily <day>

**PR:** https://github.com/kalkatos/mahou/pull/$PR_NUMBER
**Daily doc:** .docs/daily/daily_<day>.md

### What to review
- Does today's plan advance the game's vision?
- Are any design decisions from today conflicting with the game concept?
- Are the sprint goals still aligned with the milestone?

### Output
- Post a review comment on the PR with APPROVED or NEEDS REVISION
- kanban_complete with verdict in metadata and summary"
```

Both tasks go to `ready` immediately (no parent dependencies). The kanban dispatcher picks them up in parallel. After both complete, run `/wrap-up-daily` to incorporate their feedback.

⚠️ **Pitfall:** These review tasks must capture PR feedback BEFORE `/wrap-up-daily` runs. If `/wrap-up-daily` updates the daily document before Griffin/Hag have posted their reviews, the feedback loop breaks.

### 13. Senior Reviews

**@Griffin (senior programmer) review:**
- Are the technical priorities correct?
- Are blockers being addressed appropriately?
- Is the pace sustainable?

**@Hag (senior game designer) review:**
- Does today's plan advance the game's vision?
- Are any design decisions from today conflicting with the game concept?

Check the PR for review comments and verdicts:

```bash
gh pr view <PR_NUMBER> --json reviews,comments
```

A review can have three verdicts:
- **APPROVED** — proceed, but check for non-blocking observations that should still be addressed
- **APPROVED with observations** — the senior approves but expects observations addressed before merge
- **NEEDS REVISION** — must address before proceeding

Present feedback to the user. Then run `/wrap-up-daily` to incorporate the feedback and update both the daily document and the sprint backlog.

---

### 14. After PR Approval — Dispatch Tasks

**Dispatching is now handled by `/wrap-up-daily`.** When the user approves and merges the daily PR, `/wrap-up-daily` automatically dispatches the worker→review→decision chains per field (see PROCESS.md Tracks A, B1, B2):

1. **Track A — Game Design** (if `[Capy]` tasks exist): @Capy `/game-design-pass` → @Hag review → @Elk orchestrator decision. Runs first. If any game design task is **blocking**, Tracks B1/B2 wait for game design PR approval.
2. **Track B1 — Code** (if `[Angel]` or `[Jack]` tasks exist): @Angel/@Jack `/task-execution` → @Griffin review → @Elk orchestrator decision. All `prog` field tasks are dispatched in sequence — each completes its chain before the next drops. User is only notified when the entire `prog` field is done OR a task reaches 3 NEEDS REVISION.
3. **Track B2 — Art & Sound** (if `[Fairy]` or `[Levi]` tasks exist): @Fairy/@Levi → @Kavu review → @Elk orchestrator decision. Runs in parallel with Track B1. Same field-complete notification pattern.
4. **Tests** (@Imp): Dispatched after all `prog` field tasks are complete.

Workers in the same field share a branch (`day/vX.Y.Z/<field>`). See `/task-execution` skill for branch naming.

### 15. Report Completion

Return a summary including:
- Today's top 3 priorities
- Any blockers that need attention
- Game design blocking status (blocking or non-blocking for today's code work)
- The PR link for review
- Process reminder:

> "**Process:**
> 1. @Griffin reviews → APPROVED or NEEDS REVISION
> 2. @Hag reviews → APPROVED or NEEDS REVISION
> 3. @Elk runs `/wrap-up-daily` to incorporate feedback → updates daily + backlog → **dispatches tasks per field**
> 4. @User approves and merges
> 5. **Track A — Game Design:** @Capy `/game-design-pass` → @Hag review → @Elk orchestrator (up to 3 rounds). If blocking, Tracks B1/B2 wait.
> 6. **Track B1 — Code:** @Angel/@Jack `/task-execution` → @Griffin review → @Elk orchestrator. All `prog` tasks run in sequence. User notified when field is done or 3 NEEDS REVISION hit.
> 7. **Track B2 — Art & Sound:** @Fairy/@Levi → @Kavu review → @Elk orchestrator. Parallel with B1.
> 8. **Tests:** @Imp `/create-tests` after all `prog` tasks complete.
> 9. After all daily tasks: @Elk `/review-day` → end-of-day production review (APPROVED or NEEDS REVISION)
> 10. After all sprint tasks: @Elk `/review-sprint` → sprint review → @Griffin, @Hag, @Kavu, @Levi review"

## Common Pitfalls

1. **Not assigning tasks.** The daily IS the backlog. Every task must have a clear owner persona (`[Angel]`, `[Jack]`, etc.). Unassigned tasks don't get done.
2. **Not checking prerequisites.** If core files are missing, redirect, don't proceed with incomplete context.
3. **Vague priorities.** "Work on combat" is not a plan. Be specific: "Implement enemy patrol behavior for the forest level."
4. **Skipping document consistency checks.** Decisions made during the daily can ripple into the game concept, roadmap, or glossary.
5. **Not dating the report.** The filename must use the sprint+day convention (e.g. `daily_v1.1.1.md` matching the Day field in project-state.md). These accumulate over the sprint.
6. **Ignoring sprint overrun.** If a sprint is dragging well past its expected duration, flag it in the daily and propose a scope cut or sprint split.
7. **Silent on unresponsive agents.** If an agent misses a full daily cycle without completing their kanban tasks, reassign or escalate.
8. **Skipping the PR.** Every daily must go through the PR → senior review → user approval gate.
9. **Using wrong gh auth.** Always source `.env` + `gh_auth.sh` before `gh` commands.
10. **Dispatching before PR approval.** Don't create kanban tasks until the daily PR is merged.
11. **Creating a duplicate daily PR.** Always check for an existing daily PR (step 0) before creating a new one. A second PR for the same day fragments the review conversation.
12. **Ignoring observations from APPROVED reviews.** An APPROVED review with observations still requires action. Address all observations before asking the user to merge.
13. **Leaving the backlog empty when flagged.** The sprint backlog (`.docs/backlog.md`) is a milestone deliverable. If a reviewer flags it, populate it in the same update commit.
14. **Not adding a senior review response table.** Without a table mapping each observation to its resolution, reviewers must re-read the full diff to see if their feedback was addressed.
15. **Pushing to the wrong branch.** After updating the document, push to the existing PR branch, not main. Use `git push origin <local>:<pr-branch>` if they diverge.
16. **Using the old date-based naming.** Daily files are now named `daily/daily_<sprint_day>.md` (e.g., `daily/daily_v1.1.1.md`) — inside the `.docs/daily/` subdirectory, not flat under `.docs/`. Tasks in backlog use `<sprint>.<day>.<task_seq>` (e.g., `v1.1.1.1`). The `project-state.md` includes a `Day:` field tracking the current day (e.g., `Day: v1.1.1`).
17. **Pushing decisions.md to the PR branch.** `.docs/decisions.md` is a main-branch file — it is NOT tracked on the daily PR branch. After syncing decisions (step 3b), push decisions.md directly to `main` (step 5b), not to the PR branch. Including it in the PR branch commit causes wrong-branch commits that must be reverted.
18. **Using `--body` for PRs with special characters.** Markdown characters (bold `**`, em-dashes `—`, backticks, numbered lists) in the PR body cause shell interpretation errors when passed via `gh pr create --body "..."`. Use `--body-file` instead: write the body to a temp file, then `gh pr create ... --body-file /tmp/pr_body.md`.
19. **Auto-dispatching Imp tasks.** Test tasks (Imp) are never auto-dispatched. When defining the backlog, flag Imp tasks as manual in the daily document notes so it's clear they're held for user dispatch after the preceding code PRs merge.
20. **Apostrophes in kanban `--body` break single-quote wrapping.** When passing multi-line bodies to `hermes kanban create --body '...'`, an apostrophe (e.g., "game's") terminates the single-quoted string early, causing shell argument parsing errors. Escape apostrophes with `\047` octal: `game\047s`. Alternatively, use double-quote wrapping (`--body "..."`) but then escape internal double quotes and `$` characters.
21. **Not categorizing game design tasks by blocking status.** Every `[Capy]` game design task must be marked **blocking** or **non-blocking** for Track B1. Unmarked game design tasks default to blocking — this may unnecessarily delay programming work. Always ask the user: "Does this game design task block today's programming, or can they run in parallel?"
22. **Not grouping tasks by field in the backlog.** The daily backlog must group tasks under Track A / Track B1 / Track B2 headers so `/orchestrate` can dispatch per field. Flat lists of mixed tasks break field-based orchestration.
23. **Forgetting to update the standalone backlog.md.** The daily document's "Today's Backlog" section defines tasks for the day, but `.docs/backlog.md` is the sprint-wide task list (current sprint only — previous sprints are archived by `/milestone`) that `/orchestrate` reads for field dispatch. After writing the daily, always update `.docs/backlog.md` with the same tasks — push it directly to `main` (not the PR branch) alongside `decisions.md`.

## Support Files

- `references/process-overview.md` — Full Agentic Gamedev Process v2 workflow, persona mappings, and design decisions.
- `templates/daily-report-template.md` — The daily report output template.

## Verification Checklist

- [ ] Step 0: Checked for existing daily PR before creating a new one
- [ ] Prerequisite files confirmed (project-state, roadmap)
- [ ] Previous daily report reviewed for carry-over context
- [ ] `.docs/project-state.md` updated with today's Day value (e.g., `v1.1.2`)
- [ ] Blockers identified and documented
- [ ] Today's top 3 priorities confirmed with user
- [ ] Backlog checked for pre-existing tasks before defining new ones
- [ ] Backlog tasks defined or refined with clear goals and assignee personas
- [ ] New decisions recorded in decisions.md (step 7, before writing daily)
- [ ] After senior review: decisions synced to decisions.md (step 3b)
- [ ] Document consistency checked (game-concept, roadmap, glossary)
- [ ] Output written to `.docs/daily/daily_<sprint>.<day>.md`
- [ ] All template sections filled
- [ ] PR created (with correct profile auth)
- [ ] Review tasks dispatched to Griffin and Hag (hermes kanban create)
- [ ] Senior reviews completed
- [ ] If senior feedback received: observations mapped to resolutions, daily updated, PR pushed, summary comment added
- [ ] After PR approval: tasks dispatched via kanban
- [ ] Next step reminder includes conditional art/sound gates
