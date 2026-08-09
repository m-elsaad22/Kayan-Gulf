const API_BASE =
  process.env.NEXT_PUBLIC_KAYAN_API_BASE_URL ?? 'http://127.0.0.1:3000/v1';

const TOKEN_KEY = 'kayan_admin_token';
const ROLE_KEY = 'kayan_admin_role';

export function getToken(): string | null {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem(TOKEN_KEY);
}

export function setSession(token: string, role: string) {
  localStorage.setItem(TOKEN_KEY, token);
  localStorage.setItem(ROLE_KEY, role);
}

export function clearSession() {
  localStorage.removeItem(TOKEN_KEY);
  localStorage.removeItem(ROLE_KEY);
}

export function getRole(): string | null {
  if (typeof window === 'undefined') return null;
  return localStorage.getItem(ROLE_KEY);
}

async function request<T>(
  path: string,
  options: RequestInit = {},
): Promise<T> {
  const headers = new Headers(options.headers);
  headers.set('Accept', 'application/json');
  if (options.body && !headers.has('Content-Type')) {
    headers.set('Content-Type', 'application/json');
  }
  const token = getToken();
  if (token) headers.set('Authorization', `Bearer ${token}`);

  const res = await fetch(`${API_BASE}${path}`, {
    ...options,
    headers,
  });

  const data = (await res.json().catch(() => ({}))) as T & {
    message?: string;
    statusCode?: number;
  };

  if (!res.ok) {
    const message =
      typeof data.message === 'string'
        ? data.message
        : `request_failed_${res.status}`;
    throw new Error(message);
  }
  return data;
}

export async function login(email: string, password: string) {
  return request<{
    userId: string;
    accessToken: string;
    role: string;
  }>('/auth/login', {
    method: 'POST',
    body: JSON.stringify({ email, password }),
  });
}

export const adminApi = {
  stats: () => request<AdminStats>('/admin/stats'),
  users: () => request<{ items: AdminUser[] }>('/admin/users'),
  products: () => request<{ items: AdminProduct[] }>('/admin/products'),
  orders: () => request<{ items: AdminOrder[] }>('/admin/orders'),
  services: () => request<{ items: AdminService[] }>('/admin/services'),
  bookings: () => request<{ items: AdminBooking[] }>('/admin/bookings'),
  ads: () => request<{ items: AdminAd[] }>('/admin/ads'),
  setOrderStatus: (id: string, status: string) =>
    request(`/admin/orders/${id}/status`, {
      method: 'PATCH',
      body: JSON.stringify({ status }),
    }),
  setProductStatus: (id: string, status: string) =>
    request(`/admin/products/${id}/status`, {
      method: 'PATCH',
      body: JSON.stringify({ status }),
    }),
  setAdStatus: (id: string, status: string) =>
    request(`/admin/ads/${id}/status`, {
      method: 'PATCH',
      body: JSON.stringify({ status }),
    }),
};

export type AdminStats = {
  counts: {
    users: number;
    products: number;
    orders: number;
    services: number;
    bookings: number;
    ads: number;
    banners: number;
  };
  recentOrders: Array<{
    id: string;
    status: string;
    total: number;
    currency: string;
    createdAt: string;
    paymentMethod: string;
  }>;
};

export type AdminUser = {
  id: string;
  email: string | null;
  phone: string | null;
  name: string | null;
  role: string;
  isProfileComplete: boolean;
  createdAt: string;
};

export type AdminProduct = {
  id: string;
  slug: string;
  nameAr: string;
  name: string;
  price: number;
  stock: number;
  status: string;
  isFeatured: boolean;
};

export type AdminOrder = {
  id: string;
  status: string;
  total: number;
  currency: string;
  paymentMethod: string;
  itemCount: number;
  userEmail: string | null;
  userName: string | null;
  createdAt: string;
};

export type AdminService = {
  id: string;
  slug: string;
  nameAr: string;
  name: string;
  basePrice: number;
  totalBookings: number;
  isAvailable: boolean;
};

export type AdminBooking = {
  id: string;
  bookingNumber: string;
  status: string;
  price: number;
  serviceNameAr: string;
  userEmail: string | null;
  scheduledAt: string;
};

export type AdminAd = {
  status: string;
  daysLeft: number;
  ad: {
    id: string;
    slug: string;
    title: string;
    city: string;
    price: number | null;
  };
};
