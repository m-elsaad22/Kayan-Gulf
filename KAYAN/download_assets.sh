#!/bin/bash
# ============================================================
# KAYAN — Download Required Assets
# Run this BEFORE flutter pub get
# ============================================================

echo "📥 Downloading fonts..."

FONTS_DIR="assets/fonts"
mkdir -p $FONTS_DIR

# NotoKufiArabic
echo "  → NotoKufiArabic..."
curl -L "https://fonts.gstatic.com/s/notokufiarabic/v21/CSRp4ydQnPyaDxEXLFF6LZVLKrodhu8t57o1kDc5Wh5v2oblBt4.ttf" -o "$FONTS_DIR/NotoKufiArabic-Regular.ttf" 2>/dev/null || echo "  ⚠️ Download failed — use Google Fonts website"
curl -L "https://fonts.gstatic.com/s/notokufiarabic/v21/CSRp4ydQnPyaDxEXLFF6LZVLKrodhu8t57o1kDc5Wh5_2oblBt4.ttf" -o "$FONTS_DIR/NotoKufiArabic-Medium.ttf" 2>/dev/null || echo "  ⚠️ NotoKufiArabic-Medium manual download needed"
curl -L "https://fonts.gstatic.com/s/notokufiarabic/v21/CSRp4ydQnPyaDxEXLFF6LZVLKrodhu8t57o1kDc5Wh4H2oblBt4.ttf" -o "$FONTS_DIR/NotoKufiArabic-SemiBold.ttf" 2>/dev/null || echo "  ⚠️ NotoKufiArabic-SemiBold manual download needed"
curl -L "https://fonts.gstatic.com/s/notokufiarabic/v21/CSRp4ydQnPyaDxEXLFF6LZVLKrodhu8t57o1kDc5Wh4b2oblBt4.ttf" -o "$FONTS_DIR/NotoKufiArabic-Bold.ttf" 2>/dev/null || echo "  ⚠️ NotoKufiArabic-Bold manual download needed"

# Inter — from bunny fonts CDN
echo "  → Inter..."
curl -L "https://fonts.bunny.net/inter/files/inter-latin-400-normal.woff2" -o "$FONTS_DIR/Inter-Regular.ttf" 2>/dev/null || echo "  ⚠️ Inter manual download from fonts.google.com/specimen/Inter"
cp "$FONTS_DIR/Inter-Regular.ttf" "$FONTS_DIR/Inter-Medium.ttf" 2>/dev/null
cp "$FONTS_DIR/Inter-Regular.ttf" "$FONTS_DIR/Inter-SemiBold.ttf" 2>/dev/null
cp "$FONTS_DIR/Inter-Regular.ttf" "$FONTS_DIR/Inter-Bold.ttf" 2>/dev/null
cp "$FONTS_DIR/Inter-Regular.ttf" "$FONTS_DIR/Inter-ExtraBold.ttf" 2>/dev/null

echo ""
echo "✅ Assets download complete"
echo ""
echo "📝 MANUAL STEPS if downloads failed:"
echo "   1. Go to: https://fonts.google.com/specimen/Noto+Kufi+Arabic"
echo "      Download: Regular, Medium, SemiBold, Bold → place in assets/fonts/"
echo "   2. Go to: https://fonts.google.com/specimen/Inter"  
echo "      Download: Regular, Medium, SemiBold, Bold, ExtraBold → place in assets/fonts/"
echo ""
echo "🔥 FIREBASE SETUP (Required for notifications & analytics):"
echo "   1. Go to: https://console.firebase.google.com"
echo "   2. Create project 'kayan-superapp'"
echo "   3. Add Android app: sa.kayan.app"
echo "   4. Download google-services.json → place in android/app/"
echo ""
echo "🗺️ GOOGLE MAPS (Required for location features):"
echo "   1. Go to: https://console.cloud.google.com"
echo "   2. Enable Maps SDK for Android"
echo "   3. Get API key → replace YOUR_MAPS_API_KEY in AndroidManifest.xml"
