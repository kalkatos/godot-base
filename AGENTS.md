# AGENTS.md

This file helps AI coding agents become productive quickly in this repository.

## Project Snapshot

- A Godot 4.x game project. (Currently 4.6)
- Project root for Godot: `src/`
- Folder for game-specific documentation and instructions: `.docs/`.
- Important files that describe the project, its current state, and future plans:
  - `.docs/game-concept.md`: Elevator pitch, player fantasy, core mechanics, unique features.
  - `.docs/glossary.md`: Definitions for key domain terms and concepts.
  - `.docs/roadmap.md`: Definitions of major features and development phases.
  - `.docs/backlog.md`: Daily task list derived from milestones, with clear and concise descriptions.
- If the files above are missing or incomplete, notify the user that they are important and they should prioritize creating and filling them in before proceeding with other tasks.
- Create those files lazily — only when you have something to write by using their templates in `.agents/docs/`.

## Where To Work

- Data objects, configs: `src/Game/_GameDesign/`
- Game-specific code: `src/Game/Code/`
- Art assets, audio: `src/Game/Art/`
- Reusable scenes, prefabs: `src/Game/Prefabs/`
- Game scenes: `src/Game/Scenes/`
- Reusable, game-agnostic systems: `src/Modules/`
- Third-party addons/plugins: `src/addons/`

## Policy

- Prefer implementing game behavior in `src/Game/`.
- Modify `src/Modules/` carefully (shared utilities).
- Avoid editing `src/addons/` unless the task explicitly requires it.
- Avoid editing `.agents/` unless the task explicitly requires it (agent definitions, skills, rules, etc.).

## Core Rules

Rules the agent must follow when working on tasks. These rules are non-negotiable and must be adhered to in order to maintain code quality, consistency, and project organization.
  - `.agents/rules/coding-standards.md` for code style and standards.
  - `.agents/rules/agent-workflow.md` for common workflows and gotchas to avoid.
  - `.agents/rules/screen-creation.md` for specific guidelines on creating UI screens and scenes.
  - `.agents/rules/architecture.md` TBD

## Interview

When a document or task requires you to run an Interview, follow these guidelines:
  - Ask the user questions relentlessly about every aspect of the topic until reaching a shared understanding.
  - Walk down each branch of the design tree, resolving dependencies between decisions one-by-one.
  - For each question, provide your recommended answer.
  - Use the `AskUserQuestion` tool.
  - Use free-text prompts for more exploratory questions that require nuance.
  - Do not make assumptions about the user's needs or preferences without explicit confirmation. Always ask for clarification if something is unclear.
  - Write down key insights from the interview after each question.

## Run and Test

From `src/` run:
```powershell
& 'C:\Program Files\Godot\Godot_console.exe' --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -ginclude_subdirs -gexit -glog=1
```

Testing:
- GUT is included under `src/addons/gut/`.
- CLI entrypoint is `res://addons/gut/cli/gut_cli.gd`.
- If a test task is requested, prefer project-specific test config when present (for example `.gutconfig.json`), otherwise use GUT CLI options.

## Tools

- `.agents/agents/ph-creator.agent.md`: a subagent for generating placeholder images. Use it when you need a placeholder `.png` image, placeholder icon, mockup tile, dummy graphic, or quick generated image from a short prompt. For example: "Character named Joseph", or "Gold HUD icon".

## Proto System Glossary

**Agent**: An autonomous entity that can perform tasks, make decisions, and interact with the user and the project files. Agents have specific skills and rules that govern their behavior.
**_NOT_**: Persona.

**Persona**: A name used to refer to a specific agent that is responsible for a certain project or field of expertise. When a persona name is invoked, the corresponding project context is being referred to. For example, if the user says "Hey, [Persona Name], can you help me with this task?", the agent associated with that persona will be activated and will understand that the task is related to the project it is responsible for.
**_NOT_**: Agent.

**Interview**: A structured conversation between the agent and the user to gather information, clarify requirements, and make decisions. Check the [Interview](#interview) section for guidelines.
**_NOT_**: Question, Conversation, Dialogue.

**Milestone**: A major development phase that represents a significant goal or achievement in the project. Milestones are defined in the `roadmap.md` can be one of the following "Project Setup", "Core Loop", "Vertical Slice", "MVP", "Alpha", "Beta", and "Launch".
**_NOT_**: Sprint, Roadmap, Threshold, State, Task, Version, Phase, Duty.

**Roadmap**: The document that formalizes the milestones, providing a clear definition of what each milestone entails and what the project must have on each version. Live in `roadmap.md`.
**_NOT_**: Milestones, Backlog, Sprints, Tasks, Duties.

**Sprint**: A smaller development phase within a milestone that focuses on specific tasks or features. Sprints are defined in the `roadmap.md` and broken down in tasks in the `backlog.md`.
**_NOT_**: Milestone, Roadmap, Threshold, State, Task, Version, Phase, Duty, Work.

**Backlog**: The document that formalizes the tasks within a sprint, providing a detailed list of work items to be completed. Live in `backlog.md`.
**_NOT_**: Milestones, Roadmap, Sprints, Tasks, Duties.

**Task**: A specific piece of work that can be completed in a few hours up to two days, defined in the `backlog.md` and assigned to a sprint. Tasks should be clear, concise, and actionable.
**_NOT_**: Milestone, Roadmap, Sprint, Duty, Work, Phase, Session.

**Roadmap Marker**: A marker in the `roadmap.md` that indicates the current milestone and sprint of the project.
**_NOT_**: Limit, Pointer, Threshold, Barrier.

**Milestone Change**: An update to the current milestone in the `roadmap.md` that reflects a significant shift in the project's development phase.
**_NOT_**: Sprint Change, Roadmap Change, Backlog Change, State Change, Project Change, Task Change.

**Sprint Change**: An update to the current sprint in the `roadmap.md` that reflects a shift in the focus of work within the current milestone.
**_NOT_**: Milestone Change, Roadmap Change, Backlog Change, State Change, Project Change, Task Change.

**Project State**: The current status of the project in terms of its milestone and sprint, as documented in `project-state.md`.
**_NOT_**: Project Status, Project Condition, Project Phase, Project Health.
