# User Manual

Key considerations:
- Every document must use clear terms that are present in the `glossary.md` to avoid ambiguity.
- When an art asset is needed, the agent should use the subagent `ph-creator` to generate a placeholder image with a descriptive filename, and place it in the `src/Game/Art/_Placeholders` folder. The agent should then reference this asset in the code or scene as needed.


1. **Start**:
  - Run `/start [genre, theme, idea, or concept]` to define what the game is.
  - **Argument**: A short description of the game idea, genre, theme, or concept to kickstart the project. For example: "top-down roguelike set in a cyberpunk city where players control a hacker with unique abilities." You may also reference a custom document with the game.
  - **Output**: A concise `game-concept.md` file outlining the elevator pitch, player fantasy, core mechanics, and unique features.

2. **Glossary**:
  - Run `/glossary` to identify key domain terms and concepts.
  - **Argument**: Not required.
  - **Output**: A `glossary.md` file with definitions for important game-specific terminology.

3. **Prototype (Optional)**:
  - Run `/prototype [feature or system name]` to fill in or update the current milestone with prototypes if needed.
  - **Argument**: The name of a specific feature, mechanic, system, or idea that requires prototyping. For example: "core combat mechanic", "shield system", "enemy AI behavior", "level layout", etc.
  - **Output**: A `roadmap.md` file with a roadmap of major features and development phases, including any optional prototypes for testing specific mechanics or ideas.

3. **Milestones**:
  - Run `/milestone` to fill in or update the current milestone.
  - **Argument**: Not required.
  - **Output**: A `roadmap.md` file with a roadmap of major features and development phases.
  