# gh PR Review Patterns

Commands and gotchas for submitting reviews as a non-human reviewer.

## Auth

```bash
# Two approaches (set ONE, not both):

# A — HOME pointing to where gh config lives
HOME=/home/hermeswebui/.hermes/home gh auth status

# B — PAT in env var (per-profile .env approach)
# Add to ~/.hermes/profiles/<profile>/.env:
GITHUB_TOKEN=*** Then gh picks it up automatically from GITHUB_TOKEN or GITHUB_TOKEN
```

## Submit a Review

**Always use `--body-file`.** Inline `--body` breaks on pipes, backticks, and markdown tables.

```bash
# Write body first
cat > /tmp/review-body.md << 'EOF'
## Review title

Body content...
EOF

# Submit as comment (use when gh auth = PR author)
HOME=/home/hermeswebui/.hermes/home gh pr review <NUMBER> \
  --comment --body-file /tmp/review-body.md

# Submit as approval (only when gh auth != PR author)
HOME=/home/hermeswebui/.hermes/home gh pr review <NUMBER> \
  --approve --body-file /tmp/review-body.md

# Clean up
rm /tmp/review-body.md
```

## Self-Review Guard

If `gh` is authenticated as the **same account** that created the PR:
- `--approve` fails with "cannot approve your own pull request"
- `--comment` works, so put the verdict in the body text

## Get PR Context

```bash
# Full diff
HOME=/home/hermeswebui/.hermes/home gh pr diff <NUMBER>

# PR metadata + body
HOME=/home/hermeswebui/.hermes/home gh pr view <NUMBER> \
  --json number,title,body,author,reviews

# Open PRs mentioning the agent
HOME=/home/hermeswebui/.hermes/home gh pr list \
  --search "mentions:AgentName state:open"
```
