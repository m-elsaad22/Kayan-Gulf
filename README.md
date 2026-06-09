# KAYAN Super App — Flutter

تطبيق سوبر آب للخليج العربي يجمع بين التسوق الإلكتروني، الخدمات المنزلية، والإعلانات المبوّبة.

## التقنيات المستخدمة

| التقنية | الغرض |
|---------|-------|
| Flutter 3.19+ | إطار العمل |
| Riverpod 2.x | إدارة الحالة |
| GoRouter 13.x | التنقل |
| Dio 5.x | طلبات الشبكة |
| Hive | قاعدة البيانات المحلية |
| Firebase | الإشعارات والتحليلات |
| Google Fonts | الخطوط (Inter + Noto Kufi Arabic) |

## قبل تشغيل المشروع

### 1. إعداد Firebase (مطلوب)
```bash
# ثبّت FlutterFire CLI
dart pub global activate flutterfire_cli

# أنشئ مشروع في https://console.firebase.google.com
# ثم:
flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
```

### 2. تشغيل المشروع
```bash
flutter pub get
flutter run
```

## هيكل المشروع

```
lib/
├── main.dart              # نقطة الدخول
├── app.dart               # Root Widget
├── core/
│   ├── constants/         # API constants
│   ├── di/                # Dependency Injection
│   ├── errors/            # App exceptions
│   ├── network/           # Dio client + token storage
│   ├── services/          # Firebase, Payment, Socket
│   └── theme/             # Colors, typography, theme
├── features/
│   ├── auth/              # Phone OTP authentication
│   ├── cart/              # Shopping cart
│   ├── chat/              # Real-time messaging
│   ├── checkout/          # Checkout + payment
│   ├── classifieds/       # Classified ads
│   ├── ecommerce/         # Products, search, vendors
│   ├── home/              # Home screen
│   ├── notifications/     # Push notifications
│   ├── onboarding/        # First-launch onboarding
│   ├── orders/            # Order management
│   ├── profile/           # User profile
│   ├── services/          # Home services + booking
│   ├── settings/          # App settings
│   ├── splash/            # Splash screen
│   └── wallet/            # Digital wallet
├── routing/               # GoRouter configuration
└── shared/                # Providers, widgets, services
```

## دليل المستخدم — User Guide

### وضع العرض الفاتح / الداكن (Light / Dark Mode)

| العربية | English |
|---------|---------|
| افتح **الملف الشخصي** → **الإعدادات** → **وضع العرض** | Open **Profile** → **Settings** → **Theme** |
| اختر: **فاتح**، **داكن**، أو **تلقائي** (يتبع نظام الجهاز) | Choose: **Light**, **Dark**, or **System** |
| يُحفظ اختيارك تلقائياً في الجهاز | Your preference is saved automatically |

المسار في التطبيق: `/profile/settings/theme`

---

### اللغة العربية / English

| العربية | English |
|---------|---------|
| افتح **الملف الشخصي** → **الإعدادات** → **اللغة** | Open **Profile** → **Settings** → **Language** |
| اختر **العربية** أو **English** | Select **Arabic** or **English** |
| يتبدّل اتجاه الواجهة تلقائياً (RTL للعربية، LTR للإنجليزية) | UI direction switches automatically (RTL for Arabic, LTR for English) |

المسار في التطبيق: `/profile/settings/language`

---

### لوحة تحكم المشرف (Admin Panel) — مخفية

لوحة إدارة المحتوى (CMS) مخفية عن المستخدمين العاديين.

| الخطوة | التفاصيل |
|--------|----------|
| 1 | افتح **الملف الشخصي** (Profile) |
| 2 | انقر **5 مرات بسرعة** على نص **رقم الإصدار** في أسفل الشاشة |
| 3 | ستُفتح شاشة تسجيل الدخول للمشرف |
| 4 | أدخل بيانات الدخول: **اسم المستخدم:** `admin` — **كلمة المرور:** `kayan@admin` |

**English:** Profile → tap the **version text 5 times quickly** → Admin Login → `admin` / `kayan@admin`

---

### إدارة الألوان والخطوط والبانرات من لوحة المشرف

بعد تسجيل الدخول للمشرف، من **لوحة التحكم** يمكنك:

| القسم | الوظيفة |
|-------|---------|
| **إدارة البانرات** | إضافة / تعديل / حذف صور البانر في الصفحة الرئيسية |
| **إعدادات الألوان** | تغيير الألوان الأساسية (أزرق ملكي، بيبسي، ذهبي، فيروزي) — تنعكس فوراً على التطبيق |
| **إعدادات الخطوط** | ضبط حجم العناوين والنصوص والتسميات |
| **إدارة الشاشات** | إظهار / إخفاء شاشات محددة |
| **إدارة المنتجات** | إضافة وتعديل وحذف منتجات المتجر (21 فئة) |
| **إدارة الخدمات** | إدارة خدمات المنزل |
| **إدارة الإعلانات** | الموافقة / الرفض / الحذف |
| **الإعدادات العامة** | اسم التطبيق، رابط الشعار، نص عرض الترحيب، بيانات التواصل |

جميع التغييرات تُحفظ محلياً عبر `SharedPreferences` وتنعكس مباشرة في التطبيق.

---

## تحميل APK — Download Release APK

| المصدر | الرابط |
|--------|--------|
| **GitHub Releases** | [Releases](https://github.com/m-elsaad22/Kayan-Gulf/releases) — ملف `app-release.apk` |
| **GitHub Actions** | [Actions → Build Release APK](https://github.com/m-elsaad22/Kayan-Gulf/actions/workflows/build_apk.yml) — artifact `kayan-release-apk` |

لبناء APK محلياً:

```bash
flutter pub get
flutter build apk --release
# المخرجات: build/app/outputs/flutter-apk/app-release.apk
```

---

## للنشر على Google Play

1. أنشئ release keystore:
```bash
keytool -genkey -v -keystore kayan-release.jks -keyalg RSA -keysize 2048 -validity 10000 -alias kayan
```

2. أضف في `android/local.properties` (لا ترفعه لـ Git):
```properties
storeFile=../kayan-release.jks
storePassword=YOUR_STORE_PASSWORD
keyAlias=kayan
keyPassword=YOUR_KEY_PASSWORD
```

3. فعّل signing في `android/app/build.gradle` (راجع التعليقات في الملف)

4. بناء الـ App Bundle:
```bash
flutter build appbundle --release
```
