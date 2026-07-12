---
name: risk-assessment
description: 'Identify gameplay risks and create a structured risk analysis from the game concept. Use when: analyzing risks and uncertainties in the game design, creating .docs/risks.md, or invoking /risk-assessment. Part of the Agentic Gamedev Process pre-production phase. Runs after /game-concept and before /prototype.'
argument-hint: '[optional: specific area of concern, or blank to assess all risks]'
user-invocable: true
---

# /risk-assessment — Gameplay Risk Analysis

## Overview

Identifies gameplay risks from the game concept — mechanics, feel, or systems that are unproven and could sink the game if wrong. Through a relentless grill-me interview, surfaces uncertainties, formulates testable prototype questions, and writes `risks.md` following the template in `.agents/templates/risks-template.md`.

Part of the Agentic Gamedev Process (Pre-production phase). Runs after `/game-concept` and before `/prototype`.

## When to Use

- User invokes `/risk-assessment`
- A game concept exists (`.docs/game-concept.md`) and risks need to be surfaced
- The user wants to identify what to prototype first
- Do NOT use without a game concept — point the user to `/game-concept` first

## Workflow

### 1. Load Context

- Read `.agents/templates/risks-template.md` as the output schema.
- Read `.docs/game-concept.md`. If it doesn't exist, stop and tell the user: "No game concept found. Run `/game-concept` first — I need a concept to assess risks against."
- Read `.docs/glossary.md` if it exists; use consistent terminology.
- If `.docs/decisions.md` exists, scan for prior decisions that may constrain or inform risk analysis.

### 2. Categorize Risk Domains

Based on the game concept, mentally categorize potential risks into these domains. This is an internal framework — do NOT present a form to the user:

| Domain | What to Probe |
|--------|---------------|
| **Core Feel** | Is the moment-to-moment action intrinsically fun? Does the primary verb (shoot, jump, match, build) feel satisfying? |
| **Core Loop** | Is the repeatable cycle compelling after 100+ iterations? Does the feedback loop hold attention? |
| **Novel Mechanic** | Is the unique twist actually fun, or just novel? Has anything similar been proven elsewhere? |
| **Balance & Tuning** | Are there numeric ranges where the game breaks? Is difficulty progression controllable? |
| **Procedural / Systemic** | Will generated content produce interesting variety, or repetitive noise? Do systems interact in unpredictable ways? |
| **Scope & Feasibility** | Is anything in the concept beyond solo-indie capacity? Are there unknown technical hurdles? |
| **Player Understanding** | Will players understand what to do without explanation? Is the mental model clear? |

### 3. Interview — Grill the Concept

Use the `/grill-me` approach: ask relentlessly, one question at a time, walking down every branch of the risk tree. For each question, provide a recommended answer.

**Opening prompt:**

> "I'm going to grill you on the risks in this concept. For each risk domain, I'll ask what could go wrong, why it matters, and how we'd know if we solved it. I'll recommend answers — push back if I'm wrong. Ready?"

Then walk through each relevant domain. For each domain:

1. **Surface the risk:** "In [domain], what's the most likely thing to go wrong? I think it might be [recommendation]."
2. **Probe severity:** "If that fails, does the game still work? Scale of 1-10, how central is this?"
3. **Formulate the question:** "So the prototype question would be: 'If the player [action], will they feel [emotion] — evidenced by [signal]?' Does that capture it?"
4. **Define success:** "What would a pass look like? What signal tells us this is solved?"

**Skip domains that don't apply.** If the concept has no procedural generation, skip the Procedural/Systemic domain. Don't force risks where there are none.

**Cap at 5 risks maximum.** If more than 5 surface, ask: "Which of these are the top 5 by impact × uncertainty?" Prioritize ruthlessly.

### 4. Prioritize

After all risks are identified, present the prioritization table from the template. Rank by impact × uncertainty:

> "Here's the prioritization. Prototype the highest-impact, highest-uncertainty risks first. Does this order look right?"

Confirm the final ordering with the user.

### 5. Assign Prototype Paths

For each risk, recommend a prototype path based on what the question is testing:

| Question Tests | Recommended Path |
|----------------|------------------|
| Feel, juice, game feel | **Engine** (Godot) — need real-time input and feedback |
| Rules, balance, numbers | **Paper** — spreadsheet, tabletop sim, or manual calculation |
| Logic, systems, generation | **HTML/JS** — fast iteration, no engine overhead |

Confirm each path with the user.

### 6. Review Before Writing

Evaluate the risk analysis against these criteria. Present concerns and iterate:

- **Testability:** Is every prototype question answerable with a concrete signal? Vague questions produce vague prototypes.
- **Impact honesty:** Are we calling low-impact risks high-impact? Be ruthless.
- **Coverage:** Did we miss any domain that's critical to this specific concept?
- **Actionability:** Can someone read this and immediately know what prototype to build?

### 7. Write the Document

Write to `.docs/risks.md`. Follow `.agents/templates/risks-template.md` exactly. Create the `.docs/` directory if it doesn't exist.

### 8. Report Completion

Return a summary including:

- Number of risks identified
- Top-priority risk (one sentence)
- The path to the written document
- Next steps: "Run `/prototype` for each risk in priority order, starting with Risk 1."

## Common Pitfalls

1. **Assessing without a concept.** The skill requires `.docs/game-concept.md`. Don't proceed without it.
2. **Risks as feature requests.** "We need better graphics" is not a gameplay risk. Risks must be about unproven mechanics or feel.
3. **Vague prototype questions.** "Is the game fun?" is untestable. Every question must have a concrete signal.
4. **Too many risks.** Cap at 5. More than that and you're listing anxieties, not risks.
5. **Skipping the grill.** A superficial interview produces superficial risks. Grill relentlessly.
6. **Wrong prototype path.** Don't recommend an engine prototype for a balance question, or a paper prototype for a feel question.
7. **Not updating decisions.** If a risk assessment leads to a design decision, record it in `.docs/decisions.md`.

## Verification Checklist

- [ ] Template loaded: `.agents/templates/risks-template.md`
- [ ] Game concept loaded: `.docs/game-concept.md`
- [ ] Glossary loaded if available
- [ ] Risk domains categorized internally
- [ ] Grill-me interview completed for each relevant domain
- [ ] Risks capped at 5 maximum
- [ ] Prioritization table confirmed with user
- [ ] Prototype paths assigned and confirmed
- [ ] Review criteria checked and feedback incorporated
- [ ] Output written to `.docs/risks.md`
- [ ] Decisions updated if any were made
- [ ] Next steps reminder included
