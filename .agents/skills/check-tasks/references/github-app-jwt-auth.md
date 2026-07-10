# GitHub App JWT Auth Flow

This reference explains the standard Hermes GitHub App JWT authentication flow used by agent profiles.

## Files Involved

- **`~/.hermes/profiles/<profile>/.env`** — stores `APP_ID`, `PRIVATE_KEY_PATH`, `INSTALLATION_ID`
- **`~/.hermes/bin/gh_auth.sh`** — generates a JWT from the private key, exchanges it for an installation token

## Auth Command

```bash
set -a
source ~/.hermes/profiles/<YOUR_PROFILE>/.env
set +a
source ~/.hermes/bin/gh_auth.sh
export HOME=/home/hermeswebui/.hermes/home
export PATH="$HOME/.local/bin:$PATH"
```

## Flow

1. `.env` sets `APP_ID`, `INSTALLATION_ID`, `PRIVATE_KEY_PATH`
2. `gh_auth.sh` reads the PEM private key, creates a JWT (RS256, 5-min expiry), POSTs to GitHub's API to get an installation access token
3. The token is exported as `GITHUB_TOKEN`
4. The git credential helper (`gh auth git-credential`) uses `GITHUB_TOKEN` for HTTPS git operations

## Diagnostics

```bash
# Verify auth is working
gh auth status

# Check which account is active
gh auth status 2>&1 | grep -E "Logged in|Active"

# Test repo access
gh repo view <owner>/<repo> --json name,defaultBranchRef

# Check credential helper path
git config --global --get-regexp credential
```

## Common Issues

- **Credential helper wrong path**: `git config --global --get-regexp credential` shows `/non-existent/path/to/gh`. Fix: update to actual gh location.
- **Two accounts in hosts.yml**: One valid (via GITHUB_TOKEN), one expired (via hosts.yml). The active account is the valid one — as long as it has repo access, it works.
- **PRIVATE_KEY_PATH wrong**: `gh_auth.sh` exits with "Private key file not found." Verify the path in `.env`.
- **`2>/dev/null` on auth**: Suppresses all errors including JWT signing failures. Never mask auth stderr.
