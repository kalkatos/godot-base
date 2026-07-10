# SYSTEM: [[system_name]]

**Depends on:** [[other_system_design.md — list any design docs that should be read first, or remove this line if none]]

## Overview

[[A one-paragraph summary of what this system does, why it exists, and how it serves the game concept.]]

## Player Experience

[[What the player does, sees, and feels. Describe the intended experience, interactions, and feedback. Tie to the game concept and player fantasy.]]

## Mechanics & Rules

[[The concrete rules, states, flows, and parameters. Include edge cases, failure states, and constraints. Use diagrams or bullet lists for clarity. Avoid pseudocode — describe what happens, not how to implement it.]]

## Dependencies

[[What this system needs from or gives to other systems. Use structured references:]]

- **Signals emitted:** → SignalBus.[[signal_name]]
- **Signals consumed:** ← SignalBus.[[signal_name]]
- **Configs:** → Config/[[ConfigName]]
- **Scenes:** → Scene/[[SceneName]]
- **Services:** → [[ServiceName]] (e.g., AudioController, Pooler)
- **Other systems:** ⇄ [[other_system]]_design.md

## Configurable Values

[[Numbers and parameters that should be exposed in `Game/_GameDesign/Config/` rather than hardcoded. For each: name, type, suggested default, and what it controls.]]

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| [[config_key]] | [[float/int/bool/string]] | [[value]] | [[What tuning this knob affects]] |

## Open Questions

[[Things not yet decided. Each should be a single question. Resolve these before or during implementation.]]

- [[?]]
