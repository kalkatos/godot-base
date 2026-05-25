# Game Concept: Zero Hour Tactics

*Created: 2026-05-24*
*Status: Draft*

---

## Elevator Pitch

> Zero Hour Tactics is a turn-based bullet-heaven tactics roguelite where every turn unleashes build-defined projectile patterns across a compact battlefield. You survive escalating swarms by making high-consequence positioning decisions, chaining synergies, and engineering explosive tactical turns.

---

## Core Identity

| Aspect | Detail |
| ---- | ---- |
| **Genre** | Turn-based tactical roguelite + bullet heaven |
| **Platform** | PC (Steam / Epic) |
| **Target Audience** | Strategy-first mid-core/hardcore players who enjoy deep systems and replayable builds |
| **Player Count** | Single-player |
| **Session Length** | 45-120 minutes (one full run) |
| **Monetization** | Premium |
| **Estimated Scope** | Large (24-30 months, solo) |
| **Comparable Titles** | Vampire Survivors, Final Fantasy Tactics, Slay the Spire |

---

## Core Fantasy

You are a battlefield architect of impossible odds: each turn is a deliberate gamble where your positioning, sequencing, and build logic transform chaos into controlled annihilation. The fantasy is not fast hands, but superior tactical judgment under pressure. The player feels powerful because they can see the board, choose among multiple valid lines, and execute a plan whose consequences are dramatic and readable.

---

## Unique Hook

Like Vampire Survivors, and also every second of mayhem is decomposed into high-agency tactical turns where bullet spectacle is authored by strategic decisions instead of reflex execution.

---

## Player Experience Analysis (MDA Framework)

### Target Aesthetics (What the player FEELS)

| Aesthetic | Priority | How We Deliver It |
| ---- | ---- | ---- |
| **Sensation** (sensory pleasure) | 4 | Dense projectile geometry, impactful VFX, and high-contrast telegraphs |
| **Fantasy** (make-believe, role-playing) | 3 | Player as an arcane tactician shaping lethal battlefield patterns |
| **Narrative** (drama, story arc) | N/A | Minimal framing narrative; run stories emerge from tactical outcomes |
| **Challenge** (obstacle course, mastery) | 1 | Risk-reward turns, escalating enemy pressure, and consequential choices |
| **Fellowship** (social connection) | N/A | No direct multiplayer; optional community seed sharing later |
| **Discovery** (exploration, secrets) | 5 | Build interactions, hidden synergies, and encounter counterplay |
| **Expression** (self-expression, creativity) | 2 | Diverse build identities and tactical line selection each turn |
| **Submission** (relaxation, comfort zone) | 6 | Turn-based pacing reduces twitch stress while preserving tension |

### Key Dynamics (Emergent player behaviors)

- Players evaluate several tactical lines each turn and choose based on risk appetite.
- Players chase chain-kill breakpoints to unlock timing-sensitive power spikes.
- Players adapt build plans to enemy formations and map pressure instead of rote execution.
- Players replay for optimization, discovering stronger projectile pattern synergies over time.

### Core Mechanics (Systems we build)

1. Turn-based tactical board resolution with facing, positioning, and threat zones.
2. Build-defined projectile pattern system with modifiers, chaining, and persistence rules.
3. Escalation director that increases swarm pressure and encounter complexity during a run.
4. Roguelite progression with unlockable tactical options and pattern archetypes.
5. Boss encounters that test board control, sequencing, and build adaptation.

---

## Player Motivation Profile

### Primary Psychological Needs Served

| Need | How This Game Satisfies It | Strength |
| ---- | ---- | ---- |
| **Autonomy** (freedom, meaningful choice) | Multiple viable tactical lines per turn with distinct tradeoffs | Core |
| **Competence** (mastery, skill growth) | Clear skill expression through planning quality, pattern timing, and adaptation | Core |
| **Relatedness** (connection, belonging) | Emotional attachment to each run's unique build identity | Supporting |

### Player Type Appeal (Bartle Taxonomy)

Which player types does this game primarily serve?

- [x] **Achievers** (goal completion, collection, progression) — How: run completion, optimization, unlock progression, and mastery benchmarks.
- [x] **Explorers** (discovery, understanding systems, finding secrets) — How: interaction discovery, build experimentation, and emergent tactical solutions.
- [ ] **Socializers** (relationships, cooperation, community) — How: not a primary pillar for MVP.
- [ ] **Killers/Competitors** (domination, PvP, leaderboards) — How: not a primary pillar for MVP.

### Flow State Design

Flow occurs when challenge matches skill. How does this game maintain flow?

- **Onboarding curve**: First 10 minutes teach movement-risk, threat reading, and one signature synergy through staged encounters.
- **Difficulty scaling**: Enemy density, pattern complexity, and counterplay requirements escalate with run depth.
- **Feedback clarity**: Turn previews, impact trails, chain indicators, and post-turn recap make outcomes legible.
- **Recovery from failure**: Fast restart, immediate rematch loop, and persistent unlock progress keep failures educational.

---

## Core Loop

### Moment-to-Moment (30 seconds)

Assess board pressure, select a tactical line, commit to a calculated risk, and watch projectile interactions resolve with clear consequences.

### Short-Term (5-15 minutes)

Players pursue chain-kill breakpoints and build-defining upgrades that create visible power spikes and shift tactical options.

### Session-Level (30-120 minutes)

A full run moves from early setup through escalating mid-run specialization into a decisive boss test, ending with rewards, unlocks, and strategic reflection.

### Long-Term Progression

Players unlock new pattern archetypes, modifiers, and tactical tools that widen build space; mastery grows through better planning and adaptation.

### Retention Hooks

- **Curiosity**: Unseen synergies, unresolved build ideas, and unexplored tactical combinations.
- **Investment**: Persistent unlock track and high-identity builds players want to perfect.
- **Social**: Optional future community sharing of seeds/build snapshots (post-MVP).
- **Mastery**: Higher challenge goals, cleaner clears, and stronger tactical consistency.

---

## Game Pillars

### Pillar 1: Consequence-Rich Turns
Every turn must involve meaningful tradeoffs with irreversible tactical consequences.

*Design test*: If we are choosing between a safe deterministic move and a riskier line with strategic upside, choose the option that preserves meaningful risk-reward decisions.

### Pillar 2: Spectacle Through Strategy
Screen-filling projectile spectacle must emerge from planning, not reflex.

*Design test*: If a feature adds reaction checks instead of pre-turn planning depth, redesign toward planning depth.

### Pillar 3: Build Identity Over Raw Stats
Distinct interaction patterns should define runs more than flat numeric scaling.

*Design test*: If we are choosing between flat stat inflation and a new interaction rule, choose the interaction rule.

### Pillar 4: Always Multiple Valid Lines
Most board states should present at least 2-3 competitively viable tactical plans.

*Design test*: If content funnels players into one dominant sequence, redesign until alternatives are meaningfully viable.

### Anti-Pillars (What This Game Is NOT)

- **NOT twitch-execution action**: Requires reflex-heavy input that would compromise Spectacle Through Strategy.
- **NOT stat-bloat progression**: Raw number inflation would compromise Build Identity Over Raw Stats.
- **NOT solved one-path encounters**: Single correct answers would compromise Always Multiple Valid Lines.
- **NOT opaque rules soup**: Excessive hidden exceptions would compromise Consequence-Rich Turns.

---

## Visual Identity Anchor

- **Selected Direction**: Occult Blueprint
- **One-line visual rule**: Every combat decision should look like drawing a dangerous theorem onto a living battlefield.

Supporting visual principles:

1. **Ritual Geometry Readability**
   - Design test: If an effect improves spectacle but harms projectile legibility, simplify shape hierarchy and restore contrast.
2. **Arcane Systems, Tactical Clarity**
   - Design test: If decorative detail competes with board-state readability, prioritize tactical clarity over ornament.
3. **Consequence Leaves a Mark**
   - Design test: If turn resolution leaves no readable aftermath, add brief persistent residue (glyph scars, vector traces, ember marks).

- **Color philosophy**: Muted parchment and iron-black foundations, punctuated by high-contrast rune accents (cyan/amber/crimson) for threat, opportunity, and escalation.

---

## Inspiration and References

| Reference | What We Take From It | What We Do Differently | Why It Matters |
| ---- | ---- | ---- | ---- |
| Vampire Survivors | Compulsive kill-upgrade-repeat loop and build experimentation | Turn-based tactical execution with explicit board planning | Validates replayability and build-driven retention |
| Final Fantasy Tactics | Positioning depth and high-stakes tactical sequencing | Bullet-heaven density and roguelite run structure | Validates strategy-first audience fit |
| Magic: The Gathering | Modular combinatorial interactions and emergent strategy space | Spatial projectile mechanics and run-time tactical adaptation | Validates long-term discovery and mastery motivation |

**Non-game inspirations**: Arcane geometry, ritual diagrams, tactical plotting boards, and occult manuscript visual language.

---

## Target Player Profile

| Attribute | Detail |
| ---- | ---- |
| **Age range** | 18-40 |
| **Gaming experience** | Mid-core to hardcore strategy players |
| **Time availability** | 45-120 minute focused sessions |
| **Platform preference** | PC |
| **Current games they play** | Vampire Survivors, tactical RPGs, systemic strategy/deck games |
| **What they're looking for** | Bullet-heaven compulsion without reflex pressure; meaningful tactical agency |
| **What would turn them away** | Twitch-heavy execution demands, shallow build depth, dominant solved strategies |

---

## Technical Considerations

| Consideration | Assessment |
| ---- | ---- |
| **Recommended Engine** | Godot (user-selected; strong fit for 2D tactical systems and PC target) |
| **Key Technical Challenges** | Deterministic turn resolution for dense projectile interactions; build balance at high combinatorial depth |
| **Art Style** | 2D stylized (occult tactical overlays + high-contrast projectile effects) |
| **Art Pipeline Complexity** | Medium (custom 2D assets + shader-driven readability/effects) |
| **Audio Needs** | Moderate (clear tactical cues, escalation feedback, identity motifs) |
| **Networking** | None |
| **Content Volume** | Full vision target: 15-20 enemy archetypes, 120-180 upgrades, 4-6 biomes, 15-25 hours |
| **Procedural Systems** | Encounter composition and upgrade availability per run; controlled randomness for replayability |

---

## Risks and Open Questions

### Design Risks

- Dominant build strategies may reduce tactical variety.
- Turn pacing could degrade if resolution clarity is not fast and readable.

### Technical Risks

- High interaction density may create hard-to-debug edge cases in deterministic resolution.
- Tooling for balance iteration may be insufficient without early instrumentation.

### Market Risks

- Genre overlap with strong incumbents could limit discoverability.
- Turn-based framing may split expectations among traditional bullet-heaven players.

### Scope Risks

- Content volume (upgrades/enemies/biomes) could exceed solo throughput.
- Boss and encounter design demands may bottleneck late production.

### Open Questions

- Which balancing framework best prevents dominant strategy lock-in at scale? (Answer via prototype metrics + simulation passes.)
- What is the optimal turn resolution pacing window for readability and excitement? (Answer via playtest A/B of animation speed + preview density.)

---

## MVP Definition

The absolute minimum version that validates the core hypothesis.

**Core hypothesis**: Strategy-first players will find a turn-based bullet-heaven loop compelling for repeated sessions when each turn offers meaningful risk-reward and visible build synergies.

**Required for MVP**:
1. One biome with escalating encounters and one boss.
2. Six enemy archetypes with clear tactical differentiation.
3. Twenty-five upgrades enabling distinct build identities.
4. Deterministic turn resolution with readable projectile previews/outcomes.
5. Basic meta unlock progression to support replay motivation.

**Explicitly NOT in MVP** (defer to later):

- Additional biomes beyond the first.
- Expanded narrative campaign.
- Online features/community systems.
- Large enemy/upgrade catalogs beyond validation scope.

### Scope Tiers (if budget/time shrinks)

| Tier | Content | Features | Timeline |
| ---- | ---- | ---- | ---- |
| **MVP** | 1 biome, 1 boss, 6 enemies, 25 upgrades | Core loop + deterministic tactical resolution + basic progression | 4-6 months (solo) |
| **Vertical Slice** | 1 polished biome + expanded encounter variety | Refined readability, stronger onboarding, representative production quality | 8-10 months (solo) |
| **Alpha** | 3-4 biomes, broad enemy and upgrade coverage | Full feature set rough-complete, balancing in progress | 14-18 months (solo) |
| **Full Vision** | 4-6 biomes, 15-20 enemies, 120-180 upgrades, 15-25h | Full content, polished systems, release quality | 24-30 months (solo) |

---

## Next Steps

### Path A — Design-First

1. Run `/setup-engine` to configure the engine and populate version-aware reference docs.
2. Run `/art-bible` to create the visual identity specification before writing GDDs. The art bible is required before the Technical Setup gate and shapes architecture decisions.
3. Use `/design-review design/gdd/game-concept.md` to validate concept completeness before going downstream.
4. Discuss vision with the `creative-director` agent for pillar refinement.
5. Decompose the concept into individual systems with `/map-systems`.
6. Author per-system GDDs with `/design-system`.
7. Plan technical architecture with `/create-architecture`.
8. Record key architectural decisions with `/architecture-decision` (one ADR per required decision).
9. Run `/architecture-review` to bootstrap traceability from GDDs and ADRs.
10. Validate readiness to advance with `/gate-check`.

### Path B — Prototype-First

1. Run `/setup-engine` to configure the engine.
2. Run `/prototype turn-based bullet-heaven core loop` to validate the core idea before writing GDDs.
3. If prototype PROCEEDS: run `/art-bible`, then continue with Path A steps 5-10 using prototype learnings.
4. If prototype PIVOTS: return to `/brainstorm` with learnings and reshape the concept.
5. After full design and architecture, build `/vertical-slice` to validate production readiness before committing to sprints.
