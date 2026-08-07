# KAYAN — روابط تحميل الإصدارات (ZIP)

كل مرحلة تُرفَع كملف ZIP يحتوي على `kayan-app.apk` + `README.txt`.

| المرحلة | الوصف | رابط التحميل |
|---------|--------|--------------|
| phase-1-delivery | طلبات + Hub | [kayan-phase-1-delivery-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-1-delivery-1.0.0/kayan-phase-1-delivery-1.0.0.zip) |
| phase-2-entry | شاشات الدخول | [kayan-phase-2-entry-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-2-entry-1.0.0/kayan-phase-2-entry-1.0.0.zip) |
| phase-3-services | الخدمات المنزلية | [kayan-phase-3-services-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-3-services-1.0.0/kayan-phase-3-services-1.0.0.zip) |
| phase-4-shop | المتجر (59-sh-dashboard) | [kayan-phase-4-shop-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-4-shop-1.0.0/kayan-phase-4-shop-1.0.0.zip) |
| phase-5-classifieds | الإعلانات (113-cl-dashboard) | [kayan-phase-5-classifieds-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-5-classifieds-1.0.0/kayan-phase-5-classifieds-1.0.0.zip) |
| phase-6-classifieds-screens | تفاصيل + إضافة + فلاتر | [kayan-phase-6-classifieds-screens-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-6-classifieds-screens-1.0.0/kayan-phase-6-classifieds-screens-1.0.0.zip) |
| phase-7-classifieds-chat | إعلاناتي + محفوظة + محادثات | [kayan-phase-7-classifieds-chat-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-7-classifieds-chat-1.0.0/kayan-phase-7-classifieds-chat-1.0.0.zip) |
| phase-8-classifieds-extra | أقسام + إشعارات + تمييز | [kayan-phase-8-classifieds-extra-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-8-classifieds-extra-1.0.0/kayan-phase-8-classifieds-extra-1.0.0.zip) |
| phase-9-classifieds-browse | تصفح + إحصائيات + بلاغ | [kayan-phase-9-classifieds-browse-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-9-classifieds-browse-1.0.0/kayan-phase-9-classifieds-browse-1.0.0.zip) |
| phase-10-classifieds-similar | مشابهة + بائع + مميزة | [kayan-phase-10-classifieds-similar-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-10-classifieds-similar-1.0.0/kayan-phase-10-classifieds-similar-1.0.0.zip) |
| phase-11-classifieds-manage | إدارة + تواصل + تعديل | [kayan-phase-11-classifieds-manage-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-11-classifieds-manage-1.0.0/kayan-phase-11-classifieds-manage-1.0.0.zip) |
| phase-12-14-batch | طلبات إضافية + متجر + خدمات | [kayan-phase-12-14-batch-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-12-14-batch-1.0.0/kayan-phase-12-14-batch-1.0.0.zip) |
| phase-15-17-batch | متجر كامل + خدمات حجز | [kayan-phase-15-17-batch-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-15-17-batch-1.0.0/kayan-phase-15-17-batch-1.0.0.zip) |
| phase-18-20-final | حسابي + إعدادات + دعم | [kayan-phase-18-20-final-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-18-20-final-1.0.0/kayan-phase-18-20-final-1.0.0.zip) |
| phase-21-profile-polish | تلميع الملف + المحفظة + الأمان | [kayan-phase-21-profile-polish-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-21-profile-polish-1.0.0/kayan-phase-21-profile-polish-1.0.0.zip) |

## كيف يُنشأ الـ ZIP؟

```bash
chmod +x scripts/package_phase_zip.sh
./scripts/package_phase_zip.sh phase-4-shop 1.0.0
```

الملف الناتج: `dist/kayan-phase-4-shop-1.0.0.zip`

أو عبر GitHub Actions: workflow **Phase Release ZIP** (يدوي).
