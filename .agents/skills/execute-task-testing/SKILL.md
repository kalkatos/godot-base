---
name: execute-task-testing
description: 'Execute a Testing task: write GUT test cases that verify game functionality and prevent regressions. Use when: the task field is Testing, writing unit/integration tests, or invoking /execute-task-testing. Part of the Agentic Gamedev Process production phase.'
user-invocable: true
---

# /execute-task-testing — Execute a Testing Task

## Overview

Executes a Testing task by writing GUT test cases that verify game functionality and prevent regressions. Follows testing standards and runs tests to confirm they pass.

Part of the Agentic Gamedev Process (Production phase). Typically invoked by `/task-execution`, not directly.

## When to Use

- Task field is **Testing**.
- The task involves writing unit tests, integration tests, or verifying existing functionality.
- Do NOT use for game design, art, UI, or programming tasks.

## Workflow

### 1. Gather Context

Ensure these are loaded (should already be in context from `/task-execution`):

- `.docs/game-concept.md` — expected behavior.
- `.docs/decisions.md` — prior testing decisions.
- `.docs/design/<system_name>_design.md` — if tests relate to a designed system.
- `.docs/daily/daily_vX.Y.Z.md` — today's notes.
- Relevant source code in `src/Game/Code/` that needs testing.
- If this is a re-execution (NEEDS REVISION), what specific feedback must be addressed.

### 2. Identify What to Test

From the task description:

- What function, class, or system needs test coverage.
- What behaviors need verification (happy path, edge cases, error handling).
- What test file(s) to create or update.

### 3. Write the Tests

Create or update test files in `src/tests/unit/`:

- Start test file names with `test_` (e.g., `test_combat_controller.gd`).
- Use GUT's `extends GutTest` as the base class.
- Use descriptive test method names: `test_[what]_[condition]_[expected]`.
- Cover: happy path, edge cases, error states, and regression scenarios.
- Use GUT assertions: `assert_eq`, `assert_true`, `assert_false`, `assert_called`, etc.

### 4. Run the Tests

Run the test suite to confirm tests pass:

```bash
cd src && '<godot_path>' --headless --path . -s res://addons/gut/gut_cmdln.gd -gdir=res://tests/unit -ginclude_subdirs -gexit -glog=1
```

If tests fail, fix them — do not submit failing tests.

### 5. Report Output

Summarize: which test files were created/updated, what they cover, and the test run result (passed/failed count).
