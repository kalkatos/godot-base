# Mahou

Mahou is an asynchronous multiplayer Auto Battler game where the player controls a team of characters that fight against other teams of characters.

## Setting

A fantasy world where mages fight in a sport for the entertainment of the audiences. Healing and revive spells exist, so actually no one gets hurt at the end.

## Tone

Whimsical and light-hearted medieval sports. Anime and comics inspired aesthetics.

## Time Length

Each battle runs in 1 to 5 minutes.

## Variables

- MAX_TURNS = 30
- ENERGY_RANGE = 1000
- STATS_RANGE = 100
- CRITICAL_BASE_PCT = 5
- MAX_INSTRUCTIONS_PER_CHARACTER = 10

## General

- The game runs in a small window that can be placed on top of any other window, allowing the player to play the game while doing other activities.
- The player can build many teams with one to six characters each. Each character equips up to 3 spell slots and up to 3 item slots. The position of each character is also important. Then, the player can roll for a new battle.
- Team composition rules:
  - One to six characters.
  - Characters must be unique within a team (no duplicate character id in the same team).
  - Spells must be unique within a team (the same spell id cannot appear in multiple team slots).
  - Items can repeat freely within a character and across the whole team.
- Deterministic: the battles run with a seed. Given a seed and each team composition, the result of the battle must be the same every time.
- The server receives teams compositions, match them against each other, and save on the database. The server code is the same as the client code, but running headless on a docker container listening to requests.
- The client receives a battle seed and teams and runs it one turn at a time showing the result without player interaction. There are controls to fasten the battle speed (1x, 2x, 4x) or to pause the battle.
- The combat is turn-based and proceeds as follows:
  - At the start of combat, an initiative list is created with all characters from both teams. For MAX_TURNS times, the list is filled with each character's initiative value, calculated as speed plus luck factor (character.SPD + random(0, STATS_RANGE / 3)). That value is saved for each list entry (speed and luck factor). If the character's speed is changed mid-combat, the upcoming entries in the initiative list are updated.
  - At each character's turn, they do:
    - choose an action and a target based on their programming (or a basic spell if none is set)
    - execute the action
  - Characters from one team can only target characters from the front-row of the other team. The characters on the back row can only be targeted by area of effect spells or if there is no character on the front row.
  - The battle ends when all characters of one team are defeated or when all characters have had their turn from the initiative list.
- Each character can be placed on one of the 6 positions on the board. The position of the characters is important for the game. The positions are:
  - 1: front-left
  - 2: front-middle
  - 3: front-right
  - 4: back-left
  - 5: back-middle
  - 6: back-right
- When a player builds a team, that team gets registered (or updated if it already exists) in an online database. Each time the player roll for a new battle, a matching team is randomly selected from the database to be the opponent.

## Characters

- Each character differentiate itself by its static characteristics: type, stats, and passive abilities.
- For each character, the player can define up to MAX_INSTRUCTIONS_PER_CHARACTER instructions for their actions. Each instruction have a condition, a target, and an action. Each character's turn they run all the instructions in order and execute the first action whose condition and target are met.
- There is a fallback spell that costs 0 mana that is used if no condition is met. This spell is a single-targeted basic attack.
- The characters have the following stats:
  - HP: health points (0 to ENERGY_RANGE)
  - MP: mana points (0 to ENERGY_RANGE)
  - POW: magic power (0 to STATS_RANGE)
  - DEF: magical defense power (0 to STATS_RANGE)
  - SPD: speed (0 to STATS_RANGE)
  - LUK: luck to achieve critical hits or avoid negative effects (0 to STATS_RANGE)
- Character types are:
  - Vanguard (tank, front row damage absorber)
  - Striker (high damage dealer, front or back row)
  - Support (healer, buffer, debuffer, back row)
- Passive abilities may be (not limited to):
  - Receive X% more damage from Y element
  - Receive X% less damage from Y element
  - X% resistance to Y debuff
  - X% weakness to Y debuff
  - Deal X% more damage with Y element
  - Receive X% less damage from basic attacks
  - Retaliate with a basic attack when hit
  - Deal X% more damage when HP is below Y%
  - Deal X% more damage when target HP is below Y%
  - Protect ally when ally's HP is below Y%
  - Autocast spell 3 when HP gets below X%
  - Autocast spell 3 when a debuff is applied to self
- There is a maximum of 10 instructions per character.

## Spells

- The spells can (but not limited to):
  - Deal damage
  - Heal
  - Improve ally stats
  - Decrease enemy stats
  - Apply buffs
  - Apply debuffs
- Each spell has:
  - Name
  - Description
  - Element (fire, ice, lightning, wind, earth, water, light, dark, none)
  - Target (single enemy, single ally, self, all enemies, all allies, row, column, random enemy, random ally, random row, random column)
  - Effect (damage, heal, buff, debuff)
  - Mana cost (0 to STATS_RANGE)
  - Base damage/heal/buff/debuff value

## Items

- Items can be used in two ways:
  - As a consumable item
  - As an equipment
- The items provide static bonuses to the character, such as:
  - Increase stats
  - Improve resistances
  - Improve abilities
  - Add passive abilities
  - Consumable items may also provide bonuses, case which, when consumed, it ceases its bonuses
- Each item has:
  - Name
  - Description
  - Effect (increase stat, add passive ability)
  - Type (consumable, equipment)
  - Charges (if consumable, default: 1)

## Combat

- The combat is turn-based, with each character having its own turn.
- The action and target is chosen based on the character's programming.
- Conditions are evaluated in order, and the first one that is met is chosen.
- Conditions that can be used are (but not limited to):
  - Always (default)
  - Own HP below X%
  - Own HP above X%
  - Own MP below X%
  - Own MP above X%
  - Is turn number X
- Targeting logic can be (but not limited to):
  - Random (default)
  - A target that is weak to X
  - A target that is strong to X
  - A target that has buff X
  - A target that has debuff X
  - A target that has X stat below Y
  - A target that has X stat above Y
  - A target of type X
  - A target of element X
  - Lowest HP
  - Highest HP
  - Lowest MP
  - Highest MP
- The damage is calculated as follows:
  - Damage = (Base Damage * (Attacker's POW / Target's DEF))
  - For critical: if a random number between 0 and 1 is lower than (Attacker's LUK / (STATS_RANGE * 0.6) * (CRITICAL_BASE_PCT / 100)), the damage is multiplied by 2.
  - If the damage is negative or equal to zero, it is treated as 1.
  - For the basic attack, the base damage is that character's POW.
- The client will receive the battle data from the server as a json object with the following structure:
```json
  "seed": 46132522008
  "team1": {
      "team_name": "e34a80eb",
      "slots": [
        {
          "id": "mage_id",
          "item_1": "item_id_1",
          "item_2": "item_id_2",
          "item_3": "item_id_3",
          "spell_1": "spell_id_1",
          "spell_2": "spell_id_2",
          "spell_3": "spell_id_3",
          "instructions": [
            {
              "condition": "CONDITION_NAME",
              "target": "TARGET_TYPE",
              "action_type": "ACTION_TYPE",
              "action_index": 1
            },
            ...
          ]
        },
        ...
      ]
    }
  "team2": {
      # same fields as team1
    }
  "winner": 1 # (0 = draw, 1 = team1 wins, 2 = team2 wins)
  "version": "1.1.13"
```

  

