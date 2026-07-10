# Staggered Status-Gated Dispatch Recipe

Full implementation pattern for dispatching kanban tasks one-at-a-time, gated on the previous task being marked `done`. Zero agent cost via `no_agent=true` cron.

## When to Use

- User explicitly requests staggered/gated dispatch (vs. batch dump)
- Tasks have sequential dependencies within a daily
- One agent carries the bulk of implementation load
- User wants to intervene if a task gets blocked

## Files Created

### 1. Dispatch Queue: `.docs/.dispatch-queue.json`

```json
{
  "sprint": "v1.1",
  "day": "v1.1.2",
  "project": "Mahou",
  "tasks": [
    {
      "id": "v1.1.2.1",
      "assignee": "angel",
      "title": "[Project] v1.1.2.1 Task Name Here",
      "body": "## Task: v1.1.2.1 — ...\n\n**Project:** ...\n...",
      "depends_on": [],
      "status": "pending"
    },
    {
      "id": "v1.1.2.2",
      "assignee": "angel",
      "title": "[Project] v1.1.2.2 Next Task",
      "body": "...",
      "depends_on": ["v1.1.2.1"],
      "status": "pending"
    },
    {
      "id": "v1.1.2.6",
      "assignee": "imp",
      "title": "[Project] v1.1.2.6 Final Task (dependent agent)",
      "body": "...",
      "depends_on": ["v1.1.2.1", "v1.1.2.2", "v1.1.2.3", "v1.1.2.4", "v1.1.2.5"],
      "status": "pending"
    }
  ]
}
```

**Rules:**
- `id` matches the daily backlog task ID (e.g., `v1.1.2.1`)
- `title` MUST contain the `id` as a substring for dependency matching (e.g., `"[Mahou] v1.1.2.1 CombatController..."`)
- `body` is the full kanban task body — self-contained, no memory expected
- `depends_on` lists task IDs that must be `done` before this one drops
- `status` starts as `"pending"`, script sets to `"dispatched"` after creating

### 2. Dispatch Script: `~/.hermes/scripts/<project>-dispatch.py`

```python
#!/usr/bin/env python3
"""
Status-gated kanban task dispenser. Runs as no-agent cron.
Polls kanban, drops next task when dependencies are met.
Silent when nothing to do.
"""

import json
import subprocess
import sys
import os
from datetime import datetime

HERMES_BIN = "/app/venv/bin/hermes"
PROFILE = "elk"
QUEUE_PATH = "/workspace/_projects/<project>/.docs/.dispatch-queue.json"


def run_kanban_list(assignee, status):
    cmd = [HERMES_BIN, "-p", PROFILE, "kanban", "list",
           "--assignee", assignee, "--status", status, "--json"]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            return []
        raw = result.stdout.strip()
        return json.loads(raw) if raw and raw != "null" else []
    except (subprocess.TimeoutExpired, json.JSONDecodeError):
        return []


def run_kanban_create(title, assignee, body):
    cmd = [HERMES_BIN, "-p", PROFILE, "kanban", "create", title,
           "--assignee", assignee, "--body", body]
    result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
    return result.returncode == 0


def is_dependency_satisfied(dep_id, done_titles):
    for done_title in done_titles:
        if dep_id in done_title:
            return True
    return False


def main():
    queue_path = QUEUE_PATH
    if not os.path.exists(queue_path):
        sys.exit(0)

    with open(queue_path, "r") as f:
        queue = json.load(f)

    tasks = queue.get("tasks", [])
    if not tasks:
        sys.exit(0)

    assignees = list(set(t["assignee"] for t in tasks))

    # Collect done kanban task titles
    done_titles = set()
    for a in assignees:
        for t in run_kanban_list(a, "done"):
            done_titles.add(t.get("title", ""))

    # Collect in-progress assignees
    in_progress = set()
    for a in assignees:
        if run_kanban_list(a, "in_progress"):
            in_progress.add(a)

    messages = []
    for task in tasks:
        if task.get("status") != "pending":
            continue

        # Check deps
        unmet = [d for d in task.get("depends_on", [])
                 if not is_dependency_satisfied(d, done_titles)]
        if unmet:
            continue

        # Check assignee idle
        if task["assignee"] in in_progress:
            continue

        success = run_kanban_create(task["title"], task["assignee"], task["body"])
        if success:
            task["status"] = "dispatched"
            task["dispatched_at"] = datetime.utcnow().isoformat() + "Z"
            messages.append(f"✅ Dispatched {task['id']} → @{task['assignee']}")
            in_progress.add(task["assignee"])

    # Save updated queue
    with open(queue_path, "w") as f:
        json.dump(queue, f, indent=2)

    all_dispatched = all(t.get("status") in ("dispatched", "done") for t in tasks)
    if all_dispatched:
        messages.append("🏁 All tasks dispatched. Queue complete.")

    if messages:
        print("\n".join(messages))


if __name__ == "__main__":
    main()
```

### 3. Cron Job

```python
cronjob(
    action="create",
    name="<project>-<day>-dispatch",
    schedule="every 5m",       # NOTE: "5m" = ONE-SHOT, "every 5m" = RECURRING
    script="<project>-dispatch.py",
    no_agent=True,              # Zero token cost
    profile="elk",
    deliver="origin"            # Back to current session
)
```

### 4. Manual First Dispatch

The first task (no dependencies) should be dispatched immediately — don't make the user wait 5 minutes:

```bash
/app/venv/bin/hermes -p elk kanban create "<title>" --assignee <profile> --body "<body>"
```

Then mark it `"dispatched"` in the queue file.

## Dependency Matching

The script matches dependencies by substring search on kanban task **titles**. The task ID (e.g., `"v1.1.2.1"`) must appear in the kanban title. Always include the ID prefix in titles:

- ✅ `"[Mahou] v1.1.2.1 CombatController: Turn-based combat loop"`
- ❌ `"[Mahou] CombatController: Turn-based combat loop"` — won't match

IDs like `v1.1.2.3A` and `v1.1.2.3B` are distinct enough for substring matching. No false matches with sequential numbering (< 10 tasks per day).

## Cron Pitfalls

| Mistake | Result | Fix |
|---------|--------|-----|
| `schedule: "5m"` | One-shot, fires once then stops | Use `"every 5m"` |
| Script path with args | Cron rejects (`must be relative to ~/.hermes/scripts/`) | Hardcode paths in script, use bare filename |
| Script not executable | Silent failure | `chmod +x` after writing |
| `no_agent=false` (default) | Burns tokens per tick | Set `no_agent=true` |
| Missing `profile` | Script can't auth for kanban | Set `profile="elk"` |

## Cleanup

When all tasks are dispatched, the cron continues running harmlessly (producing no output). Stop it:

```python
cronjob(action="remove", job_id="<job_id>")
```

Find the job ID with `cronjob(action="list")`.
