---
name: identify-sound-assets
description: "Use when the current sprint includes audio deliverables and you need to list the sound assets required. @Levi (sound designer): reads the daily report and game concept, identifies all audio assets needed, and writes sound-assets-<date>.md with detailed descriptions and references. Only runs when the sprint has audio scope — skip entirely for headless/backend sprints."
version: 2.1.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, production, audio, assets]
    related_skills: [daily, identify-art-assets]
---

# /identify-sound-assets — Sound Asset Identification

## Overview

This skill identifies all sound assets needed for the current day's work. As **@Levi (sound designer)**, you review the daily report and game concept to determine what audio assets are required — sound effects, music, and ambience — and write detailed descriptions for each.

This is step 9 of the Dian Agentic Gamedev Process (Production phase daily loop).

**⚠️ Conditional gate:** This skill runs ONLY when the current sprint includes audio deliverables. If the sprint is purely backend/headless (e.g., Combat Simulator, data pipeline), skip this step entirely.

**Senior review:** @Levi also reviews sprint-review PRs for the sound design domain per PROCESS.md. For individual daily sound assets, the user reviews and approves directly.

## When to Use

- When the current sprint includes audio deliverables, after the `/daily` report has been run
- When starting a new sprint that introduces new player actions, enemies, or environments requiring audio
- Do NOT use for headless/backend sprints with no audio scope
- Do NOT use without a daily report

## Workflow

### 1. Load Context

- Read `.docs/project-state.md` to get the current milestone and sprint.
- Read the most recent daily report: `.docs/daily_*.md` (find by glob, pick the newest). Daily files use sprint-day naming (e.g., `daily_v1.1.1.md`).
- Read `.docs/game-concept.md` for mood, tone, and player fantasy context.
- Read `.docs/roadmap.md` for the current sprint's scope.

### 2. Scan Daily for Audio Dependencies

Go through each task in the current daily report and identify what audio each task requires. Consider:

- **Player actions:** Jump, attack, interact, walk, run, damage taken, death
- **Enemy/NPC sounds:** Spawn, attack, hurt, death, idle, alert
- **UI sounds:** Button click, menu open/close, notification, purchase, error
- **Environment:** Footsteps per surface type, object interactions, doors, ambient loops
- **Music:** New tracks for specific levels, menus, or game states
- **Ambience:** Background atmosphere for environments being built

### 3. Categorize and Describe

For each sound asset, write a detailed description:

- **SFX:** Category, trigger context, emotional quality (weighty, snappy, eerie, satisfying), duration, reference sounds
- **Music:** Context, mood, tempo, instrumentation, duration, reference tracks
- **Ambience:** Context, environmental elements to include, spatial characteristics, loop requirements

### 4. Write the Document

Read the template at `.agents/docs/templates/sound-assets-template.md` and fill in every section. Write to `.docs/sound-assets-<sprint>.<day>.md` where `<sprint>.<day>` matches the Day field from project-state.md (e.g., `sound-assets-v1.1.1.md`).

There is no senior review for individual daily sound assets (the user reviews and approves directly), but @Levi reviews sprint-review PRs for the sound design domain per PROCESS.md. Use your best judgment as @Levi to ensure quality and completeness.

### 5. Report Completion

Return a summary including:
- Number of SFX, music tracks, and ambiences identified
- The path to the written document
- Any critical audio assets that could block progress if not created promptly

## Common Pitfalls

1. **Only listing obvious SFX.** Think about UI sounds, ambience, and music — these are as important as jump and attack sounds.
2. **No emotional context.** "Sword swing sound" is vague. "A heavy, metallic whoosh with a sharp slice at the end — should feel powerful and dangerous" gives the sound designer something to work with.
3. **Forgetting surface-dependent sounds.** If the player walks on grass, stone, and wood, those need different footstep sounds.
4. **No references.** Every sound should have at least one reference — a game with similar audio, a real-world sound, or a mood adjective.
5. **Listing too many assets for one day.** Be realistic about what a solo dev can create in one day. Prioritize.

## Support Files

- `templates/sound-assets-template.md` — The sound assets output template. Reference when writing the document in step 4.

## Verification Checklist

- [ ] Project state, backlog, and game concept loaded
- [ ] All audio dependencies extracted from backlog tasks
- [ ] Each asset has category, description, references, and technical notes
- [ ] SFX, music, and ambience sections all considered (even if some are empty)
- [ ] Output written to `.docs/sound-assets-<sprint>.<day>.md`
- [ ] All template sections filled
