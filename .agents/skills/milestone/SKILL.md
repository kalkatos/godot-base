
Before starting:

- Check if the `.docs/roadmap.md` file exists. If not, create it based on the template in `.agents/docs/roadmap-template.md` and set every milestone and sprint to "TBD".
- Check if the `.docs/backlog.md` file exists. If not, create it based on the template in `.agents/docs/backlog-template.md`.
- Check if the `.docs/project-state.md` file exists and contains a defined milestone and sprint. If not, there is an alternative way to know the current milestone and sprint from the roadmap by capturing what milestone and sprint the roadmap mark is currently pointing to. Create or update the project state accordingly.

<what-to-do>

1. **Get Project State**
  - Read the project state.
  - If the milestone is "Undefined", update to "Milestone: Project Setup" and "Sprint: Start".
  - If the milestone is "Project Setup" and the sprint is "Undefined" or "Start":
    - Read `.docs/game-concept.md`.
    - If the game concept does not exist or is incomplete, tell the user to run the skill `/start` and exit this skill.
  - Check if the current milestone and sprint align with the roadmap mark position in the roadmap. If not, notify the user and `AskUserQuestion` to confirm the current milestone and sprint based on the roadmap, and update the project state accordingly.

2. **Check Milestone**
  - Read the section about the current milestone in the roadmap.
  - If no sprints are created for the current milestone:
    - Run an Interview to define what are the sprints for the current milestone.
    - Go to step 4 (Change Sprint) to change current sprint to the first one in the list.
  - Else:
    - Read the backlog.
    - If the backlog has current sprint:
      - If all tasks are done, go to step 3 (Finish Sprint).
      - Else, redirect to `/daily` and continue from there (exit this skill).
    - Else:
      - `AskUserQuestion` to confirm the next sprint.
      - Once confirmed, go to step 4 (Change Sprint) to change current sprint to the one confirmed.

3. **Finish Sprint**
  - If the finished sprint is a prototype, run the `/prototype-review` skill and exit this skill.
  - Move the roadmap mark to the next sprint in the roadmap.
  - If the next sprint is the Prototypes sprint, run the `/prototype` skill and exit this skill.
  - If the next sprint is in the same milestone, update the project state with the new sprint.
  - Else if the next sprint is in the next milestone:
    - `AskUserQuestion` to confirm that the user has reached the milestone goal and wants to move to the next milestone.
    - If the user confirms, set project state to the next milestone and go to step 2 (Check Milestone) to check if the next milestone has defined sprints.
    - If the user denies, Interview them to understand what is missing for them to consider the milestone goal reached and exit this skill.

4. **Change Sprint**
  - Set the roadmap mark and project state to the new sprint.
  - Clean up the backlog and set it to the new sprint with no tasks.
  - Redirect to `/daily` to fill in the backlog and continue from there (exit this skill).

</what-to-do>

<supporting-info>

## Guidelines for this skill:

- The objective of this skill is to manage the project's production towards the defined milestones.
- This skill does 3 things:
  - Fill in current milestone sprints.
  - Fill in current sprint tasks.
  - Changes current milestone and/or current sprint when the user confirms that they have reached that milestone or done all the tasks in the current sprint.
- When working on the roadmap, only edit the current milestone section and keep the rest of the document intact.
- The sprints must be organized sequencially so that the roadmap mark can be moved down and everything above it is already completed. This means that if the user wants to change the current sprint to one that is not the next one in the list, the list must be rearranged to put that sprint next in line after the current one.
- When changing the current sprint or milestone, the roadmap mark must be updated accordingly.
- This is the only skill allowed to edit the roadmap and project state documents, so all changes to those documents must be done through this skill to ensure consistency and avoid conflicts.

## How to create a sprint:

- A sprint is a medium-sized chunk of work that should be achievable within a few days to two weeks. It should be specific enough to provide a clear goal, but not so small that it becomes a task.
- When defining sprints, always have the milestone in mind and how the completion of those sprints will lead to the achievement of the milestone goal.
- Good candidates for sprints:
  - A new feature
  - A new system
  - A mechanic that requires multiple steps to implement
  - A new screen or interaction
  - A group of related assets
  - A tool or pipeline setup
  - A prototype to test a specific mechanic or idea
  - A large refactor or redesign
- Each sprint must be described as follows:
  - **Name:** [[Name of the sprint, concise and descriptive. For example: "Backend Communication", "Simulation Layer", "Enemy AI", "Combat System", "Forest Biome"]]
  - **Description:** [[Short description of the sprint. For example: "Create a bare bones level to test the core mechanics.", "Implement the shield mechanic, where the player can block incoming attacks and reflect projectiles back at enemies."]]
- Examples of badly designed sprints to avoid:
  - "Spells" is too vague and big, better broken down into smaller sprints like "Inventory System" + "Spell System" + "Health and Damage System" + "Enemy Combat AI" + "VFX and Animations for Spells".
  - "Player Character Animations" is more of a task than a sprint, better to put it in the backlog and have a sprint like "Player Character" that includes multiple related tasks such as "Player Character Concept" + "Player Character Modeling" + "Player Character Animations".
  
## Glossary

**Milestone List**:
Milestone can only be one of the names below. Each milestone name is the state of the project once that milestone is reached.
0. Project Setup
1. Core Loop
2. Vertical Slice
3. MVP
4. Alpha
5. Beta
6. Launch

**Sprints Defined**: A milestone has defined sprints if its section in the roadmap contains a list of sprints with descriptions and user stories, even if they are not yet confirmed by the user. The presence of this list indicates that the milestone has a defined structure of work to be done, which can be reviewed and confirmed by the user. 

**Game Concept Completeness**: The game concept is complete if it has the following sections filled out with meaningful content: Game Identity, Elevator Pitch, Player Fantasy, Core Mechanics, Core Loop, Unique Features, References, and Further Notes.



</supporting-info>
