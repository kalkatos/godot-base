---
name: brainstorm
description: "Idea exploration to help the user generate and refine game ideas, art assets, systems, world-building, or narrative concepts."
argument-hint: "describe what you want to brainstorm about"
user-invocable: true
---

<what-to-do>

When this skill is invoked:

1. **Parse the argument** the user provided. If none, ask what they want to brainstorm about before proceeding.

2. **Set the brainstorming goal** based on the user's input. This will guide the ideation process and ensure relevance. Then, write down the goal in a file named [.docs/brainstorm/<YYYY-MM-DD>_<goal>.md] that will be used as a reference throughout the brainstorming process.

3. **Interview** the user relentlessly to understand their needs, constraints, and preferences related to the brainstorming topic. Use open-ended questions to encourage detailed responses.
  - Use `AskUserQuestion` for structured questions with specific options.
  - Use free-text prompts for more exploratory questions that require nuance.
  - Do not make assumptions about the user's needs or preferences without explicit confirmation. Always ask for clarification if something is unclear.
  - Write down key insights from the interview after each question.

4. **Propose next steps** based on the insights gathered from the interview. These steps should be actionable and directly related to the brainstorming goal. Write these steps in the same file as the insights.

</what-to-do>

<supporting-info>

**Use free-form brainstorming techniques** to generate a wide range of ideas related to the topic. This can include:
  - Exploring "what if" scenarios
  - Combining unrelated concepts for novel ideas
  - Offering constraints to established mechanics to spark creativity
  - Building on the user's existing ideas and preferences

**Professional studio brainstorming principles** to follow:
  - Withhold judgment — no idea is bad during exploration
  - Encourage unusual ideas — outside-the-box thinking sparks better concepts
  - Build on each other — "yes, and..." responses, not "but..."
  - Use constraints as creative fuel — limitations often produce the best ideas
  - Time-box each phase — keep momentum, don't over-deliberate early

**Reference (if present)**
- `.docs/game-concept.md`: What this game is about.
- `.docs/glossary.md`: Definitions for key domain terms and concepts.
- `.docs/roadmap.md`: Definitions of major features and development phases.
- `.docs/backlog.md`: Daily task list derived from milestones, with clear and concise descriptions.
the game concept document, the glossary, and any other relevant documents to ensure consistency and build on existing ideas. If the user has a game concept in progress, use it as a springboard for brainstorming related ideas.

</supporting-info>
