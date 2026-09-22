import { api } from '../api';
import { toast } from './ui';

interface Draft {
  id: string;
  kind: 'observation' | 'identification';
  payload: Record<string, unknown>;
  createdAt: string;
}

const KEY = 'kp_offline_drafts';

export function loadDrafts(): Draft[] {
  try {
    return JSON.parse(localStorage.getItem(KEY) ?? '[]') as Draft[];
  } catch {
    return [];
  }
}

function saveDrafts(d: Draft[]) {
  localStorage.setItem(KEY, JSON.stringify(d));
}

/** Queue a submission made while offline. Syncs when connectivity returns. */
export function queueDraft(kind: Draft['kind'], payload: Record<string, unknown>) {
  const drafts = loadDrafts();
  drafts.push({ id: `${Date.now()}-${Math.random().toString(36).slice(2)}`, kind, payload, createdAt: new Date().toISOString() });
  saveDrafts(drafts);
  toast('Saved offline — will sync when you are back online');
}

/** Attempt to sync all queued drafts. Returns remaining count. */
export async function syncDrafts(): Promise<number> {
  const drafts = loadDrafts();
  const remaining: Draft[] = [];
  for (const d of drafts) {
    try {
      const path = d.kind === 'observation' ? '/api/v1/observations' : '/api/v1/identifications';
      await api(path, { method: 'POST', body: JSON.stringify(d.payload) });
    } catch {
      remaining.push(d);
    }
  }
  saveDrafts(remaining);
  if (drafts.length && !remaining.length) toast('Offline drafts synced ✓');
  return remaining.length;
}

function isOfflineError(e: unknown): boolean {
  return e instanceof TypeError || (e instanceof Error && /network|fetch|failed/i.test(e.message));
}

export async function onlineOrQueue(
  kind: Draft['kind'],
  payload: Record<string, unknown>,
  send: () => Promise<unknown>,
): Promise<'sent' | 'queued'> {
  if (!navigator.onLine) {
    queueDraft(kind, payload);
    return 'queued';
  }
  try {
    await send();
    return 'sent';
  } catch (e) {
    if (isOfflineError(e)) {
      queueDraft(kind, payload);
      return 'queued';
    }
    throw e;
  }
}

