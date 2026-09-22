import { api, getToken, esc } from '../api';
import { bindAsyncAction, toast } from './ui';

// ---------- Notifications ----------
export async function renderNotifications(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  const data = await api<{ notifications: { id: string; title: string; message: string; read_at: string | null; created_at: string }[] }>(
    '/api/v1/notifications').catch(() => ({ notifications: [] }));
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Notifications</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    ${data.notifications.map((n) => `
      <ion-card data-id="${n.id}" style="${n.read_at ? 'opacity:0.65' : ''}">
        <ion-card-content><b>${esc(n.title)}</b><br/>${esc(n.message)}<br/><small>${esc(n.created_at.slice(0, 10))}</small></ion-card-content>
      </ion-card>`).join('') || '<p>No notifications.</p>'}
  </div>`;
  root.querySelectorAll('ion-card[data-id]').forEach((el) => el.addEventListener('click', async () => {
    await api(`/api/v1/notifications/${(el as HTMLElement).dataset.id}/read`, { method: 'PATCH' }).catch(() => null);
    void renderNotifications(root);
  }));
}

// ---------- Suggest correction ----------
const FIELDS = ['description', 'leaf_description', 'bark_description', 'flower_description', 'fruit_description', 'seed_description', 'family'];

export function renderCorrection(root: HTMLElement, speciesId: string) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Suggest Correction</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <ion-item><ion-select label-placement="stacked" id="field" label="Field">${FIELDS.map((f) => `<ion-select-option value="${f}">${f}</ion-select-option>`).join('')}</ion-select></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="prop" label="Proposed correction"></ion-textarea></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="exp" label="Explanation / source"></ion-textarea></ion-item>
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Submit for review</button>
  </div>`;
  bindAsyncAction(root, '#go', async () => {
    try {
      await api('/api/v1/corrections', {
        method: 'POST',
        body: JSON.stringify({
          species_id: speciesId,
          field_name: ((root.querySelector('#field') as HTMLIonSelectElement).value as string) ?? 'description',
          proposed_value: ((root.querySelector('#prop') as HTMLIonTextareaElement).value as string) ?? '',
          explanation: ((root.querySelector('#exp') as HTMLIonTextareaElement).value as string) ?? '',
        }),
      });
      toast('Correction submitted — pending review');
      window.location.hash = `#/tree/${speciesId}`;
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Failed';
    }
  });
}

// ---------- Report ----------
const REASONS = ['incorrect_information', 'incorrect_identification', 'suspicious_listing', 'spam', 'inappropriate_content', 'misleading_seller', 'other'];

export function renderReport(root: HTMLElement, entityType: string, entityId: string) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Report</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <ion-item><ion-select label-placement="stacked" id="reason" label="Reason">${REASONS.map((r) => `<ion-select-option value="${r}">${r}</ion-select-option>`).join('')}</ion-select></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="desc" label="Details (optional)"></ion-textarea></ion-item>
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Submit report</button>
  </div>`;
  bindAsyncAction(root, '#go', async () => {
    try {
      await api('/api/v1/reports', {
        method: 'POST',
        body: JSON.stringify({
          entity_type: entityType,
          entity_id: entityId,
          reason: ((root.querySelector('#reason') as HTMLIonSelectElement).value as string) ?? 'other',
          description: ((root.querySelector('#desc') as HTMLIonTextareaElement).value as string) || undefined,
        }),
      });
      toast('Report submitted — thank you');
      window.history.back();
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Failed';
    }
  });
}

// ---------- Moderator queues ----------
interface Queue {
  observations: { id: string; status: string; province: string | null; contributor: string }[];
  identifications: { id: string; status: string; province: string | null; suggestion_count: number }[];
  listings: { id: string; title: string; material_type: string; province: string; seller_name: string }[];
  corrections: { id: string; field_name: string; scientific_name: string; submitted_by: string }[];
  reports: { id: string; entity_type: string; reason: string }[];
}

export async function renderModeration(root: HTMLElement) {
  const me = await api<{ user: { roles: string[] } }>('/api/v1/auth/me').catch(() => null);
  if (!me || (!me.user.roles.includes('moderator') && !me.user.roles.includes('admin'))) {
    root.innerHTML = `<div class="pad"><p>Moderator access required.</p></div>`;
    return;
  }
  const q = await api<Queue>('/api/v1/admin/review-queue?limit=20').catch(() => null);
  if (!q) {
    root.innerHTML = `<div class="pad"><p>Failed to load queue.</p></div>`;
    return;
  }
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Moderation</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <h3>🌱 Observations (${q.observations.length})</h3>
    ${q.observations.map((o) => `<p>${esc(o.contributor)} · ${esc(o.province ?? '—')} · ${esc(o.status)}
      <button data-obs="${o.id}" data-a="approve">approve</button>
      <button data-obs="${o.id}" data-a="reject">reject</button></p>`).join('') || '<p>None.</p>'}
    <h3>📷 Identifications (${q.identifications.length})</h3>
    ${q.identifications.map((r) => `<p><a href="#/identify/${r.id}">${r.id.slice(0, 8)}…</a> · ${esc(r.province ?? '—')} · ${r.suggestion_count} suggestions · ${esc(r.status)}</p>`).join('') || '<p>None.</p>'}
    <h3>🛒 Listings (${q.listings.length})</h3>
    ${q.listings.map((l) => `<p><a href="#/market/${l.id}">${esc(l.title)}</a> · ${esc(l.seller_name)}
      <button data-list="${l.id}" data-a="approve">approve</button>
      <button data-list="${l.id}" data-a="reject">reject</button></p>`).join('') || '<p>None.</p>'}
    <h3>✏️ Corrections (${q.corrections.length})</h3>
    ${q.corrections.map((c) => `<p><i>${esc(c.scientific_name)}</i> · ${esc(c.field_name)} · by ${esc(c.submitted_by)}
      <button data-corr="${c.id}" data-ok="1">approve</button>
      <button data-corr="${c.id}" data-ok="0">reject</button></p>`).join('') || '<p>None.</p>'}
    <h3>🚩 Reports (${q.reports.length})</h3>
    ${q.reports.map((r) => `<p>${esc(r.entity_type)} · ${esc(r.reason)} <button data-rep="${r.id}">resolve</button></p>`).join('') || '<p>None.</p>'}
  </div>`;
  const refresh = () => renderModeration(root);
  root.querySelectorAll('button[data-obs]').forEach((b) => b.addEventListener('click', async () => {
    const el = b as HTMLElement;
    await api(`/api/v1/observations/${el.dataset.obs}/${el.dataset.a === 'approve' ? 'approve' : 'reject'}`,
      { method: 'POST', body: '{}' }).catch((e) => toast(e instanceof Error ? e.message : 'Failed'));
    refresh();
  }));
  root.querySelectorAll('button[data-list]').forEach((b) => b.addEventListener('click', async () => {
    const el = b as HTMLElement;
    await api(`/api/v1/marketplace/${el.dataset.list}/${el.dataset.a === 'approve' ? 'approve' : 'reject'}`,
      { method: 'POST', body: '{}' }).catch((e) => toast(e instanceof Error ? e.message : 'Failed'));
    refresh();
  }));
  root.querySelectorAll('button[data-corr]').forEach((b) => b.addEventListener('click', async () => {
    const el = b as HTMLElement;
    const action = el.dataset.ok === '1' ? 'approve' : 'reject';
    await api(`/api/v1/corrections/${el.dataset.corr}/${action}`, { method: 'POST', body: '{}' })
      .catch((e) => toast(e instanceof Error ? e.message : 'Failed'));
    refresh();
  }));
  root.querySelectorAll('button[data-rep]').forEach((b) => b.addEventListener('click', async () => {
    await api(`/api/v1/admin/reports/${(b as HTMLElement).dataset.rep}/resolve`, {
      method: 'POST', body: JSON.stringify({ status: 'resolved', resolution: 'Reviewed via mobile moderation.' }),
    }).catch((e) => toast(e instanceof Error ? e.message : 'Failed'));
    refresh();
  }));
}

