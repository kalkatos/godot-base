
<what-to-do>

1. Read `.docs/project-state.md`
  - If that file is not present, create it with "Milestone: Project Setup" and "Sprint: Start".
  - If the milestone is "Undefined", update to "Milestone: Project Setup" and "Sprint: Start".
    - Read `.docs/game-concept.md`
      - If the game concept does not exist or is incomplete, tell the user to run `/start` and exit this skill.

2. `AskUserQuestion` to confirm current milestone and sprint.
  - If the user does not confirm the milestones writen to `.docs/project-state.md`, ask them to specify the correct milestone by presenting the `Milestone List` below.
  - Update `.docs/project-state.md` to the confirmed milestone. Note that this configures a Milestone Change.

3. Read `.docs/roadmap.md` to get the definition of the current milestone.
  - If the milestone definition is not found, create it based on the template in `.agents/docs/roadmap-template.md`.
  - Read the section about the current milestone.
  - If no sprint is defined for the current milestone:
    - `Run Interview` to define what are the sprints for the current milestone.
    - Do not proceed until the user confirms the sprints.
    - Define current sprint as the first one in the list and update `.docs/project-state.md` accordingly.
  - If sprints are defined for the current milestone:
    - `AskUserQuestion` to confirm the current sprint.
    - If the user does not confirm the sprint, ask them to specify the correct sprint by presenting the list of sprints defined in `.docs/roadmap.md` for the current milestone.
    - Update `.docs/project-state.md` to the confirmed sprint. Note that this configures a Sprint Change.

4. If we had a `Milestone Change` or `Sprint Change`, read `.docs/backlog.md`.
  - If the roadmap is not found, create it with the template in `.agents/docs/backlog-template.md`. Then it is a fresh roadmap.
  - If the roadmap is not fresh and no tasks are defined for the current sprint:
    - Get permission from the user to clean up what is writen in roadmap.
    - `Run Interview` to define what are the tasks for the current sprint.
  - Do not proceed until the user confirms the tasks.
  - Update `.docs/backlog.md` with the confirmed tasks for the current sprint.






</what-to-do>

<supporting-info>

- The objective of this skill is to manage the project's production towards the defined milestones.
- This skill checks current milestone, confirms it with the user, and updates the project state accordingly.
- 

**Milestone List**:
"Milestone" can only assume one of these top-level names. Each milestone name is the state of the project once that milestone is reached.
0. Project Setup
1. Core Loop
2. Vertical Slice
3. MVP
4. Alpha
5. Beta
6. Launch

**Game Concept Completeness**: The game concept is complete if it has the following sections filled out with meaningful content: Game Identity, Elevator Pitch, Player Fantasy, Core Mechanics, Core Loop, Unique Features, References, and Further Notes.

</supporting-info>
