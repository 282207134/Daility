"""Build documentation previews from test screenshots (requires Pillow)."""
from pathlib import Path
from PIL import Image, ImageDraw

root = Path(__file__).resolve().parents[1]
screens = root / "docs/screenshots"
previews = screens / "previews"
previews.mkdir(exist_ok=True)
files = sorted(p for p in screens.glob("*.png") if p.name != "overview.png")
width, height, margin, caption = 225, 488, 20, 28
rows = (len(files) + 3) // 4
sheet = Image.new("RGB", (4 * (width + margin) + margin,
                         rows * (height + caption + margin) + margin), "#F2F2F6")
draw = ImageDraw.Draw(sheet)
for i, path in enumerate(files):
    image = Image.open(path).convert("RGB")
    preview = image.copy()
    preview.thumbnail((250, 542), Image.Resampling.LANCZOS)
    preview.save(previews / path.name, optimize=True)
    image.thumbnail((width, height), Image.Resampling.LANCZOS)
    x = margin + (i % 4) * (width + margin)
    y = margin + (i // 4) * (height + caption + margin)
    draw.text((x, y + 5), path.stem.replace("_", " "), fill="#050516")
    sheet.paste(image, (x, y + caption))
sheet.save(screens / "overview.png", optimize=True)
print(f"Created {len(files)} previews and overview.png")
