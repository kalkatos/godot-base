#!/usr/bin/env python3
"""
Status-gated kanban task dispenser — reference implementation (Mahou project).

Runs as a no-agent cron job every 5 minutes. Reads a .dispatch-queue.json,
checks kanban status, and creates the next task when dependencies are met.
Produces no output when there's nothing to do (silent cron).

Copy and adapt for other projects — change QUEUE_PATH and the title prefix
in get_done_task_ids() to match your project's task ID format.
"""

import json
import subprocess
import sys
import os
from datetime import datetime, timezone

HERMES_BIN = "/app/venv/bin/hermes"
PROFILE = "elk"
QUEUE_PATH = "/workspace/_projects/mahou/.docs/.dispatch-queue.json"


def run_kanban_list(assignee, status):
    """Query kanban tasks for an assignee with given status."""
    cmd = [
        HERMES_BIN, "-p", PROFILE, "kanban", "list",
        "--assignee", assignee,
        "--status", status,
        "--json"
    ]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        if result.returncode != 0:
            print(f"[WARN] kanban list failed for {assignee}/{status}: {result.stderr.strip()}", file=sys.stderr)
            return []
        raw = result.stdout.strip()
        if not raw or raw == "null":
            return []
        return json.loads(raw)
    except (subprocess.TimeoutExpired, json.JSONDecodeError) as e:
        print(f"[WARN] kanban list error for {assignee}/{status}: {e}", file=sys.stderr)
        return []


def run_kanban_create(title, assignee, body):
    """Create a kanban task. Returns True on success."""
    cmd = [
        HERMES_BIN, "-p", PROFILE, "kanban", "create", title,
        "--assignee", assignee,
        "--body", body
    ]
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, timeout=30)
        if result.returncode == 0:
            return True
        print(f"[ERROR] kanban create failed: {result.stderr.strip()}", file=sys.stderr)
        return False
    except subprocess.TimeoutExpired as e:
        print(f"[ERROR] kanban create timeout: {e}", file=sys.stderr)
        return False


def get_done_task_ids(assignees):
    """Get all done task IDs by querying kanban for completed tasks."""
    done_titles = set()
    for assignee in assignees:
        done_tasks = run_kanban_list(assignee, "done")
        for task in done_tasks:
            title = task.get("title", "")
            # Extract task ID from title pattern "[Project] v1.1.2.X ..."
            # ADAPT THIS for your project's task ID format
            for prefix in ["v1.1.", "v1.1.2"]:
                if prefix in title:
                    done_titles.add(title)
    return done_titles


def get_running_assignees(assignees):
    """Check which assignees have running tasks (prevents double-assign)."""
    running = set()
    for assignee in assignees:
        tasks = run_kanban_list(assignee, "running")  # NOT "in_progress"!
        if tasks:
            running.add(assignee)
    return running


def is_dependency_satisfied(dep_id, done_kanban_tasks):
    """Check if a dependency (task ID like 'v1.1.2.1') is done."""
    for done_title in done_kanban_tasks:
        if dep_id in done_title:
            return True
    return False


def main():
    queue_path = QUEUE_PATH

    if not os.path.exists(queue_path):
        print(f"[WARN] Queue file not found: {queue_path}", file=sys.stderr)
        sys.exit(0)

    with open(queue_path, "r") as f:
        queue = json.load(f)

    tasks = queue.get("tasks", [])
    if not tasks:
        sys.exit(0)

    assignees = list(set(t["assignee"] for t in tasks))
    done_titles = get_done_task_ids(assignees)
    running_set = get_running_assignees(assignees)

    messages = []
    dispatched_any = False

    for task in tasks:
        if task.get("status") != "pending":
            continue

        task_id = task["id"]
        assignee = task["assignee"]
        deps = task.get("depends_on", [])

        # Check dependencies
        all_deps_met = True
        for dep_id in deps:
            if not is_dependency_satisfied(dep_id, done_titles):
                all_deps_met = False
                break

        if not all_deps_met:
            continue

        # Don't double-assign an agent with a running task
        if assignee in running_set:
            continue

        # All conditions met — dispatch
        success = run_kanban_create(task["title"], assignee, task["body"])
        if success:
            task["status"] = "dispatched"
            task["dispatched_at"] = datetime.now(timezone.utc).isoformat()
            messages.append(f"✅ Dispatched {task_id} → @{assignee}: {task['title']}")
            dispatched_any = True
            running_set.add(assignee)

    # Save if we dispatched anything (simple boolean, NOT a _saved flag on all tasks)
    if dispatched_any:
        with open(queue_path, "w") as f:
            json.dump(queue, f, indent=2)

    all_dispatched = all(t.get("status") in ("dispatched", "done") for t in tasks)
    if all_dispatched:
        messages.append("🏁 All tasks dispatched. Queue complete.")

    if messages:
        print("\n".join(messages))


if __name__ == "__main__":
    main()
