# 回 DIAN Agentic Gamedev Process v2

Process for developing games using AI. The goal is to use skills to identify what tasks need to be done, and execute them in a structured way following the project's rules and guidelines. The process is designed to be flexible and adaptable to different types of games and development teams.

## Rules, Guidelines, and Observations

- The entire process has two phases: Pre-production and Production. The pre-production phase is focused on defining the game concept and (optionally) testing the core mechanics with prototypes. The production phase is focused on building the game in milestones, with daily check-ins to review progress and plan the next steps.
- The focus is always on the current milestone and sprint with the game vision in mind without over-planning, and not trying to predict the future for the whole project.
- A day is not bound to a specific date. It is simply a unit of work that represents a set of tasks that can be completed in a single session. A day can be as short as a few hours or as long as a full workday, depending on the complexity of the tasks and the availability of the team.
- A sprint has no fixed number of days — it may span 1+ days depending on the work to be done. A sprint ends when all its tasks are complete and the user invokes `/sprint` to start the next one. Similarly, a milestone ends when the user invokes `/milestone` for the next milestone. The user is the gatekeeper for all phase transitions.
- To adjust scope mid-sprint, the user can invoke `/sprint` or `/daily` to re-plan remaining work.
- **Version numbering**: `vX.Y.Z.W` = milestone.sprint.day.task (e.g., `v1.2.3.4` = Milestone 1, Sprint 2, Day 3, Task 4).
- **Milestone List** (ordered, rigid):
  0. Project Setup
  1. Core Loop
  2. Vertical Slice
  3. MVP
  4. Alpha
  5. Beta
  6. Launch
- The final art and sound assets will be created by the user or a human artist. The AI will only create placeholder assets for the purpose of testing and prototyping.

## Files

All documents have a template in the `.agents/templates/` folder. The following files are used in the process:

- `.docs/decisions.md`: A log of all decisions made during the project, including the rationale behind each decision and any alternatives considered.
- `.docs/glossary.md`: Defines key terms and concepts for the project to establish an ubiquitous language.
- `.docs/roadmap.md`: Lists milestones and sprints.
- `.docs/project-state.md`: A simple file to point out what are the current milestone, sprint and day.
- `.docs/backlog.md`: Lists tasks for the current sprint divided by day.
- `.docs/art-assets.md`: Lists all art assets needed for the project.
- `.docs/sound-assets.md`: Lists all sound assets needed for the project.
- `.docs/design/<system_name>_design.md`: Lists design notes for a specific system. Created by `/execute-task-game-design`.
- `.docs/daily/daily_<vX.Y.Z>.md`: A log of what will be done on a specific day.
- `.docs/reviews/review_<vX.Y.Z.W>.md`: The content of what was reviewed for a task with a verdict of either "APPROVED" or "NEEDS REVISION".

## Task Fields (in order of execution)

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
- **/sprint** Use /grill-me with the user to define the current sprint tasks.
  - *Output*: Update the `roadmap.md`, the `project-state.md`, and the `backlog.md` to reflect the new sprint.
- **/daily** Use /grill-me with the user to assert what tasks can be completed on the day. Then organize them in order of field if present: 1. Game Design, 2. Art, 3. UI, 4. Programming, 5. Testing. Invoke `/daily-review` to do a second review pass on the tasks and provide feedback.
  - *Output*: Update the `backlog.md` to reflect the tasks for the day and create a new file in `.docs/daily/daily_<vX.Y.Z>.md` to log what was discussed.
- **/daily-review** Review the tasks for the day and provide feedback on their feasibility, priority, and dependencies. If any tasks are deemed unfeasible or require additional information, invoke `/grill-me` to gather more context from the user. Write to the daily log file in `.docs/daily/daily_<vX.Y.Z>.md` with the feedback and any additional context gathered.
  - *Output*: Update the `backlog.md` to reflect the review and update the daily log file in `.docs/daily/daily_<vX.Y.Z>.md`.
- **/task-execution** Identify the task to be executed. If coming from a review with verdict of "NEEDS REVISION", read what was reviewed to fix. Identify the field of the task and invoke the appropriate 'execute' skill. At the end of execution, invoke the /task-review skill to review the completed task and provide feedback. This will help ensure that the work meets the project requirements and quality standards. If creating a new file, read `.agents/rules/file-naming.md`.
  - *Output*: Execution of one of the 'execute' skills below.
- **/execute-task-game-design** Gather full context before acting. Follow the game concept, the decisions, the glossary, and the daily notes. Write clear, concise, and actionable design documentation on folder `.docs/design/`. Avoid verbosity.
  - *Output*: Update the appropriate design document in `.docs/design/` with the new design documentation.
- **/execute-task-art** Identify what art assets will be needed. Create placeholder assets for each one of them. Check or create `.docs/art-assets.md` according to template. Add to it the description of each asset identified.
  - *Output*: Update the `.docs/art-assets.md` with the new asset descriptions and create placeholder assets in the appropriate folder.
- **/execute-task-ui** Gather full context before acting. Follow the game concept, the decisions, the glossary, and the daily notes. Create wireframes first. Then read `.agents/rules/screen-creation.md` and implement the user interface screens, menus, or HUDs as `.tscn` objects. Do not write code for this step.
  - *Output*: Create or update the appropriate `.tscn` files in `src/Game/Scenes/` or `src/Game/Prefabs/` with the new user interface screens, menus, or HUDs.
- **/execute-task-programming** Gather full context before acting. Follow `.agents/rules/coding-standards.md` and `.agents/rules/architecture.md`. Write clean, maintainable code. Create and use prefabs where appropriate. Avoid verbose comments.
  - *Output*: Create or update the appropriate code files in `src/Game/Code/` with the new code. Add prefabs to `src/Game/Prefabs/` if needed.
- **/execute-task-testing** Identify the tests that need to be written. Create test cases that verify the game's functionality and avoid regressions. Follow testing standards.
  - *Output*: Create or update the appropriate test files in `src/tests/unit/` with the new test cases.
- **/task-review** This will help ensure that the work meets the project requirements and quality standards. Review the completed task and provide a verdict of either "APPROVED" or "NEEDS REVISION" on a file in `.docs/reviews/review_<vX.Y.Z.W>.md`. Further reviews for the same task must go to the same file. If a task reaches 3 consecutive "NEEDS REVISION" verdicts, stop and ask the user for guidance — do not loop further.
  - *Output*: Update the appropriate review file in `.docs/reviews/review_<vX.Y.Z.W>.md` with the verdict and any feedback or comments on the completed task.


