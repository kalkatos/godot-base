---
name: daily
description: "Use when you need to run a daily check-in during Production phase. @Elk (producer): reviews progress since last daily, identifies blockers, plans today's focus, and writes daily_<date>.md. Does NOT manage the backlog — use /create-backlog for that."
user-invocable: true
---

# /daily — Daily Check-in Report

## Overview

This skill runs the daily check-in during Production phase. As **@Elk (producer)**, you review progress, identify blockers, plan today's focus, and produce a daily report. This skill does NOT manage the backlog — that's handled by `/create-backlog`.

This is step 7 of the Agentic Gamedev Process (Production phase daily loop).

## When to Use

- Daily, at the start of the work session during Production phase
- When the user wants to review progress and plan the day
- Do NOT use during Pre-production (the daily loop is Production only)
- Do NOT use to fill the backlog — use `/create-backlog` for that

## Workflow

### 1. Check Prerequisites

Verify these files exist. If any are missing, redirect to `/milestone` and exit:
- `.docs/project-state.md`
- `.docs/roadmap.md`
- At least one `.docs/backlog-*.md` (the most recent dated backlog)

### 2. Load Current State

- Read `.docs/project-state.md` for current milestone and sprint.
- Read the most recent backlog (`backlog-*.md`).
- Read the most recent daily report if one exists (`daily_*.md`).
- Read `.docs/game-concept.md` and `.docs/roadmap.md` for context.

### 3. Review Progress

- Review the previous daily report (if it exists) and compare against the current backlog.
- Check which tasks from the previous day were completed and which were not.
- If the backlog has all tasks marked done → redirect to `/milestone` to finish the sprint and exit.

### 4. Identify Blockers

Ask the user:

> "What's blocking progress right now? Are there any tasks you couldn't complete, dependencies that haven't arrived, or technical issues slowing you down?"

Record all blockers with specific details — what's blocked, why, and what's needed to resolve it.

### 5. Plan Today's Focus

Work with the user to determine the top 3 priorities for today:

> "Based on the current sprint and backlog, here's what I suggest for today: [list 3 tasks]. Does this look right? What would you change?"

Confirm the plan with the user.

### 6. Record Decisions

If any important decisions were made during the check-in, read `.docs/decisions.md` and add new decisions following the decisions template format:
- **What:** clear description
- **Why:** rationale
- **When:** today's date, current milestone, current sprint
- **Alternatives Considered:** if any

### 7. Check Document Consistency

Read these documents and verify the decisions made today don't conflict:
- `.docs/game-concept.md`
- `.docs/roadmap.md`
- `.docs/glossary.md`

If conflicts are detected, notify the user and ask if they want to update the documents.

### 8. Write the Daily Report

Read the template at `.agents/docs/templates/daily-report-template.md` and fill in every section. Write to `.docs/daily_<date>.md` where `<date>` is today's date in YYYY-MM-DD.

The report includes:
- Current context (milestone, sprint, phase, day count)
- Progress since last daily (with task statuses)
- Blockers
- Today's focus (3 items)
- Decisions made today
- Backlog reference (note: "Run `/create-backlog` to populate today's tasks")
- Team assignments per persona
- Notes and observations

### 9. Senior Reviews

**@Griffin (senior programmer) review:**
- Are the technical priorities correct?
- Are blockers being addressed appropriately?
- Is the pace sustainable?

**@Hag (senior game designer) review:**
- Does today's plan advance the game's vision?
- Are any design decisions from today conflicting with the game concept?

Present feedback to the user and flag any concerns.

### 10. Report Completion

Return a summary including:
- Today's top 3 priorities
- Any blockers that need attention
- The path to the written report
- Reminder: "Next: @Fairy runs `/identify-art-assets`, @Levi runs `/identify-sound-assets`, then @Elk runs `/create-backlog` to populate today's tasks."

## Common Pitfalls

1. **Trying to manage the backlog.** This skill produces a report, not a backlog. Point the user to `/create-backlog` for task management.
2. **Not checking prerequisites.** If core files are missing, the skill should redirect, not proceed with incomplete context.
3. **Vague priorities.** "Work on combat" is not a plan. Be specific: "Implement enemy patrol behavior for the forest level."
4. **Skipping document consistency checks.** Decisions made during the daily can ripple into the game concept, roadmap, or glossary. Check for conflicts.
5. **Not dating the report.** The filename must include the date. These accumulate over the sprint.

## Verification Checklist

- [ ] Prerequisite files confirmed (project-state, roadmap, backlog)
- [ ] Previous daily report reviewed for carry-over context
- [ ] Blockers identified and documented
- [ ] Today's top 3 priorities confirmed with user
- [ ] New decisions recorded in decisions.md
- [ ] Document consistency checked (game-concept, roadmap, glossary)
- [ ] Senior reviews completed
- [ ] Output written to `.docs/daily_<date>.md`
- [ ] All template sections filled
- [ ] Next step reminder included
