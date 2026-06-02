---
name: prototype
description: "Use when you need to build a throwaway prototype to test a specific gameplay risk. @Brute (prototyper): builds fast, dirty prototypes to validate or refute risks identified in risks.md. Produces a playable build and a PROCEED/PIVOT/KILL verdict."
user-invocable: true
---

# /prototype — Risk Validation Prototype

## Overview

This skill builds throwaway prototypes to test specific gameplay risks identified in `risks.md`. As **@Brute (prototyper)**, your job is to build fast, answer a single question, and throw the code away. The prototype exists to validate or refute a risk, not to become production code.

This is step 5 of the Agentic Gamedev Process (Pre-production phase). You run once per risk, in priority order.

## Prototyper Philosophy

You are a collaborative implementer, not an autonomous code generator. The user approves all decisions. Your job is to answer design questions with running software, not build production systems.

**Core rules:**
- Prototype code is disposable. It informs production, it does not become production.
- Build only what answers the question. Ruthlessly cut scope.
- If a prototype takes more than 2 hours without reaching playable state, stop — the scope is too large or the question is wrong.
- 3 PIVOT iterations on the same concept → force a KILL consideration.

## When to Use

- After `/analyze-risks` has produced `risks.md` with identified risks
- When you need to test whether a specific mechanic actually works
- For one risk at a time, in priority order from risks.md
- Do NOT use without risks.md — you need a clear question to answer

## Phase 1: Load the Risk

### 1.1 Read risks.md

Find the next untested risk in `.docs/risks.md` (the highest priority one not yet prototyped).

### 1.2 Confirm the Risk

Read the risk's prototype question aloud to the user:

> "I'll prototype: **Risk [N]: [Name]** — '[prototype question]'. The recommended path is **[Engine/HTML/Paper]**. Is this the right risk to test first?"

If the user wants to test a different risk, switch to that one.

### 1.3 Confirm the Hypothesis

Make sure the prototype question is a **falsifiable hypothesis**:

> "If the player [does X], they will feel [Y] — we will know this is true if [measurable signal Z]."

Good: "If the player parries with precise timing, they will feel powerful — we'll know if playtesters voluntarily parry more than dodge after 10 minutes."
Bad: "Is combat fun?" — not falsifiable.

If the question is vague, work with the user to sharpen it. A prototype without a clear question wastes time.

### 1.4 Identify the Riskiest Assumption

Ask: "What is the single biggest assumption in this mechanic that could make it not work? That's the first thing to test — not the easiest thing, the riskiest."

---

## Phase 2: Choose the Prototype Path

If the risk already has a path recommendation, confirm it. Otherwise, select based on what the question is testing:

| Question type | Path | Reliability |
|--------------|------|-------------|
| Game feel, timing, physics, action | **Engine** | 50-60% one-shot (2-4 iterations normal) |
| Logic, rules, turn-based systems | **HTML** | 85-90% one-shot |
| Strategy, economy, progression, rulesets | **Paper** | 100% |

**Engine path** — for action games, platformers, physics. Write code → user runs in engine → reports errors → fix → repeat. Sunk cost: if 2+ hours without playable state, reframe or switch paths.

**HTML path** — for puzzle, card, turn-based, idle games. Write a single self-contained `.html` file. Must open by double-clicking, no server. **Do NOT use for action games** — browser latency (50-133ms) lies about feel.

**Paper path** — for strategy, economy, board game-style mechanics. Write `rules.md` and `play-log.md`. Cannot validate feel.

Confirm the path with the user:

> "For this risk, I recommend the **[path]** because [reason]. Use this path?"

---

## Phase 3: Plan the Prototype

Define in 3-5 bullet points the minimum viable prototype:

- What is the falsifiable hypothesis?
- What is the absolute minimum needed to answer it?
- What is explicitly CUT? (menus, save systems, error handling, polish, architecture — all of it)

**Scope constraint:** A prototype tests ONE mechanic. If scope covers more than one, cut it down. When in doubt, cut more.

**Do not add polish.** No menus, no game over screens, no music, no UI unless the UI IS the mechanic being tested.

Present the plan. Get user confirmation before building.

---

## Phase 4: Implement

### General Standards (intentionally relaxed)

- Hardcode values freely
- Use placeholder assets (colored rectangles, debug shapes)
- Skip error handling entirely
- Use the simplest approach that works
- No architecture, no patterns, no abstractions
- Every file starts with:
  ```
  // PROTOTYPE - NOT FOR PRODUCTION
  // Question: [Core question being tested]
  // Date: [Current date]
  ```

### Engine Path — Multi-turn Loop

After writing initial code:

> "The prototype files are written. Run the project in your engine now. If there are errors, paste them here and I'll fix them. If it runs, describe what you see."

Iterate:
1. User runs → reports errors or observations
2. Agent fixes errors or adjusts the mechanic
3. Repeat until playable or sunk cost rule triggers (2 hours)

### HTML Path — Single Output

Write a single `prototype.html` to `prototypes/[risk-name]-concept/`. Include all styles, logic, and assets inline.

### Paper Path — Document + Log

Write `prototypes/[risk-name]-concept/rules.md` (game rules) and `prototypes/[risk-name]-concept/play-log.md` (simulated walkthrough of one complete play cycle).

---

## Phase 5: Playtest Debrief

The prototype is built. Hand it to the user and capture what they actually experienced.

First, have them play:

> "The prototype is ready. Play through it as a new player would — not as the developer. Take your time. Come back when you have a feel for it."

Then ask these questions **one at a time**, waiting for each answer:

1. **Hypothesis check:** "The hypothesis was: [restate]. Did it hold up — CONFIRMED, PARTIALLY CONFIRMED, or REFUTED? What did you see?"

2. **Best moment:** "What was the moment — if any — where it felt like it was working? Be specific."

3. **Worst moment:** "What was the most frustrating, confusing, or broken moment? Be specific — not 'it felt slow' but 'the jump took about half a second to respond and I felt like I was fighting the controls'."

4. **Surprise:** "Did anything happen that you didn't expect — good or bad?"

5. **Verdict:** "PROCEED, PIVOT, or KILL — and one sentence why."

If any answer is vague, follow up: "Can you be more specific?"

---

## Phase 6: Generate Prototype Report

Read `.agents/docs/templates/prototype-report.md` for the report structure. Fill in every section based on observations. Write to `prototypes/[risk-name]-concept/REPORT.md`.

Update `prototypes/index.md` (create if it doesn't exist) — append one row: risk name, date, path, verdict, link to REPORT.md.

---

## Phase 7: Senior Reviews

### @Griffin (senior programmer) Review

Evaluate the prototype code:
- Was the right path chosen for the risk?
- Are the results technically valid, or are there confounding factors?
- Is the verdict supported by the technical evidence?

### @Hag (senior game designer) Review

Evaluate the prototype mechanics:
- Does the result validate or refute the design assumption?
- Is the verdict correct based on the playtest debrief?
- Are there any design insights beyond the hypothesis?

Present both reviews to the user before finalizing the verdict.

---

## Phase 8: Summary and Next Steps

### If PROCEED

> "The mechanic works. The risk is validated. [Key finding that supports this]."

- Update `risks.md` to mark this risk as VALIDATED.
- Next step: if more risks remain, run `/prototype` for the next risk. Otherwise, move to Production phase with `/milestone`.

### If PIVOT

Before moving on, capture what to carry forward:

1. "What specifically worked that we should preserve?"
2. "What is the single most important thing to change?"

Write `prototypes/[risk-name]-concept/PIVOT-NOTE.md` with: original hypothesis, what to keep, what to change, revised hypothesis.

> "Next step: run `/prototype` with the revised hypothesis to test the adjusted direction."

Check: if this is the 3rd PIVOT on the same risk, ask: "Three pivots on this concept. Is this the right idea, or are we in the sunk cost trap?"

### If KILL

Confirm the verdict is sound (2+ of these should apply):
- [ ] Core mechanic still unclear after 2+ playtests?
- [ ] No "fun moment" observed in any session?
- [ ] 3+ PIVOT iterations with no improvement?
- [ ] Concept only works when heavily explained?
- [ ] Building this feels like obligation, not excitement?

Document the kill in `prototypes/GRAVEYARD.md`:
```
## [Risk Name] — YYYY-MM-DD
- Kill reason: [specific blocker]
- What worked: [what might be reusable]
- What failed: [specific mechanic/design]
- Next time: [what to try differently]
```

> "Next step: move to the next risk in risks.md, or if this was a critical risk, consider whether the game concept needs revision via `/start`."

---

## Common Pitfalls

1. **Prototyping without a clear question.** If the hypothesis is vague ("is combat fun?"), the prototype will be directionless. Sharpen the question first.
2. **Over-scoping.** A concept prototype tests ONE mechanic. If you're building menus, save systems, or more than one mechanic, you're doing it wrong.
3. **Using HTML for feel-dependent risks.** Browser latency lies. If you're testing whether a jump feels right, HTML won't tell you. Use Engine.
4. **Spending too long on Engine path.** If 2+ hours without playable state, stop. The question or scope is wrong. Reframe or switch to Paper.
5. **Keeping prototype code.** Prototype code is throwaway. Production implementation is written from scratch with proper standards. Never import prototype code into production.
6. **Skipping the playtest debrief.** Building the prototype is only half the work. The structured debrief questions produce the actual data the verdict needs.

## Verification Checklist

- [ ] Risk loaded from risks.md with clear prototype question
- [ ] Hypothesis is falsifiable and measurable
- [ ] Prototype path selected and user confirmed
- [ ] Scope plan confirmed (3-5 bullets, one mechanic only)
- [ ] Prototype built (engine/html/paper as appropriate)
- [ ] Playtest debrief completed (all 5 questions answered)
- [ ] REPORT.md written with real observations (no placeholder text)
- [ ] prototypes/index.md updated
- [ ] @Griffin and @Hag reviews completed
- [ ] Verdict (PROCEED/PIVOT/KILL) documented with evidence
- [ ] risks.md updated with result
- [ ] Next step clearly communicated
