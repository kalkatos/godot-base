---
name: game-concept
description: 'Define a game concept from an elevator pitch. Use when: creating a new game concept document, defining genre/core mechanics/unique selling points, filling in .docs/game-concept.md, or invoking /game-concept. Part of the Agentic Gamedev Process pre-production phase.'
argument-hint: '[elevator pitch or concept idea]'
user-invocable: true
---

# /game-concept — Game Concept Definition

## Overview

Creates a structured game concept document from an elevator pitch. Through a guided interview, confirms creative anchors, generates concept directions, defines the core loop, and writes `game-concept.md` following the exact template in `.agents/templates/game-concept-template.md`.

Part of the Agentic Gamedev Process (Pre-production phase).

## When to Use

- User invokes `/game-concept` with an elevator pitch or concept idea
- A game concept document needs to be created or refined
- Do NOT use without a pitch/idea from the user

## Workflow

### 1. Load Context

- Read `.agents/templates/game-concept-template.md` as the single output schema. The output MUST match this template exactly — all 8 sections, in order, no extra sections.
- If `.docs/market-research-*.md` exists, read the most recent one for audience and competitor context. If none exists, proceed without it.
- Read `.docs/glossary.md` if it exists; enforce term consistency throughout.
- If `.docs/game-concept.md` already exists, ask: "A concept already exists. Refine it or start over?" Act accordingly.

### 2. Interview — Creative Anchors

Ask these questions ONE AT A TIME. Wait for an answer before asking the next. Recommend an answer with each question.

**Mandatory (5):**

1. **Tone:** "What tone should this game have? (e.g., dark and oppressive, lighthearted and whimsical, tense and atmospheric, silly and chaotic)"
2. **Session Length:** "How long should a typical play session be? (e.g., 5-minute bursts, 20-30 minute runs, 1-2 hour sessions)"
3. **Meta Progression:** "How much meta-progression should the game have? (e.g., none — pure skill, light — a few unlocks, heavy — lots of progression systems)"
4. **Inspiration:** "What game, film, book, or experience most inspires the feel of what you want to create? What specifically do you want to capture from it?"
5. **Core Twist:** "What is the ONE thing that makes this game different from everything else in its genre?"

**Identity (3):**

- **Perspective:** "What perspective? (e.g., top-down, side-scrolling, first-person, isometric)"
- **Target Platform:** "What's the primary target platform? (e.g., PC, mobile, console)"
- **Player Count:** "Single-player, local co-op, or online multiplayer?"

### 3. Generate Three Concept Directions

Based on the confirmed anchors and pitch, generate **exactly 3 distinct concept directions**. Each must be clearly different from the others. Present each with:

- A working title (single evocative word: e.g., "Prism", "Heist", "Summer")
- 2-4 bullet points capturing the core idea

Ask the user to choose one or customize by mixing elements across ideas.

### 4. Define the Core Loop

Using the chosen concept direction, define the core loop:

> "Walk me through one complete cycle of gameplay. What does the player do repeatedly — action, feedback, and progression — in a 5-minute slice?"

- The core loop must be distinct, not a generic genre template.
- Confirm the final core loop with the user before proceeding.

### 5. Build the Concept Document

Build the concept following `.agents/templates/game-concept-template.md` exactly. The output MUST contain ONLY these 8 sections, in this order:

1. **Game Identity** — working title (single evocative word), genre, perspective, player count, target platform
2. **Elevator Pitch** — 1-2 sentences summarizing what the player does and why it's compelling
3. **Player Fantasy** — who the player feels like and why it's compelling
4. **Core Mechanics** — bullet list of main actions and interactions the player repeats
5. **Core Loop** — bullet list of the primary cycle of actions, feedback, and progression
6. **Unique Features** — standout ideas, twists, or combinations that make this distinct
7. **References** — games/films/books with notes on what is borrowed from each
8. **Further Notes** — additional thoughts, constraints, or ideas

Rules:

- Keep each section brief: 1-3 bullets where possible
- Use clear, unambiguous terminology aligned to `.docs/glossary.md`
- Do NOT add extra sections beyond the 8 listed above — the template is the contract
- The working title must be a single evocative word

### 6. Review Before Writing

Evaluate the concept against these criteria. Present any concerns to the user and iterate before writing:

- **Distinctiveness:** Is the core twist genuinely different from existing games, or is this a reskin?
- **Coherence:** Do mechanics, loop, and fantasy align into a cohesive experience?
- **Scope:** Is this concept feasible for a solo indie developer? Flag anything overly ambitious.
- **Completeness:** Are all 8 sections filled with meaningful content?

### 7. Write the Document

Write to `.docs/game-concept.md`. Create the `.docs/` directory if it doesn't exist. Update `.docs/glossary.md` with any new terms introduced.

### 8. Report Completion

Return a summary including:

- Working title
- One-sentence elevator pitch
- The path to the written document
- Next steps: "Optional: `/risk-assessment` to identify gameplay risks, then `/prototype` to test core mechanics."

## Common Pitfalls

1. **Skipping creative anchors.** Without the five mandatory questions, the concept will be generic. Don't skip any.
2. **Generating samey directions.** The three concept directions must be genuinely different, not variations on the same idea.
3. **Generic core loop.** "Explore, fight, collect" is a genre template, not a core loop. Dig deeper.
4. **Over-writing.** Each section should be 1-3 bullets. This is a concept document, not a GDD.
5. **Template drift.** Adding extra sections or rearranging the 8 template sections. Follow the template exactly.
6. **Not updating the glossary.** New terms must be defined in `.docs/glossary.md` for consistency.

## Verification Checklist

- [ ] Template loaded: `.agents/templates/game-concept-template.md`
- [ ] Market research loaded if available
- [ ] Five creative anchors confirmed with user
- [ ] Identity questions (perspective, platform, player count) answered
- [ ] Three distinct concept directions presented and one chosen
- [ ] Core loop defined and confirmed
- [ ] All 8 concept sections filled with meaningful content (no extras, no omissions)
- [ ] Review criteria checked and feedback incorporated
- [ ] Output written to `.docs/game-concept.md`
- [ ] Glossary updated with new terms
- [ ] Next steps reminder included
