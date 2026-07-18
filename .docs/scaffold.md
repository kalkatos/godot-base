# CODE SCAFFOLDING: MAHOU

A scaffolding guide for the codebase. The classes are organized by architectural layers. This document focuses on classes that are part of the core loop of the game. It is not meant to be a complete description of the entire codebase, but rather a guide to help agents and developers evolve the codebase while keeping its consistency and coherence.

## Editor Model

### Class: Mage extends Resource
Template for a character's stats and passive abilities in editor.
var mage_id: String
var hp: int
var mp: int
var power: int
var defense: int
var speed: int
var luck: int
var abilities: Array[Ability]
var sprite: Texture2D

### Class: Rule extends Resource
Base class for all battle modifiers used in abilities, spells, items, and status effects. It has all the virtual methods that will be implemented in inheriting classes.
var priority: int # Default is 0, but some rules may need to be evaluated above others
func on_event_name (simulation: Simulation) -> void # Repeat for all events

### Class: Ability extends Resource
A character's ability that can be used in the game.
var id: String
var title: String
var description: String
var icon: Texture2D
var rules: Array[Rule]

### Class: Spell extends Resource
A character's spell that can be used in the game.
var id: String
var title: String
var description: String
var icon: Texture2D
var element: Enums.Element
var mana_cost: int
var rules: Array[Rule]

### Class: Item extends Resource
A character's item that can be used in the game.
var id: String
var title: String
var description: String
var icon: Texture2D
var is_consumable: bool
var charges: int
var rules: Array[Rule]

### Class: StatusEffect extends Resource
Status effect that modifies a character.
var id: String
var title: String
var description: String
var rules: Array[Rule]

### Class: Instruction extends Resource
A character's instruction that can be used in the game. It's a Resource mostly for in-editor testing and debugging purposes, runtime uses only InstructionData.
var condition: Enums.Condition
var target: Enums.Target
var action_type: Enums.ActionType
var action_index: int
func export () -> InstructionData # To save locally or to be sent to the server.

### Class: MageInit extends Resource
A character's initial conditions. It's a Resource mostly for in-editor testing and debugging purposes, runtime uses only MageData and MageUnit.
var mage: Mage
var spells: Array[Spell]
var items: Array[Item]
var instructions: Array[Instruction]
func export () -> MageData # To save locally or to be sent to the server.

### Class: Team extends Resource
Team definition. It's a Resource mostly for in-editor testing and debugging purposes, runtime uses only TeamData.
var front_left: MageInit
var front_middle: MageInit
var front_right: MageInit
var back_left: MageInit
var back_middle: MageInit
var back_right: MageInit
func export () -> TeamData # To save locally or to be sent to the server.

### Class: PriceCompendium extends Node
A collection of all the items and spells available in the store and their prices.
var items: Dictionary[Item, int]
var spells: Dictionary[Spell, int]

### Class: BattleConfig extends Node
Configurations for all the battles in the game.
var initiative_variation: int
var max_turns: int

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
var mage_index: int = -1
var turn_owner: MageUnit
var rule_origin: Variant
var mages_by_id: Dictionary[int, MageUnit] # MageUnit instance id -> MageUnit
var mages_by_team: Dictionary[int, Array[MageUnit]] # MageUnit team id -> Array[MageUnit]
var initiative_rolls: Dictionary[int, int] # MageUnit instance id -> initiative roll
var initiative_list: Array[int] # MageUnit instance ids ordered by initiative roll
func init (battle_data: BattleData, seed_value: int)
	rng = RandomNumberGenerator.new(seed_value)
	# Setup MageUnits
	# Roll initiatives with initiative_variation
	_on_battle_started()
func run_next_turn () -> void
	if _check_battle_ended():
		return
	if turn <= 0:
		turn = 1
		mage_index = 0
	else:
		mage_index += 1
		if mage_index >= mages_by_id.size():
			mage_index = 0
			turn += 1
	var mage_id = initiative_list[mage_index]
	var mage = mages_by_id[id]
	if mage.hp <= 0:
		run_next_turn()
		return
	turn_owner = mage
	_on_turn_started()
	_evaluate_instruction(mage)
	_clean_up()
	_on_turn_ended()
	if _check_battle_ended():
		_on_battle_ended()
func _get_list_of_rules () -> Array[RuleContext]:
	# Build a list of RuleContext with all active rules and their context
	# Order the rules by priority
func _on_event_name () -> void
	var rules = _get_list_of_rules()
	# Run on_event_name in each one of the rules to alter the state passing this Simulation as context object
func _evaluate_instruction (mage: MageUnit) -> void
	# Assess which action will be performed from the mage instructions array (fallback to basic attack)
	# Set up this context and fire events accordingly (on_cast for spells, _on_item_used for consumable items, etc.)
func _clean_up () -> void
	# Check death of any unit to fire _on_death event
func _check_battle_ended () -> bool
	# Check if all mages of a team are dead or turn number is >= max_turns

---

## Presenter

### Class: BattleTesterPresenter extends Node2D
Type: world (2D). Accessible from: always on for test/debug purposes. Description: this class runs the simulation and displays the results on the console through text.
var seed: int
var team_1: Team
var team_2: Team
var one_turn_each_time: bool
var delay: float
func _ready () -> void
	var battle_data = BattleData.new()
	battle_data.seed = seed
	battle_data.team_1 = team_1.export()
	battle_data.team_2 = team_2.export()
	var simulation = Simulation.new(battle_data, seed)
func _input (event: InputEvent) -> void
	# If button R is pressed: if one_turn_each_time: run one turn of the simulation; else: run the simulation until the end
func run ()

### Class: MainScenePresenter extends CanvasLayer
Type: scene screen. Accessible from: always on. Description: is the only scene in the game and root for all the other screens. Manages the other screens. Has a menu bar that shows different buttons depending on the current mode. In Idle Mode, it shows the buttons: store, inventory, history, and battle. In Battle Mode, it shows the buttons: pause, 1x, 2x, 4x, exit.
var _mode: Enums.SceneMode
func handle_button_clicked (slug: String) -> void # Each button calls this function with the button's slug name when pressed. Then, this function emit the appropriate request signal through SignalBus.

### Class: WindowPresenter extends CanvasLayer
Type: overlay screen. Accessible from: always on. Description: shows the window controls (close/quit, move, and settings).
var close_button: Button # Closes the window with a confirmation dialog
var move_button: Button # When pressed, the player drags the game screen to position anywhere
var settings_button: Button

### Class: CharacterEditPresenter extends CanvasLayer
Type: popup screen. Accessible from: selecting a character in the world. Description: shows a character's stats, abilities, spells, items, and instructions and allows to edit them.

### Class: HistoryPresenter extends CanvasLayer
Type: popup screen. Accessible from: a button in the menu. Description: shows the history of battles for current team.

### Class: StorePresenter extends CanvasLayer
Type: popup screen. Accessible from: MainScenePresenter in Store Mode. Description: allows to buy items and spells.

### Class: BattlePresenter extends Node2D
Type: world (2D). Accessible from: always on. Description: manages the battle simulation itself, except for the UI. Runs the simulation and updates each character's HP/MP/etc.

### Class: TeamPresenter extends Node2D
Type: world (2D). Accessible from: always on. Description: manages the team presentation in the world. In Idle Mode, it shows the selected team and allows to edit it. In Battle Mode, it shows the player's team and the opponent team. Updates when a new team is selected.

### Class: DialogPresenter extends CanvasLayer
Type: popup screen. Accessible from: button on WindowPresenter. Description: Reusable dialog window.

### Class: SettingsPresenter extends CanvasLayer
Type: popup screen. Accessible from: button on WindowPresenter. Description: Shows the settings menu.

### Class: InventoryPresenter extends CanvasLayer
var container: GridContainer
func setup (objects: Array[Resource]) -> void
	# Setup the grid container with the InventoryObjectViews
	# Hook up each InventoryObjectView signal to the _handle_object_click
func _handle_object_click (object: InventoryObjectView) -> void
	# Emit to SignalBus an intention of equipping the object

---

## View
Menu of instructions. Store display. Current teams widget. Menu of buttons for each mode.

### Class: InventoryObjectView extends Control
A visual representation of an object in the inventory (item, spell, or character).
signal on_click
var icon_view: TextureRect
var _object: Resource
func setup (object: Resource) -> void
func _handle_click () -> void
	on_click.emit()

### Class: CharacterView extends Node2D
A visual representation of a character in the world.
var sprite: Sprite2D
var health_bar: HealthBar
var mana_bar: HealthBar

---

## Enums

### Enums.SceneMode
IDLE, BATTLE

### Enums.Position
FRONT_LEFT, FRONT_MIDDLE, FRONT_RIGHT, BACK_LEFT, BACK_MIDDLE, BACK_RIGHT

### Enums.Element
NONE, FIRE, ICE, LIGHTNING, WIND, EARTH, WATER, LIGHT, DARK

### Enums.Condition
ALWAYS, HP_BELOW_25PCT, HP_BELOW_50PCT, HP_BELOW_75PCT, HP_ABOVE_25PCT, HP_ABOVE_50PCT, HP_ABOVE_75PCT, MP_BELOW_25PCT, MP_BELOW_50PCT, MP_BELOW_75PCT, MP_ABOVE_25PCT, MP_ABOVE_50PCT, MP_ABOVE_75PCT, IS_FIRST_TURN, HAS_STATUS_EFFECT, many more TBD...

### Enums.Target
RANDOM, SELF, ALLY, ENEMY, ALL_ENEMIES, ALL_ALLIES

### Enums.ActionType
BASIC_ATTACK, USE_SPELL, USE_ITEM, DIE
