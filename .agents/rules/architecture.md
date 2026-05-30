---
trigger: always_on
---

# Architecture Guidelines

- Systems must be deep and modular, with clear separation of concerns and single responsibility.
- A deep system is one that has multiple layers of abstraction, allowing for flexibility and extensibility without modifying existing code. For example, a combat system might have separate layers for input handling, action resolution, damage calculation, and visual effects.
- Game-specific logic and assets belong in `Game/`, while reusable, game-agnostic systems go in `Modules/`.
- Avoid tight coupling between systems; use signals and data-driven design to enable flexibility and maintainability.
- Follow established patterns for scene organization, node structure, and resource management to ensure consistency across the project.
- Prioritize readability and clarity in code and scene structure, even if it means more files or nodes, to facilitate onboarding and collaboration.
- When in doubt, prefer composition over inheritance to promote flexibility and reuse.
