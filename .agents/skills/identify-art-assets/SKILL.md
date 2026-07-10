---
name: identify-art-assets
description: "Use when the current sprint includes visual deliverables and you need to list the art assets required. @Fairy (art director): reads the daily report and game concept, identifies all visual assets needed, and appends them to the monolithic .docs/art-assets.md with detailed final descriptions. Only runs when the sprint has visual scope — skip entirely for headless/backend sprints."
version: 2.3.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, production, art, assets]
    related_skills: [daily, create-placeholder, identify-sound-assets]
---

# /identify-art-assets — Art Asset Identification

## Overview

This skill identifies all art assets needed for the current day's work. As **@Fairy (art director)**, you review the daily report and game concept to determine what visual assets are required, write detailed final descriptions for each, and append them to the master `.docs/art-assets.md` file — the canonical, monolithic art asset inventory for the entire game.

This is step 6 of the Dian Agentic Gamedev Process (Production phase daily loop).

**⚠️ Conditional gate:** This skill runs ONLY when the current sprint includes visual deliverables. If the sprint is purely backend/headless (e.g., Combat Simulator, data pipeline), skip this step entirely — the daily report will note that no art assets are needed today.

## When to Use

- When the current sprint includes visual deliverables, after the `/daily` report has been run
- When starting a new sprint that requires new visual assets
- Do NOT use for headless/backend sprints with no visual scope
- Do NOT use without a daily report — you need to know what tasks need art

## Workflow

### 1. Load Context

- Read `.docs/project-state.md` to get the current milestone and sprint.
- Read the most recent daily report: `.docs/daily_*.md` (find by glob, pick the newest). Daily files use sprint-day naming (e.g., `daily_v1.1.1.md`).
- Read `.docs/game-concept.md` for visual style references and player fantasy context.
- Read `.docs/roadmap.md` for the current sprint's scope and goals.
- If a visual style guide or art bible exists, load it.

### 2. Scan Daily for Art Dependencies

Go through each task in the current daily report and identify what art assets each task requires. Consider:

- **New characters or enemies:** Sprites, animations, portraits
- **New environments:** Tilesets, backgrounds, props
- **UI elements:** Icons, buttons, panels, HUD elements, menus
- **Effects:** Particles, VFX sprites, screen effects
- **Items/objects:** Pickup sprites, inventory icons, equipment visuals

### 3. Describe Each Asset (5 fields)

For each identified asset, write exactly 5 fields. The **Description** is the final, shipped-game description — not a placeholder. Write as if briefing a concept artist or 3D modeler.

- **Type:** Character sprite / Environment tile / UI element / Effect / Icon / Other
- **Dimensions:** Exact or recommended pixel dimensions (e.g., 128×128, 64×64)
- **Description:** A detailed, narrative description of what the FINAL polished asset will depict. Include: composition, key visual elements, lighting/mood, color harmonies, texture/material detail, animation/motion characteristics, and how it integrates into the broader visual style. Be specific enough that an artist could paint it or a modeler could build it from this alone.
- **References:** Similar assets from other games, concept art, real-world objects, or mood descriptors
- **Technical notes:** Sprite sheet layout, atlas needs, file format, naming convention, engine-specific constraints

### 4. Senior Review — @Kavu

Perform a senior art director review. Evaluate:

- **Consistency:** Do all assets align with the game's visual style and each other?
- **Completeness:** Are any assets missing that the sprint tasks will need?
- **Scope:** Is the list feasible for one day's art direction?
- **Quality of descriptions:** Are descriptions specific enough for an artist to work from?

Present the feedback to the user and incorporate their decisions.

### 5. Write to `.docs/art-assets.md`

This is the **canonical, monolithic** art asset file — every asset across all sprints lives here.

1. **Check if `.docs/art-assets.md` exists.** If not, create it from the template (`templates/art-assets-template.md`), which includes the asset categories (Character Sprites, Environments, UI, Effects, Items/Objects, Other) and the `## Latest` section.
2. **Append new assets** under the `## Latest` heading. Sort each asset into the appropriate category section.
3. **Each asset** uses the 5-field format from step 3 and the template.
4. **Do NOT create per-day files** (no `art-assets-<sprint>.<day>.md`). Everything goes into the single `.docs/art-assets.md`.
5. After writing, assets in `## Latest` should eventually be moved by a human curator into their permanent category section below — but for now, the `## Latest` section serves as the inbox.

**⚠️ Branch selection:** The art-assets document must be committed to the **same branch as the art task**, NOT the shared programming branch. Check the daily report — each art task specifies its branch at the end (e.g., "Work on branch: `day/v1.2.2/art`"). If the art task has a dedicated branch (typically `<sprint>/art`), check it out in the Fairy worktree (`/workspace/_projects/mahou/fairy/`), write the document there, and commit. Do NOT commit art-assets changes to the main worktree's `prog` branch.

### 6. Report Completion

Return a summary including:
- Number of assets identified
- The path to the written document (`.docs/art-assets.md`)
- If any assets require immediate placeholders for the current sprint, note the `/create-placeholder` commands to run separately

## Common Pitfalls

1. **Listing assets without checking the backlog.** Only list assets that are needed for TODAY'S tasks. Future assets can wait.
2. **Writing placeholder descriptions instead of final descriptions.** The `Description` field is the final shipped-game description. There is no separate placeholder description here — placeholders are handled by `/create-placeholder` as a separate step.
3. **Vague descriptions.** "A beautiful enchanted forest" is useless. "A clearing in an ancient forest at twilight — massive oak trees with bioluminescent moss frame the scene, soft blue-green glow from mushroom clusters at the base, firefly particles drifting upward, a stone altar at the focal point with carved runes catching the bioluminescent light" is useful.
4. **Forgetting UI assets.** UI is easy to overlook but is often the most asset-heavy part of a sprint.
5. **No references.** Every asset description should include at least one reference — another game, a real-world object, a mood descriptor.
6. **Creating per-day files.** Do NOT create `art-assets-<sprint>.<day>.md` files. All assets go into the single monolithic `.docs/art-assets.md`.
7. **Committing to the wrong branch.** Art-assets changes belong on the art task's branch (e.g., `day/v1.2.2/art`), NOT the shared programming branch (`day/v1.2.2/prog`). The daily report specifies each task's branch — find the art task (usually Fairy's) and use its branch. Write in the Fairy worktree at `/workspace/_projects/mahou/fairy/`, not the main worktree, when the target branch is a task-specific art branch.

## Support Files

- `templates/art-assets-template.md` — The art assets output template. Reference when writing the document in step 6.

## Verification Checklist

- [ ] Project state, backlog, and game concept loaded
- [ ] All art dependencies extracted from backlog tasks
- [ ] Each asset has exactly 5 fields: Type, Dimensions, Description (final, shipped-game quality), References, Technical notes
- [ ] Descriptions are detailed enough for a concept artist to work from (composition, lighting, color, texture, animation, integration)
- [ ] @Kavu review completed and feedback incorporated
- [ ] Output appended to `.docs/art-assets.md` (monolithic file, NOT a per-day file)
- [ ] Assets sorted into correct category sections under `## Latest`
- [ ] Committed to the correct art task branch (not the `prog` branch)
