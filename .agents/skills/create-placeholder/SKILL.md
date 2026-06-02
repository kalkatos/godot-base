---
name: create-placeholder
description: "Use when you need a placeholder image, icon, mockup tile, dummy graphic, or quick generated image for game development. Invokes create_image.py to generate a .png from a short prompt with configurable size, color, shape, and text."
user-invocable: true
---

# /create-placeholder — Placeholder Image Generator

## Overview

This skill generates placeholder images for game development using the `create_image.py` script. It produces `.png` files with configurable size, color, shape, and centered text — perfect for programmer art, UI mockups, sprite stand-ins, and icon placeholders.

This is used ad-hoc during Production (steps 11-12) whenever a programmer or UI developer needs a visual asset to work with before final art is ready.

## When to Use

- When @Angel (programmer) or @Jack (GUI developer) needs a placeholder sprite, icon, or graphic
- When the art assets list (`art-assets-*.md`) flags an asset for placeholder creation
- When you need quick visual stand-ins: characters, items, UI icons, tiles, HUD elements, backgrounds
- Do NOT use for final art — this generates colored rectangles with optional shapes and text only

## The Script

The placeholder generator lives at `.scripts/create_image.py`. It uses PIL/Pillow and requires no external dependencies beyond what's standard.

### Script Flags

| Flag | Description | Default |
|------|-------------|---------|
| `-t <text>` | Text centered on the image | (none) |
| `-n <name>` | Output filename (.png added if missing) | Derived from text or UUID |
| `-f <folder>` | Output folder | Current directory |
| `-r <WxH>` | Resolution, e.g., `128x128` or `64x32` | `128x128` |
| `-c <color>` | Main color (name or hex) | `white` |
| `-tc <color>` | Text color (name or hex) | `black` |
| `-s <shape>` | Shape on transparent background: `circle`, `square`, `diamond`, `star`, `utri`, `dtri`, `rtri`, `ltri` | (none — filled image) |
| `-ts <size>` | Text size | PIL default |

### Examples

```bash
python .scripts/create_image.py -t "Sword" -r 32x32 -c gray -s diamond -f src/Game/Art/Items/
python .scripts/create_image.py -t "PLAY" -r 200x60 -c "#4a90d9" -tc white -f src/Game/Art/UI/
python .scripts/create_image.py -t "Enemy" -r 64x64 -c red -s circle -f src/Game/Art/Enemies/
python .scripts/create_image.py -t "Health\nPotion" -r 32x32 -c green -s utri -f src/Game/Art/Items/
```

## Workflow

### 1. Determine the Request

If the user provided a description as an argument, parse it. Otherwise, ask:

> "What placeholder do you need? Tell me: (1) what it represents, (2) size in pixels, (3) where to save it, and (4) any color or shape preference."

Extract the minimum settings:
- **Text:** Short label for the image
- **Size:** Default `128x128` if not specified, or infer from context (icons 32x32, sprites 64x64, UI elements vary)
- **Output folder:** Default `src/Game/Art/` if inside a Godot project, otherwise ask
- **Color:** Pick a sensible default based on context (red for enemies, green for health/items, blue for UI, gray for generic)
- **Shape:** Suggest if appropriate (circle for characters, diamond for items, square for tiles)

### 2. Confirm with User

Show the command you plan to run and ask for confirmation:

> "I'll run: `python .scripts/create_image.py -t '[text]' -r [WxH] -c [color] [flags] -f [folder]`. This will create `[filename]`. Proceed?"

### 3. Run the Script

Execute the command from the project root. The project root is determined by finding `project.godot` or `src/project.godot` in the working directory.

If the script fails with a PIL/Pillow error, install it: `pip install Pillow` and retry.

### 4. Report the Result

Return the exact command run and the full path to the saved image.

If the user needs multiple placeholders, offer to batch them:

> "I can generate more placeholders. Just describe the next one or tell me you're done."

## Defaults by Asset Type

| Asset Type | Size | Shape | Color |
|-----------|------|-------|-------|
| Character sprite | 64x64 | circle | User's choice |
| Enemy sprite | 64x64 | circle | red |
| Item icon | 32x32 | diamond | gold/yellow |
| UI button | 200x60 | (none) | blue |
| Tile | 32x32 | square | gray |
| Background | 1920x1080 | (none) | dark |
| HUD icon | 32x32 | (none) | white |
| Health pickup | 32x32 | utri | green |

## Common Pitfalls

1. **Wrong project root.** Always resolve the project root before running. If no Godot project is found, ask the user where to save.
2. **Forgetting the output folder.** Without `-f`, the image goes to the current directory. Always specify the output folder.
3. **Missing Pillow.** The script needs PIL/Pillow. If `pip install Pillow` fails, notify the user.
4. **Backslash in text.** Line breaks in text should be literal `\n` characters that the script handles — don't escape them twice.
5. **Overwriting files.** Check if the target file already exists. If so, warn the user before overwriting.

## Verification Checklist

- [ ] Project root identified (Godot project or user-specified)
- [ ] Asset type, size, color, shape, and text all determined
- [ ] User confirmed the command
- [ ] Script executed successfully
- [ ] Output path confirmed and reported to user
