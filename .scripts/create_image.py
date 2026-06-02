import sys
import os
import math
import uuid
from PIL import Image, ImageDraw, ImageFont

# --- Help ---
if "-h" in sys.argv:
    print("""
Usage: python create_image.py [options]

Options:
  -c  <color>       Main color as name (red, white) or hex (#ff0000)   [default: white]
  -s  <shape>       Shape on transparent background:                    [default: none, filled image]
                      circle, square, diamond, star,
                      utri, dtri, rtri, ltri
  -f  <folder>      Output folder                                       [default: . (current dir)]
  -t  <text>        Text drawn in the center                            [default: (none)]
  -tc <text_color>  Text color as name or hex                           [default: black]
  -r  <resolution>  Image size as WxH                                   [default: 128x128]
  -n  <name>        Output filename (.png added if missing)             [default: <text> or UUID]
  -ts <size>        Text size                                           [default: PIL default]
  -h                Show this help message
""")
    sys.exit(0)

# --- Argument parsing ---
args = sys.argv[1:]

def get_arg(flag, default=None):
    if flag in args:
        idx = args.index(flag)
        if idx + 1 < len(args):
            return args[idx + 1]
    return default

color_arg    = get_arg("-c", "white")
shape_arg    = get_arg("-s", None)
folder_arg   = get_arg("-f", ".")
text_arg     = get_arg("-t", "")
text_color   = get_arg("-tc", "black")
resolution   = get_arg("-r", "128x128")
name_arg     = get_arg("-n", None)
text_size_arg = get_arg("-ts", None)

# --- Parse resolution ---
w, h = map(int, resolution.lower().split("x"))

# --- Parse color (name or hex) ---
def parse_color(value):
    if value.startswith("#"):
        value = value.lstrip("#")
        if len(value) == 6:
            return tuple(int(value[i:i+2], 16) for i in (0, 2, 4)) + (255,)
        elif len(value) == 8:
            return tuple(int(value[i:i+2], 16) for i in (0, 2, 4, 6))
    return value  # PIL named color

main_color = parse_color(color_arg)
txt_color  = parse_color(text_color)

# --- Shape polygon helpers ---
def circle_bbox (w, h, pad=4):
    return [pad, pad, w - pad, h - pad]

def star_points (cx, cy, r_outer, r_inner, points=5):
    coords = []
    for i in range(points * 2):
        angle = math.radians(-90 + i * 180 / points)
        r = r_outer if i % 2 == 0 else r_inner
        coords.append((cx + r * math.cos(angle), cy + r * math.sin(angle)))
    return coords

def diamond_points (w, h, pad=4):
    cx, cy = w / 2, h / 2
    return [(cx, pad), (w - pad, cy), (cx, h - pad), (pad, cy)]

def triangle_points (w, h, direction, pad=4):
    if direction == "utri":
        return [(pad, h - pad), (w - pad, h - pad), (w / 2, pad)]
    elif direction == "dtri":
        return [(pad, pad), (w - pad, pad), (w / 2, h - pad)]
    elif direction == "rtri":
        return [(pad, pad), (w - pad, h / 2), (pad, h - pad)]
    elif direction == "ltri":
        return [(w - pad, pad), (pad, h / 2), (w - pad, h - pad)]

# --- Build image ---
if shape_arg:
    img  = Image.new("RGBA", (w, h), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    cx, cy = w / 2, h / 2
    outline_color = (0, 0, 0, 255)
    outline_width = 2

    if shape_arg == "triangle":
        shape_arg = "utri"
    if shape_arg == "circle":
        draw.ellipse(circle_bbox(w, h), fill=main_color, outline=outline_color, width=outline_width)
    elif shape_arg == "square":
        draw.rectangle([4, 4, w - 4, h - 4], fill=main_color, outline=outline_color, width=outline_width)
    elif shape_arg == "diamond":
        draw.polygon(diamond_points(w, h), fill=main_color, outline=outline_color, width=outline_width)
    elif shape_arg == "star":
        r_outer = min(w, h) / 2 - 4
        r_inner = r_outer * 0.4
        draw.polygon(star_points(cx, cy, r_outer, r_inner), fill=main_color, outline=outline_color, width=outline_width)
    elif shape_arg in ("utri", "dtri", "rtri", "ltri"):
        draw.polygon(triangle_points(w, h, shape_arg), fill=main_color, outline=outline_color, width=outline_width)
else:
    img  = Image.new("RGBA", (w, h), main_color)
    draw = ImageDraw.Draw(img)

# --- Draw text ---
if text_arg:
    text_arg = text_arg.replace("\\n", "\n")
    font = None
    if text_size_arg:
        try:
            # Try to load a common font, or default with size if possible
            try:
                font = ImageFont.truetype("arial.ttf", int(text_size_arg))
            except:
                try:
                    font = ImageFont.load_default(size=int(text_size_arg))
                except:
                    font = ImageFont.load_default()
        except:
            pass
    draw.multiline_text((w / 2, h / 2), text_arg, fill=txt_color, anchor="mm", align="center", font=font)

# --- Determine filename ---
if name_arg:
    filename = name_arg
elif text_arg:
    filename = text_arg.replace("\\n", "_").replace("\n", "_").replace(" ", "_").lower()
else:
    filename = str(uuid.uuid4())[:8]  # Short UUID as fallback

# --- Sanitize filename (strip forbidden characters) ---
import re
filename = re.sub(r'[\\/:*?"<>|]', '', filename)

if not filename.lower().endswith(".png"):
    filename += ".png"

# --- Save ---
os.makedirs(folder_arg, exist_ok=True)
output_path = os.path.join(folder_arg, filename)
img.save(output_path)
print(f"Saved: {output_path}")
