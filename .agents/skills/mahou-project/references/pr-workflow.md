# Mahou PR Workflow Reference

## Auth incantation (Angel profile)

```bash
set -a
source /home/hermeswebui/.hermes/profiles/angel/.env
set +a
export PATH="/home/hermeswebui/.local/bin:$PATH"
export PATH="/home/hermeswebui/.hermes/home/.local/bin:$PATH"
source /home/hermeswebui/.hermes/bin/gh_auth.sh
```

After first-time auth, configure git to use `gh` as its credential helper so `git fetch`/`git push` to HTTPS remotes works:

```bash
gh auth setup-git --hostname github.com
```

This is a one-time setup per environment — it persists across sessions. Without it, `gh_auth.sh` sets `GITHUB_TOKEN` for the `gh` CLI, but `git` (HTTPS) doesn't know about it and fails with `could not read Username`.

**IMPORTANT:** Some `.env` files have stale paths. If `source .env` fails with "No such file", override `PRIVATE_KEY_PATH` inline:
```bash
export PRIVATE_KEY_PATH="/home/hermeswebui/.hermes/profiles/angel/angel.private-key.pem"
source /home/hermeswebui/.hermes/bin/gh_auth.sh
```

## Push

```bash
cd /workspace/_projects/mahou/angel
git -c credential.helper='!f() { echo "username=x-access-token"; echo "password=$GITHUB_TOKEN"; }; f' push -u origin <branch>
```

## Create PR

**Preferred (gh CLI):**
```bash
export HOME=/home/hermeswebui/.hermes/home
gh pr create --base angel --head <branch> --title "..." --body '...'
```

**Fallback (curl + GitHub REST API)** — use when `gh` CLI is unavailable:
```bash
# Auth must be sourced first (see Auth incantation above)
curl -s -X POST https://api.github.com/repos/kalkatos/mahou/pulls \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  -d '{
    "title": "...",
    "head": "<branch>",
    "base": "angel",
    "body": "..."
  }'
```

The base branch for Angel's PRs is **`angel`** (not `main`). Feature branches are created from `angel`, and PRs target `angel`. The `main` branch receives merges via the `elk` worktree's daily workflow.

## Branching

Feature branches created from `angel` worktree base branch. Use `cd /workspace/_projects/mahou/angel`.

## Before commenting on a PR or kanban task

**Always verify the PR state first** — check whether it was merged, closed, or still open. Do not comment about a PR without confirming its current status via the GitHub API or `gh pr view`.
