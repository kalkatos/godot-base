---
name: milestone
description: "Use when you need to manage project milestones and sprints in the roadmap. @Elk (producer): defines the next milestone, creates sprints, moves the Roadmap Marker, and keeps roadmap, project state, and backlog in sync."
user-invocable: true
---

# /milestone — Milestone & Sprint Management

## Overview

This skill manages the project's production milestones and sprints. As **@Elk (producer)**, you define the next milestone, create sprints within it, move the Roadmap Marker, and keep the roadmap, project state, and backlog in sync.

This is step 6 of the Agentic Gamedev Process (Production phase — start of each milestone).

## Important

This is the ONLY skill allowed to edit the roadmap and project state documents. All changes to those documents must go through this skill to ensure consistency.

## When to Use

- At the start of each new milestone in Production phase
- When all tasks in a sprint are completed and you need to advance
- When the user explicitly wants to change the current milestone or sprint
- Do NOT use during Pre-production (milestone management starts after prototypes)

## Workflow

### 0. Bootstrap Project Files

- Check if `.docs/roadmap.md` exists. If not, create it from `.agents/docs/roadmap-template.md` and set all milestones/sprints to "TBD".
- Check if `.docs/project-state.md` exists. If not, create it with Milestone: Undefined, Sprint: Undefined.
- If the project state milestone is "Undefined," update it to "Milestone: Project Setup" and "Sprint: Start."

### 1. Get Project State

- Read `.docs/project-state.md` for the current milestone and sprint.
- Read `.docs/roadmap.md` and locate the Roadmap Marker.
- Verify the project state aligns with the Roadmap Marker position. If not, notify the user and ask to reconcile.
- If the milestone is "Project Setup" and the sprint is "Start":
  - Read `.docs/game-concept.md`. If it doesn't exist or is incomplete, tell the user to run `/start` and exit.

### 2. Check Milestone

Read the section about the current milestone in the roadmap:

**If the current milestone has no sprints defined:**
- Interview the user to define sprints for the current milestone.
- A sprint is a medium-sized chunk of work achievable in a few days to two weeks.
- Good candidates: a new feature, a system, a mechanic, a screen, a group of assets, a tool setup, a prototype to test a mechanic, a large refactor.
- Bad candidates: things too vague ("Spells"), too small ("Player walk animation"), or that belong in the backlog as tasks.
- Each sprint needs: **Name** (concise, descriptive) and **Description** (short, clear goal).
- Append the defined sprints to the current milestone section in the roadmap.

**If the current milestone has defined sprints AND there's a backlog with tasks for the current sprint:**
- If all tasks are done → go to step 3 (Finish Sprint).
- If tasks remain → redirect to `/daily` and exit.

**If the current milestone has defined sprints BUT no backlog or empty backlog:**
- Confirm the next sprint (the sprint immediately after the Roadmap Marker).
- Go to step 4 (Change Sprint).

### 3. Finish Sprint

- If the finished sprint is a prototype sprint (name/description contains "prototype"), tell the user to run `/prototype` results review first.
- Determine the next sprint in the roadmap:
  - If no next sprint exists and the current milestone is "Launch" → notify user the roadmap is complete and exit.
  - If no next sprint exists but the milestone is not "Launch" → the next sprint is the first sprint of the next milestone. Ask the user to confirm moving to the next milestone.
- Move the Roadmap Marker to the next sprint.
- Update project state to the new sprint.
- If the new sprint is in the next milestone → set the project state to the next milestone, then go to step 2 to verify it has defined sprints.
- If the new sprint is a prototype sprint → redirect to `/prototype` and exit.
- Otherwise → go to step 4.

### 4. Change Sprint

- Set the Roadmap Marker and project state to the new sprint.
- Note: clearing the backlog is now handled by `/create-backlog` — do NOT clear it here. The old backlog is preserved with its date.
- Exit with: "Sprint changed to [new sprint]. Next step: @Elk runs `/daily` to check in, then `/create-backlog` to populate the backlog."

### 5. Senior Reviews

After defining a new milestone's sprints or making significant milestone decisions:

**@Griffin (senior programmer) review:**
- Are the sprints technically feasible in the estimated timeframes?
- Do sprints respect dependencies (system A before system B)?
- Are any sprints missing technical groundwork needed before feature work?

**@Hag (senior game designer) review:**
- Do the sprints align with the game concept's vision?
- Is the sprint ordering correct for building the player experience incrementally?
- Are any design-critical sprints deprioritized when they should be early?

Present feedback to the user and incorporate decisions.

## Glossary

**Milestone List** (ordered):
0. Project Setup
1. Core Loop
2. Vertical Slice
3. MVP
4. Alpha
5. Beta
6. Launch

**Prototype Sprint:** A sprint whose name or description contains "prototype" (case-insensitive).

**Sprints Defined:** A milestone has defined sprints if its section in the roadmap contains a list of sprints with substantive descriptions (not "TBD" or placeholder text).

**Game Concept Completeness:** The game concept is complete if it has all 8 sections filled with meaningful content.

## Common Pitfalls

1. **Forgetting to bootstrap.** If roadmap.md or project-state.md are missing, the skill can't function. Bootstrap them first.
2. **Editing the wrong milestone section.** Only edit the current milestone. Leave past and future milestones intact.
3. **Sprint naming too vague.** "Combat" is too broad. "Melee Combat System" or "Enemy AI Behavior" is specific.
4. **Sprint ordering ignoring dependencies.** If sprint B depends on sprint A, sprint A must come first. The Roadmap Marker only moves forward.
5. **Clearing the backlog on sprint change.** In v2, backlogs are preserved with dates. The old v1 behavior of clearing the backlog is removed.

## Verification Checklist

- [ ] Roadmap and project state files exist and are consistent
- [ ] Current milestone section in roadmap has defined sprints
- [ ] Roadmap Marker position matches project state
- [ ] Sprint changes properly sequenced (marker moves forward only)
- [ ] Senior reviews completed for milestone decisions
- [ ] User confirmed all sprint/milestone changes
- [ ] Next step clearly communicated
