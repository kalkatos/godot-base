# Strategy Pattern for Pluggable Game Rules in Godot/GDScript

Use when a game mechanic has multiple possible implementations that should be switchable at runtime or test-time without modifying the core loop.

## When to Reach for It

- Victory/loss conditions (elimination, turn limit, first blood, king of the hill)
- AI decision-making (aggressive, defensive, random, scripted)
- Damage formulas (flat, percentage, elemental)
- Target selection (weakest, highest threat, proximity)
- End-of-turn effects (poison tick, shield decay, summon duration)
- Scoring/rating systems

## The Pattern

### 1. Base interface (abstract class)

```gdscript
# Model/VictoryCondition.gd (or any predicate)
class_name VictoryCondition
extends RefCounted

func check (context: CombatContext) -> VictoryResult:
    return VictoryResult.new(false, "")
```

Use `RefCounted` (not `Resource`, not `Node`) — it's lightweight, has no scene baggage, and gets freed automatically.

### 2. Result type

```gdscript
# Model/VictoryResult.gd
class_name VictoryResult
extends RefCounted

var decided: bool
var winner_id: String    # "" for draw, team_id for victory

func _init (p_decided: bool, p_winner_id: String):
    decided = p_decided
    winner_id = p_winner_id
```

### 3. Concrete implementations

```gdscript
# Model/EliminationVictory.gd
class_name EliminationVictory
extends VictoryCondition

func check (context: CombatContext) -> VictoryResult:
    for team_id in context.teams:
        if context.teams[team_id].any_alive():
            continue
        # Only other team remains → they win
        return VictoryResult.new(true, _find_other_team(team_id))
    return VictoryResult.new(false, "")
```

```gdscript
# Model/TurnLimitVictory.gd
class_name TurnLimitVictory
extends VictoryCondition

@export var max_turns: int = 30

func check (context: CombatContext) -> VictoryResult:
    if context.turn_count >= max_turns:
        return VictoryResult.new(true, _judge_draw_winner(context))
    return VictoryResult.new(false, "")
```

### 4. Composition (run multiple strategies in order)

```gdscript
# Model/CompositeVictory.gd
class_name CompositeVictory
extends VictoryCondition

var conditions: Array[VictoryCondition] = []

func check (context: CombatContext) -> VictoryResult:
    for condition in conditions:
        var result = condition.check(context)
        if result.decided:
            return result
    return VictoryResult.new(false, "")
```

### 5. Wiring in the controller

```gdscript
# Control/CombatController.gd
func _init ():
    # Compose victory strategies — order matters (first match wins)
    victory = CompositeVictory.new()
    victory.conditions = [
        EliminationVictory.new(),
        TurnLimitVictory.new(),
    ]

func _tick_combat (context: CombatContext):
    # ... resolve actions ...
    var result = victory.check(context)
    if result.decided:
        emit_combat_ended(result.winner_id)
        return
    # ... advance turn ...
```

## Testing Benefits

Each strategy is a **single predicate** you can test against a **minimal context** — no need to spin up the full combat engine:

```gdscript
# Test: elimination fires exactly when a team is dead
func test_elimination_via_team_death ():
    var strat = EliminationVictory.new()
    var ctx = _make_context_with_dead_team("team_b")
    var result = strat.check(ctx)
    assert_true(result.decided)
    assert_eq(result.winner_id, "team_a")

# Test: turn limit at boundary
func test_turn_limit_at_max_turns ():
    var strat = TurnLimitVictory.new()
    strat.max_turns = 30
    assert_true(strat.check(_make_context(turn_count = 30)).decided)

# Test: turn limit does NOT fire early
func test_turn_limit_not_premature ():
    var strat = TurnLimitVictory.new()
    strat.max_turns = 30
    assert_false(strat.check(_make_context(turn_count = 29)).decided)
```

## When NOT to Use

- **Only one implementation exists, and none are planned.** A 10-line `_check_victory()` method with two `if` branches is fine. The strategy pattern adds indirection — it pays off with the third variant, not the first.
- **The predicate logic changes per deployment but not per game session.** Configurable constants (max_turns, team_size) don't need a strategy — `@export var` on the controller is enough.
- **Performance-critical code called per-frame.** Strategy pattern adds a virtual call per check. For per-tick combat checks (once per unit per turn), it's negligible. For per-frame collision queries, it's not.
- **The result needs to modify game state.** If the victory check also awards XP, unlocks a scene transition, or triggers a cutscene, the strategy pattern's single return value is too narrow — use an event/queue instead.

## Alignment with Modular MVP Architecture

- `VictoryCondition` (RefCounted) sits between the Model layer (passive data) and Controller layer (rules). It's a **rule predicate** operating on model data — not a View, not a Service.
- Composability via `CompositeVictory` follows the architecture's composition-over-inheritance principle.
- Strategies are injected into the Controller at init time, keeping the Controller's core loop clean of branching.
- Mirrors the planned Day 3 pluggable AI: `AIDecision` (strategy) → `CombatController` (host) follows the identical pattern.
