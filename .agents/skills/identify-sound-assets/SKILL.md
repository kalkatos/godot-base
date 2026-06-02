---
name: identify-sound-assets
description: "Use when you need to list the sound assets required for the current sprint. @Levi (sound designer): reads the backlog and game concept, identifies all audio assets needed, and writes sound-assets-<date>.md with detailed descriptions and references."
user-invocable: true
---

# /identify-sound-assets — Sound Asset Identification

## Overview

This skill identifies all sound assets needed for the current day's work. As **@Levi (sound designer)**, you review the backlog and game concept to determine what audio assets are required — sound effects, music, and ambience — and write detailed descriptions for each.

This is step 9 of the Agentic Gamedev Process (Production phase daily loop).

## When to Use

- Daily, after the `/daily` report and `/create-backlog` have been run
- When starting a new sprint that introduces new player actions, enemies, or environments requiring audio
- Do NOT use without an active backlog

## Workflow

### 1. Load Context

- Read `.docs/project-state.md` to get the current milestone and sprint.
- Read the most recent backlog: `.docs/backlog-*.md` (find by glob, pick the newest).
- Read `.docs/game-concept.md` for mood, tone, and player fantasy context.
- Read `.docs/roadmap.md` for the current sprint's scope.

### 2. Scan Backlog for Audio Dependencies

Go through each task in the current backlog and identify what audio each task requires. Consider:

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

Read the template at `.agents/docs/templates/sound-assets-template.md` and fill in every section. Write to `.docs/sound-assets-<date>.md` where `<date>` is today's date in YYYY-MM-DD.

There is no senior review for sound assets (the process doesn't specify one), but use your best judgment as @Levi to ensure quality and completeness.

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

## Verification Checklist

- [ ] Project state, backlog, and game concept loaded
- [ ] All audio dependencies extracted from backlog tasks
- [ ] Each asset has category, description, references, and technical notes
- [ ] SFX, music, and ambience sections all considered (even if some are empty)
- [ ] Output written to `.docs/sound-assets-<date>.md`
- [ ] All template sections filled
