---
trigger: always_on
---

# Agent Workflow

AW-01. For behavior bugs, trace signal flow first (`SignalBus` -> controllers -> views).
AW-02. For balance/content tweaks, prefer data/resources in `Game/_GameDesign/` over hardcoding.
AW-03. Keep edits minimal and scoped; do not refactor across layers unless requested.
AW-04. When changing systems that emit signals or mutate shared state:
AW-04-A. Inspect emit functions in `src/Game/Globals/signal_bus.gd` for side effects.
AW-04-B. Check consumers before changing signal payloads.
AW-05. Verify scene wiring before code changes: broken NodePath references and renamed nodes are frequent root causes.
AW-06. For UI/input bugs, validate control focus, mouse filter, and pause mode before rewriting logic.
AW-07. Keep gameplay constants out of scripts; add/tune values in resources under `Game/_GameDesign/Config/`.
AW-08. When adding or changing signals, preserve backward compatibility unless a breaking change is explicitly requested.
AW-09. If touching autoload/singleton behavior, check for initialization order assumptions and circular dependencies.
AW-10. For pooled or dynamically spawned nodes, verify signal connections/disconnections to avoid duplicate callbacks.
AW-11. Prefer deterministic repro steps for bugs (fixed seed, fixed scene, minimal setup) before implementing a fix.
AW-12. Run relevant GUT tests after behavior changes; add a focused regression test when fixing a bug.
AW-13. Avoid editing `addons/` unless the task explicitly targets third-party/plugin behavior.
AW-14. When unsure where a behavior belongs, keep game-specific logic in `Game/` and only generalize into `Modules/` when reuse is clear.
