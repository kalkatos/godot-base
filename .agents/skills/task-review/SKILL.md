---
name: task-review
description: 'Review a completed task against completeness, correctness, and alignment criteria. Write verdict and feedback to a review file. Use when: invoked by /task-execution after a task completes, reviewing task output, or invoking /task-review directly. Part of the Agentic Gamedev Process production phase.'
user-invocable: true
---

# /task-review — Review a Completed Task

## Overview

Reviews a completed task against three quality lenses and writes a verdict (APPROVED or NEEDS REVISION) to `.docs/reviews/review_vX.Y.Z.W.md`. Enforces the 3-strike rule: if a task reaches 3 consecutive NEEDS REVISION verdicts, stop and ask the user for guidance.

Part of the Agentic Gamedev Process (Production phase). Typically invoked by `/task-execution`, not directly.

## When to Use

- Invoked automatically by `/task-execution` after each task completes.
- User invokes `/task-review vX.Y.Z.W` to manually re-review a task.
- Do NOT use for reviewing days or sprints — this is task-level only.

## Workflow

### 1. Gather Context

- The task version `vX.Y.Z.W`.
- The task description from `backlog.md`.
- The task field (Game Design, Art, UI, Programming, Testing).
- The files created or modified during execution.
- If a prior review exists at `.docs/reviews/review_vX.Y.Z.W.md`, read it to count prior attempts.

### 2. Review Against Three Lenses

#### Completeness

Did the task produce the expected outputs?

- Are all expected files created/updated?
- Does the output match what the task description asked for?
- Is anything missing or half-done?

#### Correctness

Does the output follow the project's rules?

- **Game Design**: Clear, concise, actionable, aligned to template.
- **Art**: Placeholders created, documented in `.docs/art-assets.md`, correct format and path.
- **UI**: Wireframes created first, scenes follow screen-creation rules, no code written.
- **Programming**: Follows coding-standards, architecture rules, file-naming conventions.
- **Testing**: Tests cover happy path and edge cases, pass when run, follow naming conventions.

#### Alignment

Does the output match the project's vision?

- Consistent with `.docs/game-concept.md`?
- Uses terminology from `.docs/glossary.md`?
- Respects decisions in `.docs/decisions.md`?
- Consistent with daily notes?

### 3. Determine Verdict

**APPROVED** — All three lenses pass. Output is complete, correct, and aligned.

**NEEDS REVISION** — One or more lenses fail. Provide specific, actionable feedback.

### 4. Count Attempts

Check `.docs/reviews/review_vX.Y.Z.W.md` for prior verdicts:

- Count consecutive NEEDS REVISION verdicts.
- If this is the 3rd NEEDS REVISION (attempt count would reach 3): do NOT write another NEEDS REVISION. Instead, stop and ask the user for guidance.

### 5. Write the Review File

Create or update `.docs/reviews/review_vX.Y.Z.W.md`:

```markdown
# Review vX.Y.Z.W

**Task:** [description from backlog]
**Field:** [field]
**Verdict:** APPROVED | NEEDS REVISION
**Attempt:** N/3

## Assessment

- **Completeness:** [notes — what was done, what's missing]
- **Correctness:** [notes — rule violations or confirmations]
- **Alignment:** [notes — design consistency]

## Feedback

[If APPROVED: brief confirmation of what was done well.]
[If NEEDS REVISION: specific, actionable fixes. Reference files and line numbers.]
```

### 6. Return Verdict

Report the verdict to `/task-execution` so it can either mark the task done or loop back for revision.
