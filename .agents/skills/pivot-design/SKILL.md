---
name: pivot-design
description: Pivot a game concept to a new design direction — changing genre, player fantasy, core mechanics, and propagating term changes to the glossary. Record the pivot as a decision. Use when user invokes /pivot-design or explicitly asks to pivot/redesign/reorient the game concept.
---

# Pivot Design

Interview the user section-by-section through the game-concept.md, gather the new direction, apply changes incrementally, and propagate stale terms to the glossary.

## Quick start

1. Verify `.docs/game-concept.md` exists. If not, stop — this skill pivots, it does not create.
2. Interview the user through each section of the concept (see [Interview flow](#interview-flow)).
3. After each section is resolved, apply changes to `game-concept.md` immediately.
4. After all concept sections are updated, scan for stale glossary terms and propagate.
5. Record the pivot as a decision in `.docs/decisions.md`.

## Interview flow

Ask questions one at a time, one section at a time. For each question, provide a recommended answer based on what's already been decided. Do not move to the next section until the current one is resolved.

### Section order

1. **Direction summary** — ask the user for a freeform description of the new direction. What's the big change? This sets context for the rest of the interview.

2. **Game Identity** — new genre? new perspective? new platform? Recommend keeping what still fits, changing what doesn't.

3. **Player Fantasy** — who does the player feel like now? What fantasy does the new design deliver?

4. **Core Mechanics** — what are the new verbs? What mechanics from the old design are being replaced? For each old mechanic that goes away, what replaces it?

5. **Core Loop** — walk through the new moment-to-moment cycle. How does it differ from the old loop?

6. **Unique Features** — what makes this new direction stand out? Which old unique features survive the pivot?

7. **References** — what games/inspirations now inform this design? Which old references are still relevant?

8. **Further Notes** — tone, pacing, meta-progression, simulation model. What changes?

### After each section

Apply the changes to `game-concept.md` immediately using `replace_string_in_file`. Do not batch — capture decisions as they crystallize.

## Glossary propagation

After all concept sections are updated:

1. **Scan the new concept** for domain terms not yet in the glossary. Propose definitions for each.
2. **Scan the glossary** for terms whose definitions reference mechanics or concepts that no longer exist in the pivoted concept. Flag each as potentially stale.
3. **For each stale term**, propose one of:
   - **Remove** — the term is no longer relevant (e.g., "Tactic Card" after pivoting away from deckbuilding).
   - **Redefine** — the term name still works but its definition is now wrong (e.g., "State Machine" changing from animation system to core mechanic).
   - **Replace** — the concept still matters but needs a new canonical name (e.g., "Scouting" → "Recon").
4. **For each new term**, add it to the glossary with a definition, examples, and a `_NOT_` list.
5. Apply glossary changes incrementally as each term is resolved.

### Conflict resolution

When a new term conflicts with an existing glossary definition:
- Flag the conflict immediately.
- Propose the new definition as the default.
- Let the user confirm or override.

## Decision record

After all changes are applied, append a decision entry to `.docs/decisions.md`. Create the file from `.agents/docs/decisions-template.md` if it doesn't exist. The entry must include:

- **Decision Name**: "Design Pivot: [brief description of the pivot]"
- **What**: Summary of the old design, what it pivoted to, and which sections changed.
- **Why**: The rationale — why this direction better serves the vision.
- **When**: Current date (YYYY-MM-DD), current milestone and sprint from `roadmap.md` if available.
- **Alternatives Considered**: What other directions were discussed and why they were rejected.

## Rules

- Never modify `.agents/` files other than the skill being created.
- Never modify `src/addons/`.
- Always use terms consistent with the glossary after it's updated.
- The concept document must stay within the template structure — do not add or remove sections.
