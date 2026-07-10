# Autoload `.tscn` Template

When converting a Resource-based Config to a Node-based Autoload, use this `.tscn` format.

## Template

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://PATH/TO/SCRIPT.gd" id="1_id"]

[node name="NodeName" type="Node"]
script = ExtResource("1_id")
property = default_value
```

## Example: CombatConfig

`CombatConfig.tscn` placed at `src/Game/Code/Model/Config/`:

```
[gd_scene load_steps=2 format=3]

[ext_resource type="Script" path="res://Game/Code/Model/Config/combat_config.gd" id="1_combat_config"]

[node name="CombatConfig" type="Node"]
script = ExtResource("1_combat_config")
max_turns = 30
stats_range = 30
```

## Autoload Registration

In `project.godot` `[autoload]` section:

```
ConfigName="*res://Game/Code/Model/Config/ConfigName.tscn"
```

## Key Rules

- The `.tscn` goes **alongside the script** (same directory), matching the convention used by `AudioController.tscn`.
- The `[node]` `type` is the **base engine class** (`Node`), not the `class_name`.
- Exported properties with default values are copied from the old `.tres`'s `[resource]` section to the `[node]` section.
- Delete the old `.tres` after creating the `.tscn`.
