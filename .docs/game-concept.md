# GAME CONCEPT: Read

Keep this document brief. Prefer 1 to 3 bullets per section and short sentences over exhaustive detail. This is a high-level overview to align the team on the core identity and vision of the game. Detailed design decisions, mechanics, and features will be defined later in the development process.

**IMPORTANT**: The language in this document must use clear, unambiguous terms that are also defined in `.docs/glossary.md`. This avoids ambiguity in later stages.

## 1. Game Identity

- Working title: **Read**
- Genre: Autobattler Fighting Roguelite
- Perspective: Side-view (2D)
- Player count: Single-player + Async PvP
- Target platform: PC (Windows/Mac/Linux)

## 2. Elevator Pitch

A roguelite autobattler where you build a fighter's AI brain through a deck of tactic cards, scout your opponent's tendencies between rounds, and watch cinematic 2D fighting game replays unfold. Win fights to draft new cards and evolve your fighting style across a gauntlet of stylized opponents — then send your fighter into other players' runs as an async opponent.

## 3. Player Fantasy

- Feel like a corner coach and fight analyst who reads opponents and crafts the perfect gameplan before the bell rings.
- Feel the thrill of watching your fighter autonomously execute the strategy you built — landing the combos and reads you designed.

## 4. Core Mechanics

- **Tactic Card Deckbuilding**: Build a deck of behavior cards (jab, block low, anti-air, super, etc.) that define your fighter's moment-to-moment AI decisions.
- **Opponent Scouting**: Between fights, see fragments of the next opponent's deck and their fighting style tendencies.
- **Deck Teching**: Swap cards in and out to counter what you've scouted — anti-air against a jumper, block pressure against an aggressor.
- **Full Replay Spectating**: Watch AI-driven 2D fighting game matches play out in real-time (~3 min per fight) with full animation and spectacle.
- **Mid-Run Drafting**: Win a fight → choose new tactic cards to evolve your fighter's AI brain on the fly.

## 5. Core Loop

- Start a run with a chosen fighter and a starter deck of tactic cards.
- Scout the next opponent: see fragments of their deck and fighting style.
- Tweak your deck to counter their tendencies.
- Watch the full fight replay (~3 min) as both fighters' AI decks play out autonomously.
- Win → draft new tactic cards and earn gold.
- Repeat across ~10 opponents (~30 min total per run).
- Lose → run ends. Cash out for meta-progression unlocks (new fighters, starter cards, arenas).

## 6. Unique Features

- **Deck as Fighting Brain**: Cards are not abstract buffs — they ARE your fighter's decision-making. A "crouching jab" card means your fighter will choose to crouching jab in that situation. The deck IS the personality.
- **Mind-Reading Metagame**: Scout opponent deck fragments between fights, then tech against specific cards and tendencies. Prediction and preparation replace twitch reflexes.
- **Cinematic Autobattler**: Fights are not data sims — they are fully animated 2D fighting game replays with stylized fighter personalities, hit sparks, and dramatic camera work.
- **Async PvP Opponents**: Your fighter + deck can appear as an opponent in other players' gauntlets. Your creation fights even when you're offline.

## 7. References

- From **Street Fighter / classic fighting games**: character archetypes, special moves, combo structure, and the concept of "making a read" as a core fighting game skill.
- From **Auto Chess / TFT**: autobattler structure — set up your board (deck), then watch it play out; drafting between rounds.
- From **Slay the Spire / deckbuilding roguelites**: run-based structure, drafting cards mid-run, building synergies, meta-progression between runs.

## 8. Further Notes

- **Tone**: Stylized and energetic — vibrant fighter personalities, arcade energy, flashy visual effects, big moment punctuation.
- **Meta-progression**: Light roguelite-lite — unlock new fighters, starter cards, and arenas between runs. No heavy stat grinding.
- **Pacing**: ~3 min per fight, ~10 opponents per run, ~30 min per full run. Sessions can be picked up and put down between fights.
- **Simulation Model**: Fights are fully simulation-driven — no real-time physics collisions or player-controlled movement. Cards determine all actions (attacks, blocks, positioning), and outcomes are calculated directly from card data. The spectacle comes from animation and presentation, not from physics interaction.
- Concept originated from `/start` with seed: "Street Fighter-like fighting game but autobattler. The user defines rules, but the battle happens asynchronously."
