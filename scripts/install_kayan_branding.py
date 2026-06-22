#!/usr/bin/env python3
"""Install KAYAN branding assets into Android/iOS launcher icons.

Requires the owner's files (NOT auto-generated from logo):
  - assets/images/kayan_icon.webp  (square app icon — 3D knot mark)
  - assets/images/kayan_logo.png     (full wordmark — KAYAN + GULF SUPER APP)

Usage:
  python3 scripts/install_kayan_branding.py
"""

from __future__ import annotations

import os
import sys
from pathlib import Path

try:
    from PIL import Image
except ImportError:
    print("Install Pillow: pip install Pillow")
    sys.exit(1)

ROOT = Path(__file__).resolve().parents[1]
ICON_SRC = ROOT / "assets/images/kayan_icon.webp"
LOGO_SRC = ROOT / "assets/images/kayan_logo.png"
ANDROID_RES = ROOT / "android/app/src/main/res"

ANDROID_SIZES = {
    "mipmap-ldpi": 36,
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}

IOS_ICONS = [
    ("ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-1024x1024@1x.png", 1024),
    ("ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@3x.png", 180),
    ("ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-60x60@2x.png", 120),
    ("ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-83.5x83.5@2x.png", 167),
    ("ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-76x76@2x.png", 152),
    ("ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-40x40@2x.png", 80),
    ("ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-29x29@2x.png", 58),
    ("ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-20x20@2x.png", 40),
]


def _load_icon() -> Image.Image:
    for candidate in [ICON_SRC, ROOT / "assets/images/kayan_icon.png"]:
        if candidate.exists():
            img = Image.open(candidate).convert("RGBA")
            w, h = img.size
            if w != h:
                print(f"WARNING: icon is {w}x{h} — should be square. Center-cropping.")
                side = min(w, h)
                left = (w - side) // 2
                top = (h - side) // 2
                img = img.crop((left, top, left + side, top + side))
            return img
    print("ERROR: Missing kayan_icon.webp (or kayan_icon.png) in assets/images/")
    sys.exit(1)


def _verify_logo() -> None:
    if not LOGO_SRC.exists():
        print("ERROR: Missing kayan_logo.png in assets/images/")
        sys.exit(1)
    img = Image.open(LOGO_SRC)
    print(f"Logo: {LOGO_SRC.name} — {img.size[0]}x{img.size[1]} {img.mode}")


def install_android(icon: Image.Image) -> None:
    for folder, size in ANDROID_SIZES.items():
        out_dir = ANDROID_RES / folder
        out_dir.mkdir(parents=True, exist_ok=True)
        resized = icon.resize((size, size), Image.Resampling.LANCZOS)
        resized.save(out_dir / "ic_launcher.png", "PNG")
        resized.save(out_dir / "ic_launcher_round.png", "PNG")
        print(f"  Android {folder}: {size}px")


def install_ios(icon: Image.Image) -> None:
    for rel, size in IOS_ICONS:
        path = ROOT / rel
        path.parent.mkdir(parents=True, exist_ok=True)
        icon.resize((size, size), Image.Resampling.LANCZOS).save(path, "PNG")
        print(f"  iOS {path.name}: {size}px")


def main() -> None:
    print("KAYAN branding installer")
    _verify_logo()
    icon = _load_icon()
    print(f"Icon source: {icon.size[0]}x{icon.size[1]}")
    print("Installing Android mipmaps...")
    install_android(icon)
    print("Installing iOS AppIcon...")
    install_ios(icon)
    print("Done. Run: flutter pub get && flutter build apk --release")


if __name__ == "__main__":
    main()
