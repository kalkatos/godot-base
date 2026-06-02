---
name: identify-art-assets
description: "Use when you need to list the art assets required for the current sprint. @Fairy (art director): reads the backlog and game concept, identifies all visual assets needed, and writes art-assets-<date>.md with detailed descriptions and references."
user-invocable: true
---

# /identify-art-assets — Art Asset Identification

## Overview

This skill identifies all art assets needed for the current day's work. As **@Fairy (art director)**, you review the backlog and game concept to determine what visual assets are required, write detailed descriptions for each, and flag which can be created as placeholders with `/create-placeholder`.

This is step 8 of the Agentic Gamedev Process (Production phase daily loop).

## When to Use

- Daily, after the `/daily` report and `/create-backlog` have been run
- When starting a new sprint that requires new visual assets
- Do NOT use without an active backlog — you need to know what tasks need art

## Workflow

### 1. Load Context

- Read `.docs/project-state.md` to get the current milestone and sprint.
- Read the most recent backlog: `.docs/backlog-*.md` (find by glob, pick the newest).
- Read `.docs/game-concept.md` for visual style references and player fantasy context.
- Read `.docs/roadmap.md` for the current sprint's scope and goals.
- If a visual style guide or art bible exists, load it.

### 2. Scan Backlog for Art Dependencies

Go through each task in the current backlog and identify what art assets each task requires. Consider:

- **New characters or enemies:** Sprites, animations, portraits
- **New environments:** Tilesets, backgrounds, props
- **UI elements:** Icons, buttons, panels, HUD elements, menus
- **Effects:** Particles, VFX sprites, screen effects
- **Items/objects:** Pickup sprites, inventory icons, equipment visuals

### 3. List and Describe Each Asset

For each identified asset, write a detailed description including:

- **Type:** Character sprite / Environment tile / UI element / Effect / Icon / Other
- **Dimensions:** Exact or recommended pixel dimensions
- **Visual description:** Colors, mood, level of detail, key visual characteristics
- **References:** Similar assets from other games, concept art, or style references
- **Technical requirements:** Sprite sheet layout, atlas needs, file format, naming convention

### 4. Flag Placeholder Candidates

For assets that are needed immediately but final art will take time, identify which can be created as placeholders using `/create-placeholder`. Note the exact command to use.

### 5. Senior Review — @Kavu

Perform a senior art director review. Evaluate:

- **Consistency:** Do all assets align with the game's visual style and each other?
- **Completeness:** Are any assets missing that the sprint tasks will need?
- **Scope:** Is the list feasible for one day's art direction?
- **Quality of descriptions:** Are descriptions specific enough for an artist to work from?

Present the feedback to the user and incorporate their decisions.

### 6. Write the Document

Read the template at `.agents/docs/templates/art-assets-template.md` and fill in every section. Write to `.docs/art-assets-<date>.md` where `<date>` is today's date in YYYY-MM-DD.

### 7. Report Completion

Return a summary including:
- Number of assets identified
- Number flagged for placeholder creation
- The path to the written document
- If placeholders are needed, the `/create-placeholder` commands to run

## Common Pitfalls

1. **Listing assets without checking the backlog.** Only list assets that are needed for TODAY'S tasks. Future assets can wait.
2. **Vague descriptions.** "A cool sword" is useless. "A broadsword with a rusted iron blade, leather-wrapped hilt, and a faint blue glow along the edge — 32x32 pixels, 4-frame swing animation" is useful.
3. **Forgetting UI assets.** UI is easy to overlook but is often the most asset-heavy part of a sprint.
4. **No references.** Every asset description should include at least one reference — another game, a real-world object, a mood descriptor.
5. **Not flagging placeholders.** If an asset is needed today but final art isn't ready, flag it for placeholder creation or the programmer will be blocked.

## Verification Checklist

- [ ] Project state, backlog, and game concept loaded
- [ ] All art dependencies extracted from backlog tasks
- [ ] Each asset has type, dimensions, description, references, and technical notes
- [ ] Placeholder candidates flagged with exact commands
- [ ] @Kavu review completed and feedback incorporated
- [ ] Output written to `.docs/art-assets-<date>.md`
- [ ] All template sections filled
