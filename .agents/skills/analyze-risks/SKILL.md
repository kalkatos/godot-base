---
name: analyze-risks
description: "Use when you need to identify gameplay risks that should be tested with prototypes. @Capy (game designer): reads the game concept, analyzes mechanics for uncertainty, and writes risks.md with testable prototype questions."
user-invocable: true
---

# /analyze-risks — Gameplay Risk Analysis

## Overview

This skill identifies and documents gameplay risks that are uncertain or unproven based on the game concept. As **@Capy (game designer)**, you analyze the core mechanics and player fantasy to find what could go wrong — what assumptions haven't been validated, what mechanics might not be fun in practice, what interactions might create friction.

Each risk produces a falsifiable prototype question. These questions drive the prototyping phase.

This is step 4 of the Agentic Gamedev Process (Pre-production phase).

## When to Use

- After `/start` has produced a complete `game-concept.md`
- Before any prototyping begins — risks define what to prototype
- Do NOT use without a game concept — you need something to analyze

## Workflow

### 1. Load Context

- Read `.docs/game-concept.md`. This is mandatory. If it doesn't exist or is incomplete, tell the user to run `/start` first and exit.
- Read `.docs/pitch.md` if available for additional context on the intended player experience.
- Read `.docs/glossary.md` and enforce term consistency.

### 2. Analyze the Core Mechanics

Go through each core mechanic from the game concept and ask:

- **Is this mechanic proven in other games?** If yes, the risk is lower (but the combination might be novel).
- **Does this mechanic rely on a specific feel?** Feel-dependent mechanics (combat, movement, timing) are higher risk and need engine prototypes.
- **Is the fun of this mechanic obvious, or is it subtle?** Subtle/complex fun (strategy depth, emergent systems) is higher risk — players might not "get it."
- **Are there hidden interactions?** Mechanics that interact with other systems in non-obvious ways create combinatorial risk.

### 3. Identify Riskiest Assumptions

From the analysis, identify the 3-5 riskiest assumptions. A good risk:

- Is specific, not vague ("Players might not find the shield parry satisfying" not "Combat might not be fun")
- Has a clear test (a prototype can answer it)
- If wrong, would fundamentally undermine the game concept

### 4. Formulate Prototype Questions

For each risk, write a falsifiable prototype question:

> "If the player [does X], they will feel [Y] — we will know this is true if [measurable signal Z]."

Good: "If the player parries an attack with precise timing, they will feel powerful and in control — we'll know if playtesters voluntarily parry more than they dodge after 10 minutes of play."

Bad: "Is combat fun?" — not falsifiable, not measurable.

### 5. Assign Prototype Paths

For each risk, recommend a prototype path:

- **Engine:** The risk involves game feel, timing, physics, or moment-to-moment action. Requires native engine performance.
- **HTML:** The risk involves logic, rules, or turn-based systems. Can be tested in a browser.
- **Paper:** The risk involves strategy, economy, progression, or ruleset balance. Can be simulated by hand.

### 6. Prioritize

Rank risks by impact × uncertainty:
- High impact + high uncertainty = prototype first
- High impact + low uncertainty = prototype if time allows
- Low impact = deprioritize

### 7. Senior Review — @Hag

Before finalizing, perform a senior game designer review. Evaluate:

- Are these risks genuinely unknown, or are they things we already know from existing games?
- Is each prototype question falsifiable and measurable?
- Are the highest-impact risks at the top?
- Are we missing any critical risk that could kill the project?

Present the feedback to the user and incorporate their decisions.

### 8. Write the Document

Read the template at `.agents/docs/templates/risks-template.md` and fill in every section with real analysis. Write to `.docs/risks.md`.

### 9. Report Completion

Return a summary including:
- Number of risks identified
- The top-priority risk and its prototype question
- The path to the written document
- Reminder: "Next step: @Brute runs `/prototype` for each risk in priority order."

## Common Pitfalls

1. **Listing implementation risks instead of gameplay risks.** "The engine might not support X" is an implementation risk, not a gameplay risk. This skill is about whether the design works, not whether the tech works.
2. **Vague prototype questions.** "Test if combat is fun" is useless. Every question must be falsifiable with a measurable signal.
3. **Too many risks.** 3-5 is the sweet spot. If you have 15, you're listing concerns, not risks. Merge related ones.
4. **Skipping the path recommendation.** Each risk needs a path — don't make Brute guess whether to use HTML or Engine.
5. **No prioritization.** If all risks are "high priority," none are. Force-rank them.

## Verification Checklist

- [ ] Game concept loaded and analyzed
- [ ] 3-5 specific, falsifiable risks identified
- [ ] Each risk has a prototype question and path recommendation
- [ ] Risks prioritized by impact × uncertainty
- [ ] @Hag review completed and feedback incorporated
- [ ] Output written to `.docs/risks.md`
- [ ] All template sections filled (no placeholder text)
- [ ] Next step reminder included
