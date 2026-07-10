# 回 DIAN Agentic Gamedev Process

Working title: 回 Dian

## Core Principles

- **Opinionated**: Present concise options to be followed, not open-ended questions. Avoid blank slates.
- **Collaborative**: Involve the user in the decision-making process, especially for major decisions. Avoid silent assumptions.
- **Iterative**: Build in cycles of ideation, selection, and refinement. Avoid waterfall or one-shot generation.
- **Bite-sized**: Break down the process into small, manageable steps. Avoid overwhelming the user with too much information or too many choices at once.
- **Lean**: Focus on the minimum viable output at each stage. Avoid unnecessary documentation or over-engineering.
- **Multi-agentic**: Multiple agents act upon the project to deliver a game.
- **Ever-evolving**: This process is always subject to change as new processes get created and stale processes get removed.

## Rules and Guidelines

- The entire process has two phases: Pre-production and Production. The pre-production phase is focused on defining the game concept and testing the core mechanics with prototypes. The production phase is focused on building the game in milestones, with daily check-ins to review progress and plan the next steps.
- This process is not meant to be in the Waterfall style. It is meant to be iterative and collaborative, ever-evolving, with the user involved in the decision-making process and providing feedback at each PR.
- A Pull Request is created whenever an `@User approves PR` instruction appears. The chain does not advance past that point until the PR is approved and merged.
- The senior agents (Griffin, Hag, and Kavu) review the work of the other agents and provide feedback on the PR (APPROVED or NEEDS REVISION) to ensure that the work is of high quality and aligned with the overall vision of the project.
- **Kanban is the coordination mechanism.** Elk dispatches tasks to agents via `hermes kanban create`. Each agent profile picks up their assigned tasks through the kanban gateway. No file-based handoff — all task assignment and status tracking flows through kanban.

## Failure & Pivot

The process is not a happy-path script. Real development hits friction. These rules handle common failure modes without adding bureaucracy:

- **PR stuck in revision** → Max 2 revision rounds. If a PR gets NEEDS REVISION twice from a senior reviewer, @Elk escalates to the user for a decision (override, redesign, or abandon the approach).
- **Sprint overrun** → If a sprint is dragging well past its expected duration, @Elk flags it in `/daily` and proposes either a scope cut or splitting the sprint into smaller chunks.
- **Unresponsive agent** → If an agent misses one full daily cycle without completing their assigned kanban tasks, @Elk reassigns the task to another appropriate agent or escalates to the user.

**Prototype failures are handled case by case** — no standard procedure. The verdict (PROCEED/PIVOT/KILL) and its implications guide the next step individually.

## The Agents

The agents are described below with their actions. Each one maps to a profile:
- Angel - programmer
  - Does programming tasks
- Brute - prototyper
  - Creates prototypes.
- Capy - game designer
  - Generates the pitch
  - Generates the game concept.
  - Analyzes risks in the gameplay.
- Dino - marketer
  - Does market research.
- Elk - producer
  - Defines milestones.
  - Runs the daily.
  - Creates the backlog.
- Fairy - art director
  - Identifies art assets.
- Griffin - senior programmer
  - Analyzes prototypes.
  - Reviews the milestone.
  - Reviews the daily.
  - Reviews Angel's code.
- Hag - senior game designer
  - Analyzes the pitch.
  - Analyzes the game concept.
  - Analyzes the risks in the gameplay.
  - Reviews the milestone.
  - Reviews the daily.
- Imp - QA analyst
  - Writes tests for Angel's code and provides feedback on any issues or bugs found.
- Jack - GUI developer
  - Creates GUI elements (screens, menus, HUDs).
- Kavu - senior art director
  - Reviews art direction and sound design tasks.
- Levi - sound designer
  - Identifies sound assets.

## The Process

### Pre-production phase

- @Dino: `/do-market-research` to search the web for trending game genres and themes.
  - *Output*: `market-research-<short-description>-<date>.md` with the findings of the research, including potential niches and opportunities for the game.
- @User approves PR.

- @Capy: `/generate-pitch` to create a short and compelling elevator pitch for the game based on the market research findings and the initial concept provided by the user.
  - *Output*: `pitch.md` with the generated elevator pitch for the game, highlighting its unique selling points and potential appeal to the target audience.
- @Hag: `/review-pr` to analyze Capy's work and provide feedback on the PR.
- @User approves PR.

- @Capy: `/start` to create a game concept from the elevator pitch.
  - *Output*: `game-concept.md` with a detailed description of the game's vision, core mechanics, unique features, and player fantasy.
- @Hag: `/review-pr` to analyze Capy's work and provide feedback on the PR.
- @User approves PR.

- @Capy: `/analyze-risks` to identify potential risks in gameplay that could be solvable with a prototype.
  - *Output*: `risks.md` with a list of identified risks in the gameplay, along with questions that should be addressed on a prototype.
- @Hag: `/review-pr` to analyze Capy's work and provide feedback on the PR.
- @User approves PR.

<while> There are still prototypes to be made:

- @Brute: `/prototype` for one prototype to create a quick and dirty prototype to test each of the identified risks in the gameplay.
  - *Output*: A prototype for the identified risk, with a focus on testing that one mechanic and answer the risk question.
- @Griffin `/review-pr` to analyze the prototype code and provide feedback on the PR about the results of the tests.
- @Hag `/review-pr` to analyze the prototype implementation and check if it can answer the risk question.
- @User fills in a prototype report and approves the PR.

</while>

### Production Phase

<while> There are milestones to progress to

- @Elk:  `/milestone` to define the next milestone based on the progress of the project.
  - *Output*: `roadmap.md` with a clear definition of the next milestone, including specific objectives and user stories to guide the development process.
- @Griffin: `/review-pr` to analyze and comment on the PR what to be done for the milestone on the programming side.
- @Hag: `/review-pr` to analyze and comment on the PR what to be done for the milestone on the game design side.
- @User adds comments to the PR or proceeds.
- @Elk: `/consolidate-milestone` to produce the milestone memo with all the information discussed, and update `decisions.md` and `glossary.md` with any new terms or decisions.
  - *Output*: `milestone-memo-<milestone>-<date>.md` with all the details discussed on the milestone definition. `decisions.md` and `glossary.md` updated if relevant.

<while> There are sprints and tasks to be done for the current milestone

**Every sprint day (not literal days, can span multiple days):**

- @Elk:  `/daily` to review progress, identify blockers, and plan the next steps by updating the backlog.
  - *Output*: `daily_<sprint>.<day>.md` with a summary of the daily check-in, including progress updates, identified blockers, and an updated backlog with clear and concise task descriptions for the next steps in the development process, assigned to the appropriate team members (core programming to Angel, UI design to Jack).
- @Griffin: `/review-pr` to review the daily document.
- @Hag: `/review-pr` to review the daily document.
- @User adds comments to the PR or proceeds.
- @Elk: `/wrap-up-daily` updates the *daily document* and the *backlog* with all the information discussed. Then, dispatch the tasks to the appropriate team members (game design to Capy, core programming to Angel, UI design to Jack, art to Fairy, sound to Levi).
  - *Output*: `daily_<sprint>.<day>.md` updated and `backlog.md` updated.

**Track A — Game Design (may or may not block the next ones):**

<if> there are game design tasks for the day:

<for> up to 3 review rounds until APPROVED

- @Capy: `/game-design-pass` to do game design tasks.
  - *Output*: The actual game design work.
- @Hag: `/review-pr` to review Capy's work and provides feedback on the PR.
- @Elk: `/orchestrate` to start a new round if not APPROVED or break the loop if still NEEDS REVISION after 3 attempts.

</for>

- @User approves game design PR.

</if>

**Track B1 — Code (starts immediately if not dependent on game design tasks):**

<foreach> task of programming or GUI

<for> up to 3 review rounds until APPROVED

- @Jack: `/task-execution`, then creates GUI elements (screens, menus, HUDs) based on the daily tasks related to UI, using placeholder assets created with `/create-placeholder` when necessary.
  - *Output*: The actual screens, menus, and HUDs.
- @Angel: `/task-execution`, then does programming tasks with placeholder assets created with `/create-placeholder` when necessary.
  - *Output*: The actual scripts, configs, data files, etc.
- @Griffin: `/review-pr` to review Jack's GUI work and Angel's code and provides feedback on the PR.
- @Elk: `/orchestrate` to start a new round if not APPROVED or notify the user **only if** still NEEDS REVISION after 3 attempts.

</for>

</foreach>

<for> up to 3 review rounds until APPROVED

- @Imp: `/create-tests` writes tests for Angel's code and provides feedback on any issues or bugs found.
  - *Output*: Tests for the work of Angel.
- @Griffin: `/review-pr` to review Imp's tests and provides feedback on the PR.
- @Elk: `/orchestrate` to start a new round if not APPROVED or break the loop if still NEEDS REVISION after 3 attempts.

</for>

- @User approves tests PR.

**Track B2 — Art & Sound (parallel with B1, non-blocking):**

<if> the current sprint includes visual deliverables:

<for> up to 3 review rounds until APPROVED

- @Fairy: `/identify-art-assets` to identify the art assets needed for the day and write a detailed description for each asset, including references and specific instructions for the artists.
  - *Output*: add to `.docs/art-assets.md` identified art assets needed for the day, along with detailed descriptions, references, and instructions for the artists to create the assets in alignment with the game's visual style and aesthetic.
- @Kavu: `/review-pr` to review Fairy's work and provides feedback on the PR.
- @Elk: `/orchestrate` to start a new round if not APPROVED or break the loop if still NEEDS REVISION after 3 attempts.

</for>

- @User approves art PR and creates the art assets.

</if>

<if> the current sprint includes audio deliverables

<for> up to 3 review rounds until APPROVED

- @Levi: `/identify-sound-assets` to identify the sound assets needed for the day and write a detailed description for each asset, including references and specific instructions for the sound designer.
  - *Output*: add to `sound-assets.md` identified sound assets needed for the day, along with detailed descriptions, references, and instructions for the sound designer to create the assets in alignment with the game's audio style and aesthetic.
- @Kavu: `/review-pr` to review Levi's work and provides feedback on the PR.
- @Elk: `/orchestrate` to start a new round if not APPROVED or break the loop if still NEEDS REVISION after 3 attempts.

</for>

- @User approves sound PR and creates the sound assets.

</if>

**After all the tasks for the day are done:**

- @Elk: `/review-day` to review the day's production outcomes — task completion across all fields, milestone progress, blockers, documentation accuracy, and sprint health. Must give a veredict (APPROVED or NEEDS REVISION).
  - *Output*: A daily-review PR with the full review and a veredict APPROVED or NEEDS REVISION.

<while> the daily-review is NEEDS REVISION

- @Elk `/orchestrate` to dispatch the remaining tasks to the appropriate team members (Angel for programming, Capy for game design, Jack for UI, Imp for tests)
- If there are tasks for Angel:
  - @Angel: `/task-execution` to do programming tasks and fixes according to the review.
- If there are tasks for Capy:
  - @Capy: `/game-design-pass` to do game design tasks and fixes according to the review.
- If there are tasks for Jack:
  - @Jack: `/task-execution` to do UI tasks and fixes according to the review.
- If there are tasks for Imp:
  - @Imp: `/create-tests` to create tests for Angel's code and achieve total test coverage.
- @Griffin: `/review-pr` to review the tasks and provides feedback on the PR.

</while>

**After all the tasks for the sprint are done:**

- @Elk: `/review-sprint` to review everything that was done for the sprint, analyze if the objectives were achieved. Must give a veredict (APPROVED or NEEDS REVISION).
  - *Output*: A sprint-review PR.
- @Griffin: `/review-pr` to review the sprint-review PR on the programming side.
- @Hag: `/review-pr` to review the sprint-review PR on the game design side.
- @Kavu: `/review-pr` to review the sprint-review PR on the art design side.
- @Levi: `/review-pr` to review the sprint-review PR on the sound design side.
- @User approves sprint-review PR.

</while>

The game is done!!! 🎉🎉🎉
