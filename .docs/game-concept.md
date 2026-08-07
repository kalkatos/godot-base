# GAME CONCEPT: SOCSIM

Keep this document brief. Prefer 1 to 3 bullets per section and short sentences over exhaustive detail. This is a high-level overview to align the team on the core identity and vision of the game. Detailed design decisions, mechanics, and features will be defined later in the development process.

**IMPORTANT**: The language in this document must use clear, unambiguous terms that are also defined in `.docs/glossary.md`. This avoids ambiguity in later stages.

## 1. Game Identity

- Working title: Socsim
- Genre: Soccer autobattler (spectator sports simulation)
- Perspective: Broadcast camera — angled, sideline view following the action
- Player count: Single-player (admin-only)
- Target platform: Web

## 2. Elevator Pitch

A soccer autobattler that compresses a full match into a tense 10-minute broadcast you watch, not play. You tune each team's strength variables, launch the fixture, and the compressed realism engine plays the match itself — real soccer dynamics with a moderate dose of luck deciding the outcome.

## 3. Player Fantasy

Feel like a matchday director and head coach in one: you set the odds by tuning your teams, then watch a living, dramatic match unfold that can still surprise you with an upset.

## 4. Core Mechanics

- Tune each team's strength variables (attack, defense, stamina, morale, luck weighting) and save them as reusable presets in the local database
- Launch a fixture between two teams and control match presentation (camera, pacing)
- Watch the compressed realism engine simulate the match in real time
- Read the outcome and adjust variables to rebalance teams for the next fixture

## 5. Core Loop

- Tune each team's strength variables and save them as reusable presets
- Launch a fixture between two teams
- Watch the engine simulate the 10-minute match (two 5-minute halves): possession, pressure, momentum, injuries, upsets
- Resolve the outcome — tuning sets the odds, luck decides the story
- Adjust variables and launch the next fixture

## 6. Unique Features

- Compressed realism engine: real soccer dynamics (possession, pressure, momentum, injuries, upsets) rendered into a fast 10-minute watchable match
- The product is the broadcast: designed to be watched on stream, never played directly
- Tweakable strength variables rendered into match-determining power
- Moderate, visible luck that allows genuine upsets
- International Superstar Soccer Deluxe look and feel with a modern anime/comics art style

## 7. References

- From International Superstar Soccer Deluxe (ISS Deluxe), we take the look and feel of match presentation — readable, energetic, fast-paced action — restyled in a modern anime/comics art style (not pixel art)
- From Football Manager, we take rendering team strength into variables that drive a simulated match engine
- From Blaseball, we take the concept of a simulated sport built to be spectated and streamed
- From auto chess (Auto Chess / Teamfight Tactics), we take the autobattler framing: units clash autonomously, and setup/tuning decides the watchable result

## 8. Further Notes

- Matches are 10 minutes: two 5-minute halves
- One-off fixtures; no seasonal meta-progression — teams are reusable presets saved to the local database
- All control belongs to a single admin; viewers only watch
- Luck must have moderate influence: enough to allow upsets, not so much that tuning stops mattering
- Scope for a solo dev: keep the engine variable-driven and start with placeholder art; target Web via Godot's web export
