# Per-Profile GitHub App Authentication

Each Hermes profile uses its own GitHub App (bot account) for `gh` CLI and `git` operations, replacing shared PAT tokens.

## Auth Flow

```bash
# 1. Load profile environment (contains GH_APP_ID, GH_APP_INSTALLATION_ID, GH_APP_PRIVATE_KEY)
source ~/.hermes/profiles/<profile>/.env

# 2. Generate and export GITHUB_TOKEN via the GitHub App auth script
source ~/.hermes/bin/gh_auth.sh

# 3. Verify
gh auth status
# ✓ Logged in to github.com account <profile-bot> (GITHUB_TOKEN)

# 4. git operations now work with the bot token
git pull
# Already up to date.
```

## How It Works

- `~/.hermes/bin/gh_auth.sh` uses the GitHub App credentials from `.env` to generate a short-lived installation access token
- The token is exported as `GITHUB_TOKEN`, which both `gh` and `git` (via Git Credential Manager / `gh auth setup-git`) respect
- No global PAT exists — each profile authenticates independently

## When This Matters

- **Any skill using `gh CLI`** must source both files before issuing `gh` commands
- **`git` operations on repos cloned via HTTPS** rely on the same `GITHUB_TOKEN` — if it's missing, pulls/pushes fail with auth errors
- **Cron jobs** (via `cronjob` tool) run in a separate session and need the profile set explicitly or the auth steps in their prompt
- **If `gh auth status` fails**, the profile's `.env` may be missing (not yet set up for this profile) or the bot app may be misconfigured

## Verification Checklist

- [ ] `.env` exists at `~/.hermes/profiles/<profile>/.env`
- [ ] `gh_auth.sh` exists at `~/.hermes/bin/gh_auth.sh`
- [ ] After sourcing both: `gh auth status` shows bot account with `(GITHUB_TOKEN)` suffix
- [ ] Git pull/push operations succeed on a known repo
