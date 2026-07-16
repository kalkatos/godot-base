# DECISIONS: Mahou

Decisions taken during the project that impact the direction of development, design, or other aspects of the game. This document serves as a record of those decisions, the rationale behind them, and any alternatives that were considered.

---

## Creative Direction

**Working Title: Mahou**
**What:** The game is named Mahou (Japanese for "magic"), anchoring the lighthearted mage-sports fantasy. The Arena sports-fantasy concept direction was chosen over Protocol (logic-puzzle focus) or Archive (collection focus).
**Why:** The sports-fantasy angle best supports the competitive league, spectator spectacle, and anime-inspired tone described in the premise. Protocol was too sterile and Archive too solitary.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** "Protocol" (logic-circuit visual style, minimal spectacle) — rejected as too narrow and lacking the emotional hook the user wanted. "Archive" (collection/discovery focus) — rejected as it downplayed the competitive PvP core.

**Genre: Asynchronous Auto Battler with Programmable Team AI**
**What:** The game is an asynchronous multiplayer auto battler where player skill is expressed through programming each character's conditional instruction chains, not through real-time control or stat grinding.
**Why:** Combines the "set up and watch" loop of Backpack Battles with the tactical AI programming of Unicorn Overlord. Async removes matchmaking friction; programmable AI gives depth without demanding the player's full attention.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Real-time PvP matchmaking — rejected because it conflicts with the desktop companion / second-screen premise. Traditional turn-based RPG — rejected as it requires active player input during combat, which doesn't fit the spectate-focused experience.

**Perspective: Side View 2×3 Grid**
**What:** Battles are displayed in side view, with each team occupying a 2×3 grid on their side of the board (front row and back row, left/middle/right).
**Why:** User specified this over the recommended top-down view. Side view better supports dramatic spell animations, character silhouettes, and the sports-spectacle feel — like watching a side-scrolling fighting game.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Top-down board view — recommended as simpler for readability in a small window, but rejected by user in favor of side view's dramatic potential.

**Core Twist: Programmable Instructions as Primary Skill Expression**
**What:** Victory in Mahou comes from how cleverly the player chains conditional instructions across their team, not from grinding better gear or higher stats. Each character runs up to 10 prioritized conditions, and the first met condition fires each turn.
**Why:** This is the differentiator from every other auto battler. The player is not just assembling a team — they're writing a mini-program for each character. Skill ceiling comes from logic, not time investment.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Traditional gear/level-based power progression — rejected as it would make the game a stat-check grind rather than a strategic puzzle.

---

## Format & Platform

**Desktop Companion Format**
**What:** The game runs in a small, always-on-top window designed for second-screen play — the player can watch battles while doing other activities on their primary screen.
**Why:** Core to the pitch: Mahou is not a full-attention game. The small window constraint drives every design decision from UI density to battle length (1–5 minutes) to the spectate-only combat model.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Full-screen application — rejected as it contradicts the second-screen premise. Mobile-first — rejected because the always-on-top window pattern is inherently a desktop experience (mobile could come later).

**Asynchronous PvP Model**
**What:** Players build teams, submit them to a server, and get matched against other players' stored team snapshots. Battles are deterministic from a seed — no real-time coordination between players is needed.
**Why:** Async removes scheduling friction and matchmaking wait times. Players engage on their own schedule. The server only needs to store teams and seeds, not run real-time game sessions.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Real-time matchmaking — rejected as incompatible with the desktop companion / second-screen use case. Single-player only — rejected as it removes the competitive hook and the "outsmart real players" fantasy.

**Deterministic Seed-Based Battles**
**What:** Given the same seed and the same two team compositions, the battle outcome is always identical. All randomness is derived from the seed, making every result reproducible and verifiable.
**Why:** Fairness — no hidden server-side advantage or RNG manipulation. Both players can replay and verify the battle. Also simplifies the server architecture: battles are pure computation, no stateful sessions.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Client-authoritative outcomes — rejected as exploitable. Server-side real-time random — rejected as it prevents reproducibility and complicates server architecture.

---

## Systems & Rules

**Light Meta-Progression**
**What:** New characters, spells, and items are unlocked gradually through play milestones (e.g., win thresholds, battle counts). Not everything is available at the start, but the unlock curve is gentle and non-grindy.
**Why:** Provides a reason to keep playing and a sense of growing collection without turning the game into a grind. Heavy progression would clash with the pick-up-and-play second-screen nature; zero progression would give no long-term hook.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Heavy progression systems (battle passes, daily quests, extensive upgrade trees) — rejected as too demanding for a second-screen game. Pure skill / everything unlocked — rejected as it removes the collection and discovery appeal.

**Team Composition Rules**
**What:** Teams have 1–6 characters. Characters must be unique within a team (no duplicates). Spells must be unique within a team (same spell can't appear in multiple slots). Items can repeat freely within a character and across the team.
**Why:** Character uniqueness prevents degenerate same-hero stacking. Spell uniqueness forces strategic diversity — you can't put Fireball on everyone. Item repeatability allows creative stacking strategies and reduces frustration.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** No uniqueness rules — rejected as it would lead to degenerate "6 of the best character" metas. Items also unique — rejected as too restrictive for build creativity.

**Character Type System: Vanguard / Striker / Support**
**What:** Three distinct character types: Vanguard (tank, absorbs damage on front row), Striker (high damage dealer, front or back row), Support (healer/buffer/debuffer, back row). Types determine role and optimal positioning.
**Why:** Three types is enough for strategic variety without overwhelming complexity. The type system interacts with the front/back row mechanic: Vanguards protect the back line, Supports need protection, Strikers flex.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Classless system — rejected as it makes team-building feel aimless. More granular types (5+) — rejected as overkill for the scope and harder to balance.

**Shared Server-Client Codebase**
**What:** The server runs the same Godot code as the client, headless in a Docker container. Battle simulation, damage calculation, and instruction evaluation are shared — no separate implementation.
**Why:** Eliminates the risk of client-server mismatches in battle outcomes. Reduces development effort (write once, run everywhere). Deterministic seed-based battles make this feasible — the server just needs to compute, not render.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Separate server implementation in another language (e.g., Rust, Go) — rejected as it doubles implementation effort and risks subtle behavior differences between client and server.

**Battle Constants**
**What:** MAX_TURNS=30, ENERGY_RANGE=1000 (HP/MP scale), STATS_RANGE=100 (POW/DEF/SPD/LUK scale), CRITICAL_BASE_PCT=5%, MAX_INSTRUCTIONS_PER_CHARACTER=10.
**Why:** These constants define the entire balance envelope. MAX_TURNS=30 keeps battles at 1–5 minutes. ENERGY_RANGE at 10× STATS_RANGE gives a wide HP pool for tactical depth. MAX_INSTRUCTIONS=10 provides enough depth for complex chains without overwhelming the player.
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Different scale ratios — considered but the 10:1 HP-to-stats ratio and 30-turn cap emerged from the premise as the simplest starting point for a balanced, watchable battle length.

**Inspiration Mix: Backpack Battles + Unicorn Overlord**
**What:** The game explicitly draws from Backpack Battles (async auto-battler loop, inventory puzzle, set-up-and-watch pacing) and Unicorn Overlord (tactical AI programming via prioritized conditional instructions), wrapped in sports-anime spectacle.
**Why:** User explicitly specified these two references over the recommended FFXII Gambits + Hearthstone Battlegrounds combination. These references more precisely capture the async nature (Backpack Battles) and the tactical programming depth (Unicorn Overlord).
**When:** 2026-07-15, Pre-production, Game Concept Definition.
**Alternatives Considered:** Final Fantasy XII Gambit system — similar instruction programming concept, but FFXII is a real-time single-player RPG, not async PvP. Hearthstone Battlegrounds — similar auto-battler genre but real-time and lacks AI programming.