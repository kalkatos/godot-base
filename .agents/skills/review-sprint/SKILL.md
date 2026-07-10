---
name: review-sprint
description: "Use when all tasks for a sprint are complete and you need an end-of-sprint review. @Elk (producer): reviews everything done for the sprint, analyzes if objectives were achieved, writes a sprint-review with a verdict (APPROVED or NEEDS REVISION), and creates a PR for multi-domain senior review (Griffin, Hag, Kavu, Levi)."
version: 1.0.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, production, review, sprint-review]
    related_skills: [review-day, daily, milestone, review-pr, orchestrate]
---

# /review-sprint — End-of-Sprint Review

## Overview

This skill performs a comprehensive review of the entire sprint after all daily tasks are complete. As **@Elk (producer)**, you review everything that was accomplished across all days of the sprint, analyze whether the sprint objectives were achieved, write a sprint-review document, create a PR, and route it for multi-domain senior review.

This is part of the Dian Agentic Gamedev Process (Production phase), running after all tasks for the sprint are done. The sprint cannot advance to the next sprint or milestone until this review is APPROVED.

## When to Use

- After all daily tasks for ALL days in the sprint are complete
- After all daily review PRs are APPROVED
- When the sprint's objectives (as defined in roadmap.md) should be assessed
- Do NOT use mid-sprint while daily loops are still active
- Do NOT use for individual day reviews — use `/review-day` for those

## Agent Persona

You are **Elk**, the producer. For this review, you step back from daily coordination and assess the big picture. You care about:

- **Objective achievement** — did the sprint deliver what it promised?
- **Milestone progress** — is the project on track for the current milestone?
- **Quality** — is the output production-ready?
- **Process health** — did the daily loop work smoothly or were there recurring issues?
- **Scope management** — did the sprint stay focused or drift?

## Workflow

### 1. Load Sprint Context

**⚠️ First, pull the latest from the remote.** Daily review files are created by PR merges and may not exist on your local disk even though the PR was merged. Always run `git pull` (or `git merge origin/main` for projects with non-standard branch names) before scanning for daily review files.

Read:
- `.docs/project-state.md` — current milestone and sprint
- `.docs/roadmap.md` — the sprint's defined objectives
- All daily reports for this sprint: `.docs/daily_<sprint>.*.md` (all days)
- All daily reviews for this sprint: `.docs/daily-review-<sprint>.*.md`
- `.docs/game-concept.md` — the vision
- `.docs/milestone-memo-*.md` if one exists for this milestone
- `.docs/decisions.md` — all decisions logged during the sprint

### 2. Collect All Sprint PRs

Find all PRs from the sprint period:

```bash
gh pr list --state merged --limit 100 --json number,title,author,createdAt,mergedAt,body | \
  python3 -c "
import json, sys
data = json.load(sys.stdin)
# Filter by sprint timeframe — adjust dates based on sprint duration
for pr in data:
    print(f\"PR #{pr['number']}: [{pr['author']}] {pr['title']}\")
"
```

Group PRs by day (from the task IDs and branch names) for the sprint summary.

### 3. Assess Sprint Objectives

For each objective defined in the roadmap's sprint description, assess:

| Objective | Status | Evidence |
|---|---|---|
| <objective 1> | ✅ Achieved / ⚠️ Partial / ❌ Not met | PRs #X, #Y, daily reviews |
| <objective 2> | ... | ... |

**Achieved:** The objective is fully complete with merged PRs and passing tests.
**Partial:** Some progress but not all scope covered.
**Not met:** No work done toward this objective.

### 4. Summarize by Domain

#### Programming (@Angel)
- What was built (list key features implemented)
- Architecture changes or new patterns introduced
- Technical debt incurred (if any — flag it explicitly)
- Test coverage across the sprint

#### GUI (@Jack)
- Screens, menus, HUDs created
- Placeholder assets used and what needs replacement
- UI/UX patterns established

#### Art (@Fairy)
- Art assets identified vs. created
- Visual style consistency across assets
- Any art pipeline issues

#### Sound (@Levi)
- Sound assets identified vs. created
- Audio style consistency
- Any audio pipeline issues

#### QA (@Imp)
- Tests written vs. features implemented
- Bugs discovered and their resolution status
- Test coverage gaps identified

### 5. Process Health Check

Assess how well the daily loop functioned during this sprint:

- **PR velocity** — how many days did the sprint span? Was the pace sustainable?
- **Review turnaround** — did senior reviews happen promptly or cause delays?
- **Revision cycles** — any tasks hit the 2-round NEEDS REVISION limit?
- **Unresponsive agents** — any agents miss a full daily cycle?
- **Sprint overrun** — did the sprint take significantly longer than expected?
- **Scope creep** — did tasks expand beyond their original scope?

### 6. Decisions Audit

Review all decisions logged during the sprint in `.docs/decisions.md`:
- Are there decisions that contradict earlier ones?
- Are there decisions that should be revisited based on outcomes?
- Are there implicit decisions (made in code but not documented)?

### 7. Produce the Verdict

Based on the comprehensive assessment, give exactly one verdict:

- **APPROVED** — the sprint met its objectives. All deliverables are complete and of acceptable quality. Process health is good. Ready to advance to the next sprint or milestone.

- **NEEDS REVISION** — the sprint has gaps that must be addressed before advancing. Specify exactly what's missing or below quality and who needs to address it.

### 8. Write the Sprint Review Document

Read `.agents/docs/templates/sprint-review-template.md` if it exists. Write `.docs/sprint-review-<sprint>-<date>.md`.

The document must include:

- **Verdict:** APPROVED or NEEDS REVISION (prominently at the top)
- **Sprint summary:** One paragraph overview of what the sprint accomplished
- **Objectives assessment:** Table with status and evidence
- **Domain summaries:** Programming, GUI, Art, Sound, QA — what was delivered
- **Process health:** Velocity, review turnaround, issues
- **Decisions audit:** Key decisions and any concerns
- **Technical debt:** Items intentionally deferred
- **If NEEDS REVISION:** Specific gaps and assigned owners
- **Next sprint recommendations:** What to prioritize next

### 9. Create PR for Multi-Domain Senior Review

```bash
git checkout -b sprint-review/<sprint>
git add .docs/sprint-review-<sprint>-<date>.md
git commit -m "sprint-review: <sprint> — APPROVED"  # or NEEDS REVISION
git push origin sprint-review/<sprint>

cat > /tmp/sprint_review_body.md << 'EOF'
## Sprint Review: <sprint>

**Verdict:** APPROVED / NEEDS REVISION

### Sprint Summary
...

### Objectives
| Objective | Status |
|---|---|
| ... | ✅ / ⚠️ / ❌ |

### Senior Review Needed

**@Griffin (programming):** Review the technical output — architecture, code quality, test coverage.

**@Hag (game design):** Review the design output — does the sprint deliver the intended player experience?

**@Kavu (art direction):** Review the art output — visual cohesion, asset completeness.

**@Levi (sound design):** Review the audio output — audio style, asset completeness.
EOF

gh pr create \
  --title "Sprint Review: <sprint> — APPROVED" \
  --body-file /tmp/sprint_review_body.md
```

### 10. Dispatch Kanban Review Chain

After the sprint review PR is created, dispatch kanban tasks for each senior reviewer using the same parent-child chaining as `/orchestrate`. Each task becomes ready only after the previous reviewer completes, ensuring orderly sequential review. A final notification task alerts the user when all reviews are submitted.

**Delegation order:**

| Step | Reviewer | Domain | Parent |
|------|----------|--------|--------|
| 1 | griffin | Programming | — (no parent) |
| 2 | hag | Game Design | griffin's task |
| 3 | kavu | Art Direction | hag's task |
| 4 | levi | Sound Design | kavu's task |
| 5 | elk | Notification | levi's task |

**Task creation (use hermes CLI, not delegate_task):**

For each reviewer, create a kanban task with `--skill review-pr`. Use `--parent` for steps 2–5 to chain them. Capture each returned task ID for the next step's `--parent`.

The body for each reviewer task must include:
- The sprint PR number and URL
- The domain-specific review criteria (from the sprint review PR body)
- Instruction to post the review comment on the PR with `APPROVED` or `NEEDS REVISION` for their domain
- Instruction to mark the kanban task DONE after posting

**Elk's notification task (step 5):**
The body instructs Elk to read all four parent review task completions, extract each verdict, and send a single Telegram message summarizing all four verdicts. If all APPROVED, signal readiness for user merge. If any NEEDS REVISION, list the domain(s) and the specific issues.

```bash
# Example: Step 1 — Griffin (programming)
/app/venv/bin/hermes -p elk kanban create "Review Sprint <sprint>: Programming" \
  --assignee griffin \
  --skill review-pr \
  --tenant <project> \
  --json \
  --body '## Sprint Review: <sprint> — Programming Review

**PR:** #<pr_number> — https://github.com/<owner>/<repo>/pull/<pr_number>
**Domain:** Programming

### Review Criteria
- Architecture quality and consistency
- Code completeness relative to sprint objectives
- Test coverage adequacy
- Technical debt assessment

### What to do
1. Read the full sprint review at `.docs/sprint-review-<sprint>-<date>.md`
2. Review the code output through your programming lens
3. Post a review comment on PR #<pr_number> with APPROVED or NEEDS REVISION for your domain
4. Mark this kanban task DONE after posting'

# Example: Step 5 — Elk notification
/app/venv/bin/hermes -p elk kanban create "Sprint <sprint> Review: Notify User" \
  --assignee elk \
  --tenant <project> \
  --parent <levi_task_id> \
  --json \
  --body '## Sprint <sprint> — All Reviews Complete

### Instructions
1. Read all four parent review tasks (griffin, hag, kavu, levi) via kanban_show
2. Extract each verdict (APPROVED or NEEDS REVISION)
3. Send a single Telegram message summarizing all four verdicts
4. If all APPROVED: signal that the sprint is ready for user merge
5. If any NEEDS REVISION: list the domain(s) and specific issues
6. Mark this kanban task DONE'
```

### 11. Senior Review Criteria

Per PROCESS.md, each senior reviews the sprint through their domain lens:

**@Griffin (senior programmer):**
- Architecture quality and consistency
- Code completeness relative to sprint objectives
- Test coverage adequacy
- Technical debt assessment

**@Hag (senior game designer):**
- Does the sprint output align with the game concept?
- Does the player experience advance as expected?
- Are design decisions consistent and well-documented?

**@Kavu (senior art director):**
- Visual cohesion across all art assets
- Asset quality and completeness
- Does art match the intended visual style?

**@Levi (sound designer):**
- Audio cohesion and quality
- Asset completeness for the sprint's audio needs
- Does audio match the intended style?

Each posts their review on the PR with APPROVED or NEEDS REVISION for their domain.

### 13. After All Reviews APPROVED

When all four seniors have approved (per the kanban review chain or direct PR comments), signal to the user:

> "**Sprint `<sprint>` review complete — all domains APPROVED.** Ready for user approval and merge. After merge, @Elk runs `/milestone` to advance to the next sprint or define the next milestone."

If any domain is NEEDS REVISION, route the specific issues back to the responsible agent (Angel, Jack, Fairy, or Levi) via @Elk `/orchestrate`.

### 14. After User Approves and Merges

The sprint is formally closed. When `/milestone` advances to the next sprint, it will archive the current sprint's backlog to `.docs/backlog-<sprint>.md` and reset `.docs/backlog.md` for the new sprint.

The next step depends on position in the roadmap:
- If more sprints remain in the current milestone → `/milestone` to advance to the next sprint
- If this was the last sprint of the milestone → `/milestone` to define the next milestone
- If this was the Launch milestone → the game is done! 🎉

## Output

- `.docs/sprint-review-<sprint>-<date>.md` — the comprehensive sprint review
- A GitHub PR with the review, routed to Griffin, Hag, Kavu, and Levi
- A clear verdict (APPROVED or NEEDS REVISION)

## Common Pitfalls

1. **Reviewing before all daily reviews are APPROVED.** If any day still has a NEEDS REVISION daily review, the sprint review is premature. Fix the days first.
2. **Assessing objectives against the wrong baseline.** Always check against the sprint description in roadmap.md, not what you remember it being.
3. **Ignoring process health in favor of output.** A sprint that delivered everything but burned out the team in 3 consecutive crunch days is a NEEDS REVISION on process, not APPROVED.
4. **Not routing to all four senior domains.** Even if a domain had no deliverables this sprint, the senior should confirm that — don't skip a reviewer.
5. **Treating the sprint review as a rubber stamp.** This is the quality gate between sprints. Be honest about gaps.
6. **Vague NEEDS REVISION items.** "Art needs work" is useless. "The forest tileset is missing the autumn variant described in art-assets v1.1.2 line 15."
7. **Daily review files missing from disk after PR merge.** Daily review PRs create files (e.g., `.docs/daily-review-v1.1.4.md`) that land on the remote's default branch. If the local worktree is behind, `search_files` won't find them and you'll think the review is missing. Always `git pull` before scanning.
8. **PR creation blocked by user consent.** The `gh pr create` command requires user approval and may be denied. If blocked, present the sprint review summary to the user with the branch name and ask them to create the PR manually or approve the command. Do NOT retry the blocked command or attempt the same outcome via a different tool.

## Verification Checklist

- [ ] All sprint daily reports and daily reviews loaded
- [ ] All sprint PRs collected and organized by day
- [ ] Sprint objectives assessed against roadmap.md definitions
- [ ] Domain summaries written for programming, GUI, art, sound, QA
- [ ] Process health assessed (velocity, reviews, overruns)
- [ ] Decisions audited for consistency
- [ ] Technical debt explicitly documented
- [ ] Sprint review document written with all sections
- [ ] PR created and routed to all four senior reviewers (Griffin, Hag, Kavu, Levi)
- [ ] All domain reviews received and addressed
- [ ] User informed of next step after approval
