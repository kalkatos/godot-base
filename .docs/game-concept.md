# GAME CONCEPT: Count

Keep this document brief. Prefer 1 to 3 bullets per section and short sentences over exhaustive detail. This is a high-level overview to align the team on the core identity and vision of the game. Detailed design decisions, mechanics, and features will be defined later in the development process.

**IMPORTANT**: The language in this document must use clear, unambiguous terms that are also defined in `.docs/glossary.md`. This avoids ambiguity in later stages.

## 1. Game Identity

- Working title: Count
- Genre: Puzzle
- Perspective: Top-down
- Player count: Single-player
- Target platform: Web (play-in-browser)

## 2. Elevator Pitch

A whimsical grid-based puzzle game where every step you take decreases a tile's number — and when it hits zero, your path rewinds, undoing obstacles and reopening routes. Plan your walk forward to move backward.

## 3. Player Fantasy

Feel like a clever time-weaver, dancing across a numbered grid where every footprint is also an eraser. Outsmart the board by turning forward movement into backward opportunity.

## 4. Core Mechanics

- Walk a character across a top-down grid of numbered tiles, one step at a time.
- Each step onto a tile decreases its value by 1.
- When a tile reaches zero, it triggers a rewind — your character retraces their path backward by that tile's original value in steps, undoing state changes along the way.
- Rewinds can reopen closed gates, un-move obstacles, and restore blocked paths.
- Reach the exit tile to complete the puzzle.

## 5. Core Loop

- Enter a puzzle — a small grid with numbered tiles, a character start position, and an exit.
- Study the board and plan a route where stepping on tiles in the right order causes rewinds that clear your way to the exit.
- Walk the path — step tile by tile, triggering rewinds that reshape the board state.
- Reach the exit and advance to the next, slightly harder puzzle.
- A session strings together 3–5 puzzles of escalating complexity, wrapping up in about 5 minutes.

## 6. Unique Features

- Forward movement IS backward planning — the same action that progresses you also winds back the clock.
- Numbers are not timers — they are rewind distance, turning counting into a spatial puzzle tool.
- Pure skill, no meta-progression — every player faces the same puzzles on equal footing.
- Whimsical, bouncy aesthetic where tiles pulse and paths glow, making rewinds feel playful rather than punishing.

## 7. References

- From **Baba Is You**, we borrow the rule-bending creativity and whimsical puzzle tone, where simple elements combine into surprising interactions.
- From **Threes!**, we borrow the satisfying feel of number manipulation and the elegance of a single, deep mechanic explored fully.
- From **Braid**, we borrow the idea of rewinding as a core puzzle mechanic — but reinterpreted spatially rather than temporally.

## 8. Further Notes

- The game should use a clean, colorful art style with bouncy animations that reinforce the lighthearted tone.
- Rewind animations must be visually clear: a "ghost trail" retracing the path while tiles and obstacles animate back to their prior state.
- Initial prototype should focus on small grids (3×3 to 5×5) with a single rewind per puzzle, then scale up.
- The web build should be lightweight and instant-load, with no download or account required.

### Rejected Concept Directions

**Direction A: "Echo"** — A grid-based puzzle where numbered tiles count down each turn. When a tile reaches zero, it echoes — reverting adjacent tiles to their state from that many turns ago. Puzzles chain echoes together: set up cascading rewinds to reshape the board and reach the exit. Whimsical, bouncy art style with tiles that pulse and "pop" when they echo.

**Direction C: "Recall"** — Push numbered blocks around a grid. Every push ticks their count down by 1. When a block hits zero, it recalls — snapping back to where it was N turns ago, carrying whatever's riding on it. Build Rube Goldberg-like chains: push block A, it recalls carrying block B, which lands and triggers block C's recall. Playful, toy-like aesthetic where blocks feel weighty and satisfying.
