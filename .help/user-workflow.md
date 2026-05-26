# Workflow

Key considerations:
- Every document must use clear terms that are present in the `glossary.md` to avoid ambiguity.
- When an art asset is needed, the agent should use the subagent `ph-creator` to generate a placeholder image with a descriptive filename, and place it in the `src/Game/Art/_Placeholders` folder. The agent should then reference this asset in the code or scene as needed.


1. **Start**:
  - Run `/start [genre, theme, idea, or concept]` to define what the game is.
  - **Output**: A concise `game-concept.md` file outlining the elevator pitch, player fantasy, core mechanics, and unique features. The game concept must already have terms for key domain entities and systems to avoid ambiguities in later stages.

2. **Glossary**:
  - Run `/glossary` to identify key domain terms and concepts.
  - **Output**: A `glossary.md` file with definitions for important game-specific terminology.

3. **Prototype (Optional)**:
  - Run `/prototype [feature or system name]` to fill in or update the current milestone with prototypes if needed.
  - **Output**: A `milestones.md` file with a roadmap of major features and development phases, including any optional prototypes for testing specific mechanics or ideas.

3. **Milestones**:
  - Run `/milestone` to fill in or update the current milestone.
  - **Output**: A `milestones.md` file with a roadmap of major features and development phases.
  