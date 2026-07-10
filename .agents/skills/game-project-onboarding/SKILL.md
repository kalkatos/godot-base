---
name: game-project-onboarding
description: >-
  Onboard to a new or existing game development project as the game design
  guardian. Assess project structure, check for required design documents,
  verify agent workflow conventions, and report a clear summary of what
  exists and what's missing.
trigger:
  - User says "let's onboard", "set up the project", "check out the repo"
  - A new game repository is provided or cloned
  - First session with an unfamiliar game project
---

# Game Project Onboarding

## Goal

Get a complete understanding of a game project's structure, design docs, and
agent conventions in one pass, then report a clear summary to the user so they
know exactly where things stand.

## Discovery Steps

### 1. Read the project's AGENTS.md (if it exists)
This is the single most important file. It defines:
- Project root paths (Godot project root, code directories, asset directories)
- Required design documents (game-concept.md, roadmap.md, backlog.md, etc.)
- Agent rules and conventions
- Testing setup and commands
- Naming conventions and glossary links

### 2. Check the project-state.md
Look in the project's docs directory (often `.docs/` or `docs/`). This file
records the current milestone and sprint. If it says "Undefined", flag this.

### 3. Audit the required design documents
Cross-reference what AGENTS.md says against what actually exists on disk.
Typical required docs (from the Mahou template):

| Document | Purpose |
|----------|---------|
| game-concept.md | Elevator pitch, player fantasy, core mechanics, unique features |
| premise.md / premisse.md | Detailed design premise and variable definitions |
| glossary.md | Ubiquitous language for the project |
| roadmap.md | Milestones, sprints, and phase definitions |
| backlog.md | Current sprint task list |
| decisions.md | Record of key design decisions |

Flag any missing docs and note what they should contain.

### 4. Read the existing design docs (premise, glossary, decisions)
These tell you what the game actually is. Extract:
- **Core premise**: genre, platform, player fantasy
- **Core mechanics**: what the player does, how combat/actions work
- **Key systems**: characters, spells, items, progression
- **Design variables**: constants, ranges, limits
- **Decisions already made** (or noting none recorded yet)

### 5. Assess project state
Report:
- **Current milestone/sprint** (from project-state.md)
- **Docs that exist** (summarize their content)
- **Docs that are missing** (note what they should contain)
- **Code that exists** (check src/ if applicable — not in scope here, but note that user can explore separately)
- **Testing setup** (if AGENTS.md describes it)

## Output Format

Report to the user in this structure:

```
**✅ [Project Name]** cloned/loaded at [path].

**Existing docs:**
- doc1.md — summary of content
- doc2.md — summary of content

**⚠️ Missing:**
- doc3.md — what it should contain

**Current Milestone:** [value or Undefined]
```

Then offer 3–4 options for next steps (e.g. define game concept, set up
roadmap, explore code, log design decisions).

## Pitfalls

- Don't assume `game-concept.md` exists even if AGENTS.md says to create it
  later. Some projects use a different name (e.g. `premisse.md`).
- If AGENTS.md references a `game-concept.md` but only `premisse.md` exists,
  note the discrepancy — the user may want to consolidate or rename.
- The glossary may have system terms (Sprint, Milestone, Interview) already
  defined but empty project-specific terms. Flag this.
- `.gitconfig` may use a credential helper that expects `$GITHUB_TOKEN`. Source
  `~/.hermes/.env` to make it available when pulling/cloning.
- If `decisions.md` is only a template (no actual decisions recorded), flag it.
