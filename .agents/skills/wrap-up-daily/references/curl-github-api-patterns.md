# curl GitHub API Patterns

Use these patterns when `gh` CLI auth is broken (stale GH_TOKEN) but the GITHUB_TOKEN from the GitHub App installation flow is valid.

## Token Acquisition

```bash
source /home/hermeswebui/.hermes/profiles/elk/.env
source /home/hermeswebui/.hermes/bin/gh_auth.sh
# GITHUB_TOKEN is now set to a fresh installation token
```

## Read PR Details

```bash
curl -s -H "Authorization: Bearer *** \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/kalkatos/mahou/pulls/39"
```

Check `state` and `merged` fields:
- `"state": "open"` → PR is open, normal workflow
- `"state": "closed"` and `"merged": true` → PR was merged, use post-merge path
- `"state": "closed"` and `"merged": false` → PR was closed without merging

## Read PR Reviews

```bash
curl -s -H "Authorization: Bearer *** \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/kalkatos/mahou/pulls/39/reviews"
```

Each review has: `user.login`, `state` (APPROVED/CHANGES_REQUESTED/COMMENTED), `body`.

## Read PR Comments (review-line-level)

```bash
curl -s -H "Authorization: Bearer *** \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/kalkatos/mahou/pulls/39/comments"
```

## Read PR Conversation Comments (issue-level)

Use the Issues endpoint — this works for both open and merged PRs:

```bash
curl -s -H "Authorization: Bearer *** \
  -H "Accept: application/vnd.github+json" \
  "https://api.github.com/repos/kalkatos/mahou/issues/39/comments"
```

## Post a Comment on a Merged PR

`gh pr comment` fails on merged PRs. Use the Issues API instead:

```bash
# Write comment to file
cat > /tmp/comment.md << 'EOF'
Your markdown here
EOF

# Post via API
source /home/hermeswebui/.hermes/profiles/elk/.env
source /home/hermeswebui/.hermes/bin/gh_auth.sh
curl -s -X POST \
  -H "Authorization: Bearer *** \
  -H "Accept: application/vnd.github+json" \
  -H "Content-Type: application/json" \
  -d "$(python3 -c "import json; print(json.dumps({'body': open('/tmp/comment.md').read()}))")" \
  "https://api.github.com/repos/kalkatos/mahou/issues/39/comments"
```

## Python Pattern (for complex markdown bodies)

```python
import json, subprocess, urllib.request

# Get token
result = subprocess.run(
    "source /home/hermeswebui/.hermes/profiles/elk/.env && "
    "source /home/hermeswebui/.hermes/bin/gh_auth.sh && echo $GITHUB_TOKEN",
    shell=True, capture_output=True, text=True)
token = result.stdout.strip()

# Post comment
with open("/tmp/comment.md") as f:
    body = f.read()

data = json.dumps({"body": body}).encode("utf-8")
req = urllib.request.Request(
    "https://api.github.com/repos/kalkatos/mahou/issues/39/comments",
    data=data,
    headers={
        "Authorization": f"Bearer {token}",
        "Accept": "application/vnd.github+json",
        "Content-Type": "application/json",
        "User-Agent": "hermes-bot"
    }
)
resp = json.loads(urllib.request.urlopen(req).read())
print(f"Posted: {resp.get('html_url')}")
```
