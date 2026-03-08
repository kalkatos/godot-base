---
trigger: always_on
---

# Game Architecture

The game architecture must be strictly followed for every change executed in the code. This document is the **single source of truth** for structural and coding conventions.

---

## Folder Structure Overview

```
GodotBase/             # (Or your specific Project Folder)
├── Game/              # All game-specific logic and assets
│   ├── Art/           # Visual assets (sprites, fonts, backgrounds, UI art)
│   ├── Code/          # Core scripts — organized in MVC pattern
│   │   ├── Model/     # Data definitions (Resources)
│   │   ├── View/      # Presentation and visual logic
│   │   └── Control/   # Glue between Model and View
│   ├── Globals/       # Autoloaded scripts & scenes (project-wide singletons)
│   ├── Prefabs/       # Reusable PackedScene components (.tscn)
│   ├── Scenes/        # Top-level game scenes (e.g., Main, MainMenu, Gameplay)
│   └── _GameDesign/   # Data-driven resources (.tres) — tweakable game data
│       └── Data/      # Spreadsheets, translations, CSV data
├── Modules/           # Reusable engine-level modules (game-agnostic utilities)
│   ├── Audio/         # Audio management (AudioController autoload)
│   ├── Debug/         # Generic debug utilities and overlay (DebugCommands)
│   ├── SceneController/  # Scene transition management
│   ├── Storage/       # Persistence (Storage autoload)
│   ├── UI/            # Reusable UI components (health bars, tooltips, etc.)
│   └── Utils/         # General utilities (Pooler autoload, helpers)
├── addons/            # Third-party plugins and submodules
│   ├── anthonyec.camera_preview/
│   ├── genki-analytics/
│   ├── genki-flying-text/
│   └── (others)       # e.g. GenkiDraggable, etc.
├── Icon/              # App and export icons
├── Placeholders/      # Placeholder assets for development
└── Temp/              # Temporary files (not for production)
```

---

## Core Principles

### 1. MVC Pattern (`Game/Code/`)
- **Model** (`Code/Model/`) — Pure data definitions via Godot `Resource` scripts. They describe *what* data exists but hold no presentation or orchestration logic.
  - Examples: `sample_model.gd`, custom data containers, etc.

- **View** (`Code/View/`) — All presentation scripts. They render data to the player and react to visual events. Views should **never** modify Model data directly; they signal intent upward.
  - Examples: `sample_view.gd`, UI panels, item displays, character renderers.

- **Control** (`Code/Control/`) — Orchestration scripts that glue Model and View together. They listen to signals, manage game flow, and coordinate state transitions.
  - Examples: `sample_controller.gd`, level managers, input handlers, gameplay coordinators.

### 2. Signal Bus Pattern (`signal_bus.gd`)
- `SignalBus` is the **sole signal manager** in the project. Any class that needs to send or receive cross-node signals **must** do it through `SignalBus`.
- All signals are prefixed with `_on_` for auto-connection (e.g., `_on_gameplay_started`, `_on_player_hp_changed`).
- Each signal has a corresponding `emit_<signal_name>()` function that handles broadcasting to both the local instance and the global `SignalBus` singleton.
- **UI data flow**: Sending or receiving data from UI elements must go through `SignalBus`. The UI node (or a child node) attaches `signal_bus.gd`, which points to the correct emit function. For buttons, this invokes `emit_<some_signal>()`.
- **Emit functions may contain side effects** — some emit functions update `Global` state variables before emitting (e.g., updating a score or player HP). Be aware of this when adding new signals. Only the signal_bus can do that.

### 3. Node Communication Rule: "Access Down, Signal Up"
- **Accessing children**: A parent node can reference child nodes directly, preferably via `@export` variables set in the editor (`.tscn`).
- **Communicating upward**: A node must **never** directly reference its parent or siblings. Use signals (via `SignalBus`) to communicate data upward or outward.
- **Rationale**: This keeps the scene tree decoupled and allows nodes to be reattached or reused without breaking references.

### 4. Autoloaded Globals (`project.godot`)
The following singletons are autoloaded and available project-wide:

| Autoload Name      | Path                                    | Purpose                                    |
|--------------------|-----------------------------------------|--------------------------------------------|
| `Storage`          | `Modules/Storage/storage.gd`            | Persistence / save-load management         |
| `SignalBus`        | `Game/Globals/signal_bus.gd`            | Central signal bus (see above)             |
| `Debug`            | `Modules/Debug/DebugCommands.tscn`      | Debug overlay and console commands         |
| `Pooler`           | `Modules/Utils/pooler.gd`               | Object pooling utility                     |
| `AudioController`  | `Modules/audio/AudioController.tscn`    | Music and SFX management                   |
| `Global`           | `Game/Globals/global.gd`                | Project-wide constants, references, and runtime state |
| `Analytics`        | `addons/genki-analytics/Analytics.tscn` | Analytics tracking                         |

### 5. Global State (`global.gd`)
- `Global` holds **exported configuration** (`@export` groups for Defaults, Measurements, References, Prefabs, Sorting Orders, etc.) and **runtime state** variables.
- Configuration values set via `@export` should be adjusted in the editor on the `Global.tscn` (or globally loaded equivalent) — not hardcoded in scripts.
- Runtime state is mutable and managed by Controllers and `SignalBus` emit functions.

### 6. Enums (`enums.gd`)
- All project-wide enumerations live in `enums.gd` (class name: `Enums`).
- Current enums: Add any enums needed for the specific game here.
- Always reference enums as `Enums.<EnumName>.<Value>`.

---

## Data-Driven Design (`Game/_GameDesign/`)

- The `_GameDesign` folder contains **Resource** files (`.tres`) that drive the game's data. 
- **Once the core code is stable, this folder should be the primary place to tweak features and balance.** Avoid changing code scripts for pure data adjustments.
- Primary spreadsheet and translation data are managed via **CSV spreadsheets** in `_GameDesign/Data/`.
- Manage localized strings and bulk stats through these files to ensure data is decoupled from logic.

---

## Modules vs. Addons vs. Game Code

| Layer       | Folder      | Change Policy                                                                          |
|-------------|-------------|----------------------------------------------------------------------------------------|
| **Game**    | `Game/`     | Freely modified — this is the custom game logic.                                       |
| **Modules** | `Modules/`  | Reusable, game-agnostic utilities. Modify carefully; changes affect any project using them. |
| **Addons**  | `addons/`   | Third-party plugins and submodules. **Do NOT change lightly** — only when strictly necessary. Prefer extending or wrapping addon functionality in `Game/` or `Modules/`. |

---

## Scene Organization

- **Top-level scenes** live in `Game/Scenes/`: e.g., `Main.tscn`, `SampleScene.tscn`.
- **Reusable prefab scenes** live in `Game/Prefabs/`: UI components, shared objects, VFX.
- **Prefabs vs Scenes**: Prefabs are instantiated dynamically at runtime or composed into Scenes. Scenes are loaded as full game states.

---

## Naming & Coding Conventions

- **Language**: Always use English for everything, code members and comments.
- **Signals**: Always prefixed with `_on_` (e.g., `_on_game_started`).
- **Emit functions**: Always prefixed with `emit_` (e.g., `emit_game_started`).
- **Model scripts**: Named after the data they represent.
- **Node references**: Use `@export` variables bound in the editor rather than `get_node()` / `$` paths when referencing child nodes.
- **Method declarations**: Always include a space between the method name and the opening parenthesis (e.g., `func my_method (param: int) -> void:` instead of `func my_method(param: int) -> void:`).

---

## Images and art assets:

- The 'Art' folder holds all art assets (image, sound, animations, etc.) each on a subfolder with related themes.
- Every asset created during the execution must go to a folder named '_Placeholder' under Art/<Theme>/...
- Every art asset generated must follow the art style: "in the style of Wildfrost, but without freeze or snow themes (unless explicitly requested), outlines, cartoonish characters, and flat saturated colors".