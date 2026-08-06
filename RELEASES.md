# KAYAN — روابط تحميل الإصدارات (ZIP)

كل مرحلة تُرفَع كملف ZIP يحتوي على `kayan-app.apk` + `README.txt`.

| المرحلة | الوصف | رابط التحميل |
|---------|--------|--------------|
| phase-1-delivery | طلبات + Hub | [kayan-phase-1-delivery-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-1-delivery-1.0.0/kayan-phase-1-delivery-1.0.0.zip) |
| phase-2-entry | شاشات الدخول | [kayan-phase-2-entry-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-2-entry-1.0.0/kayan-phase-2-entry-1.0.0.zip) |
| phase-3-services | الخدمات المنزلية | [kayan-phase-3-services-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-3-services-1.0.0/kayan-phase-3-services-1.0.0.zip) |
| phase-4-shop | المتجر (59-sh-dashboard) | [kayan-phase-4-shop-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-4-shop-1.0.0/kayan-phase-4-shop-1.0.0.zip) |
| phase-5-classifieds | الإعلانات (113-cl-dashboard) | [kayan-phase-5-classifieds-1.0.0.zip](https://github.com/m-elsaad22/Kayan-Gulf/releases/download/phase-5-classifieds-1.0.0/kayan-phase-5-classifieds-1.0.0.zip) |

## كيف يُنشأ الـ ZIP؟

```bash
chmod +x scripts/package_phase_zip.sh
./scripts/package_phase_zip.sh phase-4-shop 1.0.0
```

الملف الناتج: `dist/kayan-phase-4-shop-1.0.0.zip`

أو عبر GitHub Actions: workflow **Phase Release ZIP** (يدوي).
