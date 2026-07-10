---
name: milestone
description: "Use when you need to manage project milestones and sprints in the roadmap. @Elk (producer): defines the next milestone, creates sprints, moves the Roadmap Marker, creates a PR for senior review, and delegates to /consolidate-milestone after reviews. Keeps roadmap, project state, and backlog in sync."
version: 3.2.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, production, management, roadmap]
    related_skills: [daily, prototype, consolidate-milestone]
---

# /milestone — Milestone & Sprint Management

## Overview

This skill manages the project's production milestones and sprints. As **@Elk (producer)**, you define the next milestone, create sprints within it, move the Roadmap Marker, create a PR for senior review, and delegates to /consolidate-milestone to produce the milestone memo after reviews.

This is step 6 of the Dian Agentic Gamedev Process (Production phase — start of each milestone).

## Important

This is the ONLY skill allowed to edit the roadmap and project state documents. All changes to those documents must go through this skill to ensure consistency.

## When to Use

- At the start of each new milestone in Production phase
- When all tasks in a sprint are completed and you need to advance
- When the user explicitly wants to change the current milestone or sprint
- Do NOT use during Pre-production (milestone management starts after prototypes)

## Workflow

### 0. Bootstrap Project Files

- Check if `.docs/roadmap.md` exists. If not, create it from `.agents/docs/roadmap-template.md` and set all milestones/sprints to "TBD".
- Check if `.docs/project-state.md` exists. If not, create it with Milestone: Undefined, Sprint: Undefined.
- If the project state milestone is "Undefined," update it to "Milestone: Project Setup" and "Sprint: Start."

### 1. Get Project State

- Read `.docs/project-state.md` for the current milestone and sprint.
- Read `.docs/roadmap.md` and locate the Roadmap Marker.
- Verify the project state aligns with the Roadmap Marker position. If not, notify the user and ask to reconcile.
- If the milestone is "Project Setup" and the sprint is "Start":
  - Read `.docs/game-concept.md`. If it doesn't exist or is incomplete, tell the user to run `/start` and exit.

### 2. Define Milestone Sprints

Read the section about the current milestone in the roadmap:

**If the current milestone has no sprints defined:**
- Interview the user to define sprints for the current milestone.
- A sprint is a medium-sized chunk of work achievable in a few days to two weeks.
- Good candidates: a new feature, a system, a mechanic, a screen, a group of assets, a tool setup, a prototype to test a mechanic, a large refactor.
- Bad candidates: things too vague ("Spells"), too small ("Player walk animation"), or that belong in the backlog as tasks.
- Each sprint needs: **Name** (concise, descriptive) and **Description** (short, clear goal).
- Append the defined sprints to the current milestone section in the roadmap.

**If the current milestone has defined sprints AND there's a backlog with tasks for the current sprint:**
- If all tasks are done → go to step 3 (Finish Sprint).
- If tasks remain → redirect to `/daily` and exit.

**If the current milestone has defined sprints BUT no backlog or empty backlog:**
- Confirm the next sprint (the sprint immediately after the Roadmap Marker).
- Go to step 4 (Change Sprint).

### 3. Finish Sprint

- If the finished sprint is a prototype sprint (name/description contains "prototype"), tell the user to run `/prototype` results review first.
- Determine the next sprint in the roadmap:
  - **If a next sprint already exists in the roadmap** after the current sprint → that's the next sprint. Proceed.
  - **If no next sprint exists and the current milestone is "Launch"** → notify user the roadmap is complete and exit.
  - **If no next sprint exists but the milestone is not "Launch"** → BEFORE defaulting to the next milestone, ask the user: *"No more sprints are defined for this milestone. Do you want to define a new sprint within the current milestone, or advance to the next milestone?"* Many milestones (especially Core Loop, Vertical Slice) naturally contain multiple sprints — do not assume the user wants to advance just because only one sprint is defined.
    - If user wants a **new sprint in current milestone** → go to step 2 (Define Milestone Sprints) for the current milestone.
    - If user wants to **advance** → the next sprint is the first sprint of the next milestone. Confirm the milestone switch with the user.
- Move the Roadmap Marker to the next sprint.
- Update project state to the new sprint.
- If the new sprint is in the next milestone → set the project state to the next milestone, then go to step 2 to verify it has defined sprints.
- If the new sprint is a prototype sprint → redirect to `/prototype` and exit.
- Otherwise → go to step 4.

### 4. Change Sprint

- Set the Roadmap Marker and project state to the new sprint.
- **Archive the old sprint's backlog:** If `.docs/backlog.md` contains tasks from the previous sprint, archive them to `.docs/backlog-<old-sprint>.md` for historical reference.
- **Clean `.docs/backlog.md` for the new sprint:** Write a fresh `.docs/backlog.md` containing only the new sprint's section header (from `roadmap.md`) and a placeholder comment (`<!-- Tasks will be added by /daily -->`). The file must contain only current-sprint tasks — `/orchestrate` reads this file to dispatch, and stale tasks from old sprints would cause incorrect dispatches.
- Exit with: "Sprint changed to [new sprint]. Previous backlog archived to `.docs/backlog-<old-sprint>.md`. Next step: @Elk runs `/daily` to check in."

### 5. Create PR for Senior Review

After defining sprints for a new milestone or making significant milestone structure changes, create a PR. **Use `--body-file` to avoid shell interpretation issues with markdown characters:**

```bash
# Write PR body to temp file to avoid shell escaping issues
cat > /tmp/milestone_pr_body.md << 'PRBODYEOF'
## Milestone Update

**Milestone:** <name>
**Sprints defined:** <count>

### Senior Review Needed
- **@Griffin:** Are the sprints technically feasible? Do they respect dependencies?
- **@Hag:** Do the sprints align with the game concept? Is the ordering correct for player experience?
PRBODYEOF

git checkout -b milestone/<slug>
git add .docs/roadmap.md .docs/project-state.md
git commit -m "milestone: <milestone-name> sprints defined"
git push origin milestone/<slug>
gh pr create --title "Milestone: <milestone-name>" --body-file /tmp/milestone_pr_body.md
```

Capture the PR number from the output (e.g., `https://github.com/.../pull/38` → `38`).

### 6. Dispatch Senior Review Chain (Kanban)

After creating the milestone PR, dispatch a **sequential kanban chain** — Griffin reviews first, then Hag (gated on Griffin), then Elk decides (gated on Hag). This ensures Hag can consider Griffin's technical feedback before posting the design review.

Use the hermes CLI (NOT `delegate_task` — subagents don't have `kanban_create`):

```bash
PR_NUMBER=<captured from step 5>
MILESTONE="<milestone-name>"

# --- Task 1: Griffin review (ready immediately) ---
GRIFFIN_OUTPUT=$(/app/venv/bin/hermes -p elk kanban create \
  "Milestone review: ${MILESTONE} — Senior Programmer" \
  --assignee griffin \
  --skill review-pr \
  --tenant mahou \
  --json \
  --body "## Senior Programmer Review: Milestone ${MILESTONE}

**PR:** https://github.com/kalkatos/mahou/pull/${PR_NUMBER}

### What to review
- Are the sprints technically feasible in the estimated timeframes?
- Do sprints respect dependencies (system A before system B)?
- Are any sprints missing technical groundwork needed before feature work?

### Output
- Post a review comment on the PR with APPROVED or NEEDS REVISION
- kanban_complete with verdict in metadata and summary")

GRIFFIN_TASK_ID=$(echo "$GRIFFIN_OUTPUT" | jq -r '.id')

# --- Task 2: Hag review (parent = Griffin, gated until Griffin finishes) ---
HAG_OUTPUT=$(/app/venv/bin/hermes -p elk kanban create \
  "Milestone review: ${MILESTONE} — Senior Game Designer" \
  --assignee hag \
  --skill review-pr \
  --tenant mahou \
  --parent ${GRIFFIN_TASK_ID} \
  --json \
  --body "## Senior Game Designer Review: Milestone ${MILESTONE}

**PR:** https://github.com/kalkatos/mahou/pull/${PR_NUMBER}

### What to review
- Do the sprints align with the game concept\\047s vision?
- Is the sprint ordering correct for building the player experience incrementally?
- Are any design-critical sprints deprioritized when they should be early?

### Output
- Post a review comment on the PR with APPROVED or NEEDS REVISION
- kanban_complete with verdict in metadata and summary")

HAG_TASK_ID=$(echo "$HAG_OUTPUT" | jq -r '.id')

# --- Task 3: Elk orchestrator decision (parent = Hag, gated until Hag finishes) ---
ELK_OUTPUT=$(/app/venv/bin/hermes -p elk kanban create \
  "Orchestrator decision: milestone ${MILESTONE} after senior reviews" \
  --assignee elk \
  --skill orchestrate \
  --tenant mahou \
  --parent ${HAG_TASK_ID} \
  --json \
  --body "## Orchestrator Decision for Milestone ${MILESTONE}

**Griffin review task:** ${GRIFFIN_TASK_ID}
**Hag review task:** ${HAG_TASK_ID}
**PR:** https://github.com/kalkatos/mahou/pull/${PR_NUMBER}
**Review count:** 1

### Instructions
When this task becomes ready (Hag\\047s review is done):

1. \`kanban_show ${GRIFFIN_TASK_ID}\` — read Griffin\\047s verdict
2. \`kanban_show ${HAG_TASK_ID}\` — read Hag\\047s verdict
3. Run \`milestone_orchestrator_decision()\` per this skill (Section 7)"
```

Report the chain:

```
## 🔗 Review Chain Dispatched

| Step | Task | Assignee | Status |
|------|------|----------|--------|
| 1 | Milestone review — Senior Programmer | @griffin | ready |
| 2 | Milestone review — Senior Game Designer | @hag | todo (gated) |
| 3 | Orchestrator decision | @elk | todo (gated) |
```

The kanban dispatcher auto-promotes each step. Griffin reviews → marked done → Hag promoted to ready → Hag reviews → marked done → Elk promoted to ready.

### 7. `milestone_orchestrator_decision()` — When Elk Runs the Decision Task

When Elk is spawned for the orchestrator decision task (title starts with "Orchestrator decision: milestone"), extract the data and run this logic:

```python
# Read parent review tasks
griffin_task = kanban_show(griffin_task_id_from_body)
hag_task = kanban_show(hag_task_id_from_body)

griffin_verdict = extract_verdict(griffin_task)  # "APPROVED" or "NEEDS REVISION"
hag_verdict = extract_verdict(hag_task)           # "APPROVED" or "NEEDS REVISION"
pr_number = extract_pr_number_from_body()
review_count = extract_review_count_from_body()

if review_count >= 3:
    # Escalate to user
    send_message(target="telegram", message="⚠️ Milestone review count is 3 for PR #${pr_number}. Needs human intervention.")
    kanban_complete()
    return

if griffin_verdict == "APPROVED" and hag_verdict == "APPROVED":
    # Both approved — notify user to merge
    send_message(target="telegram", message="✅ Milestone ${MILESTONE} APPROVED. PR #${pr_number} is ready to merge. After merging, @Elk will run /consolidate-milestone to produce the milestone memo.")
    kanban_complete()
    return

if griffin_verdict == "NEEDS REVISION" or hag_verdict == "NEEDS REVISION":
    # At least one needs revision — create revision chain
    feedback = []
    if griffin_verdict == "NEEDS REVISION":
        feedback.append("Griffin: " + extract_feedback(griffin_task))
    if hag_verdict == "NEEDS REVISION":
        feedback.append("Hag: " + extract_feedback(hag_task))
    
    # Create revision tasks for both reviewers (count + 1)
    request_milestone_revision(griffin_task, hag_task, review_count + 1, feedback)
    kanban_complete()
    return

# Unknown verdict
send_message(target="telegram", message="⚠️ Unknown verdict for milestone ${MILESTONE}, PR #${pr_number}. Needs human review.")
kanban_complete()
```

**`request_milestone_revision()`** creates a new sequential review chain (Griffin → Hag → Elk) for the re-review round. Same pattern as Step 6 but with `review_count` incremented and revision context in the body.

### 8. Delegate to /consolidate-milestone

After both senior reviews are APPROVED and the user approves the PR, the milestone memo is handled by a separate skill. Redirect to `/consolidate-milestone`:

- **What `/consolidate-milestone` does:** reads all senior reviews, maps observations to resolutions, produces `milestone-memo-<milestone>-<date>.md`, updates `glossary.md` with new domain terms, and syncs decisions to `decisions.md`.
- Do NOT produce the milestone memo inline in this skill — delegate to the dedicated skill to keep the process consistent.

### 9. Report Completion

Report:

- The approved PR link
- Next step: "After merging, @Elk runs `/consolidate-milestone` to produce the milestone memo, then `/daily` to begin the first sprint's daily loop."

## Glossary

**Milestone List** (ordered):
0. Project Setup
1. Core Loop
2. Vertical Slice
3. MVP
4. Alpha
5. Beta
6. Launch

**Prototype Sprint:** A sprint whose name or description contains "prototype" (case-insensitive).

**Sprints Defined:** A milestone has defined sprints if its section in the roadmap contains a list of sprints with substantive descriptions (not "TBD" or placeholder text).

**Game Concept Completeness:** The game concept is complete if it has all 8 sections filled with meaningful content.

## Common Pitfalls

1. **Forgetting to bootstrap.** If roadmap.md or project-state.md are missing, the skill can't function. Bootstrap them first.
2. **Editing the wrong milestone section.** Only edit the current milestone. Leave past and future milestones intact.
3. **Sprint naming too vague.** "Combat" is too broad. "Melee Combat System" or "Enemy AI Behavior" is specific.
4. **Sprint ordering ignoring dependencies.** If sprint B depends on sprint A, sprint A must come first. The Roadmap Marker only moves forward.
5. **Not cleaning the backlog on sprint change.** When a new sprint starts, archive the old sprint's backlog to `.docs/backlog-<old-sprint>.md` and reset `.docs/backlog.md` with only the new sprint's section header. Backlogs from previous sprints are archived, not lost. Leaving old-sprint tasks in `.docs/backlog.md` would cause `/orchestrate` to dispatch stale tasks.
6. **Skipping the PR gate.** Per PROCESS.md, milestone changes must go through PR → Griffin review → Hag review → user approval before becoming active. Don't treat the roadmap as finalized until the PR is merged.
7. **Producing the milestone memo before reviews.** The memo consolidates feedback from Griffin and Hag — write it AFTER both have reviewed, not before.
8. **Assuming advancement to the next milestone is the only option.** When a sprint finishes and no more sprints are defined in the current milestone, the skill used to auto-advance to the next milestone. This is wrong for milestones that naturally span multiple sprints (Core Loop, Vertical Slice, etc.). Always ASK the user whether they want a new sprint in the current milestone or to advance.
9. **Duplicate Roadmap Marker when editing the roadmap.** When inserting a new sprint and moving the Roadmap Marker with `patch()`, be careful: the old marker line must be removed manually. The patch that adds the new sprint + marker may leave the old marker in place. Always re-read the file after editing to verify only one marker exists.
10. **Not dispatching the review chain.** After creating the milestone PR, the kanban chain (Griffin → Hag → Elk) must be dispatched immediately. Don't wait for the user to manually ask for reviews — the chain handles it automatically.
11. **Apostrophes and special characters in `--body` strings.** When passing multi-line bodies to `hermes kanban create --body`, special characters cause shell interpretation errors. Apostrophes in single-quoted bodies (`'...'`) terminate the string early — always use double-quote wrapping (`--body "..."`). Escape literal double-quotes inside the body with `\"` and dollar signs with `\$`. In double-quoted strings, apostrophes are safe as-is (no escaping needed). The `game's vision` example works fine inside `--body "..."`.

## Verification Checklist

- [ ] Roadmap and project state files exist and are consistent
- [ ] Current milestone section in roadmap has defined sprints
- [ ] Roadmap Marker position matches project state
- [ ] Sprint changes properly sequenced (marker moves forward only)
- [ ] PR created for milestone changes
- [ ] Review chain dispatched via kanban (Griffin → Hag → Elk)
- [ ] Senior reviews completed via kanban chain
- [ ] Orchestrator decision processed (APPROVED / NEEDS REVISION / escalated)
- [ ] User approved and merged the PR
- [ ] /consolidate-milestone delegated to produce the milestone memo with all review feedback incorporated
- [ ] Next step clearly communicated
