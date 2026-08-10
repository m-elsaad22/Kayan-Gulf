'use client';

import { FormEvent, useEffect, useState } from 'react';
import { AdminShell } from '@/components/AdminShell';
import { AppControl, adminApi, getRole } from '@/lib/api';
import { isPrivilegedAdmin } from '@/lib/roles';

export default function AppControlPage() {
  const [form, setForm] = useState<AppControl | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [saved, setSaved] = useState<string | null>(null);
  const privileged = isPrivilegedAdmin(getRole());

  useEffect(() => {
    adminApi
      .appControl()
      .then(setForm)
      .catch((e: Error) => setError(e.message));
  }, []);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    if (!form || !privileged) return;
    setError(null);
    setSaved(null);
    try {
      const next = await adminApi.updateAppControl({
        enabled: form.enabled,
        maintenanceMode: form.maintenanceMode,
        forceUpdate: form.forceUpdate,
        messageAr: form.messageAr,
        messageEn: form.messageEn,
        minVersion: form.minVersion,
        latestVersion: form.latestVersion,
        supportUrl: form.supportUrl,
        websiteUrl: form.websiteUrl,
        apkUrl: form.apkUrl,
        playStoreUrl: form.playStoreUrl,
      });
      setForm(next);
      setSaved('تم الحفظ — التطبيق سيلتقط الحالة من واجهة API.');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'save_failed');
    }
  }

  if (!form) {
    return (
      <AdminShell title="تحكم التطبيق">
        {error ? <p className="error">{error}</p> : <p className="muted">جارٍ التحميل…</p>}
      </AdminShell>
    );
  }

  return (
    <AdminShell title="تحكم التطبيق (Kill Switch)">
      {error && <p className="error">{error}</p>}
      {saved && <p className="muted">{saved}</p>}
      <form className="panel" onSubmit={onSubmit}>
        <p className="muted">
          السلطة الأساسية: قاعدة البيانات عبر API. ملف cPanel هو طوارئ فقط.
        </p>
        <label>
          <input
            type="checkbox"
            checked={form.enabled}
            disabled={!privileged}
            onChange={(e) => setForm({ ...form, enabled: e.target.checked })}
          />{' '}
          التطبيق مفعّل (enabled)
        </label>
        <br />
        <label>
          <input
            type="checkbox"
            checked={form.maintenanceMode}
            disabled={!privileged}
            onChange={(e) =>
              setForm({ ...form, maintenanceMode: e.target.checked })
            }
          />{' '}
          وضع الصيانة
        </label>
        <br />
        <label>
          <input
            type="checkbox"
            checked={form.forceUpdate}
            disabled={!privileged}
            onChange={(e) => setForm({ ...form, forceUpdate: e.target.checked })}
          />{' '}
          فرض التحديث
        </label>
        <div className="field" style={{ marginTop: 12 }}>
          <label>رسالة عربية</label>
          <textarea
            rows={2}
            value={form.messageAr}
            disabled={!privileged}
            onChange={(e) => setForm({ ...form, messageAr: e.target.value })}
          />
        </div>
        <div className="field">
          <label>English message</label>
          <textarea
            rows={2}
            value={form.messageEn}
            disabled={!privileged}
            onChange={(e) => setForm({ ...form, messageEn: e.target.value })}
          />
        </div>
        <div className="field">
          <label>minVersion</label>
          <input
            value={form.minVersion}
            disabled={!privileged}
            onChange={(e) => setForm({ ...form, minVersion: e.target.value })}
          />
        </div>
        <div className="field">
          <label>latestVersion</label>
          <input
            value={form.latestVersion}
            disabled={!privileged}
            onChange={(e) => setForm({ ...form, latestVersion: e.target.value })}
          />
        </div>
        <div className="field">
          <label>supportUrl</label>
          <input
            value={form.supportUrl}
            disabled={!privileged}
            onChange={(e) => setForm({ ...form, supportUrl: e.target.value })}
          />
        </div>
        <div className="field">
          <label>websiteUrl</label>
          <input
            value={form.websiteUrl}
            disabled={!privileged}
            onChange={(e) => setForm({ ...form, websiteUrl: e.target.value })}
          />
        </div>
        <div className="field">
          <label>apkUrl</label>
          <input
            value={form.apkUrl ?? ''}
            disabled={!privileged}
            onChange={(e) =>
              setForm({ ...form, apkUrl: e.target.value || null })
            }
          />
        </div>
        <div className="field">
          <label>playStoreUrl</label>
          <input
            value={form.playStoreUrl ?? ''}
            disabled={!privileged}
            onChange={(e) =>
              setForm({ ...form, playStoreUrl: e.target.value || null })
            }
          />
        </div>
        <p className="muted">آخر تحديث: {new Date(form.updatedAt).toLocaleString('ar-SA')}</p>
        {privileged && (
          <button className="btn" type="submit">
            حفظ التحكم
          </button>
        )}
      </form>
    </AdminShell>
  );
}
