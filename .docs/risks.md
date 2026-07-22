# RISK ANALYSIS: Count — 2026-07-22

Identified gameplay risks that are unknown or unproven based on the game concept. These risks should be tested with Godot prototypes before committing to full production. Each risk includes a testable question that a prototype can answer.

Keep this document focused — only include risks that can be meaningfully reduced through prototyping.

---

## Risk 1: Player Comprehension of the Rewind Mechanic

**Description:** The core mechanic — numbers on tiles represent rewind distance, not timers, hit points, or resources — is genuinely novel and maps to no established game convention. Players may step on a "3" tile three times, see it hit zero, and watch their character zip backward undoing progress without understanding why it happened or how to use it deliberately. The risk is that players stumble through puzzles via trial-and-error rather than intentional planning, undermining the core fantasy of "outsmarting the board."

**Why it matters:** The entire player fantasy — "feel like a clever time-weaver" — depends on players forming a correct mental model of the rewind mechanic. If players brute-force puzzles without understanding, the game fails at its central promise. Severity: 10/10 — the game lives or dies on player comprehension.

**Prototype question:** If a player encounters a puzzle where a rewind is required to reach the exit, will they understand that stepping on numbered tiles causes backward movement — evidenced by them deliberately triggering a rewind to open a path, without trial-and-error guessing or external hints?

**Success criteria:** In a playtest with 5 fresh players on the first rewind-required puzzle, at least 4 out of 5 trigger the rewind intentionally (not by accident) and can articulate why the character moved backward. Visual cues used: ghost trail retracing the path, tile pulsing on countdown, bouncy rewind animation, and a countdown indicator above the character.

---

## Risk 2: Puzzle Design Depth Within Jam Scope

**Description:** The rewind mechanic — walk forward, trigger rewinds, reshape the board — may have a narrow design space. If every interesting puzzle converges to the same pattern (e.g., "step on tile A to rewind and open gate B"), puzzles will feel repetitive rather than surprising. For a jam-scope target of ~15 puzzles, the risk is not whether 15 puzzles can be made, but whether each can teach or surprise with a distinct rewind interaction.

**Why it matters:** Puzzle games thrive on the "aha!" moment — the satisfaction of discovering a new trick. If solutions converge to a single pattern, the game loses novelty and the progression feels flat, even across only 15 puzzles.

**Prototype question:** Can we hand-design 5 puzzles (a minimum viable puzzle set) where each demonstrates a distinct rewind interaction — e.g., gate-opening, obstacle-clearing, chain-rewinds — evidenced by a puzzle progression document showing no repeated solution pattern?

**Success criteria:** A puzzle progression document listing 5 puzzles, each with a different core rewind interaction and no duplicate solution pattern. Each puzzle should force the player to use the rewind in a way they haven't seen before.

---

## Risk 3: Rewind State Management Complexity

**Description:** The rewind mechanic requires a full command-pattern undo stack: every step must record which tile was stepped on, its previous number, gate states, and obstacle positions. On rewind, all of that must be reversed in order. Edge cases — a rewind that passes over a tile whose number also hits zero, or a gate that changes state mid-rewind — could introduce subtle bugs that consume jam development time.

**Why it matters:** While this is a known engineering pattern (command/undo stack) and solvable, debugging state-reversal edge cases could eat into the limited jam timeline, delaying or cutting the puzzle content that actually matters.

**Prototype question:** Can we implement a reliable rewind state system that correctly undoes tile numbers, gate states, and obstacle positions — evidenced by all state being restored correctly across 10 consecutive rewinds with edge cases (gate toggles, obstacle movements)?

**Success criteria:** An automated test (or manual verification) running 10 consecutive rewinds on a 5×5 grid with gates and obstacles, where every tile number, gate open/closed state, and obstacle position matches the pre-step state after rewind completion. Zero state desyncs.

---

## Prioritization

Rank risks by impact × uncertainty. Prototype the riskiest first.

| Priority | Risk | Impact (H/M/L) | Uncertainty (H/M/L) | Prototype Order |
|----------|------|----------------|---------------------|-----------------|
| 1 | Player Comprehension of the Rewind Mechanic | H | H | 1st |
| 2 | Puzzle Design Depth Within Jam Scope | M | M | 2nd |
| 3 | Rewind State Management Complexity | M | M | 3rd |

---

## Next Step

Run `/prototype` for each risk in priority order, starting with Risk 1.
