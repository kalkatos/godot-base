# Agentic Gamedev Process — Process Overview

Reference document for the Dian Agentic Gamedev Process. **The authoritative source is `/workspace/_main/PROCESS.md`** — always read it fresh. This document is a summary only and may be stale.

---

## Two Phases

### Pre-production (steps 1-5)
Define the concept, validate risks via prototypes. No code committed to the main branch.

### Production (steps 6+)
Build the game in milestone-based sprints with daily check-ins. Code is committed and PR'd.

---

## Persona → Role → Skill Mapping

| Persona | Role | Invokes |
|---------|------|---------|
| @Dino | Marketer | `/do-market-research` |
| @Capy | Game Designer | `/generate-pitch`, `/start`, `/analyze-risks` |
| @Brute | Prototyper | `/prototype` |
| @Elk | Producer | `/milestone`, `/daily` |
| @Fairy | Art Director | `/identify-art-assets` (conditional — visual deliverables only) |
| @Levi | Sound Designer | `/identify-sound-assets` (conditional — audio deliverables only) |
| @Angel | Programmer | (kanban tasks from daily backlog) |
| @Jack | GUI Developer | (kanban tasks from daily backlog) |
| @Imp | QA | (writes tests, reviews code) |
| @Griffin | Sr. Programmer | (reviews code, milestones, daily) |
| @Hag | Sr. Game Designer | (reviews concept, risks, milestones, daily) |
| @Kavu | Sr. Art Director | (reviews art assets) |

---

## Pre-production Flow

```
@Dino: /do-market-research
    → market-research-<desc>-<date>.md
       |
@Capy: /generate-pitch
    → pitch.md  (senior review: @Hag)
       |
@Capy: /start
    → game-concept.md  (senior review: @Hag)
       |
@Capy: /analyze-risks
    → risks.md  (senior review: @Hag)
       |
@Brute: /prototype (×N, one per risk)
    → REPORT.md + playable build
       (reviews: @Griffin + @Hag)
       |
    [All risks validated] → Production
```

---

## Production Flow

### Start of Each Milestone

```
@Elk: /milestone
    → roadmap.md updated (sprints defined, marker moved)
       (reviews: @Griffin + @Hag)
    → milestone-memo-<milestone>-<date>.md
```

### Daily Loop

```
@Elk: /daily
    → daily_<sprint>.<day>.md  (includes backlog with task assignments)
       (reviews: @Griffin + @Hag)
       (after approval: dispatch tasks via kanban)

@Fairy: /identify-art-assets (only if sprint has visual deliverables)
    → art-assets-<date>.md  (reviews: @Kavu)

@Levi: /identify-sound-assets (only if sprint has audio deliverables)
    → sound-assets-<date>.md

@Jack: GUI work  (from kanban tasks, with /create-placeholder for placeholders)
@Angel: Code work  (from kanban tasks, with /create-placeholder for placeholders)
@Imp: Tests for Angel's code  (review: @Griffin)
```

**PR Policy:** Production phase creates actual GitHub PRs. Every step that creates output goes through PR → senior review → user approval before the chain advances.

---

## Output Documents

| Document | Created By | When |
|----------|-----------|------|
| `market-research-<desc>-<date>.md` | `/do-market-research` | Pre-prod step 1 |
| `pitch.md` | `/generate-pitch` | Pre-prod step 2 |
| `game-concept.md` | `/start` | Pre-prod step 3 |
| `risks.md` | `/analyze-risks` | Pre-prod step 4 |
| `prototypes/<name>/REPORT.md` | `/prototype` | Pre-prod step 5 |
| `roadmap.md` | `/milestone` | Start of each milestone |
| `milestone-memo-<milestone>-<date>.md` | `/milestone` | Start of each milestone |
| `daily_<sprint>.<day>.md` | `/daily` | Daily (includes backlog) |
| `art-assets-<date>.md` | `/identify-art-assets` | Daily (conditional) |
| `sound-assets-<date>.md` | `/identify-sound-assets` | Daily (conditional) |

---

## Key v2 Design Decisions

### Why /daily includes the backlog
The daily check-in and task planning are a single conversation — separating them adds friction. The daily report now includes the backlog with assigned tasks. After PR approval, Elk dispatches directly via kanban.

### Why daily naming follows sprint+day convention
Each day's report is named `daily_<sprint>.<day>.md` (e.g. `daily_v1.1.1.md`). This gives a complete audit trail of what was planned vs what was done, grouped by sprint.

### Why personas are not separate profiles
Personas are roles the skill instructions reference. The user (Alex) runs each skill and the skill's text adopts that persona's perspective.

### Why PRs only in Production
In pre-production, the output is documents and throwaway prototypes — not code that goes into the main branch. In production, code changes need review for quality and consistency.

### Kanban is the coordination mechanism
Elk dispatches tasks to agents via `hermes kanban create`. Each agent profile picks up their assigned tasks through the kanban gateway. No file-based handoff.
