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
