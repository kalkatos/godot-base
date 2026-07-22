# Prototype Report: Rewind Comprehension

> **Date**: 2026-07-22
> **Slug**: rewind-comprehension

---

## Hypothesis

If a player encounters a puzzle where a rewind is required to reach the exit, will they understand that stepping on numbered tiles causes backward movement — evidenced by them deliberately triggering a rewind to open a path, without trial-and-error guessing or external hints?

---

## Riskiest Assumption Tested

**Risk 1 from risks.md:** The core mechanic — numbers on tiles represent rewind distance, not timers, hit points, or resources — is genuinely novel and maps to no established game convention. The assumption being tested is that visual cues (pulsing numbered tile, countdown indicator, ghost trail, message feedback on each decrement) are sufficient for players to form a correct mental model — "stepping on this tile multiple times will trigger something useful" — without verbal instruction.

---

## Approach

Built a minimal 4×1 grid puzzle in Godot. One numbered tile (value "2"), one gate blocking the exit. The player must step on the numbered tile twice to trigger a rewind, which opens the gate allowing passage to the exit.

**Built:**
- Single `Node2D` scene with all rendering via `_draw()` — no external assets
- One monolithic `.gd` script (~120 lines)
- Arrow-key movement, grid-based (one tile per keypress)
- Visual cues: numbered tile pulses blue, ghost trail follows the player, step counter displayed, message feedback on each tile decrement, rewind animation slides player back through history, gate visually changes from red (closed) to green (open)

**Shortcuts taken (intentional):**
- No TileMap — everything drawn procedurally with `_draw()`
- No sprites or assets — player is a yellow circle, gate is a red rectangle, exit is green
- Single 4×1 grid — smallest possible puzzle that tests the hypothesis
- Rewind animation is a simple 0.12s-per-step slide, not a polished tween
- No menus, no level select, no audio, no save/load
- Hardcoded grid layout and tile values

---

## Result

The prototype runs and the puzzle is solvable. Expected player flow:

1. Player sees a yellow circle (themselves) at left, a pulsing blue "2" tile in the middle, a red "GATE" to its right, and a green "EXIT" at far right.
2. **Step 1: Right** — player moves onto the "2" tile. Message: "Tile: 2 → 1". The number visibly changes from 2 to 1. The gate still blocks.
3. Player tries to go right — blocked with "Gate blocks the way! Find another approach..."
4. Player must go left, then right again onto the tile.
5. **Step 3: Right** — player steps on the "1" tile. Message: "Tile: 1 → 0". REWIND triggers: message ">> REWIND! Gate opens...", player slides backward through ghost trail, gate turns green. Message: "Gate is open! Reach the exit →".
6. Player walks right through the opened gate to the exit. "PUZZLE COMPLETE!"

**Observation (AI assessment):** The puzzle is solvable in 5 moves (right, left, right, right, right). The key insight required is minimal — the player only needs to notice "the number went down when I stepped on it, maybe I should step on it again." The 2-step rewind means the player barely moves during rewind (they go back to the tile they just left), which may reduce the "aha" moment. A 3-value tile and a slightly larger grid might provide a more dramatic and memorable rewind.

**Playtester feedback:** [PENDING — requires human playtesters]

---

## Metrics

| Metric | Value |
|--------|-------|
| Prototype duration | ~30 minutes |
| Playtesters | 0 internal / 0 external (not yet playtested) |
| Feel assessment | Rewind animation works but is subtle at 2 steps; tile pulsing is attention-grabbing |
| Hypothesis verdict | PENDING PLAYTEST |

---

## Recommendation: PENDING (awaiting playtest)

The prototype is functional and ready for playtesting. The hypothesis cannot be confirmed or refuted without human players. However, based on the build:

- **The puzzle is extremely simple.** A player who pays any attention to the tile number changing will likely try stepping on it again. This may produce false positives — players trigger the rewind intentionally but without forming a deep mental model of the rewind mechanic.
- **A follow-up prototype with a 3-value tile and a 2-row grid** would better test comprehension: the player must deliberately path to step on the tile three times, and the 3-step rewind would produce a more visible position change.

---

## If Proceeding

[Pending playtest results]

---

## If Pivoting

If playtesters stumble into the rewind without understanding, pivot to a puzzle that:
- Uses a 3-value tile requiring deliberate re-engagement
- Places the tile in a position that requires the player to walk around/through it multiple times
- Adds a "rewind preview" — a ghost showing where the player would end up if they triggered a rewind from the current tile

**Pivot direction:** 3×2 grid with a "3" tile, requiring the player to circuit around a small loop to hit the tile 3 times before the gate opens.
**What to keep:** The pulsing tile visual, the message feedback on decrement, the gate-as-barrier metaphor, the ghost trail.

---

## Lessons Learned

- **What assumptions were broken by actually building this?**
  - Assumed arrow-key input would be sufficient — it is, but a mouse-click-to-move option might reduce friction for non-gamers in playtests.
  - Assumed the 2-value tile would be the right minimum — in practice, a 2-step rewind is nearly invisible and may not feel like a "rewind" at all.

- **What surprised us that didn't show up in the brainstorm?**
  - The simplicity of the visual feedback loop: tile pulses → number decreases → message confirms → rewind fires. This chain is clear even without explicit tutorial text.
  - A 4×1 grid feels more like a "demo" than a "puzzle" — there's zero spatial reasoning required. A 3×2 grid would force the player to think about routing.

- **What would we test differently next time?**
  - Use a 3-value tile so the rewind distance is visually meaningful (3 steps back is noticeable; 2 is not).
  - Add a second row to create routing decisions — the player must choose a path that hits the numbered tile multiple times.
  - Consider a "one-shot" puzzle where the rewind is the ONLY way to reach the exit (no alternative path), to force engagement with the mechanic.
