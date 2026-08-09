'use client';

import { FormEvent, useState } from 'react';
import { useRouter } from 'next/navigation';
import { login, setSession } from '@/lib/api';

export default function LoginPage() {
  const router = useRouter();
  const [email, setEmail] = useState('admin@kayan.app');
  const [password, setPassword] = useState('kayan@admin');
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  async function onSubmit(e: FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    try {
      const res = await login(email.trim(), password);
      if (res.role !== 'admin') {
        throw new Error('admin_required');
      }
      setSession(res.accessToken, res.role);
      router.replace('/dashboard');
    } catch (err) {
      setError(err instanceof Error ? err.message : 'login_failed');
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="login-wrap" dir="rtl">
      <form className="login-card" onSubmit={onSubmit}>
        <h1>كيان Admin</h1>
        <p className="muted">لوحة إدارة ويب — منفصلة عن التطبيق</p>
        <div className="field">
          <label htmlFor="email">البريد</label>
          <input
            id="email"
            type="email"
            value={email}
            onChange={(e) => setEmail(e.target.value)}
            required
          />
        </div>
        <div className="field">
          <label htmlFor="password">كلمة المرور</label>
          <input
            id="password"
            type="password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            required
          />
        </div>
        {error && <p className="error">{error}</p>}
        <button className="btn" type="submit" disabled={loading} style={{ width: '100%' }}>
          {loading ? '...' : 'دخول'}
        </button>
        <p className="muted" style={{ marginTop: 16, fontSize: '0.85rem' }}>
          الافتراضي: admin@kayan.app / kayan@admin
        </p>
      </form>
    </div>
  );
}
