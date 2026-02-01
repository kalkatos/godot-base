# GodotBase

**GodotBase** is a comprehensive template project for Godot 4.x, designed to accelerate game development by providing a solid foundation of reusable modules, utilities, and plugins.

## 📁 Project Structure

*   **Game/**: Contains the specific logic for your game.
    *   `Globals/`: Global autoloads like `SignalBus` and `Global` variables.
    *   `Scenes/`: Main gameplay scenes.
*   **Modules/**: Reusable, game-agnostic components (Audio, UI, Save System, etc.).
*   **addons/**: Third-party and custom plugins.

## 🛠 Features & Modules

### 🔊 Audio Module (`Modules/Audio`)
*   **AudioController**: An autoload singleton that manages:
    *   Music and Sound Effects (SFX) channels.
    *   Master volume controls for Music and SFX.
    *   Automatic signal emission when volumes change.

### 🐛 Debug Module (`Modules/Debug`)
*   **DebugCommands**: An in-game console overlay.
    *   **Toggle**: Press `ui_cancel` (usually ESC) to open/close the console.
    *   **Pause**: Press `F7` to toggle game pause.
    *   **Commands**: built-in support for changing time scale (`time <scale>`) and FPS limit (`fps <value>`).
    *   Extensible: Add your own commands via `add_command`.

### 💾 Storage Module (`Modules/Storage`)
*   **Storage**: A simple save/load system.
    *   Persists data to `user://save_game.data` using JSON.
    *   Functions: `save(key, value)` and automatic loading on startup.

### 🛠 Utils Module (`Modules/Utils`)
*   **Pooler**: A robust object pooling system aimed at performance optimization for spawning repetitive objects (bullets, effects, etc.).
    *   Supports `Node2D`, `Node3D`, and `Control`.
*   **Propagators**: Helper classes for value propagation.

### 🎬 Scene Loader (`Modules/SceneController`)
*   **SceneLoader**: Helper for handling scene transitions.

### 🖥️ UI Components (`Modules/UI`)
A collection of ready-to-use UI scripts:
*   `AutosizeFontLabel`: Labels that automatically adjust font size to fit their container.
*   `HealthBar`: A standard health bar component.
*   `TooltipControl`: Manages tooltip displays.
*   `VisibilityAnimator`: Handles show/hide animations for UI elements.
*   `VersionText`: Automatically displays the project version.

## 🧩 Plugins (Addons)

This template comes pre-configured with the following plugins:

*   **Little Camera Preview** (`anthonyec.camera_preview`):
    *   Adds a Picture-in-Picture preview of the selected 2D or 3D camera within the Godot editor.
*   **GenkiDamage** (`genki-flying-text`):
    *   System for displaying floating damage numbers or text popups.
    *   *Dependency: Uses the `Pooler` module.*
*   **GenkiAnalytics** (`genki-analytics`):
    *   Tools for sending game analytics and telemetry.

## 🚀 Getting Started

1.  Clone this repository.
2.  Import the `project.godot` file into the Godot Engine (v4.x).
3.  Start building your game in the `Game/` folder using the provided Modules!

## ⚠️ Requirements

*   Godot Engine 4.x (Tested with 4.6 as per configuration)

Licensed under MIT License.
Alex (Kalkatos) Coutinho
