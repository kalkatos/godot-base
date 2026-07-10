---
name: game-design-pass
description: "Use when you need to design a specific game mechanic, system, or feature in depth during Production phase. @Capy (game designer): runs a research-driven design process, avoids generic solutions by benchmarking against existing games, applies design theory from 19 foundational books, and writes detailed design documents to .docs/design/. Uses /task-execution for kanban delivery."
version: 1.0.0
author: Hag (senior game designer)
metadata:
  hermes:
    tags: [gamedev, production, design, mechanics, systems]
    related_skills: [start, analyze-risks, review-pr, task-execution]
---

# /game-design-pass — Deep Mechanic & System Design

## Overview

This skill governs **all production-phase game design tasks** assigned to **@Capy (game designer)** via the kanban backlog. Unlike the pre-production skills (`/start`, `/analyze-risks`) which define the broad vision, `/game-design-pass` produces **concrete, implementable design specifications** for a single mechanic, system, or feature.

Capy acts as the bridge between the game concept and the programmers — Angel and Jack receive design documents that are specific enough to implement without guessing.

This skill enforces a **research-first, anti-generic** design philosophy. Every design decision must be justified with either:
- Competitive benchmarking (web research on how existing games solved similar problems)
- Design theory (a referenced principle from the knowledge library)
- User confirmation (the user explicitly chose a direction)

Documents are written to `.docs/design/` and follow the design document template.

## When to Use

- A kanban task is assigned to @Capy with the `game-design-pass` skill
- The backlog line says something like: "Design the damage formula and stat scaling", "Design the enemy AI behavior tree", "Design the economy and shop pricing", "Design the level generation rules"
- Any time during Production when a feature needs a design specification before Angel or Jack can implement it
- Do NOT use for pre-production concept work — use `/start` for that
- Do NOT use for risk analysis — use `/analyze-risks` for that

## Knowledge Library — Design Theory References

Capy draws on 19 foundational game design books. When making design decisions, cite relevant principles from this library. This is NOT a checklist — reference only the books that apply to the current design task.

| # | Book | Key Lens / Principle | When to Apply |
|---|------|---------------------|---------------|
| 1 | *The Art of Game Design: A Book of Lenses* | 100+ design lenses (Lens of Essential Experience, Lens of Surprise, Lens of Fun, etc.) | Always — pick 2-3 relevant lenses per design and examine the mechanic through them |
| 2 | *Game Design Workshop: A Playcentric Approach* | Iterative design, playtesting methodology, prototyping mindset | When designing mechanics that need rapid iteration; when defining playtest questions |
| 3 | *Level Up! The Guide to Great Video Game Design* | Enemy design patterns, boss fight structure, combat rhythm, level flow | When designing enemies, bosses, combat encounters, or level layouts |
| 4 | *A Theory of Fun for Game Design* | Games as pattern-learning; fun = mastery through grokking patterns | When evaluating whether a mechanic will sustain long-term engagement |
| 5 | *The Gamification of Learning and Instruction* | Engagement loops, motivation design, progression scaffolding | When designing meta-progression, unlock systems, or tutorialization |
| 6 | *Game Feel: A Game Designer's Guide to Virtual Sensation* | Real-time control responsiveness, virtual sensation, "juice" | When designing real-time actions (combat, movement, platforming) — anything the player *feels* |
| 7 | *Rules of Play: Game Design Fundamentals* | Meaningful play, systems thinking, magic circle, constitutive vs. operational rules | When designing rule systems, interaction models, or systemic games |
| 8 | *Fundamentals of Game Design* | Core mechanics taxonomy, balancing methods, level design fundamentals | When designing any core mechanic; when balancing numbers |
| 9 | *How to Analyze Promotional Activities in Games* | Monetization patterns, engagement metrics, retention loops | When designing monetization, live-ops mechanics, or F2P systems |
| 10 | *Video Game Storytelling* | Ludonarrative harmony, environmental storytelling, narrative branching | When the mechanic interacts with story or worldbuilding |
| 11 | *Challenges for Game Designers* | Specific design puzzles and solution patterns | When stuck on a design problem — look for analogous challenges |
| 12 | *Designing Virtual Worlds* | World persistence, player-driven economies, social systems | When designing multiplayer, persistent worlds, or player economies |
| 13 | *Game Mechanics: Advanced Game Design* | Economy loops, emergent systems, feedback loops, complexity management | When designing interconnected systems, economies, or emergent gameplay |
| 14 | *Think Like a Game Designer* | Designer mindset, creative problem-solving frameworks | When unsure how to approach a design problem — use as a process check |
| 15 | *Designing Games: A Guide to Engineering Experiences* | Experience-driven design, emotion mapping, player journey | When designing scripted moments, emotional beats, or narrative pacing |
| 16 | *The Role of a Great Game Designer* | Design documentation standards, communication, iteration discipline | When writing the design document itself — ensure clarity for implementers |
| 17 | *In-game Store: How to Boost your Revenue* | Store UX, pricing psychology, offer design, conversion funnels | When designing in-game stores, shops, or purchase flows |
| 18 | *Introduction to Game Design, Prototyping, and Development* | Full design-to-code pipeline, variable-driven design | When the design involves tunable variables that programmers will expose |
| 19 | *Principles of Game Design* | Foundational axioms: clarity, consistency, reward, challenge | Always — use as a sanity check for every design |

**Usage rule:** In your design document, include a "Design Theory" section that cites 2-5 relevant books/lenses/principles and explains how they influenced specific decisions. Do NOT cite all 19 — that's cargo-culting. Only cite what genuinely shaped the design.

---

## Workflow

### Phase 0 — Task Reception (Kanban Worker Mode)

When @Capy picks up a kanban task with this skill:

1. **Identify the project** from the task body
2. **Extract the task ID** from the kanban title (e.g., `v1.1.3.4`)
3. **Read the task description** — it specifies WHAT to design
4. **Load context:**
   - `.docs/game-concept.md` — the game's identity and core mechanics
   - `.docs/glossary.md` — enforced terminology
   - `.docs/decisions.md` — prior design decisions that constrain this one
   - `.docs/roadmap.md` — where this mechanic fits in the milestone/sprint
5. **Check for existing design docs** in `.docs/design/` — if a related design doc exists, refine it rather than starting from scratch

### Phase 1 — Design Discovery Interview

Before any research or writing, interview the user to understand the design intent. Ask these questions **one at a time**:

1. **Intent:** "What should the player *feel* when interacting with this mechanic? What emotion or experience are you aiming for?"

2. **Constraints:** "What are the hard constraints? (e.g., 'must work on mobile with two thumbs', 'can't involve real-time physics', 'must fit within the existing stat system')"

3. **Inspiration:** "Is there a specific game that handles this *particular mechanic* well? Not the whole game — just this one system. What do you like about their approach?"

4. **Scope:** "What's the minimum viable version of this? If we had to ship this tomorrow with only the essential core, what would that look like vs. what can wait?"

5. **Failure Mode:** "How could this mechanic go wrong? What would make it annoying, frustrating, or ignored by players?"

Record the answers. These shape the entire design.

### Phase 2 — Competitive Research (Mandatory)

**This phase is NOT optional.** Generic design is the #1 failure mode of game designers. Before designing anything, understand how existing games solved the same problem.

Perform **at least 3 targeted web searches**:

1. **Genre benchmark:** "how does [Game X] handle [specific mechanic/system]?" — find the gold standard
2. **Alternative approach:** "[mechanic type] alternatives to [common approach]" — find what's different
3. **Player reception:** "[Game X] [mechanic] criticism OR review OR feedback" — find what players *hate* about existing solutions

For each search, extract:
- What works (and why, from player reception)
- What doesn't work (common complaints)
- What's overdone (generic solutions to avoid)
- What's underexplored (gaps in the market)

**Anti-generic checklist — after research, verify your design is NOT:**
- [ ] "Health, mana, stamina" without a twist
- [ ] "Kill enemies, get XP, level up" without differentiation
- [ ] "Common, Rare, Epic, Legendary" loot tiers without novel interaction
- [ ] A skill tree that's just "+5% damage" nodes
- [ ] "Weak to fire, strong vs. ice" elemental rock-paper-scissors
- [ ] A crafting system that's just combine-A-with-B
- [ ] Any mechanic where you can say "it's just like [popular game] but..."

If your design triggers any of these, iterate until it doesn't. A design pass is NOT a copy-paste from genre conventions — it's finding the unique spin that makes *this* game's version of the mechanic special.

### Phase 3 — Design Exploration

Based on the interview insights and competitive research, generate **2-3 distinct design approaches** for the mechanic. Each approach must differ in at least one fundamental way (not just tuning numbers).

For each approach, present:
- **Name:** A short label (e.g., "Risk-Reward Gambit", "Deterministic Mastery", "Emergent Sandbox")
- **Core idea:** 2-3 sentences
- **Player experience:** What does it feel like?
- **Key differentiator:** What makes this NOT generic?
- **Risk:** What's the biggest uncertainty?

Present all approaches and ask:

> "Which direction resonates most? You can also mix elements — take the core from A but the progression from B."

### Phase 4 — Deep Design

With the chosen direction, design the mechanic in full detail. This is where the knowledge library is actively applied.

**Design the following aspects** (tailor to the mechanic type — not every section applies to every design):

#### For Rule/System Mechanics (damage formulas, stat systems, economy):
- **Variables:** Every tunable number with its name, type, and initial value
- **Formulas:** Explicit mathematical expressions (not prose — code-ready)
- **Balancing bounds:** Min/max values, expected ranges at different progression points
- **Edge cases:** What happens at zero? At cap? With negative values? When two effects conflict?
- **Scaling:** How do values change over the course of the game? Linear? Exponential? Diminishing returns?

#### For Behavioral Mechanics (AI, enemy patterns, level generation):
- **States/behaviors:** Finite state machine or behavior tree description
- **Transitions:** What triggers a state change?
- **Parameters:** Tunable knobs (aggression, speed, awareness radius, etc.)
- **Player feedback:** How does the player read what the AI is doing? (telegraphing, tells, audio cues)
- **Variation parameters:** How to create variety with the same system

#### For Interaction Mechanics (controls, abilities, items):
- **Input:** What does the player press/click/tap? What's the input window?
- **Response:** What happens immediately? What happens over time?
- **Feel specification:** For real-time actions: timing windows, acceleration curves, hit-stop duration, screen shake intensity, sound triggers (reference: *Game Feel*)
- **Constraints:** Cooldowns, resource costs, range limits, targeting rules
- **Feedback layers:** Visual, audio, and haptic feedback at each stage (anticipation → action → impact → resolution)

#### For Progression Mechanics (leveling, unlocks, meta-systems):
- **Curve shape:** The progression function (linear, exponential, logarithmic, S-curve)
- **Gates:** What blocks the player from advancing too fast?
- **Pacing:** How long between meaningful progression beats?
- **Catch-up:** Is there a mechanism for players who fall behind?
- **Mastery vs. grind:** Does progression reward skill or time investment? (reference: *A Theory of Fun*)

### Phase 5 — Senior Review Preparation (Self-Review)

Before writing the document, perform a self-review as if you were @Hag:

- **Distinctiveness check:** Would a player who's played this genre say "I've never seen this before" about any aspect?
- **Implementation clarity:** Can Angel read this and write the code without asking "but what should happen when...?"
- **Alignment check:** Does this mechanic serve the player fantasy defined in `game-concept.md`?
- **Complexity budget:** Is the complexity proportional to the mechanic's importance? (A core combat mechanic can be complex; a shop menu shouldn't be.)
- **Edge case coverage:** Did you define behavior for the 3 most likely edge cases?

Fix any issues before proceeding. If the design is too generic, return to Phase 2 and do more research.

### Phase 6 — Write the Design Document

Write to `.docs/design/<mechanic-slug>.md`. Use kebab-case for slugs (e.g., `damage-formula.md`, `enemy-ai-behaviors.md`, `shop-economy.md`).

**Document structure** (follow this exactly):

```markdown
# [Mechanic Name] — Design Document

**Status:** Draft
**Task:** <task-id>
**Date:** YYYY-MM-DD
**Game:** <from game-concept.md title>
**Related Docs:** <links to related design docs, game-concept.md, glossary entries>

## 1. Design Intent
> 2-3 sentences on what this mechanic should achieve for the player experience.

## 2. Player Experience
> Walk through the mechanic from the player's perspective. What do they see, hear, feel? What decisions do they make? What feedback do they receive?

## 3. Design Theory
> Cite 2-5 books/lenses from the Knowledge Library and explain how they informed specific decisions. Example:
> - **Game Feel (Book 6):** The parry window is set to 200ms because Swink's research shows this is the sweet spot for "tight but fair" action responses.
> - **A Theory of Fun (Book 4):** The damage formula uses diminishing returns on stacking to ensure the player must grok new patterns rather than repeating the same optimal rotation.

## 4. Competitive Context
> What did the research in Phase 2 reveal? What are the existing solutions, and how does this design differ?
> - **Benchmark:** [Game X] handles this by [approach]. Strengths: [...]. Weaknesses: [...].
> - **Our differentiation:** [What's different and why]

## 5. Specification
> The concrete, implementable design. Use sub-sections appropriate to the mechanic type:

### 5.1 Variables & Configuration
| Variable | Type | Default | Min | Max | Description |
|----------|------|---------|-----|-----|-------------|
| `base_damage` | float | 10.0 | 0 | — | Raw damage before modifiers |

### 5.2 Mechanics / Rules
> Step-by-step rules in unambiguous language. Use bullet points, numbered steps, or pseudocode.

### 5.3 Edge Cases
> What happens when:
> - [Edge case 1] → [Expected behavior]
> - [Edge case 2] → [Expected behavior]

### 5.4 Balancing Notes
> Initial values and the reasoning behind them. How to tune. What levers exist.

## 6. Integration
> How does this mechanic connect to other systems?
> - **Input from:** [systems that feed into this one]
> - **Output to:** [systems this one affects]
> - **Glossary terms:** [new or updated terms to add to glossary.md]

## 7. Implementation Notes
> Guidance for @Angel (programmer) and @Jack (GUI):
> - Where in the project structure this should live
> - Which existing systems to hook into
> - Performance considerations (if any)
> - What CAN be deferred (MVP vs. polish)

## 8. Playtest Questions
> What should we test to validate this design?
> - [Falsifiable question 1]
> - [Falsifiable question 2]
```

### Phase 7 — Update Glossary

After writing the design document, update `.docs/glossary.md` with any new terms introduced. If a term modifies an existing definition, note the change. Always maintain a single source of truth for terminology.

### Phase 8 — Push, PR, and Complete (Kanban Delivery)

Follow the `/task-execution` skill for the git workflow:

1. Authenticate with `gh`
2. Sync from main: `git checkout main && git pull origin main`
3. Create branch: `git checkout -b task/<task-id>`
4. Commit: `git add .docs/design/<slug>.md .docs/glossary.md && git commit -m "<task-id>: design <mechanic-name>"`
5. Push: `git push -u origin task/<task-id>`
6. Open PR: `gh pr create --base main --head task/<task-id> --title "[<Project>] <task-id>: Design <mechanic-name>" --body-file /tmp/pr_body.md`
7. **Report PR number redundantly:**
   - `kanban_comment` with PR URL + summary of design + key decisions
   - `kanban_complete` summary: "PR #N — Designed <mechanic-name>. Awaiting senior review by @Hag."
   - `kanban_complete` metadata with `pr_number`, `pr_url`, `design_doc` path

### Phase 9 — Senior Review (@Hag)

As @Hag, I review the design document PR. My evaluation criteria:

- **Anti-generic check:** Is this design genuinely differentiated from genre conventions? (If any anti-generic checklist item is triggered, it's NEEDS REVISION.)
- **Research depth:** Were at least 3 competitive searches performed? Are the findings reflected in the Competitive Context section?
- **Theory application:** Are 2-5 books cited with genuine influence on the design? (Cargo-cult citations without real impact = NEEDS REVISION.)
- **Implementation readiness:** Can Angel implement this without guessing? Are edge cases covered?
- **Alignment:** Does this serve the player fantasy in `game-concept.md`?
- **Completeness:** All 8 sections filled with meaningful content (not placeholder text).

**Verdict:** APPROVED or NEEDS REVISION.

---

## Common Pitfalls

1. **Skipping competitive research.** The #1 cause of generic design. You must perform at least 3 web searches before designing anything. "I already know this genre" is not a valid excuse — the market moves fast, and your knowledge may be stale.

2. **Citing books without applying them.** Listing "The Art of Game Design" in the Design Theory section without explaining which lens and how it shaped a decision is cargo-culting. Each citation must connect to a specific design choice.

3. **Designing in a vacuum.** Always cross-reference `game-concept.md`, `glossary.md`, and `decisions.md`. A brilliant mechanic that contradicts the player fantasy is wrong.

4. **Prose instead of specifications.** "The player feels powerful" is not a spec. "When the player lands a critical hit, the damage number appears 2x larger, pulses gold, and the screen shakes for 0.1s at intensity 3" is a spec.

5. **No edge cases.** The difference between a junior and senior designer is edge case thinking. What happens at zero health? What if two effects trigger simultaneously? What if the player sequence-breaks?

6. **Over-designing for a solo indie dev.** Alex is a solo developer. A mechanic that requires 200 hours of animation work is wrong no matter how elegant the design. Flag scope concerns explicitly.

7. **Not updating the glossary.** New terms introduced in the design doc must be added to glossary.md in the same PR. Terminology drift kills projects.

8. **Writing the document before the interview.** Phase 1 (interview) always comes before Phase 6 (write). The user's intent shapes the design, not the other way around.

9. **Designing for the designer, not the player.** A mechanically elegant system that players won't understand or engage with is a failure. The Player Experience section (Section 2) is the most important — if that section is weak, the whole design is weak.

---

## Verification Checklist

- [ ] Task context loaded (game-concept, glossary, decisions, roadmap)
- [ ] Phase 1: Design discovery interview completed (all 5 questions)
- [ ] Phase 2: At least 3 competitive web searches performed and documented
- [ ] Phase 2: Anti-generic checklist verified — no items triggered
- [ ] Phase 3: 2-3 distinct design approaches presented and user chose direction
- [ ] Phase 4: Full specification written (variables, rules, edge cases, balancing)
- [ ] Phase 5: Self-review passed (distinctiveness, clarity, alignment, complexity, edges)
- [ ] Phase 6: Design document written to `.docs/design/<slug>.md` with all 8 sections
- [ ] Phase 7: Glossary updated with new terms
- [ ] Phase 8: PR created with task-execution workflow (branch `task/<id>`, PR with body)
- [ ] Phase 8: Redundant PR reporting (comment + summary + metadata)
- [ ] Design document is implementable by @Angel without guesswork
- [ ] Design Theory section cites 2-5 books with genuine influence, not cargo-culting
- [ ] Competitive Context section reflects actual research findings
