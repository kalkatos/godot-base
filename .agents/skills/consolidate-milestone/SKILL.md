---
name: consolidate-milestone
description: "Use when @Elk needs to consolidate the milestone memo after senior reviews. Reads Griffin's and Hag's PR feedback on the milestone definition, maps observations to resolutions, produces the milestone memo consolidating all sprint definitions and senior guidance, updates decisions.md and glossary.md with any new domain terms or decisions, and posts a summary comment on the milestone PR. This is the step between 'seniors review the milestone PR' and 'the sprint loop begins' in the Dian Agentic Gamedev Process."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, production, management, milestone, consolidation]
    related_skills: [milestone, review-pr, daily, wrap-up-daily]
---

# /consolidate-milestone — Consolidate Milestone Memo After Senior Review

## Overview

This skill consolidates the milestone definition after seniors (Griffin and Hag) have reviewed the milestone PR. As **@Elk (producer)**, you read every observation from the senior reviews, map each one to a concrete resolution, produce the milestone memo, and sync any new decisions and glossary terms to the permanent project logs.

This is the step between "Seniors review the milestone PR" and "The sprint loop begins" in the Dian Agentic Gamedev Process (PROCESS.md lines 109–115).

## When to Use

- The milestone PR exists and has received reviews from **both** Griffin and Hag
- The user has added comments or indicated they are ready to proceed
- You are in the Production phase, at the start of a new milestone
- Do NOT use before both seniors have submitted their review
- Do NOT use during Pre-production
- Do NOT use during an active sprint (use `/wrap-up-daily` instead)

## Workflow

### Step 1: Verify the Milestone PR Exists and Has Reviews

Confirm the milestone PR is open and both seniors have submitted reviews:

```bash
source $HOME/.hermes/profiles/elk/.env
source $HOME/.hermes/bin/gh_auth.sh
gh pr list --head milestone/ --state OPEN --json number,title,reviews,comments
```

If no milestone PR exists, redirect to `/milestone` and exit.
If reviews are missing from either Griffin or Hag, report which senior still needs to review and exit.
If the user hasn't added comments or approved yet, ask them whether to proceed.

### Step 2: Read the Milestone Definition and All Reviews

Read all relevant context:

- **The roadmap** (`.docs/roadmap.md`) — extract the current milestone's sprint definitions, objectives, and user stories
- **All PR reviews and comments** — extract every observation from Griffin, Hag, and the user
- **The project state** (`.docs/project-state.md`) — confirm the current milestone and sprint

Pull every unique observation, note, and concern from all reviews. Pay special attention to:

- **Griffin's technical feedback** — feasibility concerns, dependency ordering, missing technical groundwork, architecture constraints
- **Hag's design feedback** — vision alignment, player experience progression, design-critical priorities
- **User comments** — scope preferences, priority shifts, explicit decisions

### Step 3: Map Each Observation to a Resolution

Create a response table mapping every unique observation to its resolution:

| Observation | Source | Resolution |
|---|---|---|
| (Quoted or paraphrased) | @Griffin / @Hag / @User | ✅ Specific change or decision made |

**Every observation must have a resolution entry.** If an observation cannot be resolved (e.g., conflicting opinions from seniors), flag it explicitly to the user before proceeding — do not silently drop it.

### Step 4: Produce the Milestone Memo

Write `.docs/milestone-memo-<milestone>-<date>.md`. The <milestone> slug is derived from the milestone name (lowercase, hyphens). The <date> is today's date in YYYY-MM-DD format.

If `.agents/docs/templates/milestone-memo-template.md` exists, use it as the structural template. Otherwise, use this structure:

```markdown
# Milestone Memo: <milestone-name>

**Date:** <YYYY-MM-DD>
**Milestone:** <name> (<number>)
**Sprints:** <count> sprints defined

## Sprint Overview

| # | Sprint Name | Description | Est. Duration |
|---|---|---|---|
| 1 | ... | ... | ... |
| 2 | ... | ... | ... |

## Technical Guidance (from @Griffin)

- Key technical constraints and feasibility notes
- Dependency ordering rationale
- Architecture decisions applicable to this milestone
- Technical risks and mitigation strategies

## Design Guidance (from @Hag)

- Vision alignment notes
- Player experience progression through sprints
- Design-critical priorities and their sprint placement
- Design risks and mitigation strategies

## User Decisions

- Scope decisions made by the user
- Priority shifts or explicit overrides
- Any deferred or cut items with rationale

## Architecture Notes

- Technical patterns to follow or establish
- System boundaries and interfaces defined for this milestone
- Config/data-driven requirements

## Deliverables Checklist

### Sprint 1: <name>
- [ ] <deliverable>
- [ ] <deliverable>

### Sprint 2: <name>
- [ ] <deliverable>

...

## Observation → Resolution Table

| Observation | Source | Resolution |
|---|---|---|
| ... | ... | ✅ ... |
```

The memo must be **self-contained and authoritative** — it is the single document a new agent should read to understand the milestone's scope, constraints, and decisions.

### Step 5: Update Glossary (glossary.md)

Read `.docs/glossary.md`. Identify any new domain terms, concepts, or naming conventions introduced in:

- The milestone sprints and their descriptions
- Griffin's technical guidance
- Hag's design guidance
- Any new systems, mechanics, or entities defined

**For each new term, add a glossary entry:**

```markdown
### <Term>
<Clear, concise definition. 1–3 sentences.>
```

Do NOT duplicate existing glossary entries. If a term already exists but needs refinement, update the existing entry instead of creating a duplicate.

If no new terms are identified, note "No new glossary terms" in the completion report.

### Step 6: Sync Decisions to decisions.md

Extract any architectural, design, or process decisions that were made during the milestone review:

- Decisions from Griffin's technical feedback (patterns to follow, constraints adopted)
- Decisions from Hag's design feedback (scope priorities, design directions locked in)
- Decisions from the user (explicit overrides, cuts, or mandates)
- Decisions implicit in the observation→resolution mappings

Read `.docs/decisions.md` and append each new decision:

```markdown
## <Date> — <decision-title>

- **What:** <clear description of the decision>
- **Why:** <rationale behind the decision>
- **When:** <date>, Milestone <name>, Sprint Start
- **Source:** <@Griffin / @Hag / @User — from milestone review PR #<number>>
- **Alternatives Considered:** <if any, briefly>
```

decisions.md is a main-branch file. Commit and push it directly to `main`:

```bash
# Edit decisions.md from the MAIN worktree
source $HOME/.hermes/profiles/elk/.env
source $HOME/.hermes/bin/gh_auth.sh
cd <project-root>  # main worktree, NOT elk/
git config user.email "elk@kalkatos.games"
git config user.name "Elk"
git add .docs/decisions.md .docs/glossary.md
git commit -m "docs: consolidate milestone <milestone-name> — decisions and glossary"
git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git"
git push origin main
git remote set-url origin "https://github.com/<owner>/<repo>.git"
```

If no new decisions are identified, note "No new decisions" in the completion report.

### Step 7: Commit and Push the Milestone Memo

Push the milestone memo to the milestone PR branch:

```bash
# All edits must happen from the elk worktree
source $HOME/.hermes/profiles/elk/.env
source $HOME/.hermes/bin/gh_auth.sh
cd <project-root>/elk
git add .docs/milestone-memo-<milestone>-<date>.md
git commit -m "docs: milestone memo for <milestone-name> — consolidated from senior reviews"
git remote set-url origin "https://x-access-token:${GITHUB_TOKEN}@github.com/<owner>/<repo>.git"
git push origin milestone/<slug>
git remote set-url origin "https://github.com/<owner>/<repo>.git"
```

### Step 8: Post a Summary Comment on the Milestone PR

Write the comment body to a temp file (to avoid shell escaping issues), then post:

```bash
cat > /tmp/milestone_consolidation_comment.md << 'COMMENT_EOF'
## Milestone Memo Consolidated

**Milestone memo:** `.docs/milestone-memo-<milestone>-<date>.md`

### @Griffin @Hag — observations addressed:

| Observation | Source | Resolution |
|---|---|---|
| ... | ... | ✅ ... |
| ... | ... | ✅ ... |

### Files updated
- `.docs/milestone-memo-<milestone>-<date>.md` — full milestone memo with sprint overview, technical/design guidance, and deliverables checklist
- `.docs/glossary.md` — (<N> new terms added / no changes)
- `.docs/decisions.md` — (<N> new decisions added / no changes)

Ready for your approval @kalkatos. After merging, @Elk will run `/daily` to begin the first sprint.
COMMENT_EOF

gh pr comment <PR_NUMBER> --body-file /tmp/milestone_consolidation_comment.md
```

If `gh pr comment` fails, fall back to the GitHub Issues API with `curl`:

```bash
source $HOME/.hermes/profiles/elk/.env
source $HOME/.hermes/bin/gh_auth.sh
curl -s -X POST \
  -H "Authorization: Bearer $GITHUB_TOKEN" \
  -H "Accept: application/vnd.github+json" \
  -d "$(python3 -c "import json; print(json.dumps({'body': open('/tmp/milestone_consolidation_comment.md').read()}))")" \
  "https://api.github.com/repos/<owner>/<repo>/issues/<PR_NUMBER>/comments"
```

### Step 9: Update PR Labels

Ensure the PR reflects its ready state:

```bash
gh pr edit <PR_NUMBER> --remove-label "needs revision" --add-label "ready for review"
```

### Step 10: Report Completion

Return a summary to the user:

```
## Milestone Consolidation Complete — <milestone-name>

**Milestone memo:** `.docs/milestone-memo-<milestone>-<date>.md`
**PR:** <link-to-pr>

### What was produced
- **Milestone memo** with <N> sprints, technical guidance from @Griffin, and design guidance from @Hag
- **Glossary:** <N> new terms added (or "no changes")
- **Decisions:** <N> new decisions logged (or "no changes")

### Observations resolved
| Observation | Source | Resolution |
|---|---|---|
| ... | ... | ✅ ... |

### Next step
After the user approves and merges this PR, @Elk runs `/daily` to begin the first sprint's daily loop.
```

## Common Pitfalls

1. **Running before both seniors have reviewed.** Verify both Griffin and Hag have submitted reviews before proceeding.
2. **Skipping observations from APPROVED reviews.** An APPROVED review with observations still requires action. Address all observations regardless of verdict.
3. **Producing the memo before reviews are done.** The memo consolidates feedback — write it AFTER both seniors have reviewed, not before.
4. **Not updating glossary with new terms.** Milestones often introduce new systems, entities, or concepts. If Griffin or Hag uses a term not yet in the glossary, add it.
5. **Not syncing decisions to decisions.md.** The milestone review often produces architectural and design decisions that must outlive the memo. Log them in the permanent decision log.
6. **Pushing decisions.md or glossary.md to the PR branch.** These are main-branch files. Commit and push them directly to `main`, not to the milestone PR branch.
7. **Skipping the observation→resolution table.** Without a table mapping each observation to its resolution, reviewers must re-read the full memo to verify their feedback was addressed.
8. **Using `--body` for PR comments with markdown.** Shell escaping breaks on asterisks, backticks, and special characters. Always use `--body-file` with a temp file.
9. **Vague milestone memo.** The memo is the authoritative document for the milestone. It must include concrete sprint objectives, specific technical constraints, and a deliverables checklist — not vague aspirations.
10. **Forgetting to commit glossary and decisions.** After editing these main-branch files, always commit and push before reporting completion.

## Verification Checklist

- [ ] Milestone PR exists and both senior reviews are present
- [ ] User has indicated readiness to proceed
- [ ] Every unique observation extracted (including from APPROVED reviews)
- [ ] Observation→Resolution table complete (no unresolved entries)
- [ ] Milestone memo written with sprint overview, technical guidance, design guidance, user decisions, architecture notes, and deliverables checklist
- [ ] Glossary scanned and updated with any new domain terms
- [ ] New decisions synced to decisions.md on main branch
- [ ] Milestone memo committed and pushed to the PR branch
- [ ] Summary comment posted on the PR with full observation→resolution table
- [ ] PR labels updated
- [ ] User clearly informed of next step: `/daily` to begin the first sprint
