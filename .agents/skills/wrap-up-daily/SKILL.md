---
name: wrap-up-daily
description: "Use when @Elk needs to wrap up the daily after senior reviews. Reads Griffin's and Hag's PR feedback, maps observations to resolutions, updates the daily document and backlog.md, posts a summary comment on the PR, syncs decisions to decisions.md, updates glossary.md with new domain terms, and dispatches the initial worker→review→decision chains per field (Track A/B1/B2). Cuts the need for a separate /orchestrate call to start the day."
version: 2.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, production, management, daily-report, backlog, wrap-up]
    related_skills: [daily, milestone, review-pr, orchestrate]
---

# /wrap-up-daily — Wrap Up After Senior Review

## Overview

This skill wraps up the daily check-in after seniors (Griffin and Hag) have reviewed the daily PR. As **@Elk (producer)**, you read every observation from the senior reviews, map each one to a concrete resolution, update both the daily document and the sprint backlog, post a summary comment on the PR, and sync any new decisions and glossary terms to the permanent project logs.

This is the step between "Seniors review the daily PR" and "@User approves PR" in the Dian Agentic Gamedev Process (PROCESS.md lines 120–123).

**This skill replaces the inline "Update After Senior Review" logic previously embedded in the `/daily` skill.** The `/daily` skill now stops after creating the PR and reporting that senior reviews are pending; when reviews arrive, Elk runs `/wrap-up-daily` as a separate step.

## When to Use

- The daily PR exists and has received reviews from **both** Griffin and Hag
- At least one review contains observations that need to be addressed (even APPROVED reviews may have non-blocking observations)
- You are in the Production phase, inside the daily loop
- Do NOT use before both seniors have submitted their review
- Do NOT use if there are no observations to address from either reviewer
- Do NOT use during Pre-production

## Naming Convention

All artifacts follow the sprint+day convention (dot-separated), sourced from the `Day` field in `.docs/project-state.md`:

| Artifact | Pattern | Example |
|---|---|---|
| Daily report file | `.docs/daily_<sprint>.<day>.md` | `daily_v1.1.1.md` |
| Sprint backlog | `.docs/backlog.md` | (single file, updated per sprint) |
| PR branch | `daily/<day>` | `daily/v1.1.1` |

## When GH Auth Is Unavailable

Steps 1, 2, 7, 8, and 9 depend on `gh` CLI with valid auth (`source .env` + `gh_auth.sh`). If auth is broken or missing:

- **Read PR reviews from session history:** Use `session_search` to find prior review sessions from Griffin and Hag. Reviews may have been posted directly in chat rather than via GitHub PR comments.
- **User-provided reviews:** The user may provide senior observations directly in the `/wrap-up-daily` command (e.g., "/wrap-up-daily mahou PR 25" followed by "rule_origin changed to Resource"). Treat these as first-class review observations — map them to resolutions just like PR comments.
- **Self-review by agent persona:** If you are running as Griffin and no Griffin review exists, produce your review observations directly using the `/review-pr` skill's criteria (checking technical priorities, blockers, pace, file paths, code standards). For Hag's perspective, use the `/review-pr` daily review criteria (vision alignment, design decisions) and cross-reference `.docs/game-concept.md` and `.docs/glossary.md`.
- **Commit without push:** Commit changes to the daily branch locally. Save the PR comment to `.docs/wrap-up-comment-pr<num>.md` in the worktree. Report to the user which commits need manual push.
- **decisions.md and glossary.md push to main:** The `git checkout main` step in Step 6 may not work from inside a worktree. Edit in the main worktree instead (see Pitfall 11) and report the commit as needing manual push.
- **`gh` CLI rejects a fresh GITHUB_TOKEN:** Even after `source .env && source gh_auth.sh`, `gh auth status` may report "The token in GH_TOKEN is invalid" while the actual GITHUB_TOKEN from the GitHub App installation is valid. This happens when `gh` has cached a stale credential that overrides the env var. Workaround: skip `gh` for API calls. Use `curl` with the `GITHUB_TOKEN` directly for all reads (PR details, reviews, comments) and writes (posting comments). Use `git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/OWNER/REPO.git"` for git operations. See Pitfall 18 for the curl API pattern.

## Worktree Awareness

Projects with multi-agent worktrees (each agent has its own checkout) require extra care:

- **Daily PR branch lives in the `elk` worktree.** The daily branch (`daily/<day>`) is checked out at `<project>/elk/`. Do NOT try to `git checkout daily/<day>` from the main worktree or any other agent's worktree — it will fail with "branch is already used by worktree."
- **All edits to daily documents must happen from the elk worktree.** Read files from `<project>/elk/.docs/`, patch them there, commit them there.
- **Main-branch files (decisions.md and glossary.md) must be edited in the main worktree** (`<project>/.docs/`), not the elk worktree. After editing, attempt `git push origin main` from the main worktree. If auth is unavailable, report the pending commit.
- **Copy files between worktrees with `cp`** — after updating daily docs in the main worktree (for convenience), copy them to the elk worktree before committing. The main worktree copy is a transient convenience; the elk worktree copy is the one that gets committed to the PR branch.

## Workflow

### Step 1: Verify the Daily PR Exists and Has Reviews

Confirm the daily PR is open and both seniors have submitted reviews. Read the `Day` field from `.docs/project-state.md`, then:

```bash
# Auth per UNIVERSAL-RULES: source profile .env first, then gh_auth.sh
source /home/hermeswebui/.hermes/profiles/elk/.env
source /home/hermeswebui/.hermes/bin/gh_auth.sh
gh pr list --head daily/<day> --state OPEN --json number,title,reviews
```

If no PR exists for today, redirect to `/daily` and exit.
If the PR exists but is **closed and merged** (state=closed, merged=true), this is a post-merge wrap-up. Skip Steps 7 and 9 (no branch push or label changes needed). Use the post-merge path in Step 7A instead.
If the PR is closed but not merged, report and ask the user what happened before proceeding.
If reviews are missing from either Griffin or Hag, report which senior still needs to review and exit.

### Step 2: Read All Reviews

Pull every review and comment from the daily PR:

```bash
gh pr view <PR_NUMBER> --json reviews,comments
```

Extract every unique observation, note, and concern from all reviews. Pay special attention to:

- **Blocking issues** (NEEDS REVISION) — must be resolved before asking the user to merge
- **Non-blocking observations** (from APPROVED reviews) — still actionable, don't skip them
- **Specific references** to missing files, outdated paths, incorrect terminology, or scope concerns

### Step 3: Map Each Observation to a Resolution

Create a response table mapping every unique observation to its resolution:

| Observation | Resolution |
|---|---|
| (Quoted or paraphrased from reviewer) | ✅ Specific change or decision made |

**Every observation must have a resolution entry.** If an observation cannot be resolved (e.g., it requires a scope change the user hasn't approved), flag it explicitly to the user before proceeding.

### Step 4: Update the Daily Document

Read `.docs/daily_<sprint>.<day>.md` and apply these changes:

- **"Today's Focus" section:** Expand or refine based on reviewer feedback.
- **"Today's Backlog" section:** Update task descriptions with corrected paths, patterns, or scope changes the reviewers requested.
- **"Decisions Made Today" section:** Record any new decisions that arose from review feedback.
- **Add a "Senior Review Feedback" section** at the bottom of the document containing the full observation→resolution table. This lets reviewers verify their feedback was addressed in one glance.

### Step 5: Update the Sprint Backlog (backlog.md)

Read `.docs/backlog.md`. The backlog contains ONLY the current sprint's tasks (previous sprints are archived by `/milestone` to `.docs/backlog-<old-sprint>.md`). Senior reviewers may have flagged tasks that are missing, incorrectly scoped, or need refinement.

**Checklist — for each observation that touches the backlog:**

- [ ] **Task order corrected:** If a reviewer said task B must precede task A, reorder them
- [ ] **Task scope adjusted:** If a reviewer said a task is too broad or too narrow, update its description
- [ ] **Missing tasks added:** If a reviewer identified work not covered by any existing task, add it
- [ ] **Dependencies noted:** If a reviewer flagged that task X depends on task Y, add the dependency
- [ ] **Assignee corrected:** If a reviewer said a task is assigned to the wrong persona, reassign it
- [ ] **Task descriptions refined:** If a reviewer said a description is vague, add specifics (file paths, function signatures, expected outputs)

If the backlog was flagged as empty by a reviewer, populate it from the tasks defined in the daily document.

### Step 6: Sync Decisions and Glossary

If Step 4 produced new decisions, propagate them to `.docs/decisions.md`. Also scan for new domain terms and add them to `.docs/glossary.md`. Both are main-branch files — they must NOT be committed to the PR branch.

#### 6a. Update glossary.md

Read `.docs/glossary.md`. Identify any new domain terms, concepts, or naming conventions introduced in:

- Today's daily document and tasks
- Griffin's technical feedback
- Hag's design feedback
- Any new systems, mechanics, entities, or file names mentioned

**For each new term, add a glossary entry:**

```markdown
### <Term>
<Clear, concise definition. 1–3 sentences.>
```

Do NOT duplicate existing glossary entries. If a term already exists but needs refinement, update the existing entry instead.

If no new terms are identified, note "No new glossary terms" in the completion report.

#### 6b. Update decisions.md

Propagate new decisions to `.docs/decisions.md`.

**Worktree-aware approach (projects with multi-agent worktrees):**
```bash
# Edit decisions.md in the MAIN worktree (<project>/.docs/), NOT the elk worktree.
# The elk worktree has daily/<day> checked out — you cannot 'git checkout main' from there.
source /home/hermeswebui/.hermes/profiles/<your_profile>/.env
source /home/hermeswebui/.hermes/bin/gh_auth.sh
cd /workspace/_projects/<project>  # main worktree, not elk/
git config user.email "<agent>@kalkatos.games"
git config user.name "<Agent Name>"
git add .docs/decisions.md .docs/glossary.md
git commit -m "docs: add decisions and glossary from daily <day> wrap-up — <summary>"
# If git push doesn't pick up GITHUB_TOKEN, use token-in-URL:
git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git"
git push origin main
git remote set-url origin "https://github.com/<owner>/<repo>.git"  # restore clean URL
```

Each decision entry must follow:
- **What:** Clear description
- **Why:** Rationale
- **When:** Date, current milestone, current sprint
- **Alternatives Considered:** If any

### Step 7: Commit and Push to the PR Branch

Push the daily document and backlog updates to the existing PR branch:

```bash
# All edits must happen from the elk worktree (<project>/elk/).
# Auth per UNIVERSAL-RULES:
source /home/hermeswebui/.hermes/profiles/<your_profile>/.env
source /home/hermeswebui/.hermes/bin/gh_auth.sh
cd /workspace/_projects/<project>/elk
git add .docs/daily_<sprint>.<day>.md .docs/backlog.md
git commit -m "daily: wrap-up <day> with senior review feedback"
# If git push doesn't pick up GITHUB_TOKEN, use token-in-URL:
git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git"
git push origin daily/<day>
git remote set-url origin "https://github.com/<owner>/<repo>.git"  # restore clean URL
```

If the local branch name differs from the PR branch, use:
```bash
git push origin <local-branch>:daily/<day>
```

### Step 7A: Post-Merge Path (PR Already Merged)

When the daily PR is already merged (detected in Step 1), skip Steps 7 and 9. Wrap-up changes need to go to `main` directly since the PR branch no longer accepts pushes.

**Worktree-aware approach:**

1. **Commit and push from the elk worktree branch:**
   ```bash
   # The elk worktree is on branch 'elk' (not 'daily/<day>')
   source /home/hermeswebui/.hermes/profiles/elk/.env
   source /home/hermeswebui/.hermes/bin/gh_auth.sh
   cd /workspace/_projects/<project>/elk
   git add .docs/daily_<sprint>.<day>.md .docs/backlog.md
   git commit -m "daily: wrap-up <day> with senior review feedback"
   # Push elk branch
   git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git"
   git push origin elk
   git remote set-url origin "https://github.com/<owner>/<repo>.git"
   ```

2. **Merge elk branch into main** (from the main worktree):
   ```bash
   cd /workspace/_projects/<project>  # main worktree
   source /home/hermeswebui/.hermes/profiles/elk/.env
   source /home/hermeswebui/.hermes/bin/gh_auth.sh
   git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git"
   git fetch origin elk
   git merge origin/elk --no-edit
   git push origin main
   git remote set-url origin "https://github.com/<owner>/<repo>.git"
   ```

3. **Proceed to Step 8** to post the wrap-up comment on the merged PR.

### Step 8: Post a Summary Comment on the PR

Write the PR body to a temp file (to avoid shell escaping issues with markdown), then post:

```bash
cat > /tmp/wrap_up_comment.md << 'COMMENT_EOF'
**Daily document updated based on senior review feedback.**

### @Griffin @Hag — observations addressed:

| Observation | Resolution |
|---|---|
| ... | ✅ ... |
| ... | ✅ ... |

### Files updated
- `.docs/daily_<sprint>.<day>.md` — daily report with Senior Review Feedback section
- `.docs/backlog.md` — sprint backlog (if updated)
- `.docs/glossary.md` — (<N> new terms added / no changes)
- `.docs/decisions.md` — (<N> new decisions added / no changes)

Ready for your review and approval @kalkatos.
COMMENT_EOF

gh pr comment <PR_NUMBER> --body-file /tmp/wrap_up_comment.md
```

If `gh pr comment` fails (e.g., PR is merged and `gh` rejects the call, or `gh` auth says invalid token), use the GitHub Issues API directly with `curl`:

```bash
# Write the comment to a temp file first
cat > /tmp/wrap_up_comment.md << 'COMMENT_EOF'
...
COMMENT_EOF

# Post via GitHub API using GITHUB_TOKEN (not gh CLI)
source /home/hermeswebui/.hermes/profiles/elk/.env
source /home/hermeswebui/.hermes/bin/gh_auth.sh
curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  -d "$(python3 -c "import json; print(json.dumps({'body': open('/tmp/wrap_up_comment.md').read()}))")" \
  "https://api.github.com/repos/<owner>/<repo>/issues/<PR_NUMBER>/comments"
```

Or, for complex markdown with backticks and special chars, write a Python script:

```python
import json, urllib.request, subprocess
# Get token
result = subprocess.run('''source /home/hermeswebui/.hermes/profiles/elk/.env &&
  source /home/hermeswebui/.hermes/bin/gh_auth.sh && echo $GITHUB_TOKEN''',
  shell=True, capture_output=True, text=True)
token = result.stdout.strip()
# Read comment body
with open("/tmp/wrap_up_comment.md") as f:
    body = f.read()
# Post comment
data = json.dumps({"body": body}).encode("utf-8")
req = urllib.request.Request(
    "https://api.github.com/repos/<owner>/<repo>/issues/<PR_NUMBER>/comments",
    data=data,
    headers={
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "Content-Type": "application/json",
        "User-Agent": "hermes-bot"
    }
)
resp = json.loads(urllib.request.urlopen(req).read())
print(f"Comment posted: {resp.get('html_url', 'unknown')}")
```

The comment should:
- Thank each reviewer by tag
- List every observation with its resolution
- List the files that were updated
- End with a clear call to action (ask the user to approve and merge)

### Step 9: Update PR Labels

If the PR has a "needs revision" label, remove it and add "ready for review":

```bash
gh pr edit <PR_NUMBER> --remove-label "needs revision" --add-label "ready for review"
```

### Step 10: Dispatch Initial Field Tasks

After the daily PR is approved and merged, dispatch the first task in each applicable field. This replaces the old workflow where the user would run `/orchestrate` separately — `/wrap-up-daily` now kicks off all field tracks directly.

#### Step 10.1 — Read Today's Backlog

Read `.docs/daily_<sprint>.<day>.md` and extract tasks grouped by field:

| Field | Track | Workers | Reviewer |
|-------|-------|---------|----------|
| `design` | Track A | Capy (`[Capy]`) | Hag |
| `prog` | Track B1 | Angel (`[Angel]`), Jack (`[Jack]`) | Griffin |
| `art` | Track B2 | Fairy (`[Fairy]`) | Kavu |
| `sound` | Track B2 | Levi (`[Levi]`) | Kavu |

Also extract the game design blocking status from the daily document: "Game design **blocks** today's programming work" or "Game design **does not block** today's programming work."

#### Step 10.2 — Determine Dispatch Order

| Condition | Action |
|-----------|--------|
| `[Capy]` tasks exist | **Dispatch Track A (design) first** |
| `[Capy]` tasks are BLOCKING | Track B1 waits — do NOT dispatch prog/art/sound yet |
| `[Capy]` tasks are NON-BLOCKING | Dispatch Track A, B1, B2 all at once (parallel) |
| No `[Capy]` tasks | Dispatch B1 and B2 immediately |

#### Step 10.3 — Dispatch a Field's First Task

For each field being dispatched, create the worker→review→decision chain for the **first unchecked task** in that field's backlog section. Use the hermes CLI (same pattern as `/orchestrate` Step 2.3):

Field-to-worker mapping for the FIRST task in each field:
- `design` → first `[Capy]` task
- `prog` → first `[Angel]` or `[Jack]` task (whichever appears first in the backlog)
- `art` → first `[Fairy]` task
- `sound` → first `[Levi]` task

For each field's first task, create three kanban tasks:

```bash
# Worker task
/app/venv/bin/hermes -p elk kanban create "[<project>] <task_id> <short description>" \
  --assignee <assignee> \
  --skill task-execution \
  --tenant <project> \
  --json \
  --body '## Task: <task_id> — <short description>

**Project:** <project>
**Field:** <field>
**Day:** <day>

### What to do
<description from backlog line>

### Context
- See daily doc `.docs/daily_<sprint>.<day>.md` for full task details
- See glossary `.docs/glossary.md` for domain terms
- See decisions `.docs/decisions.md` for relevant decisions

### Branch
Work on branch: `day/v<version>/<field>` (e.g., `day/v1.1.1/prog`)'
```

Capture worker_task_id, then create review and orchestrator decision tasks (same as `/orchestrate` Section 2.3). The orchestrator_decision task body must include the **field tag** so the orchestrator knows which field to advance:

```
**Field:** <field>
```

#### Step 10.4 — Track B1 Special Case: Imp (Tests)

Imp's test tasks are NOT dispatched now. They are dispatched by `/orchestrate` after all `prog` field tasks (Angel + Jack) are complete. The orchestrator_decision for the last `prog` task auto-dispatches Imp's task as the next in the `prog` field.

#### Step 10.5 — Notify User

Send a summary via the active chat (or Telegram if kanban worker mode):

```
## Tasks Dispatched — <day>

| Track | Field | Task | Worker | Reviewer |
|-------|-------|------|--------|----------|
| A | design | <task_id> | @Capy | @Hag |
| B1 | prog | <task_id> | @Angel | @Griffin |
| B2 | art | <task_id> | @Fairy | @Kavu |
| B2 | sound | <task_id> | @Levi | @Kavu |

Game design is [blocking / non-blocking] for today's code work.

**What happens next:**
- Each task runs its worker→review→decision chain
- At APPROVED, the orchestrator auto-dispatches the next task in the same field
- You'll be notified when a field is fully complete or a task hits 3 NEEDS REVISION
```

### Step 11: Report Completion

Return a summary to the user:

```
## Daily Wrap-Up Complete — <day>

**PR:** <link-to-pr>

### What was updated
- `.docs/daily_<day>.md` — Senior Review Feedback section added
- `.docs/backlog.md` — (list specific changes, or "no changes needed")
- `.docs/glossary.md` — (<N> new terms added / no changes)
- `.docs/decisions.md` — (<N> new decisions added / no changes)

### Observations resolved
| Observation | Resolution |
|---|---|
| ... | ✅ ... |

### Tasks dispatched
(Track/field/worker table from Step 10.5)

### Next step
Tasks are now running per field. The orchestrator auto-advances to the next task in each field on APPROVED. You'll be notified when:
- A field is complete (all tasks done)
- A task hits 3 NEEDS REVISION (escalated to you)
- After all daily tasks: @Elk runs `/review-day`
- After all sprint tasks: @Elk runs `/review-sprint`
```

## Common Pitfalls

1. **Running before both seniors have reviewed.** Verify both Griffin and Hag have submitted reviews before proceeding. If reviews are not on the PR, check session history or ask the user to provide observations directly.
2. **Skipping observations from APPROVED reviews.** An APPROVED review with observations still requires action. Address all observations regardless of verdict.
3. **Not updating the backlog.** The backlog (`backlog.md`) is a sprint-level document and a key output. If a reviewer flagged missing tasks, wrong ordering, or scope issues, the backlog must reflect the corrections.
4. **Pushing decisions.md or glossary.md to the PR branch.** These are main-branch files. Commit and push them directly to `main` (Step 6), not to the daily PR branch.
5. **Not adding a response table.** Without a table mapping each observation to its resolution, reviewers must re-read the full diff to verify their feedback was addressed. The table is non-negotiable.
6. **Using `--body` for PR comments with markdown.** Shell escaping breaks on asterisks, backticks, and em-dashes. Always use `--body-file` with a temp file.
7. **Creating a new PR instead of updating the existing one.** All changes go to the existing `daily/<day>` branch — never create a new branch or PR.
8. **Forgetting to return to the PR branch after pushing decisions.md.** Step 6 checks out `main` to push decisions. Always `git checkout daily/<day>` afterward.
9. **Skipping PR label updates.** If the PR was marked "needs revision", remove that label. If it was already approved, ensure "ready for review" is set so the user knows it's their turn.
10. **Not verifying the PR still exists before starting.** If the user merged the PR between reviews arriving and this skill running, the `gh pr view` command will fail. Check first.
11. **Editing daily docs from the wrong worktree.** The daily branch is checked out in the `elk` worktree. Edits from the main worktree won't reach the PR. Always commit from `<project>/elk/`. See "Worktree Awareness" section above.
12. **Treating user-provided observations as secondary.** When the user includes review feedback directly in the `/wrap-up-daily` command, those are first-class review observations. Map them to resolutions in the table just as you would PR comments.
13. **Wrong home directory in auth paths.** UNIVERSAL-RULES specifies `/home/hermeswebui/.hermes/` as the home for profiles and scripts. Using `/home/hermes/.hermes/` (missing `webui`) will fail because the `.env` and `gh_auth.sh` files live at the longer path. Always verify with `ls` before sourcing.
14. **Git push doesn't inherit GITHUB_TOKEN.** Even after a successful `source .env && source gh_auth.sh`, `git push` may fail with "could not read Username" because git's credential helper doesn't see the env var. Workaround: embed the token in the remote URL temporarily with `git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git"`, push, then restore the clean URL.
15. **Committing decisions.md from the elk worktree.** The elk worktree has `daily/<day>` checked out — `git checkout main` will fail. Edit and commit decisions.md from the main project worktree instead. See updated Step 6.
16. **Skipping field task dispatch.** Step 10 is mandatory — if the daily has tasks, they must be dispatched before reporting completion. A daily wrap-up that ends without dispatching tasks leaves workers idle.
17. **Dispatching Track B1 while game design is blocking.** If the daily says "Game design blocks today's programming work," do NOT dispatch prog/art/sound tasks. Only Track A (design) is dispatched. Track B1/B2 dispatch after the game design PR is approved.
18. **`gh` CLI rejects a valid GITHUB_TOKEN.** `gh auth status` may report "invalid token" even after sourcing a fresh GITHUB_TOKEN from the GitHub App installation flow. This is a `gh` caching issue — the env var `GH_TOKEN` may hold a stale value. Workaround: read PR details, reviews, and comments via `curl -H "Authorization: Bearer $GITHUB_TOKEN"` instead of `gh`. Post comments via the Issues API endpoint (`/repos/OWNER/REPO/issues/NUM/comments`). Use `git remote set-url` with the token embedded for git operations. See the "When GH Auth Is Unavailable" section for the full curl pattern.
19. **Running wrap-up when the PR is already merged.** If the user merged the daily PR before you run /wrap-up-daily, Step 1's `gh pr list --state OPEN` will return nothing. Check the PR directly via API (`curl -s ... /repos/.../pulls/NUM`) and verify `merged: true`. In the post-merge case, commit and push to `main` via the elk worktree branch (Step 7A), not the daily branch. The daily PR branch no longer accepts pushes. Use the Issues API to post the wrap-up comment since `gh pr comment` may also fail on merged PRs.

## Verification Checklist

- [ ] Daily PR exists and both senior reviews are present
- [ ] PR is open (or check `merged: true` for post-merge path)
- [ ] Every unique observation extracted (including from APPROVED reviews)
- [ ] Observation→Resolution table complete (no unresolved entries)
- [ ] Daily document updated with Senior Review Feedback section
- [ ] Backlog.md checked and updated (if observations touched it)
- [ ] New decisions synced to decisions.md on main branch
- [ ] New glossary terms synced to glossary.md on main branch
- [ ] Changes committed and pushed (PR branch if open, via elk→main merge if merged)
- [ ] Summary comment posted on the PR with full table
- [ ] PR labels updated (skip if already merged)
- [ ] Game design blocking status extracted from daily document
- [ ] Track A dispatched (if `[Capy]` tasks exist)
- [ ] Track B1 dispatched (if `[Angel]`/`[Jack]` tasks exist AND not blocked by design)
- [ ] Track B2 dispatched (if `[Fairy]`/`[Levi]` tasks exist)
- [ ] Field dispatch summary sent to user
- [ ] User clearly informed of next steps
