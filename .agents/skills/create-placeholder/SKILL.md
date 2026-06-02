---
name: create-placeholder
description: "[v2] Delegated to Hermes. Load gamedev/create-placeholder skill for full instructions. Generates placeholder images via create_image.py for programmer art and UI mockups."
user-invocable: true
---

# /create-placeholder

> **⚠️ Version 2.0 — This skill is now managed by Hermes Agent.**

This is a stub. The full skill lives in Hermes at `gamedev/create-placeholder`.

This replaces the old `ph-creator` subagent (`.agents/agents/ph-creator.agent.md`).

## What It Does

Generates placeholder `.png` images using `.scripts/create_image.py`. Supports configurable size, color, shape, and centered text. Used by @Angel and @Jack when they need visual stand-ins before final art is ready.

## How to Use

Load the Hermes skill: `skill_view(name='create-placeholder')` or invoke via `/create-placeholder` in Hermes.

## Script

The placeholder generator: `<project-root>/.scripts/create_image.py` (requires PIL/Pillow).

Flags: `-t` text, `-r` resolution, `-c` color, `-s` shape, `-n` name, `-f` folder, `-tc` text color, `-ts` text size.
