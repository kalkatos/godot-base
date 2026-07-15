# GAME CONCEPT: Mahou

Keep this document brief. Prefer 1 to 3 bullets per section and short sentences over exhaustive detail. This is a high-level overview to align the team on the core identity and vision of the game. Detailed design decisions, mechanics, and features will be defined later in the development process.

**IMPORTANT**: The language in this document must use clear, unambiguous terms that are also defined in `.docs/glossary.md`. This avoids ambiguity in later stages. For example, if the concept includes a gravity inversion mechanic, name it explicitly and use the exact term "gravity inversion" consistently.

## 1. Game Identity

- Working title: Mahou
- Genre: Asynchronous auto battler with programmable team AI
- Perspective: Side view — each team forms a 2×3 grid on their side of the board
- Player count: Online asynchronous multiplayer
- Target platform: PC (Windows, macOS, Linux)

## 2. Elevator Pitch

Build a team of up to six mages, program their behavior with conditional instructions, and submit them to the league. Battles resolve deterministically — you spectate the results against other players' teams asynchronously, all in a small desktop companion window.

## 3. Player Fantasy

- Feel like a cunning team coach and strategist, outsmarting opponents through clever instruction programming rather than raw stats.
- Experience the spectacle of mage sports — dramatic spell clashes, roaring crowds, and league rivalries in a lighthearted fantasy arena.
- Compete in an ongoing league where every battle shapes your ranking and reputation.

## 4. Core Mechanics

- Build teams of 1–6 unique characters, each with up to 3 spells, 3 items, and up to 10 conditional instructions.
- Program character behavior through ordered instruction chains: condition → target → action, with a fallback basic attack.
- Position characters on a 2×3 grid (front row / back row) where front row protects the back row from single-target attacks.
- Submit teams to the server, get matched against another player's team, and spectate the deterministic seed-based battle at variable speeds (1x/2x/4x).
- Earn new characters, spells, and items through play milestones (light meta-progression).

## 5. Core Loop

- Tweak your team — adjust characters, spells, items, positions, and instruction chains between battles.
- Submit to the league — upload your team to the server; it enters the match pool.
- Roll for a battle — get matched against another player's team with a battle seed.
- Spectate the fight — watch the turn-based battle play out in side view, with dramatic moments on crits and knockouts.
- Learn and refine — analyze what worked, make one change, and submit again.

## 6. Unique Features

- Conditional instruction programming is the primary creative expression — victory comes from outsmarting opponents with clever AI chains, not grinding stats.
- Deterministic seeded battles mean every outcome is fair, reproducible, and purely about team composition vs. team composition.
- Desktop companion format: a small always-on-top window designed for second-screen play while doing other activities.
- Asynchronous PvP removes the need for real-time matchmaking — play on your schedule, against real players' teams.

## 7. References

- From *Backpack Battles*, borrow the async auto-battler loop, inventory puzzle of fitting items together, and the "set up and watch" pacing.
- From *Unicorn Overlord*, borrow the tactical programming of character behavior through prioritized conditional instructions.
- From sports anime (e.g., *Haikyuu!!*), draw the team rivalry, league spectacle, and the emotional arc of a competitive season — but with mages.

## 8. Further Notes

- League rankings, seasons, and tournaments are stretch goals; the MVP should use a simple win/loss counter for ranking.
- The server runs the same code as the client, headless in a Docker container, processing match requests and storing team data.
- Art style should be anime-inspired with readable character silhouettes and clear spell effect readability — the small window demands visual clarity.
- Battle length target: 1–5 minutes per match (MAX_TURNS = 30).
