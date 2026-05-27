# DECISIONS: Read

Decisions taken during the project that impact the direction of development, design, or other aspects of the game. This document serves as a record of those decisions, the rationale behind them, and any alternatives that were considered.

**Simulation-Driven Combat (No Physics Collisions)**
**What:** The game uses a simulation-driven combat model instead of real-time physics collision detection. When a card is played (e.g., a kick attack), the attacker plays the kick animation and the defender plays the receive-hit animation directly — there is no hitbox or collision check. Damage is calculated from card data and applied immediately.
**Why:** The game is a tactical card-driven fighter where all actions originate from the deck. Simulating outcomes from cards simplifies implementation, avoids physics tuning, and keeps the focus on strategic card play rather than execution timing.
**When:** 2026-05-27, v1: Core Loop, Sprint v1.1: Fighter & Arena Foundation
**Alternatives Considered:** Real-time hitbox/hurtbox collision detection (like traditional fighting games). Rejected because it adds unnecessary complexity for a card-driven game where actions are pre-determined by deck choices, not player reflexes.

**No Free Movement (Card-Driven Positioning)**
**What:** Fighters have no player-controlled free movement (no walking, jumping, or dashing via input). All positioning and movement are driven by card effects — if a card says a fighter jumps, the jump animation plays; if a card says they step forward, the step animation plays.
**Why:** Consistent with the simulation-driven model. Movement as a card effect creates interesting deck-building tradeoffs (mobility cards vs. attack cards vs. defense cards) and keeps the arena presentation clean and predictable.
**When:** 2026-05-27, v1: Core Loop, Sprint v1.1: Fighter & Arena Foundation
**Alternatives Considered:** Hybrid model with free movement + card actions (like a traditional fighting game with deck elements). Rejected to maintain design purity — every action, including positioning, should be a deliberate card choice.
