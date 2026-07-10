---
name: orchestrate
description: "Elk's master coordination skill. Implements field-based orchestration — dispatches all tasks in a field one after another, handles the worker→review→decision chain per task, and auto-advances to the next task in the same field on APPROVED. Notifies user only on field completion or 3 NEEDS REVISION."
version: 2.0.0
---

# /orchestrate — Elk's Task Orchestration

Elk dispatches tasks **per field** (design, prog, art, sound). Within a field, tasks run in sequence — each completes its worker→review→decision chain, then the next task in the same field auto-dispatches. The user is notified only when a field is fully complete or a task reaches 3 NEEDS REVISION.

## When to Load

- `/wrap-up-daily` calls this to kick off field dispatch
- User says `/orchestrate <project> field <field>` — dispatches all tasks in a field
- User says `/orchestrate <project> task <id>` — dispatches the specified task by ID (Section 1a)
- Kanban dispatcher spawns Elk for orchestrator_decision tasks — Elk runs `orchestrator_decision()`

## Delegation Map

Worker → Reviewer → Field mapping (hardcoded):

| Worker | Reviewer | Field |
|--------|----------|-------|
| angel  | griffin  | prog  |
| brute  | griffin  | (prototype — pre-production only) |
| capy   | hag      | design |
| fairy  | kavu     | art    |
| imp    | griffin  | prog   |
| jack   | griffin  | prog   |
| levi   | kavu     | sound  |


## 1a. Entry Point: `orchestrate_task_by_id(project, task_id)`

When Elk receives `/orchestrate <project> task <task_id>` (e.g., `/orchestrate mahou task v1.1.4.2`):

### Step 1a.1 — Find the task in the backlog

Read `<project_root>/.docs/backlog.md`. Search for the line matching `- [ ] <task_id> [...]`. 

- **Found and unchecked** → proceed to Step 1a.2.
- **Already checked** (`- ✅`) → report "Task <task_id> is already done." and stop.
- **Not found** → report "Task <task_id> not found in backlog." and stop.

### Step 1a.2 — Dependency check

Scan all tasks on the same day that appear BEFORE this task. If any are still unchecked (`- [ ]`), warn the user:

> ⚠️ Dependency warning: <list of unchecked preceding task IDs>. Proceeding anyway.

**Then dispatch the task immediately — do NOT block.** The user explicitly named the task, so they've made the call. Trust the user if they say a prerequisite is done even if the backlog file hasn't been updated yet. Do not refuse to dispatch or argue about the file contents.

### Step 1a.3 — Parse and dispatch

Parse the backlog line per Section 2.1 (extract task_number, assignee, description, day, project). Then call `orchestrate_task(backlog_task)` (Section 2). Report the dispatch result as a summary table:

```
## ✅ Task <task_id> Dispatched

| Role | Task ID | Assignee | Status |
|------|---------|----------|--------|
| Worker | <id> | @<assignee> | ready |
| Review | <id> | @<reviewer> | todo (gated) |
| Decision | <id> | @elk | todo (gated) |
```

---

## 1. Entry Point: `orchestrate_field(project, field)` — Field-Based Dispatch

When Elk receives `/orchestrate <project> field <field>` or is called by `/wrap-up-daily` to dispatch a field:

Valid field values: `design`, `prog`, `art`, `sound`.

### Step 1.1 — Read the backlog for this field

Read `<project_root>/.docs/backlog.md`. Note: `.docs/backlog.md` contains ONLY the current sprint's tasks (previous sprints are archived by `/milestone`). Extract all tasks for the current day. Filter to tasks belonging to the requested field using the persona→field mapping:

| Persona | Field |
|---------|-------|
| `[Capy]` | design |
| `[Angel]`, `[Jack]`, `[Imp]` | prog |
| `[Fairy]` | art |
| `[Levi]` | sound |

### Step 1.2 — Find the next unchecked task in this field

Scan the field's tasks in order. Find the first unchecked task (`- [ ]`).

**Task format in backlog.md:**
```
### Day 3 — Rules + Spells + DumbAI

#### Track A — Game Design
- ✅ v1.1.3.1 [Capy] Design spell system: ...
- [ ] v1.1.3.2 [Capy] Design element interactions: ...

#### Track B1 — Code
- [ ] v1.1.3.3 [Angel] Rule_DealDamage, Rule_Heal, Rule_StatMod: ...
- [ ] v1.1.3.4 [Jack] Spell casting UI: ...
- [ ] v1.1.3.5 [Imp] Tests for Rule system: ...

#### Track B2 — Art & Sound
- [ ] v1.1.3.6 [Fairy] Spell VFX assets: ...
- [ ] v1.1.3.7 [Levi] Spell SFX: ...
```

- **Checked tasks** start with `- ✅` or `- [x]` — skip them.
- **Unchecked tasks** start with `- [ ]` — this is the next task.

### Step 1.3 — If a task is found

Call `orchestrate_task(backlog_task, field)` (see Section 2). The task body includes the field tag so the orchestrator_decision knows which field to advance.

If in kanban worker mode, send a brief notification via Telegram:
> Field `<field>`: dispatched `<task_id>` to @<assignee>. Review by @<reviewer>.

If in interactive mode, report to the user:

```
## Field: <field> — Task Dispatched

| Role | Task ID | Assignee | Status |
|------|---------|----------|--------|
| Worker | <id> | @<assignee> | ready |
| Review | <id> | @<reviewer> | todo (gated) |
| Decision | <id> | @elk | todo (gated) |

Next: work→review→decision chain. On APPROVED, next task in <field> auto-dispatches.
```

### Step 1.4 — If no task is found (field complete)

Report:

```
✅ Field `<field>` is complete — all tasks done.

<if field is 'prog': Check if Imp tests were dispatched. If not, dispatch Imp now.>
```

For the `prog` field specifically: if all Angel + Jack tasks are done but Imp's test task is unchecked, dispatch Imp's test task as the next (and final) task in the `prog` field.

If the field is truly empty (no unchecked tasks at all, including Imp), notify the user that the field is complete. Use `send_message(target="telegram", message="...")` to deliver.

### Step 1.5 — Blocking field gating

When dispatching `prog`, `art`, or `sound` fields: check whether the `design` field has blocking tasks that are not yet complete. If the daily document says "Game design blocks today's programming work" and the `design` field still has unchecked tasks, do NOT dispatch prog/art/sound — wait for the design field to complete first.

```
if field in ['prog', 'art', 'sound'] and design_is_blocking and design_has_unchecked_tasks:
    → Log: "Track <field> waiting for Track A (design) to complete."
    → Do NOT dispatch.
    → The orchestrator_decision for the last design task will trigger prog dispatch.
```

---

## 2. `orchestrate_task(backlog_task, field)` — Create the 3-Step Chain

Given a parsed backlog task (task_number, assignee, description, day, project, field), create three kanban tasks simultaneously. The parent-child relationships handle gating automatically:

### Step 2.1 — Parse the backlog task

For a line like `- [ ] v1.1.3.2 [Angel]: Rule_DealDamage, Rule_Heal, Rule_StatMod: ...`:

| Field | Extraction | Example |
|-------|-----------|---------|
| `task_number` | The task ID | `v1.1.3.2` |
| `assignee` | Profile in brackets, lowercased | `angel` |
| `description` | Text after the assignee bracket | `Rule_DealDamage, Rule_Heal, Rule_StatMod: ...` |
| `day` | From the section header `### Day N — ...` | `3` |
| `project` | From the backlog header or project context | `mahou` |
| `field` | Passed from caller (`design`, `prog`, `art`, `sound`) | `prog` |

### Step 2.2 — Build the task body

The worker task body is the backlog line description, plus context:

```
## Task: <task_number> — <short description>

**Project:** <project>
**Day:** <day>
**Field:** <field>

### What to do
<description from backlog line>

### Context
- See daily doc `.docs/daily_<sprint>.<day>.md` for full task details
- See glossary `.docs/glossary.md` for domain terms
- See decisions `.docs/decisions.md` for relevant decisions

### Branch
Work on branch: `day/v<version>/<field>` (e.g., `day/v1.1.1/prog`)
All workers in the same field share this branch.
```

### Step 2.3 — Create all 3 kanban tasks

**Use the hermes CLI** — `delegate_task` with kanban toolset does NOT provide `kanban_create` to subagents. Create tasks sequentially via the hermes CLI so parent IDs can be captured. The base command is:

```
/app/venv/bin/hermes -p elk kanban create "<title>" \
  --assignee <assignee> --skill <skill> --tenant <project> \
  --json [--parent <parent_id>] --body '...'
```

Always use `--json` to get the task ID back. **Create in dependency order:**

**1) Worker task (status: ready):**

```bash
/app/venv/bin/hermes -p elk kanban create "[<project>] <task_number> <short description>" \
  --assignee <assignee> \
  --skill task-execution \
  --tenant <project> \
  --json \
  --body '<worker task body>'
```

Capture the returned `id` → `worker_task_id`.

**2) Review task (status: todo, parent=worker):**

```bash
/app/venv/bin/hermes -p elk kanban create "Review <task_number>: <short description>" \
  --assignee <reviewer> \
  --skill review-pr \
  --tenant <project> \
  --parent <worker_task_id> \
  --json \
  --body '## Review Task for <task_number>

**Worker:** @<assignee>
**Parent task:** <worker_task_id>
**Review count: 1**

### What to review
- The worker will push a PR and complete their task with the PR number
- Review the PR diff against the task requirements
- Use the /review-pr skill for structured feedback
- After posting the review, mark this task DONE

### Output
- PR review comment with APPROVED or NEEDS REVISION
- kanban_complete with verdict in metadata, summary, and a comment'
```

**3) Orchestrator decision task (status: todo, parent=review):**

```bash
/app/venv/bin/hermes -p elk kanban create "Orchestrator decision: <task_number> after review" \
  --assignee elk \
  --skill orchestrate \
  --tenant <project> \
  --parent <review_task_id> \
  --json \
  --body '## Orchestrator Decision for <task_number>

**Worker task:** <worker_task_id>
**Review task:** <review_task_id>
**Project:** <project>
**Day:** <day>
**Field:** <field>

### Instructions
When this task becomes ready (review task is done):

1. `kanban_show <review_task_id>` — read the reviewer'\''s completion (summary, metadata, comments) to extract the verdict
2. `kanban_show <worker_task_id>` — read the worker'\''s completion to extract the PR number
3. Run `orchestrator_decision(worker_task, review_task, field)` per this skill (Section 3)'
```

### Step 2.4 — How the chain flows (per field)

```
Worker task (ready) → dispatcher spawns @<assignee> → worker finishes → marks DONE
    ↓ (parent-child link)
Review task promoted to ready → dispatcher spawns @<reviewer> → reviewer finishes → marks DONE
    ↓ (parent-child link)
Orchestrator decision task promoted to ready → dispatcher spawns @elk → Elk runs orchestrator_decision()

    ┌─ APPROVED:
    │   Elk marks orchestrator_decision DONE
    │   → Calls orchestrate_field(project, field) to dispatch next task in same field
    │   → If no more tasks in field: notifies user "✅ Field <field> complete"
    │
    ├─ NEEDS REVISION:
    │   Elk dispatches revision chain → revision → re-review → orchestrator_decision again
    │
    └─ Escalation (3+ rounds):
        Elk notifies user of stalled PR → user intervenes
```

**Key rule:** The chain auto-runs worker → reviewer → orchestrator. On APPROVED, the orchestrator **auto-dispatches the next task in the same field**. The user is NOT notified on every APPROVED — only when a field is fully complete or a task reaches 3 NEEDS REVISION.

No cron jobs needed — the kanban dispatcher handles all promotion and spawning automatically.

---

## 3. `orchestrator_decision()` — When Elk is Spawned as Kanban Worker

When Elk receives a kanban task with title starting with "Orchestrator decision:", Elk is running as a kanban worker. The task body contains the worker_task_id, review_task_id, project, and day.

### Step 3.1 — Read the parent tasks

```python
# The orchestrator_decision task body tells you the IDs
worker_task_id = extract_worker_task_id_from_body()
review_task_id = extract_review_task_id_from_body()
field = extract_field_from_body()  # "design", "prog", "art", or "sound"

# Read the review task to get the verdict
review_task = kanban_show(review_task_id)
verdict = extract_verdict(review_task)  # "APPROVED", "NEEDS REVISION", or unknown
pr_number = extract_pr_number(review_task)  # from metadata, summary, or comments (fallback: check worker_task)

# If PR number not in review task, check worker task
if not pr_number:
    worker_task = kanban_show(worker_task_id)
    pr_number = extract_pr_number(worker_task)

# Extract review count from the review task description
review_count = extract_review_count(review_task.description)
```

### Step 3.2 — Extract helpers

**`extract_verdict(review_task)`:** Same as before — check metadata.verdict, summary, comments.

**`extract_pr_number(task)`:** Same as before — check metadata.pr_number, summary, comments.

**`extract_review_count(description)`:** Parse for `Review count: N` or `Revision count: N`. Defaults to 1.

**`extract_field_from_body()`:** Parse the orchestrator_decision task body for `**Field:** <field>`. Returns one of `design`, `prog`, `art`, `sound`.

### Step 3.3 — Decision logic (field-based)

```
if review_count >= 3:
    → send_telegram("⚠️ Task <task_number> (field <field>), PR #<pr_number> reached 3 NEEDS REVISION. Needs human review.")
    → Mark orchestrator_decision task DONE via kanban_complete
    return

if verdict == "APPROVED":
    → send_telegram("✅ <field>/<task_number> APPROVED — PR #<pr_number>. Dispatching next in field '<field>'...")
    → Mark orchestrator_decision task DONE via kanban_complete
    → Call orchestrate_field(project, field) to dispatch the next task in this field
    → If orchestrate_field returns "no more tasks":
        → send_telegram("🎉 Field '<field>' is COMPLETE. All tasks done — ready for your review @kalkatos.")
    → STOP — the chain auto-advances. Do NOT wait for user merge between tasks.

elif verdict == "NEEDS REVISION":
    → review_count += 1
    → request_revision(worker_task, review_task, review_count, field)
    → Mark orchestrator_decision task DONE via kanban_complete

else (unknown verdict):
    → send_telegram("❓ Unknown verdict for task <task_number> (field <field>), needs human review")
    → Mark orchestrator_decision task DONE via kanban_complete
```

**Critical difference from old behavior:** On APPROVED, the orchestrator does NOT stop and wait for the user to merge. It dispatches the next task in the same field immediately. The user reviews and merges all PRs for a field together when the field is complete.

---

## 4. `request_revision(worker_task, review_task, review_count, field)`

Called when the verdict is NEEDS REVISION. Creates a new 3-step chain for the re-review cycle.

### Step 4.1 — Extract information

```
task_number = extract_number(worker_task)
pr_number = extract_pr_number(worker_task)
project = extract_project(worker_task)
assignee = worker_task.assignee
reviewer = review_task.assignee
```

### Step 4.2 — Create revision chain

Use the hermes CLI (same as Step 2.3). Create in dependency order:

**1) Revision task (worker fixes):**

```bash
/app/venv/bin/hermes -p elk kanban create "Revision requested: <task_number>" \
  --assignee <assignee> \
  --skill task-execution \
  --tenant <project> \
  --json \
  --body '## Revision Requested for <task_number>

**Project:** <project>
**Field:** <field>
**PR:** #<pr_number>
**Review count:** <review_count>

### What to fix
Read the PR review comments on PR #<pr_number>. Address all blocking issues.
Work on the same branch: `day/v<version>/<field>`

### Output
Push fixes to the existing branch. The PR auto-updates.
After fixing, mark this task DONE.'
```

**2) Re-review task (parent=revision):**

```bash
/app/venv/bin/hermes -p elk kanban create "Re-review <task_number> (count: <review_count>)" \
  --assignee <reviewer> \
  --skill review-pr \
  --tenant <project> \
  --parent <revision_task_id> \
  --json \
  --body '## Re-review PR #<pr_number> for <task_number>

**Worker:** @<assignee>
**Review count:** <review_count>

### What to review
The worker has pushed fixes addressing the previous NEEDS REVISION feedback.
Re-review the PR and post a new verdict.

### Output
- PR review comment with APPROVED or NEEDS REVISION
- kanban_complete with verdict in metadata, summary, and a comment'
```

**3) Orchestrator decision task (parent=re-review):**

```bash
/app/venv/bin/hermes -p elk kanban create "Orchestrator decision: <task_number> after re-review" \
  --assignee elk \
  --skill orchestrate \
  --tenant <project> \
  --parent <re_review_task_id> \
  --json \
  --body '## Orchestrator Decision for <task_number> (re-review round <review_count>)

**Worker task (revision):** <revision_task_id>
**Review task (re-review):** <re_review_task_id>
**Project:** <project>
**Day:** <day>
**Field:** <field>
**Review count:** <review_count>

### Instructions
When this task becomes ready:
1. `kanban_show` the re-review task → extract verdict
2. `kanban_show` the revision task → extract PR number
3. Run orchestrator_decision() with field=`<field>`'
```

### Step 4.3 — Notify

Send Telegram message:

> Task <task_number>, PR #<pr_number> needs revision (round <review_count>/3). Fixes dispatched to @<assignee>.

---

## 5. Interactive vs. Kanban Worker Mode

### Interactive mode (`/orchestrate <project> field <field>` in chat)

- Elk is in a chat session (WebUI, Telegram)
- Parse the field from user input (`design`, `prog`, `art`, `sound`)
- Run `orchestrate_field(project, field)` — dispatches all tasks in the field, one after another
- Report results directly to the user in chat
- `/orchestrate <project> task <id>` still works for individual task dispatch

### Kanban worker mode (dispatched for orchestrator_decision task)

- Elk is spawned by the kanban dispatcher (not in a chat)
- Check for `HERMES_KANBAN_TASK` env var — if set, you're a kanban worker
- Read the task body for worker_task_id, review_task_id, and field
- Run `orchestrator_decision()` 
- Send notifications via Telegram using `send_message`
- Complete the orchestrator_decision task via `kanban_complete`

---

## 6. Project Detection

To find the project's `.docs/backlog.md`:

- Check for `HERMES_KANBAN_WORKSPACE` env var (if kanban worker)
- Default project path: `/workspace/_projects/mahou/`
- The backlog is at: `<project_root>/.docs/backlog.md`
- The daily doc is at: `<project_root>/.docs/daily_<sprint>.<day>.md`

---

## 7. Notification Delivery

All notifications from kanban worker mode go via Telegram:

```
send_message(target="telegram", message="<notification text>")
```

Never assume you're in a chat session when running as a kanban worker.

---

## Pitfalls

- **Don't create cron jobs for orchestration.** The kanban dispatcher handles all promotion and spawning. The parent-child task chain is self-driving.
- **Don't use `delegate_task` with kanban toolset to create tasks.** Subagents spawned via `delegate_task(toolsets=["kanban"])` do NOT have `kanban_create` available. Use the hermes CLI (`/app/venv/bin/hermes -p elk kanban create ...`) instead — this is the only reliable path in the WebUI environment.
- **Verify the chain after creation.** After creating all 3 tasks, run `hermes -p elk kanban list --assignee <worker> --json` to confirm the worker is `ready` or `running`, and check that review/orchestrator tasks are `todo`. The dispatcher picks up `ready` tasks within seconds — if the worker is still `ready` after a minute, something is wrong.
- **Don't forget to complete the orchestrator_decision task.** After processing the decision, mark it DONE via `kanban_complete` — otherwise the chain hangs.
- **Don't parse user input manually.** Extract the day number from the backlog section header, not from user messages.
- **Assignees must match existing profiles.** Verify profile names against the delegation map. Unknown profiles silently fail in kanban.
- **Review count cap is 3.** At review_count >= 3, escalate to human — don't create another revision chain.
- **One field at a time, all tasks in sequence.** When dispatching a field, ALL tasks in that field run in order — each completes its chain, then the next auto-dispatches. Never dispatch only the first task and stop.
- **Auto-advance on APPROVED — no user gate between tasks.** The orchestrator dispatches the next task in the same field immediately on APPROVED. The user is NOT notified on every APPROVED. Only notify on field completion or 3 NEEDS REVISION.
- **Field completion notification is mandatory.** When the last task in a field gets APPROVED, send a clear notification: "🎉 Field '<field>' is COMPLETE. Ready for your review @kalkatos."
- **The orchestrator_decision task ALWAYS goes to DONE.** Whether APPROVED, NEEDS REVISION, or escalated — the decision task's job is to evaluate and route. Mark it done after routing.
- **Extract data from parent tasks, not the orchestrator_decision task itself.** The orchestrator_decision task body only carries IDs — the real data (PR number, verdict) lives on the parent tasks' completion records.
- **Redundancy in extraction.** Workers and reviewers report PR numbers and verdicts in THREE places (metadata, summary, comment). Check all three — any one is sufficient.
- **Day extraction from backlog.** Day number comes from the `### Day N — ...` section header in backlog.md, NOT from parsing the task ID.
- **One question at a time with `clarify`.** When reading a complex specification from the user, ask ONE question per `clarify()` call and wait for the answer before asking the next. Bundling 4 questions into one call overwhelms the user and forces them to track multiple threads simultaneously. Sequential questions let each answer inform the next.
- **Trust the user on prerequisite completion.** When the user explicitly dispatches a task by ID that has unchecked prerequisites in the backlog, or when they say a prerequisite is already done, warn once with the dependency list and proceed. Do NOT argue with the user or refuse to dispatch because the backlog file hasn't been updated. The file may be stale — the user knows their project state better than the file does.
- **No follow-up verification after chain creation.** The three `kanban create` commands each return JSON with the task ID, status, assignee, and parent. That output is the verification. Do NOT run extra `kanban list`, `kanban show`, or shell pipelines after creation — it wastes a tool call and adds no information the creation responses didn't already provide.
- **Respect blocking design gate.** Before dispatching a `prog`, `art`, or `sound` field, check if the `design` field has blocking tasks still unchecked. If the daily document says "Game design blocks today's programming work", do NOT dispatch non-design fields until design completes.
- **prog field: dispatch Imp after Angel+Jack.** When the last Angel/Jack task in the `prog` field completes, the next dispatch should be the Imp test task (if one exists). Imp is always last in the `prog` field.
- **Extract field from orchestrator_decision task body.** The field tag (`**Field:** <field>`) is in the orchestrator_decision task body. Parse it to know which field to advance.
