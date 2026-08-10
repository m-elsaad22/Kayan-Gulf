# رفع تحكم التطبيق على cPanel — ركن التطور

الهدف: التطبيق على جوالات العملاء يتحقق عند كل فتح من ملف على موقعك.  
إذا أوقفت الملف أو حذفته، **يتوقف التطبيق عند الجميع**.

## 1) ارفع الملفات

من هذا المستودع انسخ المجلد:

```
hosting/cpanel/kayan/
  status.json
  status.php
```

إلى استضافة الموقع:

```
public_html/kayan/status.json
public_html/kayan/status.php
```

على نطاق: **https://www.rukn-eltatawer.com/**

تحقق من المتصفح:
- https://www.rukn-eltatawer.com/kayan/status.json
- https://www.rukn-eltatawer.com/kayan/status.php

يجب أن ترى `"enabled": true`.

## 2) إيقاف التطبيق عن الجميع

**طريقة أ:** عدّل `status.json`:

```json
{ "enabled": false, "messageAr": "التطبيق متوقف مؤقتًا.", ... }
```

**طريقة ب:** احذف مجلد `kayan/` أو الملف — التطبيق مصمَّم **fail-closed** (عدم الوصول = إيقاف).

**طريقة ج (PHP):** بعد تغيير `$secret` داخل `status.php`:

```
https://www.rukn-eltatawer.com/kayan/status.php?key=YOUR_SECRET&action=off
https://www.rukn-eltatawer.com/kayan/status.php?key=YOUR_SECRET&action=on
```

## 3) ربط التطبيق بالموقع

الـ APK التوزيعي يُبنى بهذه الروابط افتراضيًا:

| المفتاح | القيمة |
|---------|--------|
| `KAYAN_STATUS_URL` | `https://www.rukn-eltatawer.com/kayan/status.json` |
| `KAYAN_PUBLISHER_URL` | `https://www.rukn-eltatawer.com/` |

يمكن استخدام `status.php` بدلًا من `status.json` إذا فضّلت التحكم بـ PHP.

## 4) ملاحظات مهمة

- هذا **ليس** استضافة لـ NestJS API على cPanel (Node أصعب). الـ APK التوزيعي يعمل ببيانات محلية (mock) + تسجيل Gmail على الجهاز، والتحكم بالإيقاف من الموقع.
- لتشغيل API حقيقي لاحقًا تحتاج VPS/Node أو استضافة تدعم Node، ثم أعد بناء الـ APK بـ `KAYAN_USE_MOCK_DATA=false`.
- زر Google يحتاج إعداد SHA-1 في Google Cloud لـ `sa.kayan.app`؛ بديل فوري: تبويب **Gmail / بريد + كلمة مرور**.
