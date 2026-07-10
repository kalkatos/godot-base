---
name: mahou-project
description: Project conventions, structure, and coding standards for the Mahou Godot 4.x game. Load when working on any Mahou task to stay aligned with canonical patterns.
category: gamedev
tags: [mahou, godot, project-conventions, structure]
---

# Mahou Project Conventions

Godot 4.x game project. Repo: `https://github.com/kalkatos/mahou.git`. **Default branch: `main`** (both locally and on the remote). GitHub PRs must target `main`.

**Local filesystem layout** — all paths relative to `$hws` (workspace root):
| What | Path |
|------|------|
| Workspace root | `$hws/` |
| Repo root (main worktree, `.git` lives here) | `$hws/mahou/main/` |
| Godot project | `$hws/mahou/main/src/` |
| Dot-docs (`.docs/`) | `$hws/mahou/main/.docs/` |
| Agent rules (`.agents/`) | `$hws/mahou/main/.agents/` |
| Profile worktrees | `$hws/mahou/<profile>/` (angel, brute, capy, dino, elk, fairy, griffin, hag, imp, jack, kavu, levi) |
| Remote | `https://github.com/kalkatos/mahou.git` |

All 13 profile worktrees are direct children of `$hws/mahou/`, not nested inside the main worktree. The main worktree is a peer under `$hws/mahou/main/`. Run `git worktree list` from `$hws/mahou/main/` to see the full worktree layout.

Shared `.docs/` files (daily reports, backlog, project-state, roadmap, game-concept) are edited from the main worktree on the `main` branch. **Task-specific `.docs/` files (art-assets, sound-assets) belong on the task's own branch in the agent's profile worktree** — check the daily report for the task's branch name. Code development happens in profile worktrees.

## Canonical file locations

These are the **single source of truth** for each file type. Do NOT create duplicates elsewhere. If an existing duplicate is found, merge into the canonical location and delete the duplicate.

| File type | Canonical path |
|---|---|
| Enums | `src/Game/Globals/enums.gd` — single `class_name Enums` (all enums under one class: `Enums.SpellType`, `Enums.TargetMode`, `Enums.CharacterType`, `Enums.AIPriority`, `Enums.SceneName`) |
| Signal bus | `src/Game/Globals/signal_bus.gd` |

## Adding new enums

Add new enums to `src/Game/Globals/enums.gd` under the existing `class_name Enums`. There is only ONE class_name in this file. Do NOT create a separate `CombatEnums` class_name — it does not exist and referencing it in tests will fail at runtime. All enums (combat, scene, character, etc.) live under `Enums.*`.

## Pluggable Architecture Patterns (Strategy)

When a game mechanic has multiple possible variants (victory conditions, AI behaviour, damage formulas, target selection), extract each variant into a **`RefCounted` strategy** rather than adding `if/elif` branches to the controller's core loop.

**The pattern in one shot:**
- Base class (`extends RefCounted`) with a single `check(context) -> Result` method.
- One subclass per variant (`EliminationVictory`, `TurnLimitVictory`, etc.).
- A `Composite` class that runs sub-strategies in order (first match wins).
- The controller injects the composite at init time and calls it each tick.

**When it pays off:** The third variant. Two `if` branches in a 10-line helper is fine. The strategy pattern earns its keep when you add a fourth, fifth, or sixth mode and never touch the controller.

**Testing upside:** Each strategy is tested against a minimal context (no full combat engine needed). See `references/strategy-pattern-godot.md` for full code examples, testing idioms, and anti-patterns.

**Architecture alignment:** Mirrors the Day 3 pluggable AI pattern (`AIDecision` strategy → `CombatController` host), follows composition-over-inheritance, and sits cleanly between Model (data) and Controller (rules).

## Config files and Autoloads

Config files (classes suffixed with `Config`) must be **Node-based autoloads**, not Resources. Godot only allows `.tscn` and `.gd` files as autoloads — `.tres` (Resource) files cannot be registered.

To convert a Resource-based Config to an autoload-ready Node:

1. Change `extends Resource` → `extends Node` in the `.gd` script.
2. Replace the `.tres` file with a `.tscn` scene alongside the script (following the convention that `.tscn` autoloads live next to their script, e.g. `AudioController.tscn` in `Modules/Audio/`).
3. Delete the old `.tres`.
4. Register in `project.godot` `[autoload]` section.

The `.tscn` format for a plain node with an attached script:
```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://path/to/script.gd" id="1_id"]

[node name="ClassName" type="Node"]
script = ExtResource("1_id")
exported_property = default_value
```

See `references/autoload-tscn-template.md` for the full template.

**Testing `.tscn` autoloads:** Config autoloads registered as `.tscn` scenes are resolved as Script resources (not Node instances) by GDScript's static parser when the script lacks `class_name`. Tests must use untyped variable assignment (`var _cfg = CombatConfig`) and dynamic `get()`/`set()` calls. See the `godot-gut-testing` skill's "Testing Autoloads without class_name" section for the full pattern.

## File Naming Convention

Per `.agents/rules/file_naming.md` and CS-08:

- **`.gd` script files** use **snake_case**: `combat_controller.gd`, `turn_order.gd`, `combat_config.gd`
- **`.tscn` scene files** use **PascalCase**: `CombatConfig.tscn`, `CombatController.tscn`

When referencing files in daily documents, PR comments, or kanban tasks, always use the correct casing. Common wrong forms caught in review:

| Wrong | Correct |
|---|---|
| `CombatConfig.gd` | `combat_config.gd` |
| `CombatController.gd` | `combat_controller.gd` |
| `TurnOrder.gd` | `turn_order.gd` |
| `combat_config.tscn` | `CombatConfig.tscn` |

## Coding Standards

The project's authoritative coding standards are in `.agents/rules/coding-standards.md` (CS-01 through CS-16). Always consult this file before writing GDScript code. For the complete quick-reference table, see `references/coding-standards-cheatsheet.md`. The rules most commonly flagged in review:

| Rule | Summary |
|---|---|
| **CS-01** | `func name (param: type) -> void:` — space before `(` in declarations |
| **CS-02** | No blank lines within method bodies |
| **CS-03** | Signals: `_on_signal_name` / emit: `emit_signal_name` / handler: `_handle_signal_name` |
| **CS-04** | All enums in `Globals/enums.gd`, accessed via `Enums.EnumName.VALUE` |
| **CS-08** | Avoid hardcoding; use Config autoloads (`_GameDesign/Config/`) |
| **CS-08** | Avoid hardcoding; use Config autoloads (`_GameDesign/Config/`) |
| **CS-09** | **BLOCKER — Never create UI elements via code.** Use scene-baked hidden template children + `duplicate()`. Permanent labels placed directly in `.tscn` with all styling baked. |
| **CS-11** | NEVER use `:=` — use `var x: Type = value` or `var x = value` |
| **CS-15** | **Avoid Dictionaries as DTOs.** Use `RefCounted` classes in `Model/Dtos/` instead (see `RuleResult`, `RuleEntry` for examples) |
| **CS-16** | **Add types to collections.** `Array[String]`, `Dictionary[String, Node]` — always include type parameters |

## Pitfalls

- **DO NOT** create a second `enums.gd` in `Code/Model/` or anywhere else. The canonical file is `Globals/enums.gd`.
- **Test path case mismatch → silent pending** — On Linux (case-sensitive filesystem), `load()` / `ResourceLoader.exists()` with wrong casing returns null silently. When test code guards with `if class == null: pending(...)`, the test is **marked pending and never actually runs**. On PR #15, `test_combat_harness.gd` loaded `CombatController.gd` but the file was `combat_controller.gd` — every integration test was silently skipped. Always verify file paths match exact casing: use `search_files(target='files')` to confirm names before writing `load()` paths.
- When moving enums from a duplicate file, check for any `preload`/`load` paths that reference the old location and update them.
- For PR workflow specifics (auth sequence, push credential helper, gh pr create incantation), see `references/pr-workflow.md`.
- For coding standards quick reference (CS-01 through CS-16) and the silent-pending test trap pitfall, see `references/coding-standards-cheatsheet.md`.

- **Stale `origin/main` ref after force-push or branch reset:** `origin/main` may point to an outdated commit (e.g., when multiple agents push to main in sequence and your fetch is stale). Symptom: `git merge origin/main` produces no new files even though you know a PR was merged. Fix: force-refresh the ref with `git fetch origin main:refs/remotes/origin/main` — this bypasses the normal fetch negotiation and directly updates the local tracking ref to match the remote. Verify with `git log origin/main --oneline -3`.

- **Root-owned files in worktrees** — Previous agent sessions run as root can leave files/directories owned by root in a worktree. Symptom: `write_file`/`patch` fail with `Permission denied` on files that exist but are root-owned. Diagnose with `find <worktree-root> -user root`. Fix from host: `sudo chown -R hermeswebui:hermeswebui <affected-paths>`. Common offenders: `Code/Model/`, `_GameDesign/`, and `tests/` directories.
- **DO NOT** use `.tres` (Resource) for Config classes intended as autoloads. Autoloads must be `.tscn` (Node) or `.gd`.
- Worktree files created by agents running as `root` block writes from `hermeswebui`. Fix with `sudo chown -R hermeswebui:hermeswebui <path>` from the host before editing. **When `sudo` is unavailable** (inside the Hermes container), use the `patch` or `write_file` tool directly on the affected file — these tools handle writes differently from `cp`/`mv` and can bypass root-ownership for file content changes. Read the file first to get the old text, then patch it in-place.
- **Worktree lock — branch already checked out elsewhere:** A branch can only be checked out in one worktree at a time. If `git checkout` fails with `fatal: '<branch>' is already used by worktree at '<path>'`, the branch is already checked out in another worktree. Find which one with `git worktree list` from the repo root, then `cd` to that worktree and work from there. This applies to `daily/*`, `task/*`, and any other branch — the main worktree and every profile worktree (`angel/`, `elk/`, etc.) cannot share a checked-out branch.

- **TDD `_safe_load` path case trap:** Test harnesses (e.g. `test_combat_harness.gd`) use a `_safe_load(path)` helper that calls `ResourceLoader.exists(path)` to check if a script file exists before loading it. On Linux the filesystem is case-sensitive — `ResourceLoader.exists("res://Game/Code/Control/CombatController.gd")` returns `false` when the actual file is `combat_controller.gd` (snake_case per CS-08). Every integration test guarded by this check will silently `pending()` instead of executing. **When implementing a `class_name` script after the test was written, verify the load path in the test matches the actual file casing.** The alternative is to replace the `_safe_load` guard with `ClassDB.class_exists("ClassName")` — class_name resolution is case-insensitive and filesystem-independent.
