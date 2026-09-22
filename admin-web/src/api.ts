const API = '';

// Subpath-aware login redirects (beta serves admin at /native/backend).
export const APP_BASE: string = import.meta.env.VITE_BASE_PATH ?? '';
const loginUrl = `${APP_BASE}/login` || '/login';

/** Prefix a public asset path with the deploy base path. */
export function assetUrl(p: string): string {
  return `${APP_BASE}${p}`;
}

function token(): string | null {
  return localStorage.getItem('kp_admin_token');
}

export async function api<T>(path: string, init?: RequestInit): Promise<T> {
  const res = await fetch(API + path, {
    ...init,
    headers: {
      ...(init?.body instanceof FormData ? {} : { 'Content-Type': 'application/json' }),
      ...(token() ? { Authorization: `Bearer ${token()}` } : {}),
      ...init?.headers,
    },
  });
  if (res.status === 401) {
    localStorage.removeItem('kp_admin_token');
    window.location.href = loginUrl;
    throw new Error('Session expired — please log in again');
  }
  const data = (await res.json().catch(() => ({}))) as T & { error?: string };
  if (!res.ok) throw new Error(data.error ?? `Request failed (${res.status})`);
  return data;
}

export async function login(email: string, password: string): Promise<void> {
  const data = await api<{ token: string; user: { roles: string[] } }>('/api/v1/auth/login', {
    method: 'POST',
    body: JSON.stringify({ email, password }),
  });
  if (!data.user.roles.includes('admin') && !data.user.roles.includes('moderator')) {
    throw new Error('This account has no admin/moderator access');
  }
  localStorage.setItem('kp_admin_token', data.token);
}

export function logout() {
  localStorage.removeItem('kp_admin_token');
  window.location.href = loginUrl;
}

export function isLoggedIn(): boolean {
  return !!token();
}
