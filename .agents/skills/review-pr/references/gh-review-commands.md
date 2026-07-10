# GitHub PR Review — `gh` CLI Commands

## Posting a review

```bash
# APPROVED
gh pr review <NUMBER> --repo <OWNER/REPO> --approve --body-file /tmp/review.md

# NEEDS REVISION (request changes)
gh pr review <NUMBER> --repo <OWNER/REPO> --request-changes --body-file /tmp/review.md

# COMMENT (no verdict, just feedback)
gh pr review <NUMBER> --repo <OWNER/REPO> --comment --body-file /tmp/review.md
```

## Why `--body-file`

Always write the review to a temp file and use `--body-file` — never inline the review body with `--body "..."`. Markdown reviews contain backticks, quotes, newlines, and special characters that are a shell-escaping nightmare when passed inline. A heredoc write + `--body-file` is bulletproof.

## Auth

Per the mahou project setup, `gh` must find its config at `~/.config/gh/hosts.yml` with the correct `oauth_token`. The agent's profile `.env` + `gh_auth.sh` script provides the `GITHUB_TOKEN` environment variable.

## Viewing PR details

```bash
# Full JSON dump (title, body, author, files, stats, labels)
gh pr view <NUMBER> --repo <OWNER/REPO> --json number,title,body,author,headRefName,baseRefName,state,createdAt,labels,files,comments,additions,deletions

# Diff only
gh pr diff <NUMBER> --repo <OWNER/REPO>
```
