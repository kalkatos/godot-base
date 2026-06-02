---
name: start
description: "Use when you need to create a game concept document from an elevator pitch. @Capy (game designer): runs a guided ideation interview, generates concept directions, defines the core loop, and writes game-concept.md."
user-invocable: true
---

# /start — Game Concept Ideation

## Overview

This skill creates a structured game concept document from an elevator pitch. As **@Capy (game designer)**, you guide the user through a creative ideation process — confirming anchors, generating concept directions, defining the core loop, and writing `game-concept.md`.

This is step 3 of the Agentic Gamedev Process (Pre-production phase).

## When to Use

- After `/generate-pitch` has produced `pitch.md`
- When you need to crystallize a pitch into a detailed concept
- Do NOT use without a pitch — the pitch provides the creative direction

## Workflow

### 1. Load Context

- Read `.docs/pitch.md` — this is your primary creative input.
- Read the most recent market research (`.docs/market-research-*.md`) for audience and competitor context.
- Read `.agents/docs/game-concept-template.md` as the single output schema.
- Read `.docs/glossary.md` and enforce term consistency. If missing, create it when the first term needs definition.
- If `.docs/game-concept.md` already exists, resume and refine rather than restarting.

### 2. Interview — Creative Anchors

Interview the user to confirm creative anchors. Ask these five mandatory questions ONE AT A TIME in this order (this is the minimum high-impact decision set that prevents generic output):

1. **Tone:** "What tone should this game have? (e.g., dark and oppressive, lighthearted and whimsical, tense and atmospheric, silly and chaotic)"
2. **Session Length:** "How long should a typical play session be? (e.g., 5-minute bursts, 20-30 minute runs, 1-2 hour sessions)"
3. **Meta Progression:** "How much meta-progression (unlocks, upgrades, persistent progress between runs/sessions) should the game have? (e.g., none — pure skill, light — a few unlocks, heavy — lots of progression systems)"
4. **Inspiration:** "What game, film, book, or experience most inspires the feel of what you want to create? What specifically do you want to capture from it?"
5. **Core Twist:** "What is the ONE thing that makes this game different from everything else in its genre? The twist that makes someone say 'I haven't played anything like this before'."

Follow these with identity confirmation questions:
- **Perspective:** "What perspective? (e.g., top-down, side-scrolling, first-person, isometric)"
- **Target Platform:** "What's the primary target platform? (e.g., PC, mobile, console)"
- **Player Count:** "Single-player, local co-op, or online multiplayer?"

### 3. Generate Three Concept Directions

Based on the confirmed anchors and the pitch, generate **exactly 3 distinct concept directions**. Each must be clearly different from the others. Present each with:
- A working title (evocative one-word: e.g., "Prism", "Heist", "Summer")
- 2-4 bullet points capturing the core idea

Ask the user to choose one or customize by mixing elements across ideas.

### 4. Define the Core Loop

Using the chosen concept direction, define the core loop through targeted questions:

> "Walk me through one complete cycle of gameplay. What does the player do repeatedly — action, feedback, and progression — in a 5-minute slice?"

- The core loop must be distinct and not generic. "Explore, fight, loot" without a twist is not acceptable.
- Confirm the final core loop with the user before proceeding.

### 5. Build the Concept Document

Build `game-concept.md` using the template exactly. The output must contain ONLY these sections, in this order:

1. **Game Identity** — working title, genre, perspective, player count, target platform
2. **Elevator Pitch** — 1-2 sentences from the pitch document
3. **Player Fantasy** — who the player feels like and why it's compelling
4. **Core Mechanics** — bullet list of main actions and interactions the player repeats
5. **Core Loop** — bullet list of the primary cycle of actions, feedback, and progression
6. **Unique Features** — standout ideas, twists, or combinations that make this distinct
7. **References** — games/films/books with notes on what is borrowed from each
8. **Further Notes** — additional thoughts, constraints, or ideas

Rules:
- Keep each section brief: 1-3 bullets where possible
- Use clear, unambiguous terminology aligned to `.docs/glossary.md`
- Do not add extra sections (no MDA tables, player taxonomy, technical feasibility)
- The working title must be a single evocative word

### 6. Senior Review — @Hag

Perform a senior game designer review. Evaluate:

- **Distinctiveness:** Is the core twist genuinely different from existing games, or is this a reskin?
- **Coherence:** Do the mechanics, loop, and fantasy align into a cohesive experience?
- **Scope:** Is this concept feasible for a solo indie developer? Flag anything that seems overly ambitious.
- **Completeness:** Are all 8 sections filled with meaningful content?

If issues are found, present them to the user and iterate before writing.

### 7. Write the Document

Write to `.docs/game-concept.md`. Create the `.docs/` directory if it doesn't exist. Also update `.docs/glossary.md` with any new terms introduced.

### 8. Report Completion

Return a summary including:
- Working title
- One-sentence elevator pitch
- The path to the written document
- Reminder: "Next step: @Capy runs `/analyze-risks` to identify gameplay risks for prototyping."

## Common Pitfalls

1. **Skipping creative anchors.** Without the five mandatory questions, the concept will be generic. Don't skip any.
2. **Generating samey directions.** The three concept directions must be genuinely different, not variations on the same idea.
3. **Generic core loop.** "Explore, fight, collect" is not a core loop — it's a genre template. Dig deeper.
4. **Over-writing.** Each section should be 1-3 bullets. This is a concept document, not a GDD.
5. **Not updating the glossary.** New terms must be defined in the glossary for consistency.

## Verification Checklist

- [ ] Pitch document loaded
- [ ] Five creative anchors confirmed with user
- [ ] Three distinct concept directions presented and one chosen
- [ ] Core loop defined and confirmed
- [ ] All 8 concept sections filled with meaningful content
- [ ] @Hag review completed and feedback incorporated
- [ ] Output written to `.docs/game-concept.md`
- [ ] Glossary updated with new terms
- [ ] Next step reminder included
