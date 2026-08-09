'use client';

import Link from 'next/link';
import { usePathname, useRouter } from 'next/navigation';
import { useEffect, useState } from 'react';
import { clearSession, getRole, getToken } from '@/lib/api';

const links = [
  { href: '/dashboard', label: 'لوحة التحكم' },
  { href: '/products', label: 'المنتجات' },
  { href: '/orders', label: 'الطلبات' },
  { href: '/services', label: 'الخدمات' },
  { href: '/bookings', label: 'الحجوزات' },
  { href: '/ads', label: 'الإعلانات' },
  { href: '/users', label: 'المستخدمون' },
];

export function AdminShell({
  title,
  children,
}: {
  title: string;
  children: React.ReactNode;
}) {
  const pathname = usePathname();
  const router = useRouter();
  const [ready, setReady] = useState(false);

  useEffect(() => {
    const token = getToken();
    const role = getRole();
    if (!token || role !== 'admin') {
      router.replace('/login');
      return;
    }
    setReady(true);
  }, [router]);

  if (!ready) {
    return (
      <div className="login-wrap">
        <p className="muted">جارٍ التحقق من الجلسة…</p>
      </div>
    );
  }

  return (
    <div className="shell" dir="rtl">
      <aside className="sidebar">
        <p className="brand">
          كيان <span>Admin</span>
        </p>
        <p className="muted" style={{ margin: '0 8px' }}>
          لوحة إدارة ويب
        </p>
        <nav className="nav">
          {links.map((l) => (
            <Link
              key={l.href}
              href={l.href}
              className={pathname === l.href ? 'active' : undefined}
            >
              {l.label}
            </Link>
          ))}
        </nav>
        <button
          className="btn secondary"
          style={{ marginTop: 24, width: '100%' }}
          onClick={() => {
            clearSession();
            router.replace('/login');
          }}
        >
          تسجيل الخروج
        </button>
      </aside>
      <main className="main">
        <div className="topbar">
          <div>
            <h1>{title}</h1>
            <p className="muted">إدارة مركزية — ليست داخل التطبيق</p>
          </div>
        </div>
        {children}
      </main>
    </div>
  );
}
