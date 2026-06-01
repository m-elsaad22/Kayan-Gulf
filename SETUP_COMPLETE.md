# كيان KAYAN — دليل الإعداد الكامل

## 🚀 خطوات تشغيل التطبيق

### الخطوة 1: تثبيت المتطلبات
```bash
# Flutter 3.19+
flutter --version

# Java 17
java -version

# Android SDK 35
sdkmanager "platform-tools" "platforms;android-35"
```

### الخطوة 2: تنزيل الأصول (الخطوط)
```bash
cd kayan/
chmod +x download_assets.sh
./download_assets.sh
```

**أو يدوياً:**
- [Noto Kufi Arabic](https://fonts.google.com/specimen/Noto+Kufi+Arabic) → ضعها في `assets/fonts/`
- [Inter](https://fonts.google.com/specimen/Inter) → ضعها في `assets/fonts/`

### الخطوة 3: إعداد Firebase
1. اذهب لـ [Firebase Console](https://console.firebase.google.com)
2. أنشئ مشروع جديد: **kayan-superapp**
3. أضف تطبيق Android: `sa.kayan.app`
4. حمّل `google-services.json` → ضعه في `android/app/`
5. فعّل: Authentication, Firestore, Storage, Messaging, Crashlytics

### الخطوة 4: إعداد Google Maps
1. اذهب لـ [Google Cloud Console](https://console.cloud.google.com)
2. فعّل **Maps SDK for Android**
3. أنشئ API Key
4. في `android/app/src/main/AndroidManifest.xml` استبدل:
   ```
   YOUR_MAPS_API_KEY → مفتاحك الحقيقي
   ```

### الخطوة 5: إعداد Stripe (المدفوعات)
في `lib/features/checkout/presentation/screens/payment_screen.dart`:
```dart
Stripe.publishableKey = 'pk_live_YOUR_STRIPE_KEY';
```

### الخطوة 6: بناء التطبيق
```bash
# تثبيت المكتبات
flutter pub get

# تشغيل على جهاز/محاكي
flutter run

# بناء APK للاختبار
flutter build apk --debug

# بناء APK للنشر
flutter build apk --release

# بناء AAB للـ Play Store
flutter build appbundle --release
```

## 📁 هيكل المشروع

```
kayan/
├── lib/
│   ├── main.dart                    # نقطة الدخول
│   ├── app.dart                     # KayanApp root widget
│   ├── core/
│   │   ├── theme/                   # الألوان، الخطوط، الثيم
│   │   └── di/                      # Dependency Injection
│   ├── features/
│   │   ├── splash/                  # شاشة الـ Splash
│   │   ├── onboarding/              # الـ Onboarding
│   │   ├── auth/                    # تسجيل الدخول (OTP)
│   │   ├── home/                    # الصفحة الرئيسية
│   │   ├── ecommerce/               # المتجر الإلكتروني
│   │   ├── services/                # الخدمات المنزلية
│   │   ├── classifieds/             # الإعلانات المبوبة
│   │   ├── cart/                    # السلة
│   │   ├── checkout/                # الدفع
│   │   ├── orders/                  # الطلبات
│   │   ├── chat/                    # الدردشة
│   │   ├── profile/                 # الحساب الشخصي
│   │   ├── wallet/                  # المحفظة
│   │   └── notifications/           # الإشعارات
│   ├── routing/
│   │   ├── app_router.dart          # GoRouter config
│   │   ├── app_routes.dart          # Route constants
│   │   ├── main_shell.dart          # Bottom navigation
│   │   └── route_guards.dart        # Auth guards
│   └── shared/
│       ├── providers/               # Riverpod providers
│       ├── services/                # Local storage, notifications
│       └── widgets/                 # Shared widgets
├── android/                         # Android native (جاهز)
├── assets/
│   ├── fonts/                       # Inter + NotoKufiArabic
│   ├── images/                      # Onboarding images, banners
│   ├── icons/                       # SVG icons
│   └── lottie/                      # Lottie animations
└── pubspec.yaml                     # Dependencies
```

## ⚙️ متغيرات البيئة (Build Flavors)

```bash
# Debug (بدون API keys حقيقية)
flutter run --dart-define=ENV=debug

# Staging
flutter build apk --dart-define=ENV=staging \
  --dart-define=API_URL=https://staging-api.kayan.sa \
  --dart-define=STRIPE_KEY=pk_test_XXX \
  --dart-define=MAPS_KEY=YOUR_KEY

# Production
flutter build appbundle --release \
  --dart-define=ENV=production \
  --dart-define=API_URL=https://api.kayan.sa \
  --dart-define=STRIPE_KEY=pk_live_XXX \
  --dart-define=MAPS_KEY=YOUR_KEY
```

## 🔧 حل المشاكل الشائعة

### خطأ: Font file not found
```bash
# تأكد من وجود الخطوط
ls -la assets/fonts/
# يجب أن ترى: Inter-*.ttf و NotoKufiArabic-*.ttf
```

### خطأ: google-services.json not found
```bash
# ضع الملف في المكان الصحيح
ls android/app/google-services.json
```

### خطأ: Gradle build failed
```bash
# نظّف وأعد البناء
flutter clean
flutter pub get
cd android && ./gradlew clean && cd ..
flutter build apk --debug
```

### خطأ: SDK not found
```bash
# في android/local.properties
echo "sdk.dir=/path/to/your/Android/Sdk" >> android/local.properties
echo "flutter.sdk=/path/to/your/flutter" >> android/local.properties
```
