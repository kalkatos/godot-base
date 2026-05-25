---
name: create-concept
description: "Guided game concept ideation — from zero idea to a structured game concept document. Uses professional studio ideation techniques, player psychology frameworks, and structured creative exploration."
argument-hint: "[genre or theme hint, or 'open']"
user-invocable: true
---

When this skill is invoked:

1. Parse the argument for an optional genre or theme hint.
   - If open or no argument is provided, start from scratch.
   - Ignore external review-mode files and external gate workflows.

2. Resolve local source documents before questioning.
   - Read [.agents/docs/game-concept-template.md] as the single output schema.
   - Read [.docs/glossary.md] and enforce term consistency in concept language.
   - If [.docs/glossary.md] is missing, create it when the first term needs definition.
   - If [.docs/game-concept.md] exists, resume and refine rather than restart.

3. Run collaborative ideation in short interactive phases.
   - Use AskUserQuestion for constrained choices.
   - Use free-text prompts for nuanced answers.
   - Do not silently invent major decisions without user confirmation.
   - Start with exactly four anchor questions before any drafting:
     1. Tone
     2. Run Length
     3. Meta Progression Weight
     4. Core Twist
   - These four are mandatory because they are the minimum high-impact decision set that prevents generic output and anchors the template:
     - Tone anchors language for Elevator Pitch, Player Fantasy, and Further Notes.
     - Run Length anchors pacing constraints for Core Mechanics and Further Notes.
     - Meta Progression Weight is a major structural decision and must be confirmed, not inferred.
     - Core Twist defines differentiation for Unique Features and the central pitch sentence.
   - Follow with identity confirmation questions (Perspective, Target Platform, Player Count) to complete Game Identity.
   - Rationale: this sequence gathers the smallest decisive set first, keeps ideation short, and satisfies the requirement to avoid unconfirmed major assumptions.

4. Generate three distinct concept directions and get explicit user selection.
   - Propose exactly 3 clearly different ideas based on the confirmed anchors.
   - Keep each idea brief (title + 2 to 4 bullets).
   - Prompt the user to choose one direction, or customize by mixing elements across ideas using an open-text response.
   - Do not proceed to drafting until the user confirms the final direction.

5. Build the concept using the template exactly.
   - The working title must be a one word descriptor that captures the theme, core twist, or tone, the more evocative the better. (e.g., "Summer", "Heist", "Prism").
   - Output must contain only these sections, in this order:
     1. Game Identity
     2. Elevator Pitch
     3. Player Fantasy
     4. Core Mechanics
     5. Unique Features
     6. References
     7. Further Notes
   - Keep each section brief: 1 to 3 bullets where possible.
   - Use clear and unambiguous terminology aligned to [.docs/glossary.md].
   - Do not add extra sections such as MDA tables, player taxonomy, technical feasibility gates, or pipeline checklists.

6. Write the final document to [.docs/game-concept.md].
   - Create directories lazily only if needed.
   - Preserve concise style and template heading names.

7. Return a short completion summary.
   - Include: working title, one-sentence pitch, and written path.

Guardrails:
- This skill is self-contained for this repository.
- Do not reference external template paths outside this repository.
- If the user asks for richer downstream docs, suggest separate follow-up skills after concept write is complete.
