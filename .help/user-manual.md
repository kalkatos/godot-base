# User Manual

Key considerations:
- Every document must use clear terms that are present in the `glossary.md` to avoid ambiguity.
- When an art asset is needed, the agent should use the subagent `ph-creator` to generate a placeholder image with a descriptive filename, and place it in the `src/Game/Art/_Placeholders` folder. The agent should then reference this asset in the code or scene as needed.

### Core Principles

The vision for this workflow is to create a structured, efficient, and collaborative process for game development using the agent. The workflow is designed to be:

- **Opinionated**: There are strict skills to be run at specific times, with specific arguments, and specific outputs. This structure ensures consistency and clarity in the development process.
- **Collaborative**: The agent is a partner in the development process, working at your side to create the game. You are the human in the loop. No full delegation here.
- **Iterative**: Build in cycles of ideation, selection, and refinement. Avoid the waterfall method or one-shot generation.
- **Bite-sized**: Guide the agent to break down the process into small, manageable steps. Avoid overwhelming it with too much information or too many choices at once.
- **Lean**: Focus on the minimum viable output at each stage. Avoid unnecessary steps or over-engineering.

## Core Workflow

1. **Start**:
  - Run `/start [genre, theme, idea, or concept]` to define what the game is.
  - **Argument**: A short description of the game idea, genre, theme, or concept to kickstart the project. For example: "top-down roguelike set in a cyberpunk city where players control a hacker with unique abilities." You may also reference a custom document with the game.
  - **Output**: A concise `game-concept.md` file outlining the elevator pitch, player fantasy, core mechanics, and unique features.

2. **Milestones**:
  - Run `/milestone` to fill in or update the current milestone.
  - **Argument**: Not required.
  - **Output**: A `roadmap.md` file with a roadmap of major features and development phases.

3. **Prototype (Optional)**:
  - Run `/prototype [feature or system name]` to fill in or update the current milestone with prototypes if needed.
  - **Argument**: The name of a specific feature, mechanic, system, or idea that requires prototyping. For example: "core combat mechanic", "shield system", "enemy AI behavior", "level layout", etc.
  - **Output**: TBD

4. **Daily**:
  - Run `/daily` to review current sprint tasks, fill in new tasks, or hand off to the milestone skill when sprints change.
  - **Argument**: Not required.
  - **Output**: The `backlog.md` file filled with a list of tasks for the current sprint.

## Secondary Skills

**Map Systems**:
  - Run `/map-systems` to create a visual map of the game's systems and their interactions.
  - **Argument**: Not required.
  - **Output**: A visual diagram (e.g., flowchart, mind map) that illustrates the game's systems, their relationships, and interactions.

**Scaffold**:
  - Run `/scaffold [feature or system name]` to create a scaffold of code files and folders for a specific feature or system.
  - **Argument**: The name of the feature or system to be scaffolded. For example: "Inventory System", "Combat System", "Dialogue System", etc.
  - **Output**: A structured set of code files and folders in the appropriate location (e.g., `src/Game/Code/`) that provides a starting point for implementing the specified feature or system.

**Brainstorm**:
  - Run `/brainstorm [topic or problem]` to generate ideas, solutions, or approaches for a specific topic or problem in the project.
  - **Argument**: A short description of the topic or problem to brainstorm about. For example: "enemy types and behaviors", "level design ideas for a forest biome", "unique mechanics for the core loop", etc.
  - **Output**: A list of ideas, solutions, or approaches related to the specified topic or problem.
