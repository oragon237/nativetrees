// API client for the Katutubong Puno backend.
// Local dev: relative paths (Vite proxies /api to :4000).
// Beta/prod builds: set VITE_API_BASE=https://api.yourdomain.com
// (see BETA-DEPLOY.md; also used by the Capacitor APK).
const API_BASE: string = import.meta.env.VITE_API_BASE ?? '';

const TOKEN_KEY = 'kp_token';

export function getToken(): string | null {
  return localStorage.getItem(TOKEN_KEY);
}

export function setToken(t: string | null) {
  if (t) localStorage.setItem(TOKEN_KEY, t);
  else localStorage.removeItem(TOKEN_KEY);
}

export async function api<T>(path: string, init?: RequestInit): Promise<T> {
  const headers: Record<string, string> = {};
  if (!(init?.body instanceof FormData)) headers['Content-Type'] = 'application/json';
  const token = getToken();
  if (token) headers['Authorization'] = `Bearer ${token}`;
  const res = await fetch(API_BASE + path, { ...init, headers: { ...headers, ...init?.headers } });
  const data = (await res.json().catch(() => ({}))) as T & { error?: string };
  if (!res.ok) throw new Error(data.error ?? `Request failed (${res.status})`);
  return data;
}

export interface SpeciesCard {
  id: string;
  primary_name: string | null;
  scientific_name: string;
  growth_form: string | null;
  native_status: string;
  primary_photo: string | null;
  purposes: string[];
  conditions: string[];
  matchReasons?: string[];
}

export function photoUrl(url: string | null): string {
  if (!url) return '';
  if (/^https?:\/\//.test(url)) return url;
  return `${API_BASE}${url}`;
}

export function esc(s: unknown): string {
  return String(s ?? '').replace(/[&<>"']/g, (c) => {
    const map: Record<string, string> = { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;' };
    return map[c];
  });
}
