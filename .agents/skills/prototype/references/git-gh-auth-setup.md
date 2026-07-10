# Git & GitHub Auth Setup — Brute Profile

## Overview

The brute profile uses a git credential helper to authenticate via `$GITHUB_TOKEN`:

```
credential.helper = !f() { echo "username=oauth2"; echo "password=$GITHUB_TOKEN"; }; f
```

`gh` v2.67.0 is at `/home/hermeswebui/.hermes/home/.local/bin/gh` and auth'd via the same `GITHUB_TOKEN`.

## Token Location

The token lives in `/home/hermeswebui/.hermes/.env` (default profile's env) and is loaded into the shell via `~/.bashrc`. Because the brute profile overrides `HOME` to `~/.hermes/profiles/brute/home`, `~` resolves differently than expected — use absolute paths when troubleshooting.

## PATH Fix for `gh`

`gh` is installed but not in PATH by default due to the HOME override. The fix:

```bash
echo 'export PATH="/home/hermeswebui/.hermes/home/.local/bin:$PATH"' >> ~/.bashrc
```

Where `~/.bashrc` here means the **actual** user bashrc at `/home/hermeswebui/.bashrc` (not the profile-overridden one).

## Common Error Sequence

1. **`git pull` fails** → check token: `echo "Token length: ${#GITHUB_TOKEN}"` (0 = not loaded)
2. **`source ~/.bashrc`** → reloads env vars
3. **`detected dubious ownership`** → `git config --global --add safe.directory /workspace/brute`
4. **`cannot open '.git/FETCH_HEAD': Permission denied`** → `.git` is root-owned, need `sudo chown`
5. **`There is no tracking information`** → `git branch --set-upstream-to=origin/main main`
