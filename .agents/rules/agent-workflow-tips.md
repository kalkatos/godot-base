---
trigger: always_on
---

# Agent Workflow Tips

- For behavior bugs, trace signal flow first (`SignalBus` -> controllers -> views).
- For balance/content tweaks, prefer data/resources in `Game/_GameDesign/` over hardcoding.
- Keep edits minimal and scoped; do not refactor across layers unless requested.
- When changing systems that emit signals or mutate shared state:
  - Inspect emit functions in `src/Game/Globals/signal_bus.gd` for side effects.
  - Check consumers before changing signal payloads.
- Verify scene wiring before code changes: broken NodePath references and renamed nodes are frequent root causes.
- For UI/input bugs, validate control focus, mouse filter, and pause mode before rewriting logic.
- Keep gameplay constants out of scripts; add/tune values in resources under `Game/_GameDesign/Config/`.
- When adding or changing signals, preserve backward compatibility unless a breaking change is explicitly requested.
- If touching autoload/singleton behavior, check for initialization order assumptions and circular dependencies.
- For pooled or dynamically spawned nodes, verify signal connections/disconnections to avoid duplicate callbacks.
- Prefer deterministic repro steps for bugs (fixed seed, fixed scene, minimal setup) before implementing a fix.
- Run relevant GUT tests after behavior changes; add a focused regression test when fixing a bug.
- Avoid editing `addons/` unless the task explicitly targets third-party/plugin behavior.
- When unsure where a behavior belongs, keep game-specific logic in `Game/` and only generalize into `Modules/` when reuse is clear.