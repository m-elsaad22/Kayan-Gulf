# 🏗️ KAYAN Super App — دليل التشغيل الشامل
## Complete Setup & Run Guide

---

## الجزء الأول: فهم هيكل المشروع

```
kayan/
├── mobile/                      ← Flutter App (هذا ما نشغّله)
│   ├── kayan_demo_app.dart      ← ✅ ديمو الممول (ملف واحد مكتفٍ بنفسه)
│   ├── pubspec.yaml             ← التبعيات
│   ├── lib/
│   │   ├── main.dart            ← نقطة الدخول الرئيسية
│   │   ├── app.dart             ← MaterialApp + Router
│   │   ├── core/                ← ثيم + ألوان + DI
│   │   │   └── theme/           ← app_colors, app_gradients, etc.
│   │   └── features/            ← 43 شاشة منظمة بـ Clean Architecture
│   │       ├── auth/            ← OTP + Phone + Profile Setup
│   │       ├── home/            ← الرئيسية
│   │       ├── ecommerce/       ← منتجات + سلة + checkout
│   │       ├── services/        ← خدمات منزلية + حجز + تتبع
│   │       ├── classifieds/     ← إعلانات + نشر + my ads
│   │       ├── chat/            ← محادثات + chat detail
│   │       ├── wallet/          ← المحفظة
│   │       ├── notifications/   ← الإشعارات
│   │       └── settings/        ← الإعدادات
│   └── README_DEMO.md           ← دليل العرض للممول
│
└── backend/                     ← NestJS API (منفصل)
    ├── sprint1-6 ZIPs           ← 100+ endpoints جاهزة
    └── ...
```

---

## 📌 خياران للتشغيل — اختر الأنسب

### 🅰️ الخيار السريع: ديمو الممول (موصى به)
ملف واحد، **go_router فقط**، يعمل في 5 دقائق

### 🅱️ الخيار الكامل: المشروع الرئيسي
77 ملف Dart، Riverpod + Firebase + Google Maps، يحتاج إعداداً أعمق

---

## ═══════════════════════════════════
## 🅰️ تشغيل ديمو الممول (الأسرع)
## ═══════════════════════════════════

### المتطلبات
```
Flutter SDK: 3.16+
Dart:        3.2+
iOS:         14+ (Simulator أو جهاز حقيقي)
Android:     8.0+ (Emulator أو جهاز حقيقي)
```

### الخطوة 1 — تثبيت Flutter (إذا لم يكن مثبتاً)
```bash
# macOS
brew install --cask flutter

# أو تحميل من
# https://docs.flutter.dev/get-started/install

# التحقق من التثبيت
flutter doctor
```

### الخطوة 2 — إنشاء مشروع نظيف
```bash
# أنشئ مشروع Flutter جديد
flutter create kayan_demo --platforms=ios,android

# ادخل المجلد
cd kayan_demo
```

### الخطوة 3 — إضافة التبعية الوحيدة
```bash
flutter pub add go_router
```

**أو يدوياً في `pubspec.yaml`:**
```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0
```
```bash
flutter pub get
```

### الخطوة 4 — نسخ الديمو
```bash
# انسخ ملف الديمو محل main.dart
cp /path/to/kayan_demo_app.dart lib/main.dart

# ملاحظة: الملف يحتوي على void main() مدمج
# لا تحتاج لأي ملف آخر
```

### الخطوة 5 — التشغيل
```bash
# iPhone Simulator
flutter run -d simulator

# Android Emulator
flutter run -d emulator

# جهاز iOS حقيقي (يحتاج Apple Developer Account)
flutter run -d [device-id]

# معرفة الأجهزة المتصلة
flutter devices
```

### الخطوة 6 — بناء APK للأندرويد (للتوزيع)
```bash
# APK للتثبيت المباشر
flutter build apk --release

# الملف يكون في:
# build/app/outputs/flutter-apk/app-release.apk

# أرسله للممول عبر WhatsApp أو Google Drive
```

### الخطوة 7 — بناء IPA للآيفون
```bash
# يحتاج macOS + Xcode
flutter build ipa --release

# الملف في: build/ios/ipa/
```

---

## ═══════════════════════════════════
## 🅱️ تشغيل المشروع الكامل
## ═══════════════════════════════════

### المتطلبات الإضافية
```
Firebase Project (مجاني)
Google Maps API Key
Android SDK + Android Studio
Xcode (للـ iOS - macOS فقط)
```

### الخطوة 1 — استنساخ/نسخ الملفات

```bash
# المجلد الجذر
mkdir kayan && cd kayan
mkdir mobile && cd mobile

# انسخ كل الملفات بهذا الهيكل:
```

```
mobile/
├── pubspec.yaml           ← من الديمو (مرفق أدناه المبسّط)
├── lib/
│   ├── main.dart          ← نقطة الدخول
│   ├── app.dart
│   ├── core/
│   │   └── theme/
│   │       ├── app_colors.dart
│   │       ├── app_gradients.dart
│   │       ├── app_text_styles.dart
│   │       ├── app_border_radius.dart
│   │       ├── app_spacing.dart
│   │       └── app_theme.dart
│   ├── routing/
│   │   ├── app_router.dart
│   │   └── app_routes.dart
│   └── features/
│       ├── [كل المجلدات والشاشات]
│       └── ...
└── assets/
    ├── images/  (فارغ — الصور تُحمّل من الإنترنت)
    ├── icons/
    ├── lottie/
    └── fonts/
```

### الخطوة 2 — إنشاء مجلدات الـ assets

```bash
mkdir -p assets/{images,icons,lottie,svg,fonts}

# هذا ضروري لأن pubspec.yaml يشير إليها
touch assets/images/.gitkeep
touch assets/icons/.gitkeep
touch assets/lottie/.gitkeep
touch assets/fonts/.gitkeep
```

### الخطوة 3 — pubspec.yaml المبسّط (للمشروع الكامل)

```yaml
name: kayan
description: KAYAN Super App
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.3.0 <4.0.0'
  flutter: '>=3.19.0'

dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Navigation
  go_router: ^14.0.0

  # State Management
  flutter_riverpod: ^2.5.1

  # Network
  dio: ^5.4.3
  cached_network_image: ^3.3.1

  # Local Storage
  shared_preferences: ^2.2.3

  # UI
  shimmer: ^3.0.0
  google_fonts: ^6.2.1
  pinput: ^5.0.0
  smooth_page_indicator: ^1.2.0+3

  # Utilities
  intl: ^0.19.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0

flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
    - assets/lottie/
    - assets/fonts/
```

### الخطوة 4 — main.dart للمشروع الكامل

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:          Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor:Color(0xFF060F1E),
  ));

  runApp(const ProviderScope(child: KayanApp()));
}
```

### الخطوة 5 — تثبيت الـ packages

```bash
flutter pub get

# إذا ظهر خطأ في versions:
flutter pub upgrade
```

### الخطوة 6 — التشغيل

```bash
# تشغيل مع logs
flutter run --debug

# تشغيل بدون Firebase أخطاء (إذا لم تضفه)
flutter run --dart-define=SKIP_FIREBASE=true
```

---

## 🔧 حل المشاكل الشائعة

### المشكلة 1: `flutter: command not found`
```bash
# أضف Flutter لـ PATH
export PATH="$PATH:$HOME/flutter/bin"
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.zshrc
source ~/.zshrc
```

### المشكلة 2: `No devices found`
```bash
# iOS
open -a Simulator  # فتح iOS Simulator

# Android
# افتح Android Studio → AVD Manager → تشغيل Emulator
```

### المشكلة 3: `Package not found`
```bash
flutter pub cache repair
flutter pub get
```

### المشكلة 4: `assets not found`
```bash
# تأكد من وجود المجلدات
ls assets/
# يجب أن يكون: images/ icons/ lottie/ fonts/

# إنشاء المجلدات الناقصة
mkdir -p assets/{images,icons,lottie,fonts}
flutter pub get
```

### المشكلة 5: `Dart version incompatibility`
```bash
# تحديث Flutter
flutter upgrade

# أو تعديل pubspec.yaml
environment:
  sdk: '>=3.0.0 <4.0.0'   # توسيع النطاق
```

### المشكلة 6: iOS Build يفشل
```bash
cd ios
pod install --repo-update
cd ..
flutter run
```

### المشكلة 7: Android Gradle Error
```bash
cd android
./gradlew clean
cd ..
flutter run
```

---

## 📦 تجميع ملفات الديمو في ZIP واحد

```bash
# من مجلد kayan_demo/ بعد إنشائه
zip -r kayan_demo_complete.zip . \
  --exclude "*.git*" \
  --exclude ".dart_tool*" \
  --exclude "build/*" \
  --exclude ".flutter-plugins*"

# الحجم المتوقع: ~500KB فقط
echo "Size: $(du -sh kayan_demo_complete.zip | cut -f1)"
```

---

## 🚀 الطريقة السريعة جداً — Script واحد

احفظ هذا الـ script كـ `setup_kayan.sh` وشغّله:

```bash
#!/bin/bash

echo "🚀 KAYAN Demo Setup Script"
echo "=========================="

# 1. إنشاء المشروع
echo "📁 Creating Flutter project..."
flutter create kayan_demo --platforms=ios,android
cd kayan_demo

# 2. إضافة التبعية
echo "📦 Adding go_router..."
flutter pub add go_router

# 3. نسخ الديمو (عدّل المسار حسب مكان الملف)
echo "📋 Copying demo file..."
DEMO_PATH="$HOME/Downloads/kayan_demo_app.dart"
if [ -f "$DEMO_PATH" ]; then
  cp "$DEMO_PATH" lib/main.dart
  echo "✅ Demo file copied"
else
  echo "⚠️  ضع ملف kayan_demo_app.dart في مجلد Downloads"
  echo "   ثم شغّل: cp ~/Downloads/kayan_demo_app.dart lib/main.dart"
fi

# 4. تثبيت packages
echo "⚡ Running pub get..."
flutter pub get

# 5. تشغيل
echo ""
echo "✅ READY! Running KAYAN Demo..."
echo "💡 Press 'R' to restart | 'q' to quit"
echo ""
flutter run

```

```bash
# تشغيل الـ script
chmod +x setup_kayan.sh
./setup_kayan.sh
```

---

## 📱 اختصارات أثناء التطوير

| الاختصار | الفعل |
|---------|-------|
| `r` | Hot Reload (تحديث سريع) |
| `R` | Hot Restart (إعادة تشغيل) |
| `q` | إنهاء التطبيق |
| `d` | قائمة الأجهزة |
| `p` | عرض pixel ratios |
| `o` | toggle platform iOS/Android |

---

## 🏆 ملخص — أسرع طريقة ممكنة

```bash
# 5 أوامر فقط لتشغيل الديمو:

flutter create kayan_demo && cd kayan_demo
flutter pub add go_router
cp ~/Downloads/kayan_demo_app.dart lib/main.dart
flutter pub get
flutter run
```

**وقت الإعداد:** ~5 دقائق 🎉

---

*KAYAN Super App v2.0 · Flutter + Dart*
*"التسوق الملكي في الخليج"*
