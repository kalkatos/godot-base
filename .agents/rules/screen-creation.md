---
trigger: model_decision
---

# Screen Creation Rules

**Screen** for this project is an umbrella term that encompasses any complex UI structure that serves as interface between the player and the game systems. This includes main menus, in-game HUDs, inventory screens, character selection screens, settings menus, and more. Each screen is designed to facilitate specific interactions and provide necessary information to the player in a clear and intuitive way.

## Godot UI Structure

There are three types of screens:

1. Scene Screen
  - A scene is a self-contained unit of the game that can be loaded, instantiated, and transitioned to. They map directly to a game mode and an entry in `Enums.SceneName`. Examples include the Main Menu, Character Selection, Options, etc. Scenes live as `.tscn` files in `src/Game/Scenes/`.
  - They always occupy the entire screen. Their structure is exemplified by the Main Menu scene below, which consists of a Control root node with a VBoxContainer child that organizes the UI elements vertically:
```
MainMenu: Control
├─ VBoxContainer
|  ├─ GameName: Label
|  ├─ Space: Control
|  ├─ PlayButton: Button
```

2. Popup Screen
  - A popup is a temporary screen that appears on top of a scene to provide information, present a simple interaction, or request input from the player. Examples include confirmation dialogs, in-game settings, card browser in a card game, etc. Popups live as `.tscn` files in `src/Game/Prefabs/UI/`.
  - Always occupies the entire screen, but they are typically semi-transparent to allow the underlying scene to be partially visible.
  - Must have a close button overlay that can be clicked to close the popup as the `SettingsScreen` does.
  - Their structure is exemplified by the in-game settings popup below, which consists of a Panel root node with a MarginContainer child that provides padding, and a VBoxContainer that organizes the UI elements vertically:
```
SettingsScreen: CanvasLayer
├─ SettingsButton: TextureButton
├─ CloseOverlayButton: TextureButton
|  ├─ CenterContainer
|  │  ├─ SettingsPanel: Panel
|  |  │  ├─ MarginContainer
|  |  │  |  ├─ VBoxContainer
|  │  │  |  |  ├─ Title: Label
|  │  │  |  |  ├─ Space: Control
|  │  │  |  |  ├─ MusicContainer: HBoxContainer
|  │  │  |  |  |  ├─ MusicLabel: Label
|  │  │  |  |  |  ├─ MusicSlider: HSlider
|  │  │  |  |  ├─ SFXContainer: HBoxContainer
|  │  │  |  |  |  ├─ SFXLabel: Label
|  │  │  |  |  |  ├─ SFXSlider: HSlider
|  │  │  |  |  ├─ Space_2: Control
|  │  │  |  |  ├─ CloseButton: Button
```

3. Overlay Screen
  - An overlay is a UI element that is always present on the scene hierarchy (although it may be hidden or shown dynamically) to provide persistent information or quick access to certain interactions. Examples include in-game HUDs, minimaps, inventory bars, tooltips, etc. Overlays live as `.tscn` files in `src/Game/Prefabs/UI/`.
  - Their structure can vary widely depending on their purpose, but they typically consist of a CanvasLayer root node with various child nodes that display information or provide interactive elements.
```
InGameHUD: CanvasLayer
├─ HBoxContainer
|  ├─ VBoxContainer
|  |  ├─ HealthBar: TextureProgress
|  |  ├─ ManaBar: TextureProgress
|  ├─ InventoryButton: TextureButton
```

## Directives

1. **Containers**: Use container nodes as parents of UI elements to ensure proper layout and scalability. Avoid absolute positioning of UI elements. The most used containers are:
  - `VBoxContainer`: Arranges children vertically.
  - `HBoxContainer`: Arranges children horizontally.
  - `MarginContainer`: Provides padding around its child elements.
  - `ScrollContainer`: Provides a scrollable area for its child container.
  - `GridContainer`: Arranges children in a grid format.
  - `CenterContainer`: Centers its child elements within the available space.
  - `PanelContainer`: Wraps into its children.
