---
name: create-backlog
description: "[v2] Delegated to Hermes. Load gamedev/create-backlog skill for full instructions. @Elk (producer): populates the backlog with tasks for the current sprint. Replaces the old /daily skill's backlog function."
user-invocable: true
---

# /create-backlog

> **⚠️ Version 2.0 — This skill is now managed by Hermes Agent.**

This is a stub. The full skill lives in Hermes at `gamedev/create-backlog`.

## What It Does

@Elk interviews the user to define clear, actionable tasks for the current sprint, assigns them to personas (@Angel, @Jack, @Imp, etc.), and writes `backlog-<date>.md`. Unlike v1, backlogs are now preserved with dates rather than cleared on sprint change.

## How to Use

Load the Hermes skill: `skill_view(name='create-backlog')` or invoke via `/create-backlog` in Hermes.

## Templates

Output template: `.agents/docs/backlog-template.md` (unchanged from v1, now used with dated filenames)
