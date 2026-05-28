# GAME CONCEPT: Fighter

Keep this document brief. Prefer 1 to 3 bullets per section and short sentences over exhaustive detail. This is a high-level overview to align the team on the core identity and vision of the game. Detailed design decisions, mechanics, and features will be defined later in the development process.

**IMPORTANT**: The language in this document must use clear, unambiguous terms that are also defined in `.docs/glossary.md`. This avoids ambiguity in later stages.

## 1. Game Identity

- Working title: **Fighter**
- Genre: Programming Autobattler Roguelite
- Perspective: Side-view (2D)
- Player count: Single-player + Async PvP
- Target platform: PC (Windows/Mac/Linux)

## 2. Elevator Pitch

A programming autobattler where you wire up a state machine for your fighter — defining conditions, actions, and transitions — then watch your creation autonomously fight opponents in cinematic 2D combat. Scout enemy programs between rounds to rewire your strategy, unlock new states and conditions after victories, and climb a gauntlet of increasingly clever opponents. Your programmed fighter lives on as an async opponent in other players' runs.

## 3. Player Fantasy

- Feel like a robot programmer who builds a cunning, layered strategy by wiring conditions to actions — a grand blueprint that outthinks opponents before the fight even begins.
- Feel the thrill of watching your programmed fighter autonomously execute your state machine — switching stances, exploiting openings, and dismantling unwary opponents exactly as you designed.

## 4. Core Mechanics

- **State Machine Programming**: Wire up a graph of states, conditions, and actions that define your fighter's autonomous behavior. States are modes like "Keep Distance," "Rush Down," or "Defend." Conditions trigger transitions — "Opponent is close → switch to Rush Down." Actions execute while in a state — "Fire projectile every 2s" or "Move backward."
- **Opponent Recon**: Between fights, see fragments of the next opponent's state machine — their states, key transitions, and behavioral tendencies — to inform your counter-strategy.
- **Rewiring**: Tweak your state machine to counter what you've recon'd. Add a "Deflect" state against a projectile-heavy opponent, or a "Grapple Breaker" transition against a close-range program.
- **Full Replay Spectating**: Watch both fighters' state machines execute autonomously in cinematic 2D combat (~3 min per fight). See states activate, transitions fire, and actions play out with full animation and spectacle.
- **Mid-Run Unlocks**: Win a fight → choose new states, conditions, or actions to expand your state machine and evolve your fighter's behavior on the fly.

## 5. Core Loop

- Start a run with a chosen fighter and a starter state machine (a few states, conditions, and actions pre-wired).
- Recon the next opponent: see fragments of their state machine and behavioral tendencies.
- Rewire your state machine to counter their strategy — add transitions, tweak conditions, swap actions.
- Watch the full combat replay (~3 min) as both fighters' state machines execute autonomously.
- Win → unlock new states, conditions, or actions and earn currency.
- Repeat across ~10 opponents (~30 min total per run).
- Lose → run ends. Cash out for meta-progression unlocks (new fighters, starter states, conditions, arenas).

## 6. Unique Features

- **State Machine as Brain**: States, conditions, and transitions are not abstract modifiers — they ARE your fighter's decision-making. A "Keep Distance" state with an "Opponent is close → Rush Down" transition means your fighter will autonomously back away and switch to aggression when breached. The state machine IS the personality.
- **Prediction Metagame**: Recon opponent state machine fragments between fights, then rewire your own transitions and conditions to exploit their behavioral patterns. Outplanning replaces twitch reflexes.
- **Cinematic Autobattler**: Fights are not data sims — they are fully animated 2D combat replays with stylized fighter personalities, hit sparks, and dramatic camera work. The spectacle comes from watching your program come alive.
- **Async PvP Opponents**: Your fighter + state machine can appear as an opponent in other players' gauntlets. Your creation fights even when you're offline.

## 7. References

- From **Gladiabots / Carnage Heart**: visual state machine programming — players wire conditions to actions on a graph, then watch their creations fight autonomously. The state machine IS the gameplay.
- From **Auto Chess / TFT**: autobattler structure — set up your configuration, then watch it play out; upgrading between rounds.
- From **Slay the Spire / deckbuilding roguelites**: run-based structure, unlocking new options mid-run, building synergies, meta-progression between runs.
- From **Street Fighter / classic fighting games**: combat archetypes and spatial dynamics — zoning, rushdown, grappling — that serve as the strategic vocabulary for state machine design.

## 8. Further Notes

- **Tone**: Stylized and energetic — vibrant fighter personalities, arcade energy, flashy visual effects, big moment punctuation when a state transition triggers a decisive action.
- **Meta-progression**: Light roguelite-lite — unlock new fighters, starter states, conditions, and arenas between runs. No heavy stat grinding.
- **Pacing**: ~3 min per fight, ~10 opponents per run, ~30 min per full run. Sessions can be picked up and put down between fights.
- **Simulation Model**: Fights are fully state-machine-driven — no real-time physics collisions or player-controlled movement. State machines determine all actions (attacks, movement, blocking), and outcomes are calculated directly from action data. The spectacle comes from animation and presentation, not from physics interaction.
- Concept pivoted from original fighting-game deckbuilder design to a programming autobattler where players build state machines instead of decks.
