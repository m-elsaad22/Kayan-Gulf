# توزيع APK + تحكم cPanel + تسجيل Gmail

## ماذا طلبت؟ وكيف نُفِّذ

| طلبك | الحل |
|------|------|
| دخول بالجيميل الآن | زر **Continue with Gmail** + تبويب بريد/كلمة مرور |
| الجوال كما هو لحين OTP | تبويب الجوال باقٍ؛ OTP محلي/لاحق بعد Unifonic |
| APK يشتغل عند العميل | `scripts/build_distribution_apk.sh` (mock + واجهة كاملة) |
| أوقف التطبيق من cPanel | ملف `status.json` / `status.php` على الموقع |
| ربط بموقع ركن التطور | نعم — روابط الحالة و«عن كيان» تشير إلى https://www.rukn-eltatawer.com/ |

## خطواتك على cPanel (مهم قبل توزيع APK)

1. ارفع `hosting/cpanel/kayan/` إلى `public_html/kayan/`  
2. افتح: https://www.rukn-eltatawer.com/kayan/status.json  
3. يجب `"enabled": true`

## بناء APK

```bash
chmod +x scripts/build_distribution_apk.sh
./scripts/build_distribution_apk.sh
# الناتج: dist/kayan-rukn-YYYYMMDD.apk
```

يمكن رفع الـ APK كمرفق تحميل من موقع ركن التطور.

### إيقاف الجميع لاحقًا

- `"enabled": false` في `status.json`، أو  
- حذف المجلد `kayan/` من cPanel، أو  
- `status.php?key=SECRET&action=off`

التطبيق يفحص الحالة عند الإقلاع؛ إذا الملف غير موجود/الخادم لا يرد → **يتوقف** (شاشة إيقاف + رابط الموقع).

## Gmail / Google

1. **الأفضل:** زر Gmail (Google Sign-In) — يحتاج في Google Cloud Console:
   - تطبيق Android بحزمة `sa.kayan.app`
   - بصمة SHA-1 لتوقيع الـ APK
2. **بديل فوري بدون Google Cloud:** تبويب البريد + كلمة مرور (أي Gmail أو بريد، ≥ 6 أحرف في وضع التوزيع المحلي).

الهاتف OTP يبقى للتجربة؛ الإنتاج SMS بعد اشتراك Unifonic.

## هل Nest API على cPanel؟

عادة **لا** (cPanel = PHP). التوزيع الحالي لا يحتاج API على cPanel.  
التحكم = ملفات PHP/JSON فقط. API لاحقًا على VPS إن رغبت.

## ربط الموقع بالتطبيق

نعم ومربوط افتراضيًا:

- `KAYAN_PUBLISHER_URL=https://www.rukn-eltatawer.com/`
- شاشة About + شاشة الإيقاف تفتح الموقع
- يمكنك وضع زر «حمّل التطبيق» على الموقع يشير لملف الـ APK
