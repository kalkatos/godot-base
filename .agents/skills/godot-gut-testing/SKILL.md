---
name: godot-gut-testing
description: "Write GUT unit tests for Godot 4.x game projects — Resources, signals, enums, and data contracts."
version: 1.2.0
author: Imp (QA)
platforms: [linux, windows]
metadata:
  hermes:
    tags: [qa, testing, godot, gut, gdscript, game-development]
    related_skills: [test-driven-development]
---

# Godot GUT Testing

QA-focused patterns for writing GUT unit tests in Godot 4.x game projects.

## When to Use

- Writing new unit tests for Godot Resources, scripts, or autoloads
- Testing signal emissions and SignalBus patterns
- Running a **QA audit** on a test suite (user asks to "review tests", "do a pass on our tests", "check tests for issues")
- User asks to "write tests" or mentions GUT / Godot testing

## Test Review / QA Audit Checklist

When the user asks to review or audit existing tests (not write new ones), follow this systematic checklist. Read every test file in the suite, then evaluate against these dimensions:

### 1. Coherence — Does the test test what it claims to test?

- Read the file-level header comment and each test's docstring. Compare against the actual assertions in the body.
- **Incomplete enum tests**: A test claiming "All X values round-trip" but the loop array only contains one value. Fix by adding ALL enum members.
- **Wrongly-scoped tests**: Testing the same logic the source file already handles (e.g., a DTO round-trip test duplicating the DTO's own unit test file).

### 2. Efficiency — Are tests free of wasteful duplication?

- **Cross-file duplication**: Two test files testing the exact same thing with the same assertions. Remove the copy in the less-appropriate file (e.g., enum file shouldn't repeat SpellData round-trips already in `test_spell_data.gd`).
- **Stale preloads**: A `const ClassName = preload(...)` that's no longer used after removing duplicate tests. Delete it.

### 3. Currency — Are assertions and comments still accurate?

- Find every `pending(...)` call. Read the comment above it. Has the feature since been implemented? Has it been tested in a *newer* test file?
- **Stale PENDING**: `pending("Feature X not yet implemented")` when `test_feature_x.gd` now exists and passes. Update the comment to reference where the feature is tested now, and note why *this* file's integration test is still deferred.
- **Stale log-size assertions**: When a structured log format gains new entry types (TURN_STARTED, COMBAT_ENDED), hardcoded `assert_lt(log.size(), N)` assertions break. Read the source controller to identify every entry-adding call, recalculate expected counts, and update the assertion with a composition comment (see Pitfalls → Stale Structured-Log Size Assertions).

### 4. File header comments — Do they describe current reality?

- Header comments like "covers SpellData string fields" when the fields were changed to typed enums. Update to match current source.

### 5. Coding standards — Do tests follow project conventions?

- **CS-11**: `:=` (inferred type) — NEVER use. Replace `var u := CombatUnit.new()` with `var u: CombatUnit = CombatUnit.new()`.
- **CS-01**: `func name (param: type) -> void:` — space before `(` always.
- **CS-02**: No blank lines within method bodies.
- Use `search_files(pattern=':=', file_glob='*.gd', path='src/tests')` to quickly find all violations.

## Project Setup

Tests live under the Godot project root (usually `src/`):
```
src/
├── tests/
│   └── unit/
│       ├── test_*.gd          # Test files
│       └── helpers/           # Shared test utilities
├── addons/
│   └── gut/                   # GUT addon
│       └── cli/
│           └── gut_cli.gd    # CLI entrypoint
```

## Running Tests

**Before running, discover the Godot binary path** (see "Godot Path Discovery" above). Once found:

### Linux (server CI / container)

```bash
# From src/ directory — IMPORT_RUN FIRST
cd src && <godot> --headless --path . --import
# Then run tests
<godot> --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -ginclude_subdirs -gexit -glog=1
```

### Windows (developer machine)

```powershell
# From src/ directory (PowerShell)
& 'C:\Program Files\Godot\Godot_console.exe' --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -ginclude_subdirs -gexit -glog=1
```

CLI entrypoint: `res://addons/gut/cli/gut_cli.gd`

## Test File Template

Every test file follows this structure:

```gdscript
## Description of what this test file covers.
##
## Covers specific classes/files: res://path/to/source.gd
extends GutTest

# Resource/script references
const ClassName = preload("res://path/to/script.gd")

# Test lifecycle hooks
func before_all () -> void:
    # One-time setup (shared across all tests)

func before_each () -> void:
    # Reset state before each test

func after_each () -> void:
    # Cleanup after each test

# Test methods — must start with 'test_'
func test_specific_behavior () -> void:
    var obj: ClassName = ClassName.new()
    # ... assertions ...
```

## Key GUT Assertions

| Assertion | Usage |
|-----------|-------|
| `assert_eq(got, expected, text)` | Equality check |
| `assert_ne(got, not_expected, text)` | Inequality check |
| `assert_true(got, text)` | Boolean true |
| `assert_false(got, text)` | Boolean false |
| `assert_between(val, low, high, text)` | Range check |
| `assert_gt(got, expected, text)` | Greater than |
| `assert_lt(got, expected, text)` | Less than |
| `assert_has(array, element, text)` | Array contains |
| `assert_file_exists(path)` | File existence |
| `assert_is(obj, class, text)` | Instance-of check |
| `pending(text)` | Mark test as pending (not yet implemented) |

### Signal Assertions

```gdscript
var _bus: Node

func before_all () -> void:
    _bus = SignalBus  # Reference to autoload

func before_each () -> void:
    clear_signal_watcher()     # Always clear first — prevents cross-test bleed
    watch_signals(_bus)        # Watch the signal source

# Assert a signal was emitted
assert_signal_emitted(_bus, "signal_name", "message")

# Assert signal was NOT emitted
assert_signal_not_emitted(_bus, "signal_name")

# Assert emit count
assert_signal_emit_count(_bus, "signal_name", expected_count)

# Get signal parameters: returns Array of Arrays (one per emission)
var params: Array = get_signal_parameters(_bus, "signal_name")
# params[0] = ["param1_value", param2_value, ...] from first emission
# params[1] = [...] from second emission

# Get Nth emission's parameters (0-indexed)
var second_params: Array = get_signal_parameters(_bus, "signal_name", 1)
```

## Testing Patterns

### Resource Defaults

```gdscript
func test_resource_default_values () -> void:
    var res: MyResource = MyResourceClass.new()
    assert_eq(res.property, default_value, "Default <property> should be <expected>")
    # Test every exported property
```

### Resource Set/Get

```gdscript
func test_resource_set_get () -> void:
    var res: MyResource = MyResourceClass.new()
    res.property = expected_value
    assert_eq(res.property, expected_value)
```

### Resource Duplicate Independence

```gdscript
func test_resource_duplicate_independence () -> void:
    var orig: MyResource = MyResourceClass.new()
    orig.property = "original"
    var dup: MyResource = orig.duplicate() as MyResource
    orig.property = "changed"
    assert_eq(dup.property, "original", "Duplicate must be independent copy")
```

### Enum Value Verification

```gdscript
func test_enum_values () -> void:
    assert_eq(MyEnum.SomeType.FOO, 0)
    assert_eq(MyEnum.SomeType.BAR, 1)

func test_enum_key_count () -> void:
    var keys: PackedStringArray = MyEnum.SomeType.keys()
    assert_eq(keys.size(), expected_count, "Should have exactly <N> values")
    assert_has(keys, "FOO")
    assert_has(keys, "BAR")
```

### String-to-Enum Mapping (for Resources that store enum-related strings)

> **Note:** Only use this pattern when the Resource field IS a String that stores enum-like values (e.g., `character_type: String`). If the field is typed as an enum (e.g., `spell_type: Enums.SpellType`), use the **Enum Typed Fields** pattern below instead.

```gdscript
func test_string_field_maps_to_enum_keys () -> void:
    var expected: Array[String] = []
    for key in MyEnum.SomeType.keys():
        expected.append(key.to_lower())
    var res: MyResource = MyResourceClass.new()
    for value in expected:
        res.type_field = value
        assert_eq(res.type_field, value)
```

### Enum Typed Fields (for Resources with `@export var field: Enums.SomeEnum`)

When the Resource field is typed as a Godot enum (not a String), test enum value round-trips directly. Do NOT assign strings — they will fail at parse time.

```gdscript
func test_enum_field_round_trip () -> void:
    var res: MyResource = MyResourceClass.new()
    res.enum_field = Enums.SomeType.VALUE_A
    assert_eq(res.enum_field, Enums.SomeType.VALUE_A)


func test_all_enum_values_accepted () -> void:
    var all: Array[Enums.SomeType] = [Enums.SomeType.VALUE_A, Enums.SomeType.VALUE_B]
    var res: MyResource = MyResourceClass.new()
    for val in all:
        res.enum_field = val
        assert_eq(res.enum_field, val, "enum value %d should round-trip" % val)
```

**Enum default value:** Godot enum fields default to `0` (the first declared member), never to an empty string or `null`.

```gdscript
func test_enum_default () -> void:
    var res: MyResource = MyResourceClass.new()
    assert_eq(res.enum_field, Enums.SomeType.VALUE_A, "Default should be first enum member (value 0)")
```

### Autoload Testing (Node singletons without class_name)

When an autoload extends `Node` but has no `class_name` directive, Godot's static GDScript parser cannot resolve custom properties on the autoload reference. Use `Object.get()`/`Object.set()` to bypass static type checking:

```gdscript
func test_autoload_defaults () -> void:
    assert_eq(MyAutoload.get("max_turns"), 30, "Default max_turns should be 30")
    assert_eq(MyAutoload.get("stats_range"), 30, "Default stats_range should be 30")


func test_autoload_set_get () -> void:
    MyAutoload.set("max_turns", 50)
    assert_eq(MyAutoload.get("max_turns"), 50)


func before_each () -> void:
    # Save original values before mutating autoload state
    _saved_max_turns = MyAutoload.get("max_turns")


func after_each () -> void:
    # Restore after each test to avoid cross-test contamination
    MyAutoload.set("max_turns", _saved_max_turns)
```

**Pitfall:** Attempting `MyAutoload.max_turns` directly on a no-class_name autoload causes `Parse Error: Cannot find member "max_turns" in base "res://path/to/script.gd"`. The parser only sees the base type (`Node`). Use `get()`/`set()` always.

For autoloads that DO have `class_name` (e.g., `SignalBus` is registered as an autoload and used via `var _bus: Node = SignalBus`), direct property access works fine through the assigned variable.

### Enum Field Round-Trip (Resources with typed Enum fields)

When a Resource field is `@export var field: Enums.SomeEnum` (not String), test that all enum values round-trip correctly:

```gdscript
func test_enum_field_round_trip () -> void:
    var all_values: Array[Enums.SomeEnum] = [Enums.SomeEnum.FOO, Enums.SomeEnum.BAR]
    var res: MyResource = MyResourceClass.new()
    for val in all_values:
        res.field = val
        assert_eq(res.field, val, "field should round-trip enum value %d" % val)
```

**Pitfall — enum default value:** When a field is typed `Enums.SomeEnum`, the default is integer `0` (the first enum key), **NOT** an empty string `""`. Tests written for a String-typed field will fail with `assert_eq(res.field, "")` — fix to `assert_eq(res.field, Enums.SomeEnum.FOO, ...)`.

### Signal Emission (Parameter Integrity)

```gdscript
func test_emit_signal_with_params () -> void:
    _bus.emit_function("param_value")
    assert_signal_emitted(_bus, "signal_name")
    var params: Array = get_signal_parameters(_bus, "signal_name")
    assert_eq(params[0], "param_value", "First param must match")
```

### Full Signal Sequence

```gdscript
func test_full_sequence () -> void:
    _bus.emit_start()
    _bus.emit_action("a", "b", "data")
    _bus.emit_end("winner")
    assert_signal_emit_count(_bus, "started", 1)
    assert_signal_emit_count(_bus, "action", 1)
    assert_signal_emit_count(_bus, "ended", 1)
```

### Negative Tests (Signals not emitted)

```gdscript
func test_signals_not_emitted_when_not_called () -> void:
    assert_signal_not_emitted(_bus, "signal_name")
```

## Coding Standards in Test Files

Tests must follow the same coding standards as production code:

- **CS-01**: `func name (param: type) -> void:` — space before parenthesis ✓
- **CS-02**: No blank lines within methods
- **CS-11**: NEVER use `:=` — use explicit types (`var x: Type = value`) or cast (`var x = value as Type`)
- **Naming**: Test methods start with `test_`, use snake_case

### Incorrect vs Correct

```gdscript
# WRONG (CS-11 violation)
var sd := SpellData.new()

# CORRECT
var sd: SpellData = SpellDataClass.new()
# or
var sd = SpellDataClass.new() as SpellData
```

```gdscript
# WRONG (CS-01 violation — no space before parens)
func test_thing() -> void:

# CORRECT
func test_thing () -> void:
```

## Pitfalls

## Signal Naming Pitfall

**Always match the actual signal name in the source code.** 

In the SignalBus (`src/Game/Globals/signal_bus.gd`), **all** signals start with `_on_` prefix (e.g., `_on_combat_started`, `_on_turn_started`, `_on_combat_action_resolved`, `_on_unit_died`, `_on_combat_ended`). The `_on_` prefix is required for the auto-connection loop in `_ready()`. System-scoped signals (e.g., `_on_scene_transition_requested`) also use this prefix. **Always check the source `signal_bus.gd` before writing assertions** — never assume signal names from secondary documentation.
The `_on_` prefix signals auto-connect via the `_ready()` forwarding loop. Signals without `_on_` are manually forwarded in emit helper functions.

## Test Maintenance Pitfalls

### Missing class_name

When tests reference `SomeClass.EnumName.VALUE` and the test file runs, GDScript looks for `class_name SomeClass` in the project. If that class_name doesn't exist (it was renamed, moved, or never created), all tests using it break.

**Always verify the class_name in the source file before writing tests that reference it.** Example: tests used `CombatEnums.SpellType.DAMAGE` but the source file `enums.gd` only defines `class_name Enums` — `CombatEnums` was a phantom reference from an earlier design that never materialized.

### Emit helper parameter type drift

When SignalBus emit helpers change their parameter types (e.g., from `String` to typed `MageData`/`SpellData`), existing tests that pass string literals will fail at runtime:

```gdscript
# OLD (String params — tests pass strings)
_bus.emit_combat_action_resolved("mage_a", "mage_b", "fireball", {"damage": 50})

# NEW (typed params — tests must create instances)
var actor: MageData = MageDataClass.new()
actor.name = "mage_a"
var target: MageData = MageDataClass.new()
target.name = "mage_b"
var spell: SpellData = SpellDataClass.new()
spell.name = "fireball"
_bus.emit_combat_action_resolved(actor, target, spell, {"damage": 50})
```

When assertions check signal parameters, they must access properties on the typed objects (`.name`) rather than comparing the whole object to a string.

### RefCounted vs Resource

Some classes extend `RefCounted` (not `Resource`). Key differences for testing:

- `Resource.duplicate()` works; `RefCounted.duplicate()` is less common and may not deep-copy
- For RefCounted containers (e.g., `CombatLog`), test **clear-and-reuse** patterns instead of duplicate independence
- `RefCounted` objects don't have the `.tres` file support that Resources do; always construct programmatically

### Incomplete Enum Tests

A test that claims "All X values round-trip" but only includes a subset of enum values in the loop array:

```gdscript
# WRONG — claim says "all" but array only has one value:
func test_character_types () -> void:
    ## All CharacterType enum values round-trip.
    var types: Array[Enums.CharacterType] = [
        Enums.CharacterType.VANGUARD,   # missing STRIKER and SUPPORT!
    ]

# CORRECT — include every declared enum member:
func test_character_types () -> void:
    ## All CharacterType enum values round-trip (VANGUARD, STRIKER, SUPPORT).
    var types: Array[Enums.CharacterType] = [
        Enums.CharacterType.VANGUARD,
        Enums.CharacterType.STRIKER,
        Enums.CharacterType.SUPPORT,
    ]
```

**During QA audit:** for every test with "all" or "every" in its docstring, count the array items against `Enums.EnumName.keys().size()`. If they don't match, the test is incomplete.

### Stale PENDING Comments

As features are implemented and tested in newer test files, older test files may retain PENDING markers that claim the feature "is not yet implemented":

```gdscript
# STALE — feature was implemented in test_mp_exhaustion.gd months ago:
func test_mp_exhaustion_fallback () -> void:
    pending("MP system and spell selection not yet integrated into CombatController")

# FIXED — reference where the feature IS tested:
func test_mp_exhaustion_fallback () -> void:
    pending("MP exhaustion tested separately in test_mp_exhaustion.gd — turn-engine integration deferred")
```

**During QA audit:** grep for `pending(` across all test files. For each, ask: does a test for this feature exist somewhere else in the suite? If yes, update the comment. Also update the file header's scenario list if it marks items as "PENDING".

### Stale Structured-Log Size Assertions

When a structured log format gains new entry types (e.g., `TURN_STARTED` and `COMBAT_ENDED` boundary entries added alongside action entries), existing tests that assert a hardcoded log size break. The test was written when the log only contained action entries (`N mages × T turns = N×T entries`), but now it also includes turn boundaries, combat-ended markers, and death entries.

**Diagnosis:** When a test like `assert_lt(log_.size(), 7)` fails with `[10] expected to be < than [7]`, that's not a bug in the code — the log format was intentionally extended. Read the source that builds the log (usually the controller) and identify every entry-adding call. Count the expected entries per turn cycle including all boundary types.

**Fix:** Replace the stale hardcoded assertion with a calculation that accounts for the current entry types. Use `assert_eq` with the exact expected count and a comment that breaks down the composition:

```gdscript
# STALE — assumed only action entries (2 mages × 3 turns = 6):
assert_lt(log_.size(), 7, "Log must not exceed 6 entries for 3-turn draw")

# FIXED — accounts for TURN_STARTED + actions + COMBAT_ENDED:
# 3 TURN_STARTED + 6 action entries + 1 COMBAT_ENDED = 10 entries.
assert_eq(log_.size(), 10, "Log must have exactly 10 entries for 3-turn draw (3 TURN_STARTED + 6 actions + 1 COMBAT_ENDED)")
```

**Prevention:** When writing tests that assert log sizes, always comment the expected composition (`4 actions + 4 TURN_STARTED + 1 COMBAT_ENDED = 9`). A future agent updating the log format will have an easier time finding and updating all affected assertions.

### Enum-Typed Resource Fields Default to First Value

When a Resource has `@export var field: Enums.SomeEnum`, the default value is **the first enum key (integer 0)**, NOT an empty string, NOT `null`, and NOT a sentinel. For example:

```gdscript
# In the Resource:
@export var character_type: Enums.CharacterType

# In the test — WRONG:
assert_eq(res.character_type, "", "Default should be empty")  # Fails! Enum defaults to 0 (VANGUARD)

# CORRECT:
assert_eq(res.character_type, Enums.CharacterType.VANGUARD, "Default is first enum value (0)")
```

Always check the enum definition to know which key is index 0. Do NOT write `assert_eq(res.field, "")` for enum-typed fields — they will never hold a string.

### Verify `class_name` Before Referencing in Tests

Godot `.gd` files can only have **one** `class_name` directive. If `enums.gd` has `class_name Enums` at the top, then references like `CombatEnums.SpellType` or `CombatEnums.TargetMode` will fail at runtime — `CombatEnums` is undefined. Always open the canonical enums file and check which `class_name` is actually declared before writing tests that reference it.

```gdscript
# WRONG — CombatEnums was never declared as a class_name:
assert_eq(CombatEnums.SpellType.DAMAGE, 0)

# CORRECT — the file has class_name Enums:
assert_eq(Enums.SpellType.DAMAGE, 0)
```

### Typed Signal Emit Helpers Require Proper Objects

When a SignalBus emit helper takes typed parameters (not primitives), tests must construct the proper resource objects — you cannot pass strings or integers and expect them to work:

```gdscript
# SignalBus emit helper signature:
func emit_combat_action_resolved(actor: MageData, target: MageData, spell: SpellData, result: Dictionary) -> void:

# WRONG — passing strings where MageData/SpellData are expected:
_bus.emit_combat_action_resolved("mage_a", "mage_b", "fireball", {"damage": 50})

# CORRECT — construct proper objects:
var actor: MageData = MageDataClass.new()
actor.name = "mage_a"
var target: MageData = MageDataClass.new()
target.name = "mage_b"
var spell: SpellData = SpellDataClass.new()
spell.name = "fireball"
_bus.emit_combat_action_resolved(actor, target, spell, {"damage": 50})
```

**Assertions on signal parameters equally change** — params are now objects, not strings. Access their properties instead of comparing directly:

```gdscript
# WRONG:
assert_eq(params[0], "mage_a")

# CORRECT:
assert_eq(params[0].name, "mage_a")
```

**Preload the needed resource classes at the top of the test file:**

```gdscript
const MageDataClass = preload("res://Game/Code/Model/mage_data.gd")
const SpellDataClass = preload("res://Game/Code/Model/spell_data.gd")
```
The `_on_` prefix signals auto-connect via the `_ready()` forwarding loop. Signals without `_on_` are manually forwarded in emit helper functions.

### Enum-Typed Resource Fields Default to First Value

When a Resource has `@export var field: Enums.SomeEnum`, the default value is **the first enum key (integer 0)**, NOT an empty string, NOT `null`. For example:

```gdscript
# WRONG:
assert_eq(res.character_type, "", "Default should be empty")  # Fails! Enum defaults to 0

# CORRECT:
assert_eq(res.character_type, Enums.CharacterType.VANGUARD, "Default is first enum value")
```

Always check the enum definition to know which key is index 0. Do NOT write `assert_eq(res.field, "")` for enum-typed fields — they will never hold a string.

### Verify `class_name` Before Referencing in Tests

Godot `.gd` files can only have **one** `class_name` directive. If `enums.gd` has `class_name Enums` at the top, references like `CombatEnums.SpellType` will fail at runtime — `CombatEnums` is undefined. Always open the canonical enums file and verify the actual `class_name` before writing tests that reference it.

```gdscript
# WRONG — CombatEnums was never declared as a class_name:
assert_eq(CombatEnums.SpellType.DAMAGE, 0)

# CORRECT — the file has class_name Enums:
assert_eq(Enums.SpellType.DAMAGE, 0)
```

### Typed Signal Emit Helpers Require Proper Objects

When a SignalBus emit helper takes typed parameters (not primitives), tests must construct proper resource objects — you cannot pass strings or integers and expect them to work:

```gdscript
# SignalBus emit helper signature:
func emit_combat_action_resolved(actor: MageData, target: MageData, spell: SpellData, result: Dictionary) -> void:

# WRONG — passing strings where MageData/SpellData are expected:
_bus.emit_combat_action_resolved("mage_a", "mage_b", "fireball", {"damage": 50})

# CORRECT — construct proper objects:
var actor: MageData = MageDataClass.new()
actor.name = "mage_a"
var target: MageData = MageDataClass.new()
target.name = "mage_b"
var spell: SpellData = SpellDataClass.new()
spell.name = "fireball"
_bus.emit_combat_action_resolved(actor, target, spell, {"damage": 50})
```

**Assertions on signal parameters change equally** — params are now objects, not strings. Access their properties instead of comparing directly:

```gdscript
# WRONG:
assert_eq(params[0], "mage_a")

# CORRECT:
assert_eq(params[0].name, "mage_a")
```

**Preload the needed resource classes at the top of the test file:**

```gdscript
const MageDataClass = preload("res://Game/Code/Model/mage_data.gd")
const SpellDataClass = preload("res://Game/Code/Model/spell_data.gd")
```

## Godot Path Discovery

Godot's install path varies across environments. Do NOT assume a hardcoded path — discover it first:

```bash
# Try common locations
which godot 2>&1 || ls /usr/local/bin/godot* /app/venv/bin/godot 2>&1
# Once found, verify:
<path>/godot --version
```

Common paths encountered:
- `/usr/local/bin/godot` — system install
- `/app/venv/bin/godot` — container/Docker image
- `C:\Program Files\Godot\Godot_console.exe` — Windows

## Pre-Run Import Step (Critical When UID Errors Appear)

When Godot reports UID errors like `"Unrecognized UID"` or `"Some GUT class_names have not been imported"`, the project's `.uid` files are stale or missing. Run the import step before tests:

```bash
cd src && <godot> --headless --path . --import
```

**Always run `--import` first** when working in a fresh worktree or after copying `.gd` files from another worktree. Godot generates `.uid` files during import that resolve `class_name` cross-references. Without them, all class_name-dependent scripts fail to parse, cascading to every file that references those types.

**Pitfall — GUT import error:** The error `"Missing class_names: [GutTest, GutUtils, ...]"` means GUT's own class_names weren't imported. Run `--import` with the project loaded (not just `--headless -s gut_cmdln.gd` — that loads GUT as a script runner but doesn't import its classes). Do the `--import` pass first, then run tests.

## Resource .tres File Awareness

When `.tres` files exist in `_GameDesign/`, they define sample/test data. Reference these for realistic default values in test assertions but don't depend on them loading — test against programmatic construction.

## Testing Autoloads without class_name

When an autoload's script has no `class_name`, Godot's static parser treats the global
name differently depending on how it's registered in `project.godot`:

| Registration | How parser resolves | Working pattern |
|---|---|---|
| `.gd` script directly (e.g. `SignalBus="*res://...signal_bus.gd"`) | As a Node instance | `var _bus: Node = SignalBus` ✓ |
| `.tscn` scene wrapping script (e.g. `CombatConfig="*res://...CombatConfig.tscn"`) | As a Script/PackedScene resource, NOT a Node | `var _cfg = CombatConfig` (untyped) then `_cfg.get("prop")` / `_cfg.set("prop", val)` |

**Pitfall sequence (what NOT to do):**

```gdscript
# FAILS: "Cannot find member 'prop' in base script"
CombatConfig.max_turns           # parser can't resolve exported vars on bare Script type

# FAILS: "Value of type Script cannot be assigned to Node"
var cfg: Node = CombatConfig     # .tscn autoload resolves as Script, not Node instance

# WORKS: untyped var + dynamic get()/set()
var _cfg
func before_all () -> void:
    _cfg = CombatConfig

func test_example () -> void:
    assert_eq(_cfg.get("max_turns"), 30)
    _cfg.set("max_turns", 50)
    assert_eq(_cfg.get("max_turns"), 50)
```

**Save/restore pattern for config autoloads** (avoid cross-test contamination):

```gdscript
var _cfg
var _saved_value: int

func before_all () -> void:
    _cfg = CombatConfig

func before_each () -> void:
    _saved_value = _cfg.get("some_prop")

func after_each () -> void:
    _cfg.set("some_prop", _saved_value)
```

## GUT Test Helpers

Existing helpers live in `src/tests/unit/helpers/`. Current helper: `SeededRandom` (wraps `RandomNumberGenerator` for deterministic RNG in combat tests). Use `const ClassName = preload("res://tests/unit/helpers/helper_name.gd")` to reference helpers.
