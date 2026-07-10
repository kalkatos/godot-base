# Post-Merge Wrap-Up Git Workflow

When the daily PR is already merged before /wrap-up-daily runs, use this git workflow.

## Context

- The mahou project uses git worktrees: each agent has their own checkout.
- The elk worktree is on branch `elk` (a worktree-specific branch).
- The daily PR branch (`daily/v1.2.1`) has been merged into `main` and deleted on the remote.
- The daily document and backlog updates need to reach `main`.

## Steps

### 1. Commit in the elk worktree

```bash
cd /workspace/_projects/mahou/elk
source /home/hermeswebui/.hermes/profiles/elk/.env
source /home/hermeswebui/.hermes/bin/gh_auth.sh
git config user.email "elk@kalkatos.games"
git config user.name "Elk [bot]"
git add .docs/backlog.md .docs/daily/daily_v1.2.1.md
git commit -m "daily: wrap-up v1.2.1 with senior review feedback"
```

### 2. Push the elk branch

Use token-in-URL because git's credential helper doesn't inherit GITHUB_TOKEN:

```bash
git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/kalkatos/mahou.git"
git push origin elk
git remote set-url origin "https://github.com/kalkatos/mahou.git"
```

### 3. Merge elk into main (from main worktree)

```bash
cd /workspace/_projects/mahou  # main worktree
source /home/hermeswebui/.hermes/profiles/elk/.env
source /home/hermeswebui/.hermes/bin/gh_auth.sh
git fetch origin elk
git log --oneline origin/elk ^origin/main  # verify 1 commit ahead
git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/kalkatos/mahou.git"
git merge origin/elk --no-edit
git push origin main
git remote set-url origin "https://github.com/kalkatos/mahou.git"
```

## Verification

```bash
cd /workspace/_projects/mahou
git log --oneline main -3
# Should show the wrap-up commit as latest
```

## Why This Works

- The elk worktree branch (`elk`) is independent of any PR branch — it always exists.
- The daily PR branch (`daily/v1.2.1`) is deleted after merge but the elk branch is not.
- Merging `origin/elk` into `main` is a fast-forward if no other commits landed on main between the merge and the wrap-up commit.
- The token-in-URL pattern bypasses gh credential helper issues.
