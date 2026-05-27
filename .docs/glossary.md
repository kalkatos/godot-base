# GLOSSARY: [[GAME TITLE]]

This document defines key terms and concepts for the project. It should be updated throughout development as new terms arise or existing ones evolve. The language used in this glossary must be consistent with the terms used in the `game-concept.md` and other documentation to ensure clarity and avoid ambiguity.

**Agent**: An autonomous entity that can perform tasks, make decisions, and interact with the user and the project files. Agents have specific skills and rules that govern their behavior.
**_NOT_**: Persona.

**Persona**: A name used to refer to a specific agent that is responsible for a certain project or field of expertise. When a persona name is invoked, the corresponding project context is being referred to. For example, if the user says "Hey, [Persona Name], can you help me with this task?", the agent associated with that persona will be activated and will understand that the task is related to the project it is responsible for.
**_NOT_**: Agent.

**Interview**: A structured conversation between the agent and the user to gather information, clarify requirements, and make decisions. Check the [Interview](#interview) section for guidelines.
**_NOT_**: Question, Conversation, Dialogue.

**Milestone**: A major development phase that represents a significant goal or achievement in the project. Milestones are defined in the `roadmap.md` can be one of the following "Project Setup", "Core Loop", "Vertical Slice", "MVP", "Alpha", "Beta", and "Launch".
**_NOT_**: Sprint, Roadmap, Threshold, State, Task, Version, Phase, Duty.

**Milestone List**: The ordered sequence of milestone names that define the project's development phases. Each milestone name is the goal state of the project once that milestone is reached, not a description of what it contains: 0. Project Setup, 1. Core Loop, 2. Vertical Slice, 3. MVP, 4. Alpha, 5. Beta, 6. Launch.
**_NOT_**: Sprint List, Task List, Feature List, Phase List.

**Roadmap**: The document that formalizes the milestones, providing a clear definition of what each milestone entails and what the project must have on each version. Live in `roadmap.md`.
**_NOT_**: Milestones, Backlog, Sprints, Tasks, Duties.

**Sprint**: A smaller development phase within a milestone that focuses on specific tasks or features. Sprints are defined in the `roadmap.md` and broken down in tasks in the `backlog.md`.
**_NOT_**: Milestone, Roadmap, Threshold, State, Task, Version, Phase, Duty, Work.

**Prototype Sprint**: A sprint focused on rapid experimentation to validate a specific mechanic, interaction, or idea before committing to full implementation. A sprint is a prototype sprint if its name or description contains the word "prototype" (case-insensitive).
**_NOT_**: Feature Sprint, Production Sprint, Milestone.

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

**Current Sprint**: The sprint the project is actively working on, as recorded in `project-state.md`. The current sprint determines which tasks appear in the `backlog.md`.
**_NOT_**: Active Sprint, Working Sprint, Ongoing Sprint.

**Game Concept**: The high-level design document (`.docs/game-concept.md`) that defines the game's identity, elevator pitch, player fantasy, core mechanics, core loop, unique features, references, and further notes.
**_NOT_**: Game Design Document, GDD, Pitch Document.

**Fighter**: A combatant entity in the arena controlled by a deck of tactic cards. Has a visual sprite, animation states, and health. All actions (attacks, blocks, positioning) are determined by its deck's AI decisions, not by player input.
**_NOT_**: Character, Player, Avatar, Hero.

**Arena**: The side-view 2D stage where two fighters face each other. Contains background, ground/platform, and camera. Visuals are placeholders in early sprints.
**_NOT_**: Stage, Level, Map, Ring.

**Tactic Card (Behavior Card)**: A card that defines a specific action or decision a fighter's AI can make during a fight (e.g., jab, block low, anti-air, jump). The deck of tactic cards IS the fighter's decision-making brain.
**_NOT_**: Ability, Skill, Move, Action, Spell.

**Deck**: A collection of tactic cards assigned to a fighter, defining all possible actions that fighter can take during a fight. Built before the fight and refined through drafting and teching.
**_NOT_**: Hand, Pile, Collection, Set.

**Simulation-Driven Combat**: The combat model where all fight outcomes are resolved from card data — no real-time physics collisions or hitboxes. When a card is played (e.g., kick), the attacker plays the kick animation, the defender plays the hurt animation, and damage is calculated directly from card values.
**_NOT_**: Physics Combat, Real-Time Combat, Hitbox Combat.

**Card-Driven Positioning**: Movement and positioning in the arena are determined by tactic cards, not by free player-controlled movement. If a card says a fighter jumps or steps forward, the corresponding animation plays.
**_NOT_**: Free Movement, Player Movement, WASD.

**Replay**: A spectatable autonomous fight (~3 min) where two AI-driven fighters execute their decks. The player watches but does not control the action. Fights are fully animated with hit sparks and camera work.
**_NOT_**: Match, Battle, Fight Session, Simulation.

**Round**: A timed segment within a fight. Managed by a round timer with start/stop/reset. Rounds provide structure for fight pacing and win/loss conditions.
**_NOT_**: Turn, Phase, Match, Stage.

**Scouting**: The between-fight phase where the player views fragments of the next opponent's deck and their fighting style tendencies to inform deck teching decisions.
**_NOT_**: Spying, Inspecting, Viewing.

**Deck Teching**: The between-fight action of swapping tactic cards in and out of your deck to counter a scouted opponent's tendencies (e.g., adding anti-air cards against a jumper).
**_NOT_**: Editing, Modifying, Tuning, Tweaking.

**Drafting**: Picking new tactic cards from a selection after winning a fight, evolving the fighter's deck mid-run.
**_NOT_**: Looting, Collecting, Earning, Buying.

**Run (Gauntlet)**: A full playthrough sequence of ~10 opponents in succession, with scouting, teching, and drafting between each fight. A run ends when the player loses a fight or defeats all opponents.
**_NOT_**: Session, Game, Match, Campaign.

**Fight Manager**: The orchestrator scene that spawns two fighters in the arena, manages round timers, coordinates card-driven action resolution, and provides hooks for the fight flow.
**_NOT_**: Game Manager, Battle Controller, Arena Controller.

**State Machine**: The fighter's animation and behavior state system (e.g., idle, attack, hurt). States determine which animations play and transition rules between states. All state transitions are triggered by card-driven actions.
**_NOT_**: Finite State Machine, FSM, Animation Controller.

**Milestone Goal**: The concrete deliverable or state that defines when a milestone is considered reached, as described in the milestone's section of `roadmap.md`.
**_NOT_**: Milestone Target, Milestone Objective, Milestone Completion.

**Skill**: A named workflow invoked by the user (`/skillname`) or by another skill, defined by a `SKILL.md` file in `.agents/skills/`. Skills encapsulate domain-specific instructions for recurring tasks.
**_NOT_**: Agent, Tool, Command, Rule.
