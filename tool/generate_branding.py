"""Generate launcher derivatives from the repository-owned SVG, never AI art.

Run with Python + resvg-py + Pillow (see assets/branding/README.md).
"""
from pathlib import Path
import io
import xml.etree.ElementTree as ET
import resvg_py
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
source = (ROOT / 'assets/branding/tailordesk.svg').read_text()
svg = ET.fromstring(source)
path_data = svg.find('.//{http://www.w3.org/2000/svg}path').attrib['d']

def png(size):
    return resvg_py.svg_to_bytes(svg_string=source, width=size, height=size)

def save(relative, data):
    target = ROOT / relative
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_bytes(data)

for density, size in [('mdpi', 48), ('hdpi', 72), ('xhdpi', 96), ('xxhdpi', 144), ('xxxhdpi', 192)]:
    save(f'android/app/src/main/res/mipmap-{density}/ic_launcher.png', png(size))
for size in [192, 512]:
    save(f'web/icons/Icon-{size}.png', png(size))
    save(f'web/icons/Icon-maskable-{size}.png', png(size))
save('web/favicon.png', png(32))
save('assets/branding/tailordesk.png', png(216))

# Android uses a transparent vector foreground over a full-bleed emerald layer.
vector = f'''<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp" android:height="108dp"
    android:viewportWidth="108" android:viewportHeight="108">
    <path android:fillColor="@android:color/transparent"
        android:strokeColor="#F7F5F0" android:strokeWidth="5"
        android:strokeLineCap="round" android:strokeLineJoin="round"
        android:pathData="{path_data}" />
</vector>
'''
save('android/app/src/main/res/drawable/ic_tailordesk_foreground.xml', vector.encode())

# Replace generated iOS starter assets too; this does not configure iOS delivery.
import json
catalog = ROOT / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for item in json.loads((catalog / 'Contents.json').read_text())['images']:
    if 'filename' in item:
        size = round(float(item['size'].split('x')[0]) * float(item['scale'][:-1]))
        save(str((catalog / item['filename']).relative_to(ROOT)), png(size))

# Preview adaptive visible viewport (72/108), masks, and actual small sizes.
sheet = Image.new('RGB', (920, 390), '#F7F5F0')
draw = ImageDraw.Draw(sheet)
draw.text((24, 16), 'TailorDesk | spool and thread | #176B50', fill='#202824')
large = Image.open(io.BytesIO(png(648))).convert('RGBA').crop((108, 108, 540, 540))
for i, shape in enumerate(['Circle', 'Rounded square', 'Squircle', 'Teardrop']):
    icon = large.resize((144, 144), Image.Resampling.LANCZOS)
    mask = Image.new('L', (144, 144))
    md = ImageDraw.Draw(mask)
    if shape == 'Circle':
        md.ellipse((0, 0, 143, 143), fill=255)
    elif shape == 'Teardrop':
        md.rounded_rectangle((0, 0, 143, 143), radius=72, fill=255)
        md.rectangle((72, 72, 143, 143), fill=255)
    else:
        md.rounded_rectangle((0, 0, 143, 143), radius=36 if shape == 'Squircle' else 24, fill=255)
    x = 24 + i * 225
    sheet.paste(icon, (x, 55), mask)
    draw.text((x, 212), shape, fill='#202824')
for i, size in enumerate([16, 24, 32, 48, 64]):
    x = 24 + i * 160
    icon = large.resize((size, size), Image.Resampling.LANCZOS)
    sheet.paste(icon, (x, 270), icon)
    draw.text((x, 346), f'{size}px', fill='#202824')
sheet.save(ROOT / 'assets/branding/preview.png')
