# Parent-Child Paired Review Pattern

Replaces the cron-based staggered dispatch + review pipeline (removed as of the v2 workflow update). No cron jobs, no queue files, no dispatch scripts. Everything flows through kanban parent-child relationships.

## How It Works

```
Elk creates worker task (t_A) + review task (t_B, parent = t_A)
    │
Worker picks up t_A → does work → marks t_A DONE
    │
Kanban unblocks t_B (parent done → child becomes ready)
    │
Senior picks up t_B → reviews PR on GitHub
    ├─ APPROVED → posts review comment, marks t_B DONE
    └─ NEEDS REVISION → posts review comment, marks t_B DONE
        └─ Worker sees PR comment → creates follow-up fix PR
```

## Key Rules

1. **Always create the review task immediately after the worker task** — with `--parent <worker-task-id>`. Without the parent, the review task is immediately ready and the senior may review before the worker has even started.

2. **Worker marks DONE, never blocks.** Per the task-execution skill, after pushing the PR the worker uses `kanban_complete` — not `kanban_block`. The parent-child relationship handles the sequencing.

3. **Review task always goes to DONE after the senior posts their review.** Whether APPROVED or NEEDS REVISION, the deliverable is the PR comment. No blocking, no unblocking.

4. **User merges PRs.** UR-05: only the user merges. Neither worker nor senior merges.

## Worker → Reviewer Mapping

| Worker | Primary Reviewer | Dispatch Mode |
|---|---|---|
| Angel (code) | Griffin | Auto (parent-child chain) |
| Jack (GUI) | Griffin | Auto (parent-child chain) |
| Imp (tests) | Griffin | **Manual** (user dispatches after code PRs merge) |
| Fairy (art) | Kavu | Auto (parent-child chain) |
| Levi (sound) | User (manual review) | Auto (parent-child chain for identification) |

⚠️ **Imp (test tasks) are NEVER auto-dispatched.** See the Manual Dispatch Policy in the orchestrate skill. Test tasks depend on merged code PRs, not just kanban completion. The user dispatches them manually after merging the preceding code.

## Merge Gate — Every Task Stops at APPROVED

When the orchestrator receives an **APPROVED** verdict, it **stops and notifies the user**. It does NOT dispatch the next task. The user must merge the PR, then run `/orchestrate` to advance the chain.

```
Worker → Reviewer → Orchestrator
                         │
                    APPROVED?
                         │
                    ┌─────┴─────┐
                    │           │
                   YES          NO → needs revision loop
                    │
          Notify user + STOP
                    │
          User merges PR
                    │
          User runs /orchestrate
                    │
          Next task dispatched
```

This rule applies to ALL auto-dispatchable tasks (Angel, Jack, Fairy, Levi). Test tasks (Imp) never auto-dispatch.

## Kanban Create Examples

### Worker task
```bash
hermes kanban create \
  --assignee angel \
  --skills task-execution \
  --tenant mahou \
  --title "[Mahou] v1.2.1.1 Implement damage formula" \
  --body "## Task: v1.2.1.1 — Damage Formula..."
```

### Paired review task (immediately after)
```bash
hermes kanban create \
  --assignee griffin \
  --skills review-pr \
  --parent <worker-task-id> \
  --tenant mahou \
  --title "review-pr: [Mahou] v1.2.1.1 — Implement damage formula" \
  --body "## Task: Review PR for v1.2.1.1 ..."
```

## Why This Replaces Cron-Based Dispatch

The old workflow used:
- A staggered dispatch cron (every 5m, script-only) to release tasks one at a time
- A review dispatch cron (every 2m, script-only) to detect blocked tasks and create review cards
- A dispatch-queue.json file tracking task state

Problems with the old approach:
- Two crons running forever, silently ticking when idle
- Queue files needing manual cleanup between sprints
- Complex dependency tracking via substring matching on kanban titles
- Review pipeline was reactive (detect blocked → create review) rather than proactive

The parent-child pattern is simpler, proactive, and requires zero infrastructure beyond kanban itself.
