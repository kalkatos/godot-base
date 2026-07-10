# create_image.py — Flag Reference & Asset Type Quick Guide

Quick-reference for the placeholder image generator script at `<project-root>/.scripts/create_image.py`.

---

## All Flags

| Flag | Description | Default |
|------|-------------|---------|
| `-t <text>` | Text centered on the image. Use `\n` for line breaks. | (none) |
| `-n <name>` | Output filename (lowercase; .png appended if missing) | Derived from text or UUID |
| `-f <folder>` | Output folder (created if missing) | Current directory |
| `-r <WxH>` | Resolution like `128x128` or `64x32` | `128x128` |
| `-c <color>` | Main fill color — name (`red`) or hex (`#ff0000`) | `white` |
| `-tc <color>` | Text color — name or hex | `black` |
| `-s <shape>` | Shape on transparent bg: `circle`, `square`, `diamond`, `star`, `utri`, `dtri`, `rtri`, `ltri` | (none — filled rect) |
| `-ts <size>` | Text size (integer) | PIL default |
| `-h` | Show help text | — |

---

## Defaults by Asset Type

| Asset Type | Size | Shape | Base Color | Example |
|-----------|------|-------|-----------|---------|
| Character sprite | 512×512 | circle | (ask user) | `-t "Hero" -r 512×512 -s circle -c blue` |
| Enemy sprite | 512x512 | circle | red | `-t "Goblin" -r 512x512 -s circle -c red` |
| Item/Spell icon | 256x256 | diamond | gold | `-t "Sword" -r 256x256 -s diamond -c "#ffd700"` |
| UI button | 200×60 | (none) | blue | `-t "PLAY" -r 200x60 -c "#4a90d9" -tc white` |
| Tile | 64x64 | square | gray | `-t "Floor" -r 64×64 -s square -c "#888888"` |
| Background | 1920×1080 | (none) | dark | `-t "Forest BG" -r 1920x1080 -c "#1a1a2e"` |
| HUD icon | 128x128 | (none) | white | `-t "+5" -r 128x128 -c white -tc black` |
| Health pickup | 64×64 | utri (up triangle) | green | `-t "hp" -r 64×64 -s utri -c "#4caf50"` |
| Shield icon | 64x64 | diamond | cyan | `-t "Shield" -r 64×64 -s diamond -c "#00bcd4"` |
| Coin / currency | 64x64 | circle | yellow | `-t "$" -r 64×64 -s circle -c "#ffeb3b"` |
| Collectible | 64x64 | star | magenta | `-t "★" -r 64×64 -s star -c "#e040fb"` |

---

## Common Output Folders (Godot project)

| Context | Folder |
|---------|--------|
| Character sprites | `src/Game/Art/Characters/` |
| Enemies | `src/Game/Art/Enemies/` |
| Items / pickups | `src/Game/Art/Items/` |
| UI elements | `src/Game/Art/UI/` |
| Tiles / environment | `src/Game/Art/Environment/` |
| Effects / VFX | `src/Game/Art/Effects/` |
| Placeholder pool | `src/Game/Art/_Placeholder/` |

---

## Troubleshooting

| Error | Fix |
|-------|-----|
| `ModuleNotFoundError: No module named 'PIL'` | `pip install Pillow` |
| `-s triangle` doesn't work | Use specific: `utri` / `dtri` / `rtri` / `ltri` (the script aliases `triangle` → `utri`) |
| Text doesn't center | The script uses `anchor="mm"` — ensure no stray spaces in `-t` value |
| File not created | Check `-f` path exists (script does create it: `os.makedirs(folder_arg, exist_ok=True)`) |
