---
name: prototype
description: "[v2] Delegated to Hermes. Load gamedev/prototype skill for full instructions. @Brute (prototyper): builds throwaway prototypes to test risks from risks.md."
user-invocable: true
---

# /prototype

> **⚠️ Version 2.0 — This skill is now managed by Hermes Agent.**

This is a stub. The full skill lives in Hermes at `gamedev/prototype`.

The old v1 SKILL.md has been superseded. The v2 workflow tests specific risks from `risks.md` rather than general concept prototyping. The falsifiable hypothesis, three paths (HTML/Engine/Paper), playtest debrief, and PROCEED/PIVOT/KILL verdict remain.

## What It Does

@Brute builds a throwaway prototype for one risk in priority order. Output: a playable build and a REPORT.md with verdict.

## How to Use

Load the Hermes skill: `skill_view(name='prototype')` or invoke via `/prototype` in Hermes.

## Templates

Report template: `.agents/docs/templates/prototype-report.md` (unchanged from v1)
