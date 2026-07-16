# CODE SCAFFOLDING: MAHOU

## Editor Model

### Class: Mage
Template for a character's stats and passive abilities in editor.
var mage_id: String
var hp: int
var mp: int
var power: int
var defense: int
var speed: int
var luck: int
var abilities: Array[Ability]

### Class: Rule
Base class for all battle modifiers used in abilities, spells, items, and status effects. It has all the virtual methods that will be implemented in inheriting classes.
var priority: int # Default is 0, but some rules may need to be evaluated above others
func on_<event> (simulation: Simulation) -> void # Repeat for all events

### Class: Ability
A character's ability that can be used in the game.
var id: String
var title: String
var description: String
var rules: Array[Rule]

### Class: Spell
A character's spell that can be used in the game.
var id: String
var title: String
var description: String
var element: Enums.Element
var mana_cost: int
var base_damage: int
var rules: Array[Rule]

### Class: Item
A character's item that can be used in the game.
var id: String
var title: String
var description: String
var is_consumable: bool
var charges: int
var rules: Array[Rule]

### Class: StatusEffect
Status effect that modifies a character.
var id: String
var title: String
var description: String
var rules: Array[Rule]

### Class: Instruction
A character's instruction that can be used in the game. It's a Resource mostly for in-editor testing and debugging purposes, runtime uses only InstructionData.
var condition: Enums.Condition
var target: Enums.Target
var action_type: Enums.ActionType
var action_index: int
func export () -> InstructionData # To save locally or to be sent to the server.
func import (data: InstructionData) # To load locally or to be received from the server.

### Class: MageInit
A character's initial conditions. It's a Resource mostly for in-editor testing and debugging purposes, runtime uses only MageData and MageUnit.
var mage: Mage
var spells: Array[Spell]
var items: Array[Item]
var instructions: Array[Instruction]
func export () -> MageData # To save locally or to be sent to the server.
func import (data: MageData) # To load locally or to be received from the server.

### Class: Team
Team definition. It's a Resource mostly for in-editor testing and debugging purposes, runtime uses only TeamData.
var front_left: MageInit
var front_middle: MageInit
var front_right: MageInit
var back_left: MageInit
var back_middle: MageInit
var back_right: MageInit
func export () -> TeamData # To save locally or to be sent to the server.
func import (data: TeamData) # To load locally or to be received from the server.

---

## Runtime Model

### Class: MageUnit
Definitions for a character's stats and passive abilities in runtime. Runtime id is the object's instance id.
var mage_id: String # Source Mage for reference, not to be used as unique differentiator in dictionaries, etc.
var hp: int
var max_hp: int
var mp: int
var max_mp: int
var power: int
var defense: int
var speed: int
var luck: int
var team: int # 1 or 2
var position: Enums.Position
var abilities: Array[Ability]
var spells: Array[Spell]
var items: Array[Item]
var instructions: Array[Instruction]
var status_effects: Array[AppliedStatusEffect]

### Class: AppliedStatusEffect
Status effect applied to a character.
var status_effect: StatusEffect
var stacks: int

### Class: InstructionData
A character's instruction in simple data format.
var condition: String
var targets: String
var action_type: String
var action_index: int

### Class: MageData
A character's initial conditions in simple data format.
var mage_id: String
var spell_ids: Array[String]
var item_ids: Array[String]
var instructions: Array[InstructionData]

### Class: TeamData
Team definition for a battle in simple data format.
var front_left: MageData
var front_middle: MageData
var front_right: MageData
var back_left: MageData
var back_middle: MageData
var back_right: MageData

### Class: BattleData
Initial data for a battle in simple data format.
var seed: int
var team_1: TeamData
var team_2: TeamData
var winner: int
var version: String

### Class: RuleContext
A rule with its origin
var rule: Rule
var origin: Variant

---

## Control

### Class: RandomNumberGenerator
Singleton object for a simulation that draws a random number. Any random number within the simulation must be drawn through it to avoid drifting.
var seed_value: int
func init (seed_value: int)

### Class: Simulation
Self-contained object that holds the state of the battle and calculates it one turn at a time. Given a seed number and the teams' composition, the end result will always be the same.
var rng: RandomNumberGenerator
var turn: int
var turn_owner: MageUnit
var rule_origin: Variant
var mages_by_id: Dictionary[int, MageUnit] # MageUnit instance id -> MageUnit
var initiative_rolls: Dictionary[int, int] # MageUnit instance id -> initiative roll
var initiative_list: Array[int] # MageUnit instance ids ordered by initiative roll
func init (battle_data: BattleData, seed_value: int)
	rng = RandomNumberGenerator.new(seed_value)
	# Setup MageUnits
	# Roll initiatives
	on_battle_started()
func run_next_turn () -> void
	turn += 1
	for id in initiative_list:
		var mage = mages_by_id[id]
		if mage.hp <= 0:
			continue
		turn_owner = mage
		on_turn_started()
		evaluate_instruction(mage)
		clean_up()
		on_turn_ended()
func on_<event> () -> void
	# Build a list of RuleContext with all active rules and their context
	# Order the rules by priority
	# Run on_<event> in each one of them to alter the state passing this Simulation as context object
func evaluate_instruction (mage: MageUnit) -> void
	# Assess which action will be performed from the mage instructions array (fallback to basic attack)
	# Set up this context and fire events accordingly (on_cast for spells, on_item_used for consumable items, etc.)
func clean_up () -> void
	# Check death of any unit to fire on_death event

---

## View



---

## Enums

### Enum: Position
FRONT_LEFT, FRONT_MIDDLE, FRONT_RIGHT, BACK_LEFT, BACK_MIDDLE, BACK_RIGHT

### Enum: Element
NONE, FIRE, ICE, LIGHTNING, WIND, EARTH, WATER, LIGHT, DARK

### Enum: Condition
ALWAYS, HP_BELOW_25PCT, HP_BELOW_50PCT, HP_BELOW_75PCT, HP_ABOVE_25PCT, HP_ABOVE_50PCT, HP_ABOVE_75PCT, MP_BELOW_25PCT, MP_BELOW_50PCT, MP_BELOW_75PCT, MP_ABOVE_25PCT, MP_ABOVE_50PCT, MP_ABOVE_75PCT, IS_FIRST_TURN, HAS_STATUS_EFFECT, many more TBD...

### Enum: Target
RANDOM, SELF, ALLY, ENEMY, ALL_ENEMIES, ALL_ALLIES

### Enum: ActionType
BASIC_ATTACK, USE_SPELL, USE_ITEM, DIE
