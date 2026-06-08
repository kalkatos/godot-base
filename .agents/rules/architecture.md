---
trigger: always_on
---

# Architecture: Modular MVP — SignalBus-Driven

This project follows a **Modular MVP** architecture where all inter-layer communication flows through a central **SignalBus**. Every system is a self-contained module with a single responsibility.

## Architectural Layers

The codebase is organized into four distinct layers. Each layer has a clear responsibility, a defined home folder, and strict rules about what it can talk to.

| Layer | Folder | Responsibility | Talks To |
|-------|--------|----------------|----------|
| **Services** | `Modules/` | Cross-cutting capabilities: audio, pooling, storage, VFX, debug, UI utilities, tooltips. Fixed template — do not modify unless the task explicitly targets service internals. | SignalBus + direct calls to lower-level Services |
| **Models** | `Game/_GameDesign/` | Passive data containers: Resources, configs, enums. No logic beyond getters. | Nothing — silently loaded and read by whoever needs them |
| **Controllers** | `Game/Code/` | Game-specific rule engines, state machines, scene routing (`TransitionController`). Game logic lives here. | SignalBus (listen + emit) + direct calls to Services |
| **Views + Presenters** | `Game/Scenes/` + `Game/Prefabs/` + `Game/Code/Presenters/` | Rendering and input semantics. Views handle pixels; Presenters translate raw input into SignalBus events and SignalBus events into View updates. | SignalBus (emit + listen) + direct calls from Presenter to its View |

### View vs. Presenter — The Hard Distinction

- **View**: Knows pixels, not rules. Handles layout, animations, and raw input capture. Emits local signals only (`button_pressed`, `mouse_entered`). Never touches SignalBus.
- **Presenter**: Knows meaning, not pixels. Wires View signals to SignalBus events and SignalBus events back to View updates. The semantic boundary where raw input gains application meaning — but stops short of game logic.

```
View:     "User clicked something"         → local signal
Presenter: "That click means start game"   → SignalBus event
Controller: "Starting game means..."       → game rules
View:     SignalBus event                 → "Show this, hide that"
```

## SignalBus — The Central Nervous System

All inter-layer communication flows through `SignalBus` (`Game/Globals/signal_bus.gd`). Direct coupling between layers is forbidden except where explicitly allowed below.

### Signal Naming Rule

**Signals must use domain language, never UI terminology.** A signal describes what happened in the game world, not what button was pressed.

| ✅ Domain Language | ❌ UI Language |
|---|---|
| `_on_scene_transition_requested` | `_on_play_button_pressed` |
| `_on_character_selected(index)` | `_on_character_clicked` |
| `_on_attack_requested` | `_on_attack_button_clicked` |

The Presenter translates: `button_pressed` (View) → `_on_scene_transition_requested` (SignalBus). The signal name reflects the game-domain event, not its trigger.

### Signal Connection Pattern

- `_on_*` signals in `signal_bus.gd` auto-connect via `_ready()` for global accessibility.
- Paired with `emit_*` helper functions for clean emissions throughout the codebase.
- In-scene signals remain local; only cross-system events go on SignalBus.
- The handler of the signal will implement `handle_*` for that signal.

## Communication Rules

| From → To | Via | Rationale |
|------------|-----|-----------|
| **View → Presenter** | Local signal | View emits raw user action; Presenter wired in same scene |
| **Presenter → View** | Direct call | Presenter owns a reference to its View |
| **Presenter → SignalBus** | Direct emit | Translates View actions into application events |
| **Controller ⇄ SignalBus** | Listen + emit | Rule engines react to events and drive state changes |
| **Controller → Service** | Direct call | Controllers own game logic; can call Audio, Pooler, etc. |
| **Service → Service** | Direct call | Services know each other's API (subject to hierarchy) |

### Forbidden Calls

| Connection | Why Forbidden |
|------------|---------------|
| View → SignalBus | Views don't know what events mean; Presenter translates |
| Controller → View | Controllers are game rules, presentation-agnostic |
| Model → anything | Models are passive data; no logic, no signals |

## Service Dependency Hierarchy

Services form a directed acyclic dependency graph. A service may only depend on services below it. This is a **guideline**, not a strict rule — break it with a documented reason when necessary.

| Level | Services | May Depend On |
|-------|----------|---------------|
| **Foundation** | `Pooler`, `Storage`, `Utils` | Nothing |
| **Mid-Level** | `AudioController` | `Storage` |
| | `VFX` | `Pooler` |
| **Presentation** | `UI` | Self-contained; may depend on any |
| | `Tooltip` | `UI.ClampedControl` + `SignalBus` |

Foundation services depend on nothing. They are pure, self-contained systems. Never make Pooler reference VFX, or Storage reference AudioController.

## Scene Architecture

Screens follow the three-type system defined in [screen-creation.md](screen-creation.md):

1. **Scene Screen**: Full-screen in `Scenes/`, maps to `Enums.SceneName`, loaded via `TransitionController`.
2. **Popup Screen**: Temporary overlay in `Prefabs/UI/`, semi-transparent, close-button required.
3. **Overlay Screen**: Persistent UI in `Prefabs/UI/` (HUD, minimap), shown/hidden dynamically.

All scene transitions flow through `TransitionController` via `SignalBus._on_scene_transition_requested`. Both Presenters and Controllers use the same event — `TransitionController` is the single authority on scene loading. No one bypasses it.

## Model Access Patterns

Models are passive Resources. Access them via one of these patterns:

| Pattern | How | When |
|---------|-----|------|
| **Direct Export** | `@export var spell: SomeSpell` | Scene-specific data object wired in editor |
| **Registry/Autoload** | Central config autoload queried at runtime | Shared data needed by multiple systems |
| **Storage Load** | `Storage.load("key", default)` | Runtime-persisted player data |

Models hold no logic and emit no signals. They are data, nothing more.

## Model types

All model objects are mapped to a `.gd` script in `src/Game/Code/Model/(Config || <Category>)`. They can be Config or Resources.
| Type | Extension | Folder | What |
|---|---|---|---|
| Config | .tscn | `src/Game/_GameDesign/Config` | Variables for systems that can be accessed through autoload. |
| Resource | .tres | `src/Game/_GameDesign/<Category>` | Portable data containers for game elements like spells, characters, items, etc. |

## Composition Patterns

Prefer composition over inheritance. Use these four patterns:

| Pattern | How | Example |
|---------|-----|---------|
| **Child Node** | Add child nodes for new behavior | `AnimatedButton` composes a Tween child; `HealthBar` composes dual Range children |
| **Wrapper/Decorator** | Wrap a Node to add behavior without modifying it | `PoolItem` wraps any Node for lifecycle tracking |
| **Signal Wiring** | Bridge systems via signals without subclassing | `StorageBinder` connects Storage ↔ any node |
| **Resource** | Attach Resource data to any Node | `ParticleEmitter` is a Resource, not a base class |

## Anti-Patterns

These are explicitly forbidden:

1. **View touching SignalBus directly** — Views don't know what events mean; Presenters translate
2. **Controller referencing a View** — Controllers are game rules, presentation-agnostic
3. **Service depending on a higher-level Service** — Violates dependency hierarchy
4. **Hardcoded values in scripts** — All config lives in `_GameDesign/` Resources (data) or Scenes (config)
5. **Model holding logic** — Models are passive data; no methods beyond getters
6. **SignalBus signals named after UI** — Domain language only

## Template Contract

This is a template project. The contract for games built on it:

| Layer | Editable by Games? |
|-------|---------------------|
| `Game/` | ✅ Fully editable — scenes, presenters, controllers, models, `TransitionController` |
| `Modules/` | ❌ Fixed template — do not modify unless the task explicitly targets service internals |
| `addons/` | ❌ Third-party — do not modify unless the task explicitly targets plugin behavior |

Module graduation (moving code from `Game/` to `Modules/`) is a manual decision by the user, not an agent responsibility.

## Testing

- Tests live in `src/tests/`.
- Use the **GUT** framework (`src/addons/gut/`).
- Run from `src/` with the GUT CLI (see AGENTS.md for the exact command).
- Prefer project-specific test config (`.gutconfig.json`) when present.
