# Mahou Coding Standards — Quick Reference

> Full authority: `.agents/rules/coding-standards.md` (CS-01 through CS-16)
> File naming: `.agents/rules/file_naming.md`

## All coding standards

| Rule | Summary |
|---|---|
| **CS-01** | `func name (param: type) -> void:` — space before `(` in function declarations |
| **CS-02** | No blank lines within method bodies |
| **CS-03** | Signals: `_on_signal_name` / emit: `emit_signal_name` / handler: `_handle_signal_name` |
| **CS-04** | All enums in `Globals/enums.gd`, accessed via `Enums.EnumName.VALUE` |
| **CS-05** | Use `@export` references for child nodes; `get_node()` only for dynamic/runtime-instanced nodes |
| **CS-06** | Never use `load()`/`preload()` at runtime — use exported references |
| **CS-07** | Use `SignalBus` for cross-system communication |
| **CS-08** | Avoid hardcoding; store configurable values in `_GameDesign/Config/` autoloads |
| **CS-09** | Never create UI via code; use scene templates + `duplicate()` pattern |
| **CS-10** | DRY — factor out repeated code into reusable methods or utilities |
| **CS-11** | NEVER use `:=` (inferred assignment) — use `var x: Type = value` or `var x = value` |
| **CS-12** | Check autoload initialization order; avoid circular dependencies |
| **CS-13** | Descriptive names per *Clean Code* — no single-letter variable names |
| **CS-14** | Use enums instead of open values (magic strings/ints) when a finite range exists |
| **CS-15** | **Avoid dictionaries as DTOs.** No enforced schema, no type safety, poor readability. Use `RefCounted` classes instead. Place them in `Model/Dtos/`. Allowed only for: rapid prototyping, testing, serialization. |
| **CS-16** | **Add types to collections.** `Array[String]`, `Dictionary[String, Node]` — always include type parameters when possible. |
| **CS-16** | Add types to collections: `Array[String]`, `Dictionary[String, Node]` — no bare `Array` or `Dictionary` |

## Pitfall: Test path case mismatch → silent pending

On Linux (case-sensitive filesystem), `ResourceLoader.exists()` and `load()` with wrong casing return null **silently**. When test code guards with:

```gdscript
if CombatControllerClass == null:
    pending("CombatController.gd not yet implemented (TDD — expected to fail)")
    return
```

...the test is **marked pending and never actually runs**. Every assertion is skipped. This is invisible in CI output — pending tests aren't failures.

**Example from PR #15:** `test_combat_harness.gd` loaded `res://Game/Code/Control/CombatController.gd` but the file was named `combat_controller.gd` (snake_case). Every combat integration test was silently skipped. Both Griffin and kalkatos reviewed the code believing the tests passed.

**Prevention:**
- Use `search_files(target='files', pattern='*combat_controller*')` to confirm exact file names before writing `load()` paths.
- Prefer `ClassDB.class_exists("CombatController")` over `ResourceLoader.exists(path)` when the script has `class_name` — it's case-insensitive and immune to path typos.
- When writing new test files, never copy-paste a load path — verify it against `search_files` output.
