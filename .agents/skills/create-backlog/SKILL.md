---
name: create-backlog
description: "DEPRECATED — absorbed into /daily. The daily document now includes the backlog with task assignments. No separate backlog step exists in the process. This skill is retained for reference only."
version: 2.1.0
author: Hermes Agent
license: MIT
metadata:
  hermes:
    tags: [gamedev, production, management, backlog, deprecated]
    related_skills: [daily]
---

# /create-backlog — DEPRECATED

## ⚠️ This skill is deprecated

The backlog is now included in the daily document. Use `/daily` instead — it produces `daily_<sprint>.<day>.md` which includes today's tasks with assignee personas. There is no separate `/create-backlog` step in the Dian Agentic Gamedev Process.

Per `/workspace/_main/PROCESS.md` line 112-113: "@Elk runs `/daily` to review progress, identify blockers, and plan the next steps by updating the backlog. Output: `daily_<sprint>.<day>.md` (e.g. `daily_v1.1.1.md`) with a summary of the daily check-in, including progress updates, identified blockers, and an updated backlog with clear and concise task descriptions."

**Migration:** All task assignment and backlog management now happens in the `/daily` skill. The daily report template includes a "Today's Backlog" section with per-persona task assignments.
