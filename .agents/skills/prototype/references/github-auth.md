# GitHub Auth Setup for Prototyping Workspace

## Credential Helper Pattern

The brute profile uses a custom git credential helper that reads `$GITHUB_TOKEN`:

```
credential.helper = !f() { echo "username=oauth2"; echo "password=$GITHUB_TOKEN"; }; f
```

This sends the token as an oauth2 password on HTTPS git operations (pull, push, fetch).

## Setting the Token

The token must be exported as an environment variable in a shell profile that gets sourced:

```bash
# ~/.bashrc
export GITHUB_TOKEN="ghp_yourtokenhere"
```

After adding, source it or start a new session: `source ~/.bashrc`

## Common Problems & Fixes

### "Authentication failed" / "Invalid username or token"
→ The `$GITHUB_TOKEN` variable is empty or invalid.
Check: `echo ${#GITHUB_TOKEN}` — a length > 0 means it's set.

### "detected dubious ownership in repository"
→ `.git` directory owned by a different user.
Fix: `git config --global --add safe.directory /workspace/brute`

### "cannot open '.git/FETCH_HEAD': Permission denied"
→ `.git` directory owned by root, agent runs as hermeswebui.
Fix: `sudo chown -R hermeswebui:hermeswebui /workspace/brute/.git`

### "There is no tracking information for the current branch"
→ Local branch has no upstream set.
Fix: `git branch --set-upstream-to=origin/<branch> <branch>`

## Checking Readiness

```bash
# Verify token is set
echo "Token length: ${#GITHUB_TOKEN}"

# Test auth works (read-only)
git ls-remote

# Full test
git pull
```
