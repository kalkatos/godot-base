---
name: create-concept
description: Generate .docs/game-concept.md from a finite interview using the project template. Use when user asks to create a game concept, fill game-concept.md, define game identity, or run a concept interview.
argument-hint: Briefly describe the game idea to seed draft options (optional).
---

# Create Concept

Create or update `.docs/game-concept.md` using the structure and constraints from `.agents/docs/game-concept-template.md`.

## When To Use

- User asks for a new game concept document.
- User wants to fill `.docs/game-concept.md` via guided interview.
- User has a rough idea and needs multiple draft options per section.

## Inputs And Required Files

- Template source: `.agents/docs/game-concept-template.md`
- Output file: `.docs/game-concept.md`
- Terminology reference: `.docs/glossary.md`

If `.docs/glossary.md` is missing, notify the user and continue. Use explicit terms anyway and list terms that should be added to the glossary in a short note at the end of the generated concept.

## Finite Interview Flow

Run exactly 8 questions, in order. Do not ask additional discovery questions unless the user explicitly requests deeper iteration.

For each question:

1. Present exactly 3 draft options labeled `A`, `B`, `C`.
2. Ensure options are meaningfully different in tone, scope, or design direction.
3. Ask the user to choose one option or provide a custom answer.
4. If user gives custom input, keep it, provide one concise polished rewrite for confirmation, then move to next question.

Questions:

1. Working title and high-level genre direction.
2. Perspective and player count.
3. Target platform and session length expectation.
4. Elevator pitch (2 to 3 sentences).
5. Player fantasy statement.
6. Core mechanics (moment-to-moment loop).
7. Unique features and differentiation.
8. References and further notes (including constraints).

## Option Generation Rules

For every question, generate options that are concrete and usable as-is:

- Include explicit nouns and verbs (avoid vague phrases like "fun gameplay").
- Keep each option short: 1 line for metadata questions, up to 3 lines for narrative fields.
- Use unambiguous terms that can be mirrored in `.docs/glossary.md`.
- Avoid repeating the same concept with minor wording changes.
- Keep options aligned with the selected concept direction from earlier answers while still offering adjacent variations.

## Language Behavior

- Match the user's language for questions, options, confirmations, and final summary.
- Preserve domain terms consistently; if a term should remain in a specific language for clarity, keep it stable and mention it in glossary notes.

## Assembly Rules For `.docs/game-concept.md`

After question 8, compile the document with the same section order and headings from the template:

1. Game Identity
2. Elevator Pitch
3. Player Fantasy
4. Core Mechanics
5. Unique Features
6. References
7. Further Notes

Formatting requirements:

- Preserve concise style: 1 to 3 bullets per section when applicable.
- Keep elevator pitch to 2 to 3 sentences.
- Ensure all terms are clear and consistent.
- Replace all placeholders; no bracketed template text may remain.

## Completion Checks

Before saving, verify all checks pass:

- Exactly 8 interview answers were collected.
- Every section in template exists in the output.
- No unresolved placeholders remain.
- At least 3 core mechanics bullets exist.
- At least 2 unique features exist.
- References include what is borrowed from each reference.

If any check fails, run one compact repair pass by asking only targeted follow-up prompts for missing fields.

## Save Behavior

- Write the final content to `.docs/game-concept.md`.
- If the file already exists, overwrite it only after confirming with the user.
- After save, present a short summary:
  - The selected concept direction.
  - Terms that should be added to `.docs/glossary.md`.
  - Optional next step: create milestones in `.docs/milestones.md`.

## Response Style During Interview

- Keep each question concise.
- Always show options `A`, `B`, `C` before asking for selection.
- Support quick replies like `A`, `B with changes`, or freeform.
- Maintain momentum: one question at a time, no batching multiple questions in one turn.
- After custom replies, show one polished rewrite and ask for quick confirm before continuing.
