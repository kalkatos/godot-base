---
name: check-tasks
description: "Discover open tasks assigned to the agent across all projects in the current workspace. Checks GitHub PRs (via gh CLI) and project backlogs for tasks mentioning the agent's name or persona. Notifies the user and asks for direction if nothing is found. Use when the user says 'check your tasks', 'what should I work on', 'check tasks', 'what's next', or similar task-discovery phrases."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [workflow, agent-management, task-tracking, workspace]
---

# /check-tasks — Discover Open Tasks for the Current Agent

## Overview

This skill discovers open tasks assigned to the current agent across all projects in the workspace. It checks GitHub Pull Requests (open, mentioning the agent) and project backlogs. If no tasks are found, it notifies the user and asks for direction.

This skill is **agent-agnostic** — any agent persona can use it: Griffin (senior programmer), Angel (core programmer), Jack (UI developer), Imp (QA/tester), Capy (game designer), Hag (senior game designer), Elk (producer), Fairy (art director), Levi (sound designer), Brute (prototyper), Dino (marketer), Kavu (senior art director).

## When to Use

- User says "check your tasks", "what should I work on", "check tasks", "what's next", "re-run my kanban tasks", "re-run tasks"
- Agent is idle and needs to discover pending work
- Start of a work session to orient on outstanding items
- User wants a status summary across all projects

## Workflow

### 1. Determine Agent Identity

Extract your agent persona name from your system prompt or identity. This is typically at the start: "You are **X**, a ...". Common examples: Griffin, Angel, Jack, Imp, Capy, Hag, Elk, Fairy, Levi.

Also note any alternate forms of your name that might appear in PR mentions or task assignments (e.g., "@griffin", "Griffin", "[Griffin]").

### 1.5. Authenticate First

Before any git or gh operations, authenticate the agent's Hermes profile. The GitHub App JWT auth flow is common:

```bash
set -a
source ~/.hermes/profiles/<YOUR_PROFILE>/.env
set +a
source ~/.hermes/bin/gh_auth.sh
export HOME=/home/hermeswebui/.hermes/home
export PATH="$HOME/.local/bin:$PATH"
```

The `.env` provides `APP_ID`, `PRIVATE_KEY_PATH`, `INSTALLATION_ID`; `gh_auth.sh` generates a short-lived JWT-signed installation token and exports it as `GITHUB_TOKEN`.

**Do NOT mask auth errors.** Never pipe auth through `2>/dev/null` or similar. Suppressing auth errors causes the agent to silently fall back to a stale or expired token and assume auth is broken (when it's actually working). Always verify:

```bash
gh auth status
```

If the global git credential helper points to a nonexistent `gh` path, git operations fail with `gh: not found`. Fix it:

```bash
git config --global --unset-all "credential.https://github.com.helper"
git config --global --add "credential.https://github.com.helper" ""
git config --global --add "credential.https://github.com.helper" "!/real/path/to/gh auth git-credential"
```

### 2. Pull Latest Changes

For each project with a git remote, sync with the remote before checking tasks:

```bash
git pull --ff-only
```

Use `--ff-only` to avoid merge conflicts. If the pull fails (no remote connectivity, uncommitted changes, diverged branches, or credential helper mismatch), note the failure and proceed with the local state — do not block task discovery on a failed pull.

### 3. Discover Projects in the Workspace

Scan the active workspace directory for projects. A project is a directory that meets at least ONE of:
- Contains a `.git/` directory
- Has an `AGENTS.md` file
- Has a `.agents/` directory

For each discovered project, record:
- Project name (directory name or extracted from remote URL)
- Path to the project root
- Git remote URL (if any) — run `git remote get-url origin` inside the project

### 4. Check GitHub Pull Requests (gh CLI)

For each project that has a git remote:

**Determine if `gh` is available:**
Run `which gh` or use the known path. If `gh` is not installed or not authenticated, skip PR checks for that project (do not fail — report it as "no PR access").

**Fetch open PRs mentioning the agent:**
Run inside the project directory:
```bash
gh pr list --search "mentions:AGENT_NAME state:open" --json number,title,url,createdAt,author --jq '.[] | "#\(.number) \(.title) (by \(.author.login), \(.createdAt))"'
```

If the agent has a one-word name, also try a second search using just the name as a search term (some repos may not use `@mentions`):
```bash
gh pr list --search "AGENT_NAME in:title,body state:open" --json number,title,url,createdAt,author --jq '.[] | "#\(.number) \(.title) (by \(.author.login), \(.createdAt))"'
```

Deduplicate results across both searches.

### 5. Check Project Backlogs (Optional)

If the project follows agentic workflows with `.docs/backlog*.md` files, check the most recent backlog for tasks assigned to the agent persona.

Look for:
- `.docs/backlog.md` (unversioned, current)
- `.docs/backlog-YYYY-MM-DD.md` (most recent dated)

Search for task lines mentioning the agent persona, typically in format:
- `[Persona]` prefix (e.g., `[Angel]`, `[Griffin]`)
- `@Persona` mention within the task description

### 6. Check Kanban Board

When the user uses kanban-related phrasing or when PR/backlog checks yield nothing, query the kanban board:

```bash
hermes kanban list --assignee <AGENT_NAME>
```

For each todo/blocked task assigned to the agent, inspect details:

```bash
hermes kanban show <task_id> --json
```

**For blocked tasks:** read the block reason and comments. If `review-required`, tell the user the PR number and wait. Do NOT re-execute a blocked task unless the user explicitly unblocks it.

**For todo tasks:** read the task body for instructions and proceed to execute.

### 7. Report Findings

Present a structured summary:

```
## Tasks Found for @AgentName

### Project: [project-name]
- GitHub PRs:
  - #123: Title (by author, date) — URL
  - (or "No open PRs found")
- Backlog tasks:
  - Task description (from backlog)
  - (or "No backlog checked" / "No tasks in backlog")

### Project: [another-project]
  ...
```

### 8. When Tasks Are Found — Execute, Don't Ask

When tasks are found that clearly match the agent's known role (e.g., @Griffin reviewing a milestone PR, @Imp writing tests for @Angel's code), **proceed to execute the task immediately**. Do not ask the user "want me to do this?" — the `/check-tasks` invocation is the authorization to discover and act on assigned work.

For **PR reviews specifically**: submit the review directly to the PR using `gh pr review`. Never deliver a review only in chat.

Execution approach for PR reviews:
1. Pull the PR diff and any related design documents for context
2. Load relevant gamedev skills (e.g., `milestone`, `daily`, prototype patterns) if applicable
3. Compose the review body **to a file** — see pitfalls below for why inline body fails
4. Submit via: `gh pr review <NUMBER> --comment --body-file /tmp/review-body.md`
   Use `--comment` when `gh` is authenticated as the PR author (self-review guard). Use `--approve` when the agent has a distinct GitHub identity.
5. Report to the user: "Posted review on PR #N." — do not re-deliver the full review text.

### 9. Handle Empty Results

If **no tasks are found across any project**, respond with:

> "I checked all projects in this workspace and found no open PRs or backlog tasks assigned to me (@AgentName). What would you like me to work on?"

Then offer specific options based on project context:
- "I can review the current milestone and suggest next steps"
- "I can check if there are unassigned tasks I should pick up"
- "I can report on the current project state"

Wait for the user's direction — do NOT invent tasks.

## Common Pitfalls

1. **Assuming `gh` is available.** Always check. If `gh` is missing or unauthenticated, report it as a limitation and continue with other checks.
2. **Wrong agent name.** The agent name in the system prompt may not match the GitHub username. Try both the persona name and variations.
3. **Not discovering all projects.** Don't stop at the first project found. Scan the entire workspace for subdirectories that are projects.
4. **PR search too narrow.** Some projects use `@mention` in body, some in title, some don't use mentions at all. Try multiple search strategies.
5. **Don't mask auth errors with 2>/dev/null.** Suppressing stderr on auth commands hides real failures (JWT signing, network, wrong PRIVATE_KEY_PATH) and makes you silently fall back to stale tokens. After sourcing `.env` + `gh_auth.sh`, always verify with `gh auth status` and check exit code. If you see two accounts in `gh auth status`, the active one (GITHUB_TOKEN) must have access to the target repo.
6. **Making up tasks when nothing is found.** The skill ends with asking the user, not inventing work. The user decides the next action.
7. **Long review bodies break inline shell args.** Pipe symbols, backticks, and markdown tables cause shell escaping errors with `gh pr review --body`. Always use `--body-file /tmp/review-body.md` — write the body to a temp file first, then submit. Clean up: `rm /tmp/review-body.md` after posting.
8. **Can't self-approve.** If `gh` is authenticated as the PR author, `--approve` fails with "cannot approve your own pull request." Use `--comment` instead and put your verdict (APPROVED / NEEDS REVISION) in the body text.
9. **Git credential helper points to wrong gh path.** When `gh pr list` returns 401 despite HOME and GITHUB_TOKEN being set, the git credential helper may reference a non-existent `gh` binary. Diagnose with: `git config --global --get-regexp credential`. If the path doesn't match the actual gh location, fix it: `git config --global --unset-all credential.https://github.com.helper && git config --global --add credential.https://github.com.helper "" && git config --global --add credential.https://github.com.helper "!/correct/path/to/gh auth git-credential"`. Also verify `gh auth status` to confirm the active account has access to the target repo.

- [ ] Agent persona name identified from identity
- [ ] All projects in workspace discovered
- [ ] `gh` availability checked per project, credential helper path verified if auth fails
- [ ] Open PRs searched with both mention and title/body strategies
- [ ] Backlog checked where applicable
- [ ] Kanban board checked via `hermes kanban list` (especially for "re-run my tasks" requests)
- [ ] Results deduplicated and structured
- [ ] Empty-results fallback triggered when appropriate (user notified, options offered)
