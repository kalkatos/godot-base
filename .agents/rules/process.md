# 回 DIAN Agentic Gamedev Process v2

Process for developing games using AI. The goal is to use skills to identify what tasks need to be done, and execute them in a structured way following the project's rules and guidelines. The process is designed to be flexible and adaptable to different types of games and development teams.

## Rules, Guidelines, and Observations

- The entire process has two phases: Pre-production and Production. The pre-production phase is focused on defining the game concept and (optionally) testing the core mechanics with prototypes. The production phase is focused on building the game in milestones, with daily check-ins to review progress and plan the next steps.
- The focus is always on the current milestone and sprint with the game vision in mind without over-planning, and not trying to predict the future for the whole project.
- A day is not bound to a specific date. It is simply a unit of work that represents a set of tasks that can be completed in a single session. A day can be as short as a few hours or as long as a full workday, depending on the complexity of the tasks and the availability of the team.
- **Milestone List** (ordered, rigid):
0. Project Setup
1. Core Loop
2. Vertical Slice
3. MVP
4. Alpha
5. Beta
6. Launch

## Files

- `.docs/decisions.md`: A log of all decisions made during the project, including the rationale behind each decision and any alternatives considered.
- `.docs/glossary.md`: Defines key terms and concepts for the project to establish an ubiquitous language.
- `.docs/roadmap.md`: Lists milestones and sprints.
- `.docs/project-state.md`: A simple file to point out what are the current milestone, sprint and day.
- `.docs/backlog.md`: Lists tasks for the current sprint divided by day.
- `.docs/art-assets.md`: Lists all art assets needed for the project.
- `.docs/sound-assets.md`: Lists all sound assets needed for the project.
- `.docs/design/<system_name>_design.md`: Lists design notes for a specific system.
- `.docs/daily/daily_<vX.Y.Z>.md`: A log of what will be done on a specific day.
- `.docs/reviews/review_<vX.Y.Z.W>.md`: The content of what was reviewed for a task with a verdict of either "APPROVED" or "NEEDS REVISION".

## Task Fields

- **Game Design**: Tasks related to describing game mechanics, level design, and overall game experience.
- **Art**: Tasks related to creating placeholders, or describing visual or audio assets for the game.
- **UI**: Tasks related to creating wireframes and implementing the user interface.
- **Programming**: Tasks related to writing and maintaining the game's code.
- **Testing**: Tasks related to writing tests that verify the game's functionality and avoid regressions.

## The Process

### Pre-production Phase

- **/market-research** (Optional) Conduct market research to identify trends, target audience, and potential competitors. This will help inform the game concept and design decisions.
- **/game-concept** Define the game concept, including the genre, core mechanics, and unique selling points. Create a design document that outlines the game's vision and goals.
- **/risk-assessment** (Optional) Identify potential risks and challenges that may arise during development for the defined game concept. Prototypes must address these risks and test the core mechanics to ensure they are fun and engaging.
- **/prototype** (Optional) Develop prototypes to test the core mechanics and address the identified risks. Iterate on the prototypes based on feedback and testing results.

### Production Phase

- **/milestone** Starts a new milestone. The user must provide what milestone they are targeting, if they don't ask them before proceeding. Use /grill-me with the user to define the current milestone sprints.
  - *Output*: Update the `roadmap.md` and `project-state.md` to reflect the new milestone.
- **/sprint-planning** Use /grill-me with the user to define the current sprint tasks.
  - *Output*: Update the `roadmap.md`, the `project-state.md`, and the `backlog.md` to reflect the new sprint.
- **/daily** Use /grill-me with the user to assert what tasks can be completed on the day. Then organize them in order of field if present: 1. Game Design, 2. Art, 3. UI, 4. Programming, 5. Testing.
- **/task-execution** Identify the task to be executed. If coming from a review with verdict of "NEEDS REVISION", read what was reviewed to fix. Identify the field of the task and invoke the appropriate 'execute' skill. At the end of execution, invoke the /task-review skill to review the completed task and provide feedback. This will help ensure that the work meets the project requirements and quality standards.
  - **/execute-task-game-design** Gather full context before acting. Follow the game concept, the decisions, the glossary, and the daily notes. Write clear, concise, and actionable design documentation on folder `.docs/game-design/`. Avoid verbosity.
  - **/execute-task-art** Identify what art assets will be needed. Create placeholder assets for each one of them. Check or create `.docs/art-assets.md` according to template. Add to it the description of each asset identified.
  - **/execute-task-ui** Gather full context before acting. Follow the game concept, the decisions, the glossary, and the daily notes. Create wireframes first. Then read `.agents/rules/screen-creation.md` and implement the user interface screens, menus, or HUDs.
  - **/execute-task-programming** Gather full context before acting. Follow coding standards. Write clean, maintainable code. Use prefabs where appropriate. Avoid verbose comments.
  - **/execute-task-testing** Identify the tests that need to be written. Create test cases that verify the game's functionality and avoid regressions. Follow testing standards.
- **/task-review** This will help ensure that the work meets the project requirements and quality standards. Review the completed task and provide a verdict of either "APPROVED" or "NEEDS REVISION" on a file in `.docs/reviews/review_<vX.Y.Z.W>.md`. Further reviews for the same task must go to the same file. Stop if reached 3 reviews with verdict of "NEEDS REVISION" and escalate to the user if you see a channel of communication available.


