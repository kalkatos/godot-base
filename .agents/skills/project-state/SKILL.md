---
name: project-state
description: Quick status check for any agent. Reads the project's .docs/ to report current milestone, sprint, and what the project is about. Use when an agent needs context before starting work.
---

# /project-state — Project Status Check

A lightweight skill any agent can run to understand where a project stands. No kanban, no delegation — just reads the project docs and reports.

## When to Load

- An agent picks up a kanban task and needs context on the project
- Before starting any implementation work — "what am I building and why?"
- User asks "what's the state of Project X?"
- As the first step in `/daily` or `/orchestrate`

## Workflow

### 1. Locate the Project

Check the project's `.docs/` folder. If multiple projects exist, determine which one is being worked on from the kanban task or user context.

### 2. Read the Key Files

Read in this order:

1. **`.docs/project-state.md`** — milestone and sprint
2. **`.docs/roadmap.md`** — full roadmap, find the WE ARE HERE marker
3. **`.docs/game-concept.md`** — what the game is (first paragraph is usually enough for context)
4. **`.docs/decisions.md`** — recent decisions that might affect the work (last 5 entries)

### 3. Report

Produce a concise status block:

```
## Project: <name>

**Phase:** Pre-production / Production
**Milestone:** <milestone-name>
**Sprint:** <sprint-name>
**Concept:** <one-line summary from game-concept.md>

### Current Sprint Goal
<from roadmap.md sprint description>

### Recent Decisions
- <last 3 decisions, one line each>
```

### 4. What's Missing?

Flag any missing core documents:
- No `.docs/project-state.md` — project hasn't been set up yet
- No `.docs/game-concept.md` — game concept not defined
- No `.docs/roadmap.md` — no milestones planned
- No `.docs/decisions.md` — no decisions tracked (create it empty)

## Pitfalls

- **Don't assume the project name.** Read it from the folder or AGENTS.md.
- **Don't skip the decisions file.** A recent decision might contradict what you're about to build.
- **WE ARE HERE might be stale.** If the roadmap marker doesn't match project-state.md, trust project-state.md and flag the discrepancy.
- **Game concept is for context only.** Don't redesign the game based on reading the concept — stick to your assigned task.
