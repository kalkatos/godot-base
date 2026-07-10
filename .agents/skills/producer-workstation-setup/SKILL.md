---
name: producer-workstation-setup
description: "Configure workstation environment for the Producer project — git auth, repo management, and tooling setup for the game development pipeline."
version: 1.0.0
author: Elk
license: MIT
platforms: [linux]
metadata:
  hermes:
    tags: [Producer, Git, GitHub, Setup, Authentication]
    related_skills: [github-auth, github-repo-management]
---

# Producer Workstation Setup

Configures the development environment for managing the Producer repo (which in turn manages game projects via git submodules).

## Initial Environment Check

When entering a fresh workspace, verify:

```bash
# In the producer repo
cd /workspace/elk
git status --short
git log --oneline -3
```

### Common Issues

**Git can't pull/fetch via HTTPS (no TTY / no credential helper):**

If the repo is cloned with an HTTPS remote but there's no credential helper configured:

1. Check if `GITHUB_TOKEN` exists in the environment or `.env` file:
   
   ```bash
   grep "^GITHUB_TOKEN=" /home/hermes/.hermes/.env 2>/dev/null || echo "No token found"
   ```

2. Source it directly when needed for git operations:
   
   ```bash
   source /home/hermes/.hermes/.env 2>/dev/null
   ```

3. For git push with the personal token:
   
   ```bash
   git -c "credential.https://github.com.helper=!f() { echo username=kalkatos; echo password=$GITHUB_TOKEN; }; f" push -u origin <branch>
   ```

4. For profile-specific GitHub App auth (gh commands):
   
   ```bash
   source /home/hermes/.hermes/profiles/<profile>/.env 2>/dev/null
   source /home/hermes/.hermes/bin/gh_auth.sh
   ```

**Important:** The `.env` file at `/home/hermes/.hermes/.env` may contain non-environment-variable content (stray shell commands, `AGENTS.md` references). Always source it with `2>/dev/null` to suppress errors.

## Submodule Management

The Producer repo manages game projects as git submodules. After pulling, sync submodules:

```bash
cd /workspace/elk
git submodule update --init --recursive
```

## Pitfalls

- `.env` files are not pure `KEY=VALUE` — they may contain shell syntax. Use `source ... 2>/dev/null` to safely extract values.
- `execute_code` (Python subprocess) and `terminal` (direct shell) may have different `HOME` and `PATH` environments. Always verify context with `echo $HOME` when troubleshooting.
- Git credential helper `store` doesn't work without a TTY to prompt for the initial password entry in headless environments. Use the custom credential helper script instead.
