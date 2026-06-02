---
name: milestone
description: "[v2] Delegated to Hermes. Load gamedev/milestone skill for full instructions. @Elk (producer): manages milestones and sprints in the roadmap."
user-invocable: true
---

# /milestone

> **⚠️ Version 2.0 — This skill is now managed by Hermes Agent.**

This is a stub. The full skill lives in Hermes at `gamedev/milestone`.

The old v1 SKILL.md has been superseded. Key v2 changes: backlogs are no longer cleared on sprint change (they're preserved with dates); `/create-backlog` handles backlog population separately.

## What It Does

@Elk defines sprints for milestones, moves the Roadmap Marker, and keeps roadmap/project-state/backlog in sync.

## How to Use

Load the Hermes skill: `skill_view(name='milestone')` or invoke via `/milestone` in Hermes.

## Templates

Roadmap template: `.agents/docs/roadmap-template.md` (unchanged from v1)
