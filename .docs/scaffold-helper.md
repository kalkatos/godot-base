# Scaffold Helper

Rules to govern the scaffolding process.

- Classes inherit according to their use:
  - In Godot:
    - editor-model: Resource
    - runtime-model: RefCounted
    - view: Node/Node2D/Node3D/Control
	- presenter: Node/Node2D/Node3D/Control
	- controller: Node/Node2D/Node3D/Control
  - In Unity:
    - editor-model: ScriptableObject
    - runtime-model: C# base class (no inheritance)
    - view: MonoBehaviour
	- presenter: MonoBehaviour
	- controller: MonoBehaviour
- An editor-model classes have fields that the developer wants to tweak in the editor, and are immutable in runtime. Examples: Spells, Cards, Items, StatusEffects, Enemies, etc. They template a unit for the gameplay.
- A runtime-model class can have its fields changed at runtime, and is not meant to be changed in the editor. They may contain fields that its editor counterpart doesn't have. Examples: Characters in battle, Enemies on the world, etc.
- A view class does not contain any logic. It just renders a single element of the game state. Examples: Health bar, Coin HUD, a Character avatar, a UI button, etc.
- A presenter class is an aggregator of view objects. It may know positions, transitions, states, and animations. Usually, there is at least one presenter for each game scene (Gameplay, Menu, Character Selection, etc.). Some presenters might also be controllers (the hybrid presenter+controller is a presenter).
- A controller class holds all the game logic. It modifies the runtime-model classes and sends signals that the presenters can react to. Examples: Battle controller, enemy AI, etc.

- When analyzing a codebase, do not assume the class layer by its name. Instead, get the full context of where it is used to determine its layer.