# TailorDesk artwork

Original repository-native SVG: an ivory spool with three winding strokes and a trailing thread on deep emerald. No external artwork, fonts, gradients, or generated bitmap design is used. `tailordesk.svg` is the editable source; PNGs and the Android vector are generated derivatives.

The 108-unit canvas keeps the mark inside the central 66-unit-diameter safe circle. Android 26+ uses separate vector foreground and solid background; Android 33+ includes a monochrome themed layer. Legacy Android, web, and iOS starter icons are replaced. iOS artwork is not an iPhone distribution commitment.

Regenerate (from repository root):

```bash
python3 -m venv /private/tmp/tailordesk-branding-tools
/private/tmp/tailordesk-branding-tools/bin/pip install resvg-py==0.5.0 pillow==12.3.0
/private/tmp/tailordesk-branding-tools/bin/python tool/generate_branding.py
```

See `preview.png` for circle, rounded-square, squircle approximation and teardrop masks, plus 16–64px checks. Masks simulate static cropping; launcher animation and OEM masks still require physical-device review. Android dimensions follow [Android adaptive-icon guidance](https://developer.android.com/codelabs/basic-android-kotlin-compose-training-change-app-icon).
