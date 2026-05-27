# ROADMAP: Read

Each one of the sprints aim to be tasks that can be completed in a few days to two weeks at most. The goal is to have a clear path to follow and to be able to track progress easily. The milestones should be defined in a way that they build on top of each other, so that the completion of one milestone unlocks the next one. Tasks smaller than those must go to the `backlog.md` document.

**NOTE:** The milestone name is the goal of the milestone to reach, not what it contains.

## v0: Project Setup

The initial setup of the project, including defining the game concept, setting up the development environment, and creating the necessary documentation and tools to manage the project effectively.

### Sprint v0.1: Start

Create the game concept document with a clear and concise game idea that includes the core gameplay loop, player fantasy, and unique features. This will serve as the foundation for the rest of the development process and will help to align the team on the vision for the game.

## v1: Core Loop

Just the bare bones mechanics to have a playable version of the game with placeholders.

=== WE ARE HERE (Current milestone/sprint below) === [[Move this roadmap marker down as we progress through the milestones]]

### Sprint v1.1: Fighter & Arena Foundation

**Description:** Side-view 2D arena with two placeholder fighters, card-driven positioning and animation states (no free movement — all actions are deck-driven), health bars, and round structure. All visuals are placeholders — the goal is a functional arena where two entities can face each other.

### Sprint v1.2: Tactic Card & Deck System

**Description:** Card data model (strikes, blocks, specials, etc.), deck structure, and deck building. Cards define what actions a fighter can take. Includes a basic deck editing UI stub for assigning cards to a fighter.

### Sprint v1.3: AI Decision Engine

**Description:** The fighter AI brain that reads the deck and makes moment-to-moment decisions — when to jab, block low, anti-air, use a super, etc. The AI evaluates the current fight state and picks the best card from the deck.

### Sprint v1.4: Fight Simulation & Replay

**Description:** Autonomous fight execution: the AI decisions play out in real-time with card-driven action resolution (no physics hitboxes — animation and damage are simulated from card data), health tracking, and visual feedback. The fight is watchable as a replay (~3 min per match).

### Sprint v1.5: Scouting & Deck Teching

**Description:** Between-fight UI where the player scouts the next opponent's deck fragments and fighting tendencies, then swaps cards in and out of their own deck to counter what they've seen.

### Sprint v1.6: Run Structure & Drafting

**Description:** Full gauntlet flow: ~10 opponents in sequence, draft screen to pick new cards after each win, win/lose conditions, and meta-progression stubs (unlock tracking between runs).

---

## v2: Vertical Slice

Validated core loop with a small amount of content to demonstrate the game's potential and set the tone for the rest of development.

### v2.1: [[Name: TBD]]
**Description:** [[TBD]]

---

## v3: Minimum Viable Product (MVP)

The most stripped down version of the game that is still fun and delivers on the core player fantasy. This version should be playable from start to finish, but with minimal content and placeholder assets.

### v3.1: [[Name: TBD]]
**Description:** [[TBD]]

---

## v4: Alpha (Feature Complete)

All core features are implemented, but content may still be placeholder or incomplete. This version should be playable from start to finish with all intended mechanics, but may have bugs, balance issues, and missing content.

### v4.1: [[Name: TBD]]
**Description:** [[TBD]]

---

## v5: Beta (Content Complete)

All content is implemented and the game is feature complete. This version should be close to release-ready, but may still have bugs, balance issues, and require polish. No need for user stories in this version as all the features should already be implemented and the focus is on polishing and bug fixing.

### v5.1: [[Name: TBD]]
**Description:** [[TBD]]

---

## v6: Launch

The final version of the game that is ready for public release. This version should be polished, stable, and free of major bugs. No need for user stories in this version as all the features should already be implemented and the focus is on polishing and bug fixing.

### v6.1: [[Name: TBD]]
**Description:** [[TBD]]
