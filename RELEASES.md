# KAYAN — روابط تحميل الإصدارات (ZIP)

كل مرحلة تُرفَع كملف ZIP يحتوي على `kayan-app.apk` + `README.txt`.

| المرحلة | الوصف | الرابط |
|---------|--------|--------|
| phase-1-delivery | طلبات + Hub | [Releases](https://github.com/m-elsaad22/Kayan-Gulf/releases) — ابحث عن `phase-1-delivery` |
| phase-2-entry | شاشات الدخول | `phase-2-entry-*` |
| phase-3-services | الخدمات المنزلية | `phase-3-services-*` |

## كيف يُنشأ الـ ZIP؟

عند دمج كل مرحلة، يُشغَّل workflow **Phase Release ZIP** على GitHub Actions ويُنشئ Release تلقائياً.

محلياً:

```bash
chmod +x scripts/package_phase_zip.sh
./scripts/package_phase_zip.sh phase-3-services 1.0.0
```

الملف الناتج: `dist/kayan-phase-3-services-1.0.0.zip`
