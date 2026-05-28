# GLOSSARY: Fighter

This document defines key terms and concepts for the project to stabilish an ubiquitous language. It should be updated throughout development as new terms arise or existing ones evolve. The language used in this glossary must be consistent with the terms used in the `game-concept.md` and other documentation to ensure clarity and avoid ambiguity.

## System Terms

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

---

## Project Specific Terms

**Fighter**: A programmable combatant entity in the arena controlled by a state machine. Has a visual sprite, animation states, and health. All actions (attacks, blocks, positioning) are determined by its state machine's autonomous decisions, not by player input. The fighter may be a robot, creature, or humanoid — the player is its programmer.
**_NOT_**: Character, Player, Avatar, Hero, Unit.

**Arena**: The side-view 2D stage where two fighters face each other. Contains background, ground/platform, and camera. Visuals are placeholders in early sprints.
**_NOT_**: Stage, Level, Map, Ring.

**State**: A named behavior mode that a fighter enters and stays in until a condition triggers a transition out. Examples: "Keep Distance," "Rush Down," "Defend," "Grapple." While in a state, the fighter executes its associated actions.
**_NOT_**: Stance, Mode, Phase, Status.

**Condition**: A trigger rule that, when met, causes a transition from the current state to a target state. Conditions evaluate opponent proximity, health thresholds, opponent state, distance, or timed intervals. Examples: "Opponent is within melee range," "Health < 50%," "Opponent is in the air."
**_NOT_**: Trigger, Event, Rule, If-Statement.

**Action**: A concrete behavior the fighter executes while in a state. Actions repeat or sustain for the duration of the state. Examples: "Fire projectile every 2s," "Move backward," "Block incoming attacks," "Grapple opponent."
**_NOT_**: Move, Ability, Skill, Spell, Command.

**Transition**: A directed wire connecting a condition to a target state within the state machine. When the condition evaluates to true, the fighter transitions from its current state to the target state, where it begins executing that state's actions.
**_NOT_**: Edge, Link, Connection, Jump, Branch.

**Program (State Machine)**: The complete graph of states, conditions, actions, and transitions that defines a fighter's autonomous behavior during combat. Built before the fight and refined through rewiring and unlocking. The program IS the fighter's decision-making brain.
**_NOT_**: Deck, Build, Loadout, Script, AI.

**Simulation-Driven Combat**: The combat model where all fight outcomes are resolved from state machine data — no real-time physics collisions or hitboxes. When an action fires (e.g., projectile, grapple), the attacker plays the corresponding animation, the defender plays the reaction animation, and damage is calculated directly from action values. All behavior emerges from state machines evaluating conditions and firing transitions.
**_NOT_**: Physics Combat, Real-Time Combat, Hitbox Combat.

**State-Driven Positioning**: Movement and positioning in the arena are determined by state machine actions, not by free player-controlled movement. If a state's action says the fighter steps forward or jumps backward, the corresponding animation plays.
**_NOT_**: Free Movement, Player Movement, WASD.

**Replay**: A spectatable autonomous fight (~3 min) where two programmed fighters execute their state machines. The player watches but does not control the action. Fights are fully animated with hit sparks, state transition visual indicators, and camera work.
**_NOT_**: Match, Battle, Fight Session, Simulation.

**Round**: A timed segment within a fight. Managed by a round timer with start/stop/reset. Rounds provide structure for fight pacing and win/loss conditions.
**_NOT_**: Turn, Phase, Match, Stage.

**Recon**: The between-fight phase where the player views fragments of the next opponent's state machine — their states, key transitions, and behavioral tendencies — to inform rewiring decisions.
**_NOT_**: Scouting, Spying, Inspecting, Viewing.

**Rewiring**: The between-fight action of modifying a fighter's state machine — adding, removing, or reconnecting states, conditions, actions, and transitions — to counter a recon'd opponent's tendencies (e.g., adding a "Deflect" state against a projectile-heavy opponent).
**_NOT_**: Teching, Editing, Modifying, Tuning, Tweaking.

**Unlocking**: Picking new states, conditions, or actions from a selection after winning a fight, expanding the fighter's state machine mid-run.
**_NOT_**: Drafting, Looting, Collecting, Earning, Buying.

**Run (Gauntlet)**: A full playthrough sequence of ~10 opponents in succession, with recon, rewiring, and unlocking between each fight. A run ends when the player loses a fight or defeats all opponents.
**_NOT_**: Session, Game, Match, Campaign.

**Combat Director**: The orchestrator scene that spawns two fighters in the arena, manages round timers, coordinates state-machine-driven action resolution, evaluates conditions, fires transitions, and provides hooks for the fight flow.
**_NOT_**: Fight Manager, Game Manager, Battle Controller, Arena Controller.

**State Machine**: The core gameplay construct that defines a fighter's autonomous behavior. A directed graph of states (behavior modes), conditions (transition triggers), actions (behaviors executed within a state), and transitions (wires from conditions to target states). The player builds and rewires the state machine between fights; during combat it executes autonomously. This is the primary tool of player expression — the state machine IS the fighter's brain.
**_NOT_**: Finite State Machine, FSM, Animation Controller, Deck, Program (see Program).

**Milestone Goal**: The concrete deliverable or state that defines when a milestone is considered reached, as described in the milestone's section of `roadmap.md`.
**_NOT_**: Milestone Target, Milestone Objective, Milestone Completion.

**Skill**: A named workflow invoked by the user (`/skillname`) or by another skill, defined by a `SKILL.md` file in `.agents/skills/`. Skills encapsulate domain-specific instructions for recurring tasks.
**_NOT_**: Agent, Tool, Command, Rule.
