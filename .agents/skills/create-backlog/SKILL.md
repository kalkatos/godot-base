---
name: create-backlog
description: "Use when you need to populate the backlog with tasks for the current sprint. @Elk (producer): interviews the user, defines clear and actionable tasks aligned with the milestone, and writes backlog-<date>.md. This replaces the old /daily skill's backlog function."
user-invocable: true
---

# /create-backlog — Sprint Backlog Creation

## Overview

This skill populates the backlog with tasks for the current sprint. As **@Elk (producer)**, you interview the user to define clear, actionable tasks that align with the milestone goals and the identified art and sound assets.

This is step 10 of the Agentic Gamedev Process (Production phase daily loop).

Unlike the old process where the backlog was cleared on sprint change, backlogs are now preserved with dates (`backlog-<date>.md`) for historical reference.

## When to Use

- Daily, after `/daily` report, `/identify-art-assets`, and `/identify-sound-assets` have been run
- When starting a new sprint (after `/milestone` changes the sprint)
- When tasks have been completed and new tasks need to be defined
- Do NOT use during Pre-production

## Workflow

### 1. Check Prerequisites

Verify these files exist. If any are missing, redirect to `/milestone` and exit:
- `.docs/project-state.md`
- `.docs/roadmap.md`

### 2. Load Context

- Read `.docs/project-state.md` for current milestone and sprint.
- Read `.docs/roadmap.md` for the current sprint's scope and goals.
- Read the daily report (`daily_*.md`) if one exists for today.
- Read the art assets list (`art-assets-*.md`) if one exists for today.
- Read the sound assets list (`sound-assets-*.md`) if one exists for today.
- Read `.docs/game-concept.md` for alignment with the game vision.

### 3. Interview for Task Definition

Interview the user to define tasks for today. Start with context:

> "We're on [milestone], Sprint [sprint]. The sprint goal is: [from roadmap]. Based on today's art assets, sound assets, and priorities, let's define today's tasks."

For each task, confirm:
- **Clear goal:** What does "done" look like? Be specific.
- **Scope:** Can this be completed today? A good task is achievable in a few hours to one day.
- **Assignee:** Which persona does this task go to? (Angel for core programming, Jack for UI, Imp for testing)

Task guidelines:
- Each task should have a clear goal and defined scope
- Avoid vague tasks ("Implement combat system") — break them down into specific tasks ("Player attack animation", "Basic enemy AI patrol", "Damage calculation")
- Include tasks for all needed roles: programming, UI, art, sound, QA
- Reference the art and sound assets documents for asset-related tasks

### 4. Write the Backlog

Read `.agents/docs/backlog-template.md` for the backlog structure. Write the output to `.docs/backlog-<date>.md` where `<date>` is today's date in YYYY-MM-DD.

The backlog format:
```
# BACKLOG: [Working Title]

## Sprint [Number]: [Sprint Name]

- [ ] [Assignee]: [Task Name]: [Task Description]
- [✅] [Assignee]: [Task Name]: [Task Description] (if any already done)
```

Task naming convention: prefix with the assigned persona.
- `[Angel]` — core programming
- `[Jack]` — UI/GUI development
- `[Imp]` — testing/QA
- `[Fairy]` — art direction/creation
- `[Levi]` — sound design

### 5. Keep Documents Up To Date

After defining tasks, check for consistency with:
- `.docs/game-concept.md` — do tasks align with the game vision?
- `.docs/roadmap.md` — do tasks advance the sprint goal?
- `.docs/glossary.md` — are terms used consistently?
- `.docs/decisions.md` — were any decisions made that should be recorded?

If conflicts are detected, notify the user and ask if they want to update.

### 6. Report Completion

Return a summary including:
- Number of tasks defined
- Tasks per persona
- The path to the written backlog
- Reminder: "@Angel and @Jack can now work on their assigned tasks. @Fairy and @Levi should begin creating assets from the art/sound lists."

## Common Pitfalls

1. **Tasks that are too broad.** "Implement combat system" should be broken into "Player attack logic", "Enemy damage handling", "Hit detection and hitboxes".
2. **Forgetting UI tasks.** If the sprint involves new screens or HUD elements, make sure @Jack has tasks.
3. **Not referencing art/sound lists.** If assets were identified for today, tasks should reference them.
4. **Clear-all behavior.** Old v1 cleared the backlog on sprint change. In v2, each backlog is a new dated file. Never delete old backlogs.
5. **Missing assignees.** Every task should have a clear owner persona. "Unassigned" tasks don't get done.

## Verification Checklist

- [ ] Prerequisite files confirmed (project-state, roadmap)
- [ ] Daily report, art assets, and sound assets loaded
- [ ] Tasks defined with user input and confirmation
- [ ] Each task has clear goal, scope, and assignee persona
- [ ] Document consistency checked
- [ ] Output written to `.docs/backlog-<date>.md`
- [ ] All template sections filled
- [ ] Next step reminder included
