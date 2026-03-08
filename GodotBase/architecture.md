---
trigger: always_on
---

# Game Architecture

The game architecture must be strictly followed for every change executed in the code. This document is the **single source of truth** for structural and coding conventions.

---

## Folder Structure Overview

```
Deckana/
├── Game/              # All game-specific logic and assets
│   ├── Art/           # Visual assets (sprites, fonts, backgrounds, UI art)
│   ├── Code/          # Core scripts — organized in MVC pattern
│   │   ├── Model/     # Data definitions (Resources)
│   │   ├── View/      # Presentation and visual logic
│   │   └── Control/   # Glue between Model and View
│   ├── Debug/         # Debug tools (DebugCommands scene/scripts)
│   ├── Globals/       # Autoloaded scripts & scenes (project-wide singletons)
│   ├── Prefabs/       # Reusable PackedScene components (.tscn)
│   ├── Scenes/        # Top-level game scenes (Main, Battle, MainMenu, Reward)
│   ├── Settings/      # Configuration resources (shapes, render settings, URLs)
│   ├── Test/          # Test scenes and scripts
│   └── _GameDesign/   # Data-driven resources (.tres) — tweakable game data
│       ├── Data/      # Spreadsheets, translations, CSV data
│       ├── Emblems/   # Emblem resource definitions
│       ├── _Combos/   # Combo recipe data
│       ├── _Enemies/  # Enemy definitions
│       ├── _EnemyActions/
│       ├── _EnemyBrains/
│       ├── _EnemyTelegraphs/
│       └── Pools/     # Card pool definitions
├── Modules/           # Reusable engine-level modules (game-agnostic utilities)
│   ├── Audio/         # Audio management (AudioController autoload)
│   ├── Debug/         # Generic debug utilities
│   ├── SceneController/  # Scene transition management
│   ├── Storage/       # Persistence (Storage autoload)
│   ├── UI/            # Reusable UI components (health bars, tooltips, etc.)
│   └── Utils/         # General utilities (Pooler autoload, helpers)
├── addons/            # Third-party plugins and submodules
│   ├── anthonyec.camera_preview/
│   ├── genki-analytics/
│   ├── genki-cardgame/
│   ├── genki-draggable/
│   └── genki-flying-text/
├── Icons/             # App and export icons
├── Placeholders/      # Placeholder assets for development
└── Temp/              # Temporary files (not for production)
```

---

## Core Principles

### 1. MVC Pattern (`Game/Code/`)
- **Model** (`Code/Model/`) — Pure data definitions via Godot `Resource` scripts. They describe *what* data exists but hold no presentation or orchestration logic.
  - `Cards/` — Card-related resources (`SpellCard`, `Emblem`, `Combo`, `ComboInfo`, `PlayerDeck`, `EnemyDef`, `EncounterDef`, `CardCreator`)
  - `Effects/` — Effect data (`Effect`, `eff_add_rule`)
  - `EnemyActions/` — Enemy AI data (`EnemyAction`, `EnemyBrain`, `Telegraph`, action/brain implementations)
  - `Rules/` — Card rule resources (`Rule` base, `ru_*` implementations for timing hooks such as fetch, execution, start-of-turn, end-of-turn, discard)
  - `ValueFetchers/` — Data query resources (`ValueFetcher` base, `vf_*` implementations for counting cards, tags, effects, sums, etc.)

- **View** (`Code/View/`) — All presentation scripts. They render data to the player and react to visual events. Views should **never** modify Model data directly; they signal intent upward.
  - Examples: `DeckanaCard`, `CardDamageView`, `EnemyView`, `TelegraphView`, `EffectPresenter`, `EndScreen`, `CardBrowser`, `TooltipView`, `FeedbackForm`

- **Control** (`Code/Control/`) — Orchestration scripts that glue Model and View together. They listen to signals, manage game flow, and coordinate state transitions.
  - Examples: `CombatController`, `HandController`, `ActiveController`, `ComboController`, `EffectController`, `EncounterController`, `EnemyCreator`, `GameplayController`, `RewardController`, `AnalyticsController`

### 2. Signal Bus Pattern (`signal_bus.gd`)
- `SignalBus` is the **sole signal manager** in the project. Any class that needs to send or receive cross-node signals **must** do it through `SignalBus`.
- All signals are prefixed with `_on_` for auto-connection (e.g., `_on_combat_started`, `_on_player_hp_changed`).
- Each signal has a corresponding `emit_<signal_name>()` function that handles broadcasting to both the local instance and the global `SignalBus` singleton.
- **UI data flow**: Sending or receiving data from UI elements must go through `SignalBus`. The UI node (or a child node) attaches `signal_bus.gd`, which points to the correct emit function. For buttons, this invokes `emit_<some_signal>()`.
- **Emit functions may contain side effects** — some emit functions update `Global` state variables before emitting (e.g., `emit_player_take_damage` updates `player_hp`, `emit_card_added_to_active` increments `actions`). Be aware of this when adding new signals. Only the signal_bus can do that.

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
| `Debug`            | `Game/Debug/DebugCommands.tscn`         | Debug overlay and console commands         |
| `Pooler`           | `Modules/Utils/pooler.gd`              | Object pooling utility                     |
| `AudioController`  | `Modules/Audio/AudioController.tscn`    | Music and SFX management                   |
| `Global`           | `Game/Globals/Global.tscn`              | Project-wide constants, references, and runtime state |
| `Analytics`        | `addons/genki-analytics/Analytics.tscn` | Analytics tracking                         |
| `InputController`  | `Modules/` (UID ref)                    | Input abstraction layer                    |
| `DamageCalculator` | `Game/Globals/DamageCalculator.tscn`    | Combo/damage evaluation logic              |

### 5. Global State (`global.gd`)
- `Global` holds **exported configuration** (`@export` groups for Defaults, Measurements, References, Prefabs, Sorting Orders, Sprites, Combos, Emblems) and **runtime state** variables (player HP, enemies, active cards, turn state, etc.).
- Configuration values set via `@export` should be adjusted in the editor on the `Global.tscn` scene — not hardcoded in scripts.
- Runtime state is mutable and managed by Controllers and `SignalBus` emit functions.

### 6. Enums (`enums.gd`)
- All project-wide enumerations live in `enums.gd` (class name: `Enums`).
- Current enums: `CardState`, `CardType`, `EncounterType`, `EnemyAnimation`, `CardAnimation`, `EnemyActionType`, `CardTag`, `CardValue`.
- Always reference enums as `Enums.<EnumName>.<Value>` (e.g., `Enums.CardState.HAND`).

---

## Data-Driven Design (`Game/_GameDesign/`)

- The `_GameDesign` folder contains **Resource** files (`.tres`) that drive the game's data: emblems, combos, enemy definitions, enemy actions/brains/telegraphs, card pools, spreadsheets, and translations.
- **Once the core code is stable, this folder should be the primary place to tweak features and balance.** Avoid changing code scripts for pure data adjustments.
- Card and translation data are managed via **CSV spreadsheets** in `_GameDesign/Data/`.
- The project supports **14 languages** via translation files generated from `translation_spreadsheet.csv`.

---

## Modules vs. Addons vs. Game Code

| Layer       | Folder      | Change Policy                                                                          |
|-------------|-------------|----------------------------------------------------------------------------------------|
| **Game**    | `Game/`     | Freely modified — this is the custom game logic.                                       |
| **Modules** | `Modules/`  | Reusable, game-agnostic utilities. Modify carefully; changes affect any project using them. |
| **Addons**  | `addons/`   | Third-party plugins and submodules. **Do NOT change lightly** — only when strictly necessary. Prefer extending or wrapping addon functionality in `Game/` or `Modules/`. |

---

## Scene Organization

- **Top-level scenes** live in `Game/Scenes/`: `Main.tscn`, `Battle.tscn`, `MainMenu.tscn`, `RewardController.tscn`.
- **Reusable prefab scenes** live in `Game/Prefabs/`: card views, emblem views, UI components, arrows, VFX.
- **Prefabs vs Scenes**: Prefabs are instantiated dynamically at runtime or composed into Scenes. Scenes are loaded as full game states.

---

## Naming & Coding Conventions

- **Language**: Always use English for everything, code members and comments.
- **Signals**: Always prefixed with `_on_` (e.g., `_on_combat_started`).
- **Emit functions**: Always prefixed with `emit_` (e.g., `emit_combat_started`).
- **Model scripts**: Named after the data they represent (e.g., `spell_card.gd`, `emblem.gd`, `enemy_def.gd`).
- **Rule scripts**: Prefixed with `ru_` (e.g., `ru_value_at_execution.gd`).
- **ValueFetcher scripts**: Prefixed with `vf_` (e.g., `vf_cards_in_region.gd`).
- **Effect scripts**: Prefixed with `eff_` or `ceff_` (e.g., `eff_add_rule.gd`).
- **Enemy action scripts**: Prefixed with `act_` (actions) or `br_` (brains) (e.g., `act_deal_damage.gd`, `br_always_attack.gd`).
- **Node references**: Use `@export` variables bound in the editor rather than `get_node()` / `$` paths when referencing child nodes.
- **Global groups** (defined in `project.godot`): `PlayerPawn`, `ShowPosition`, `EncounterPosition`, `DiscardedPosition`, `StashPosition`, `DamageCardPosition`, `DamageCardOrigin`, `FlyingNumbersParent`.
- **Method declarations**: Always include a space between the method name and the opening parenthesis (e.g., `func my_method (param: int) -> void:` instead of `func my_method(param: int) -> void:`).

---

## Images and art assets:

- The 'Art' folder holds all art assets (image, sound, animations, etc.) each on a subfolder with related themes.
- Every asset created during the execution must go to a folder named '_Placeholder' under Art/<Theme>/...
- Every art asset generated must follow the art style: "in the style of Wildfrost, but without freeze or snow themes (unless explicitly requested), outlines, cartoonish characters, and flat saturated colors".
- Monster images must have 512x512 resolution, and a transparent background.
- Background images must have 16:9 aspect ratio with the maximum resolution supported.