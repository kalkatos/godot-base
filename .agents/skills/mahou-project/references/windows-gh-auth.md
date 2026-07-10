# Windows GitHub App Auth Fix

**Problem:** On Windows hosts using Git Bash/MSYS2, the `gh_auth.sh` script fails because `openssl` (mingw64 build) cannot read MSYS-style paths.

## Symptom

```
source "$HOME/AppData/Local/hermes/bin/gh_auth.sh"
# Could not open file or uri for loading private key from
# /c/users/alexc/appdata/local/hermes/profiles/elk/elk.private-key.pem:
# No such file or directory
```

The file exists, but `openssl` (mingw64) only understands Windows-style paths (`C:\users\...`), not MSYS paths (`/c/users/...`).

## Root Cause

- `gh_auth.sh` sets `PRIVATE_KEY_PATH` from `.env`, which uses MSYS paths
- `openssl -sign "$PRIVATE_KEY_PATH"` passes the MSYS path to mingw64 openssl
- mingw64 openssl calls Windows file APIs which don't recognize `/c/...` paths

## Fix 1: Patch the path before sourcing

```bash
source "$HOME/AppData/Local/hermes/profiles/elk/.env"
export PRIVATE_KEY_PATH="$(cygpath -w "$PRIVATE_KEY_PATH")"
source "$HOME/AppData/Local/hermes/bin/gh_auth.sh"
```

This converts the MSYS path to a Windows path (`C:\Users\alexc\...`) before openssl reads it.

## Fix 2: Inline JWT + token fetch (when Fix 1 still fails)

If the full `gh_auth.sh` still fails after the path fix (e.g., `/dev/null` doesn't exist), build the JWT and fetch the installation token manually:

```bash
source "$HOME/AppData/Local/hermes/profiles/elk/.env"
export PRIVATE_KEY_PATH="$(cygpath -w "$PRIVATE_KEY_PATH")"

# Build JWT
JWT_HEADER=$(echo -n '{"alg":"RS256","typ":"JWT"}' | openssl base64 -e -A | tr -d '=' | tr '/+' '_-')
NOW=$(date +%s)
IAT=$((NOW - 60))
EXP=$((NOW + 300))
JWT_PAYLOAD=$(echo -n "{\"iat\":$IAT,\"exp\":$EXP,\"iss\":\"$APP_ID\"}" | openssl base64 -e -A | tr -d '=' | tr '/+' '_-')
SIGNING_INPUT="${JWT_HEADER}.${JWT_PAYLOAD}"
JWT_SIGNATURE=$(echo -n "$SIGNING_INPUT" | openssl dgst -sha256 -sign "$PRIVATE_KEY_PATH" | openssl base64 -e -A | tr -d '=' | tr '/+' '_-')
JWT="${SIGNING_INPUT}.${JWT_SIGNATURE}"

# Fetch installation token
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Authorization: Bearer $JWT" \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/app/installations/$INSTALLATION_ID/access_tokens")
HTTP_STATUS=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')
INSTALLATION_TOKEN=$(echo "$BODY" | jq -r '.token')
export GITHUB_TOKEN="$INSTALLATION_TOKEN"

# Verify
gh auth status
```

## HTTPS Push

After auth, push via token-in-URL:

```bash
git push https://x-access-token:${GITHUB_TOKEN}@github.com/kalkatos/mahou.git <branch>
```

## Verification

- Confirm `gh auth status` shows logged in as `elk8186[bot]`
- The token is a GitHub App installation token (expires after 1 hour)
- Re-source auth before every new PR or push session
