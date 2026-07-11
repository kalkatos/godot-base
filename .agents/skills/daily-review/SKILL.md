---
name: daily-review
description: 'Review the day''s tasks for feasibility, priority, and dependencies. Use when: invoked by /daily for second-pass review, or invoked standalone to re-validate a day plan.'
argument-hint: ''
user-invocable: true
---

# /daily-review — Review Day Plan

## Overview

Reviews the current day's planned tasks for feasibility, dependencies, and correct field ordering. Flags issues and suggests adjustments. Appends feedback to the daily log. If issues are found, loops back to the user for adjustment.

Part of the Agentic Gamedev Process. Normally invoked automatically by `/daily`. Can also be run standalone.

## When to Use

- Automatically invoked at the end of `/daily`
- User runs `/daily-review` standalone to re-validate a day plan
- Tasks were adjusted and need a fresh review pass

## Workflow

### 1. Load Context

- Read `.docs/daily/daily_vX.Y.Z.md` (the current day's log).
- Read `.docs/backlog.md` for task details and sprint context.
- Read `.docs/roadmap.md` for sprint goal.

### 2. Review — Per-Field Verification

Verify each field present in today's plan, in order. For each field, adopt that field's perspective. Be concise — flag only actionable issues.

**Game Design POV** (if design tasks present):
- Do design tasks fully specify what's needed before implementation begins? Missing specs → flag.
- Dependencies: will downstream Art/UI/Programming tasks be blocked if this design task is unclear?

**Art POV** (if art tasks present):
- Are placeholder requirements clear enough to create? Vague descriptions → flag.
- Dependencies: are art tasks blocked by unfinished design specs?

**UI POV** (if UI tasks present):
- Are wireframes/scenes specified before UI implementation? Missing wireframe step → flag.
- Dependencies: is UI work ordered before or after the programming tasks it depends on?

**Programming POV** (if programming tasks present):
- Are design specs complete enough to implement? Coding against vague design → flag.
- Are tasks scoped realistically? Overly large tasks → suggest splitting.

**Testing POV** (if testing tasks present):
- Are tests planned for code being written today? Missing test coverage → flag.
- Are test tasks ordered after their corresponding programming tasks?

**Cross-field checks:**
- Field ordering correct? Game Design → Art → UI → Programming → Testing.
- Any task in the wrong day? Should be deferred or moved up.

### 3. Verdict

At the top of the review, state the verdict:

- **APPROVED**: No issues, or only minor notes that don't block execution.
- **NEEDS REVISION**: At least one actionable issue that requires plan adjustment.

If NEEDS REVISION, list issues concisely and suggest fixes. Then ask: "Adjust the plan?" Loop back to the parent skill for changes.

If a task reaches 3 consecutive NEEDS REVISION verdicts across daily reviews, stop and ask the user for guidance — do not loop further.

### 4. Write Feedback

Append to the daily log. Verdict first, then per-field findings. Keep it tight:

```
---

## Review

**Verdict: APPROVED**

- Game Design: [brief note or "—"]
- Art: [brief note or "—"]
- UI: [brief note or "—"]
- Programming: [brief note or "—"]
- Testing: [brief note or "—"]
```

Skip fields not in today's plan. Use "—" when a field has no issues.

If adjustments were made, update `backlog.md` accordingly.

### 5. Report

If invoked standalone: "Review complete. Verdict: [APPROVED / NEEDS REVISION]."

If invoked by `/daily`: return control to `/daily` for final summary.
