# Rule Architecture — Event-Driven Combat Engine

The spell/effect system uses a hook-based dispatch pattern. This reference documents the architecture established in Day 3 (v1.1.3) of Sprint v1.1.

## Core Concepts

### `Rule` (extends Resource)

Base class for all spell effects, item effects, buffs, and debuffs. Rules are **mutable and stateful** — each instance tracks its own `stacks`, `duration`, etc., and self-removes when expired.

**Hook stubs** — a Rule implements only the hooks it cares about:

```gdscript
class_name Rule
extends Resource

func handle_bot(context: BattleContext, character: MageData, rule_origin: Rule) -> Array[RuleResult]:
    return []

func handle_eot(context: BattleContext, character: MageData, rule_origin: Rule) -> Array[RuleResult]:
    return []

func handle_on_cast(context: BattleContext, caster: MageData, spell: SpellData, rule_origin: Rule) -> Array[RuleResult]:
    return []

func handle_on_hit(context: BattleContext, attacker: MageData, defender: MageData, rule_origin: Rule) -> Array[RuleResult]:
    return []
```

Each hook receives:
- `context: BattleContext` — shared match state
- `character/caster/attacker/defender: MageData` — the mage this rule is attached to
- `rule_origin: Rule` — `self` reference for stateful mutation

Returns `Array[RuleResult]` — atomic modifiers to apply.

### `BattleContext`

Holds all match state, passed to every hook:

```gdscript
class_name BattleContext
extends RefCounted

var team_a: Array[MageData]
var team_b: Array[MageData]
var turn_number: int
var phase: Enums.TurnPhase  # BOT, ACTION, EOT
var initiative_list: Array[MageData]
var combat_log: Array[String]
var config: CombatConfig
var rng: RandomNumberGenerator
```

### `RuleResult`

Lightweight atomic modifier:

```gdscript
class_name RuleResult
extends RefCounted

var target_id: int
var stat: Enums.Stat
var delta: int
var description: String
```

### Combat Processor Hook Dispatch

At each hook point, `CombatController`:
1. Gather all active rules across all characters
2. Fire the hook on each rule
3. Collect `Array[RuleResult]` from all rules
4. Apply stat deltas atomically (in order)
5. Check deaths after the phase completes

## Concrete Rules for v1.1

| Rule | Hook | Behavior |
|---|---|---|
| `Rule_DealDamage` | `handle_on_cast` | `base_power + (caster.POW / max(target.DEF, 1))`, minimum 1 damage |
| `Rule_Heal` | `handle_on_cast` | Per-spell formula via `@export var heal_amount: int` and `@export var heal_ratio: float` |
| `Rule_StatMod` | `handle_on_cast` | Instant flat stat modifier: `@export var stat: Enums.Stat`, `@export var amount: int`, `@export var is_debuff: bool` |
| `Rule_DealDamageAtEOT` | `handle_eot` | `stacks * base_value` damage per tick, `stacks -= 1`, self-removes at 0 |

## Mutable Rule Pattern

Rules track their own state and self-remove when expired. Example Poison:

```gdscript
class_name Rule_DealDamageAtEOT
extends Rule

@export var base_value: int = 5
var stacks: int = 3

func handle_eot(context, character, rule_origin):
    var rule := rule_origin as Rule_DealDamageAtEOT
    var result := RuleResult.new()
    result.target_id = character.id
    result.stat = Enums.Stat.HP
    result.delta = -(rule.stacks * rule.base_value)
    rule.stacks -= 1
    if rule.stacks <= 0:
        _remove_from_character(character, rule)
    return [result]
```

## Deferred for Later Sprints

- Duration-based effects (N turns, not stacks-based)
- Stacking mechanics (multiple instances of same buff)
- Rule interaction (rules that modify other rules)
- Conditional rules ("if target HP < 50%, deal extra damage")
