# BACKLOG: Read

This document present current sprint divided in small tasks. The tasks must be clear and concise, and must be related to the milestones defined in the `roadmap.md` document.

[ ] = Unfinished task
✅ = Finished task

## Sprint v1.1: Fighter & Arena Foundation

- [ ] Arena Scene — Side-view 2D arena scene with placeholder background, ground/platform, and camera setup.
- [ ] Fighter Scene — Placeholder fighter with a sprite, AnimationPlayer, and state machine stub (idle, attack, hurt states). No collision needed — actions are card-driven and simulated.
- [ ] Health Bars — Health bar UI above each fighter with current_health/max_health and take_damage()/heal() hooks.
- [ ] Round Timer — Round timer display with start/stop/reset, configurable duration.
- [ ] Fight Manager — Orchestrator scene that spawns two fighters in the arena, manages round timer, and exposes hooks for card-driven actions.
