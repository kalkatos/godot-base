---
name: daily
description: "[v2] Delegated to Hermes. Load gamedev/daily skill for full instructions. @Elk (producer): daily check-in report with progress, blockers, and next steps. Does NOT manage the backlog."
user-invocable: true
---

# /daily

> **⚠️ Version 2.0 — This skill is now managed by Hermes Agent.**

This is a stub. The full skill lives in Hermes at `gamedev/daily`.

**IMPORTANT v2 change:** The old `/daily` managed the backlog. In v2, `/daily` produces a **daily report** (`daily_<date>.md`) with progress, blockers, and next steps. Backlog management is now handled by `/create-backlog`.

## What It Does

@Elk reviews progress since the last daily, identifies blockers, plans today's focus, and writes `daily_<date>.md`.

## How to Use

Load the Hermes skill: `skill_view(name='daily')` or invoke via `/daily` in Hermes.

## Templates

Output template: `.agents/docs/templates/daily-report-template.md`
