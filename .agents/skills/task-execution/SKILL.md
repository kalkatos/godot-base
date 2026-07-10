---
name: task-execution
description: "Governs how worker agents execute kanban tasks — field-based branch naming (day/vX.Y.Z/<field>), main sync, PR creation, and the review-required handoff loop. Loaded via --skills on every worker kanban task. Workers in the same field share a branch."
version: 2.0.0
---

# Task Execution — Worker Workflow

The mandatory workflow every worker agent must follow when picking up a kanban task. This skill layers the git/PR/review lifecycle on top of the auto-injected `KANBAN_GUIDANCE`.

## When to Load

Elk attaches this skill to every worker kanban task via `--skills task-execution`. Workers load it automatically when spawned. Also load it manually if you're debugging the workflow.

## Step 0 — Determine Your Phase

Before doing anything else, read the kanban task's comments and prior runs to determine which phase you're in:

| Clue | Phase |
|---|---|
| Task is `running`, no prior runs, no branch exists | **Phase 1 — First run** (do the work) |
| Task is `done`, PR has `APPROVED` review comment | **Phase 2 — Approved** (no action needed) |
| Task is `done`, PR has `NEEDS REVISION` review comment | **Phase 3 — Fix and re-submit** |

**Do NOT proceed without identifying your phase.** Misidentifying means double-work or skipping review stages.

---

## Phase 1 — First Run: Do the Work

### 1.1 Extract Task Identity

Every kanban task title follows this format: `[Project] v1.1.2.3 Action verb + what`

Extract from the title:
- **Task ID** (e.g., `v1.1.2.3`) — your identity for this task
- **Version** — the sprint version (e.g., from `v1.1.2.3` → version is `v1.1.2`)

Then read the task body to find your **field**:

```
**Field:** <field>
```

Valid fields: `design`, `prog`, `art`, `sound`.

**Your branch name is:** `day/<version>/<field>` (e.g., `day/v1.1.2/prog`)

All workers in the same field share this branch. If the branch already exists (a previous worker in the same field created it), check it out and merge main — do NOT create a new branch.

### 1.2 Identify Your Project

Read the task body — it specifies the project (e.g., "**Project:** Mahou") and the workspace path.

Navigate to the project root. All git commands below are run from the project root.

### 1.3 Authenticate

Source your profile's environment and authenticate for GitHub operations:

```bash
source ~/.hermes/profiles/<your_profile>/.env
source ~/.hermes/bin/gh_auth.sh
```

Verify:
```bash
gh auth status
```

If the project uses HTTPS remotes (check with `git remote -v`), configure git to use the `gh` credential helper so `git fetch/push/pull` can use `GITHUB_TOKEN`:
```bash
gh auth setup-git --hostname github.com
```

### 1.4 Create the Field Branch

**This step is MANDATORY. Tasks with branches not named `day/v<version>/<field>` or not synced from main will fail review.**

All workers in the same field work on the SAME branch. If a previous worker in your field already created the branch, switch to it and merge main.

```bash
# Fetch latest
git fetch origin

# Sync main to your local
git checkout main
git pull origin main

# Determine your branch name:
# Version: extract from task ID (v1.1.2.3 → version is v1.1.2)
# Field: read from task body "**Field:** <field>"
# Branch: day/v<version>/<field>  (e.g., day/v1.1.2/prog)

# Check if the field branch already exists
if git ls-remote --heads origin day/v<version>/<field> | grep -q day/v<version>/<field>; then
    # Branch exists — another worker in this field created it
    git fetch origin day/v<version>/<field>
    git checkout -b day/v<version>/<field> origin/day/v<version>/<field>
    git merge main  # ensure current
else
    # First worker in this field — create the branch
    git checkout -b day/v<version>/<field>
fi

# Verify you're on the right branch
git branch --show-current
# Must output: day/v<version>/<field>
```

**Field branch sharing example:**
- Day v1.1.2, `prog` field has tasks: v1.1.2.3 [Angel], v1.1.2.4 [Jack], v1.1.2.5 [Imp]
- All three work on branch `day/v1.1.2/prog`
- Angel creates it, Jack and Imp check it out and merge main

### 1.5 Do the Work

Follow the task description in the kanban task body. Commit incrementally with clear messages:

```bash
git add <files>
git commit -m "<task-id>: <what you did>"
```

### 1.6 Push and Open PR

```bash
# Push the branch
git push -u origin day/v<version>/<field>

# Open the PR
gh pr create \
  --base main \
  --head day/v<version>/<field> \
  --title "[<Project>] <task-id>: <task description> (field: <field>)" \
  --body "## Task: <task-id>

**Field:** <field>
**Branch:** day/v<version>/<field>

**What this does:** <brief description>

**Changed files:**
- <file> — <what changed>

**How to test:** <instructions>

Closes kanban task: <task-id>
"
```

Capture the PR number and URL from the output.

### 1.7 Complete the Task

Mark your kanban task as DONE — the paired review task (created by Elk with this task as parent) will automatically become ready for the senior reviewer.

**Report the PR number redundantly in THREE places** so the orchestrator can extract it reliably from any one of them:

**A) `kanban_comment` — post the PR URL:**
```
kanban_comment(task_id="<your-task-id>", body="PR created: https://github.com/<owner>/<repo>/pull/<N>")
```
Also include: changed files list, test results (if any), decisions/trade-offs.

**B) `kanban_complete` summary — include the PR number:**
```
"PR #N — <one-line summary of what was done>. Awaiting senior review via paired review task."
```

**C) `kanban_complete` metadata — include the PR number as structured data:**
```json
{
  "pr_number": <N>,
  "pr_url": "https://github.com/<owner>/<repo>/pull/<N>",
  "changed_files": ["<file1>", "<file2>"],
  "tests_passed": <count>
}
```

Full completion call:
```python
kanban_comment(
    task_id=os.environ["HERMES_KANBAN_TASK"],
    body="PR created: https://github.com/<owner>/<repo>/pull/<N>\n\nChanged files:\n- <file> — <what changed>\n\nTest results: <results>\n\nDecisions: <key decisions>",
)
kanban_complete(
    summary="PR #<N> — <one-line summary>. Awaiting senior review via paired review task.",
    metadata={
        "pr_number": <N>,
        "pr_url": "https://github.com/<owner>/<repo>/pull/<N>",
        "changed_files": ["<file1>", "<file2>"],
        "tests_passed": <count>,
    },
)
```

**CRITICAL: Never block the task with reason `review-required`.** Mark it **done** instead. The reviewer task is created with yours as its parent — it needs your task to be in `done` status for the dependency chain to work. Blocking breaks the review pipeline.

**Do NOT merge the PR yourself** — UR-05: only the user merges PRs.

After completing, your work on this task is done. If the senior reviewer posts NEEDS REVISION on the PR, address the feedback in a follow-up PR (see Phase 3).

---

## Phase 2 — Approved: No Action Needed

Your task is already marked DONE. When the senior reviewer approves your PR, no further kanban action is needed — the user will merge the PR when ready.

**What happens next:** The orchestrator receives the APPROVED verdict and **stops the chain**. It notifies the user that PR #N is ready to merge. The next task in the backlog is NOT dispatched until the user merges and runs `/orchestrate` again. Your work is clean — wait for the merge gate to clear.

---

## Phase 3 — Needs Revision: Fix via Follow-Up PR

The senior reviewer posts NEEDS REVISION as a comment on your PR. Since your kanban task is already DONE, handle fixes as a follow-up:

### 3.1 Read the PR Review Comments

Go to your PR on GitHub. Read the senior's review comments carefully. Find:
- The specific files that need changes
- The specific issues to address
- The senior's expected outcome

### 3.2 Make the Fixes

```bash
# You should already be on your field branch
git checkout day/v<version>/<field>

# Sync with main before fixing
git merge main
```

Make the requested changes. Commit:

```bash
git add <files>
git commit -m "<task-id>: address review feedback — <summary of fixes>"
git push
```

The PR auto-updates — no need to open a new one.

### 3.3 Notify the Reviewer

Comment on the PR:
- What you changed and why
- How you addressed each review point
- Updated test results (if applicable)

The senior reviewer will see the PR update and re-review. No kanban state changes needed — your task remains DONE and the senior's paired review task handles the re-review cycle.

---

## Branch Naming — Enforced

| ✅ Correct | ❌ Rejected |
|---|---|
| `day/v1.1.2/design` | `task/v1.1.2.3` |
| `day/v1.1.2/prog` | `feat/v1.1.2.3` |
| `day/v1.1.2/art` | `feature/prog` |
| `day/v1.1.2/sound` | `v1.1.2/prog` |

Branch names use the format `day/v<version>/<field>`:
- `day/` — literal prefix for daily work
- `v<version>` — sprint version extracted from task ID (e.g., `v1.1.2.3` → `v1.1.2`)
- `<field>` — one of `design`, `prog`, `art`, `sound`

All workers in the same field share this branch. Nothing else is acceptable.

## Main Sync — Enforced

Before EVERY task (first run AND revision), you MUST:

```bash
git fetch origin
git checkout main
git pull origin main
git checkout day/v<version>/<field>   # or git checkout -b day/v<version>/<field> for first run in this field
git merge main                         # ensure field branch is current
```

Tasks built on stale main will fail review.

## Pitfalls

- **Blocking with `review-required`.** Never block your kanban task with reason `review-required` after completing work — mark it DONE instead. The paired reviewer task depends on your task being in `done` status. Blocking breaks the review dependency chain.
- **Skipping Phase 0 detection.** Always determine your phase first. Running Phase 1 on a revision task means losing the PR and context.
- **Using the wrong branch prefix.** `task/`, `feature/`, `feat/`, no prefix — all rejected at review. Only `day/v<version>/<field>` is valid.
- **Creating a new branch when the field branch already exists.** If another worker in your field already created `day/v<version>/<field>`, check it out and merge main. Do NOT create a duplicate branch.
- **Skipping main sync.** A PR from a stale branch causes merge conflicts and wastes everyone's time.
- **Completing with the wrong summary.** After Phase 1, always include the PR number and "Awaiting senior review" in your kanban_complete summary — the paired review task depends on this context.
- **Merging your own PR.** UR-05: only the user merges. After APPROVED, your work is done — the user handles the merge.
- **Not checking PR comments for NEEDS REVISION.** Your task is DONE but the senior may request changes via PR review comments. Monitor your PR for review feedback and address it promptly.
- **Not extracting the task ID from the kanban title.** The task ID is in the title format `[Project] v1.1.2.3 ...`. Extract it programmatically — don't guess.
- **Not extracting the field from the task body.** The field is specified as `**Field:** <field>` in the task body. Workers in the same field share a branch — misidentifying your field means working on the wrong branch.
- **Forgetting to authenticate.** Every new kanban spawn is a fresh session. Always source `.env` and run `gh_auth.sh` before git operations.
- **Working on the wrong project.** Read the task body for the project name and workspace path.
- **Not reading the PR template.** The PR body should include changed files, test instructions, and the kanban task reference.
- **Branch locked in another worktree.** If `git checkout day/v<version>/<field>` fails with `fatal: '...' is already used by worktree at '<path>'`, the branch is checked out in another worktree (often the main project root). Check with `git branch --show-current` from that path. If the branch is there and synced with main, work from that worktree instead of trying to check it out in your own worktree. Do NOT try to `git checkout` the same branch in two places — Git forbids it.
