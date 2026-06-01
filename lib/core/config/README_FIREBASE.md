# Firebase Setup — KAYAN

## الخطوات المطلوبة قبل البناء:

### 1. إنشاء مشروع Firebase
- اذهب إلى https://console.firebase.google.com
- أنشئ مشروع جديد باسم "kayan-superapp"

### 2. إضافة تطبيق Android
- Application ID: `sa.kayan.app`
- حمّل `google-services.json` وضعه في `android/app/`

### 3. تثبيت FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
flutterfire configure --project=kayan-superapp
```
هذا سيولّد `lib/firebase_options.dart` تلقائياً.

### 4. تفعيل Firebase في main.dart
بعد توليد firebase_options.dart، أضف في main.dart:
```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// في بداية main():
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### الخدمات المطلوب تفعيلها في Firebase Console:
- Authentication → Phone Number
- Cloud Messaging (FCM)
- Analytics
- Crashlytics
