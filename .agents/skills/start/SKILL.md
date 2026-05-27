---
name: start
description: "Guided game concept ideation — from zero idea to a structured game concept document. Uses professional studio ideation techniques, player psychology frameworks, and structured creative exploration."
argument-hint: "[genre or theme hint, or 'open']"
user-invocable: true
---

When this skill is invoked:

1. Parse the argument for an optional genre or theme hint.
   - If `open` or no argument is provided, start from scratch.

2. Resolve local source documents before questioning.
   - Read `.agents/docs/game-concept-template.md` as the single output schema.
   - Read `.docs/glossary.md` and enforce term consistency in concept language.
   - If `.docs/glossary.md` is missing, create it when the first term needs definition.
   - If `.docs/game-concept.md` exists, resume and refine rather than restart.

3. Interview the user to confirm creative anchors and constraints about the topics below, which will guide the concept generation and prevent generic outputs. For each topic, await user answers before proceeding:
     1. Tone
     2. Session Length
     3. Meta Progression Weight
     4. Inspiration
     5. Core Twist
   - These five are mandatory because they are the minimum high-impact decision set that prevents generic output and anchors the template:
     - Tone anchors language for Elevator Pitch, Player Fantasy, and Further Notes.
     - Session Length anchors pacing constraints for Core Mechanics, Core Loop, and Further Notes.
     - Meta Progression Weight is a major structural decision and must be confirmed, not inferred.
     - Inspiration provides an initial creative direction for the whole concept and fills in References.
     - Core Twist defines differentiation for Unique Features and the central pitch sentence.
   - Follow with identity confirmation questions (Perspective, Target Platform, Player Count) to complete Game Identity.
   - Rationale: this sequence gathers the smallest decisive set first, keeps ideation short, and satisfies the requirement to avoid unconfirmed major assumptions.

4. Generate three distinct concept directions and get explicit user selection.
   - Propose exactly 3 clearly different ideas based on the confirmed anchors.
   - Keep each idea brief (title + 2 to 4 bullets).
   - Prompt the user to choose one direction, or customize by mixing elements across ideas using an open-text response.
   - Do not proceed to drafting until the user confirms the final direction.

5. Run collaborative ideation to define the core loop.
   - Use the chosen concept direction as a reference point.
   - Ask targeted questions to define the core loop steps, player actions, and feedback.
   - A core loop is a bullet-point list of the main player actions, feedback, and progression that creates the primary gameplay experience.
   - Ensure the core loop is distinct and not generic (e.g., "explore, fight, loot" is too generic without a twist).
   - Confirm the core loop with the user before proceeding.

6. Build the concept using the template exactly.
   - The working title must be a one word descriptor that captures the theme, core twist, or tone, the more evocative the better. (e.g., "Summer", "Heist", "Prism").
   - Output must contain only these sections, in this order:
     1. Game Identity
     2. Elevator Pitch
     3. Player Fantasy
     4. Core Mechanics
     5. Core Loop
     6. Unique Features
     7. References
     8. Further Notes
   - Keep each section brief: 1 to 3 bullets where possible.
   - Use clear and unambiguous terminology aligned to `.docs/glossary.md`.
   - Do not add extra sections such as MDA tables, player taxonomy, technical feasibility gates, or pipeline checklists unless explicitly requested.
   - If the user provided one or more source documents with existing content, add references to them in the Further Notes section.

7. Write the final document to `.docs/game-concept.md`.
   - Create directories lazily only if needed.
   - Preserve concise style and template heading names.

8. Return a short completion summary.
   - Include: working title, one-sentence pitch, and written path.
   - Include a reminder of the next recommended skill from the workflow, if applicable.

Guardrails:
- This skill is self-contained for this repository.
- If the user asks for richer downstream docs, suggest separate follow-up skills after concept write is complete.
