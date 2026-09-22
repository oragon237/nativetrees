import QRCode from 'qrcode';
import { api, getToken, esc, photoUrl } from '../api';
import { bindAsyncAction, toast, icon, emptyState } from './ui';

interface Planted {
  id: string;
  species_name: string | null;
  scientific_name: string;
  planted_date: string;
  province: string | null;
  public_token: string;
  record_count: number;
  latest_height_m: number | string | null;
}

export async function renderPlantings(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  const data = await api<{ plantedTrees: Planted[] }>('/api/v1/planted-trees/mine').catch(() => ({ plantedTrees: [] }));
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>My Plantings</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <p class="eyebrow">Watch your impact grow</p><h1>One tree at a time.</h1><p class="page-intro">Document your plantings and follow their growth.</p>
    <button class="kp-btn block" data-href="#/plant/new">${icon('sprout')} Record a planted tree</button>
    ${data.plantedTrees.map((t) => `
      <ion-card button data-id="${t.id}">
        <ion-card-content><b>${esc(t.species_name ?? t.scientific_name)}</b><br/>
        Planted ${esc(t.planted_date)}${t.province ? ` · ${esc(t.province)}` : ''}<br/>
        <small>${t.record_count} growth records${t.latest_height_m ? ` · latest ${esc(t.latest_height_m)} m` : ''}</small></ion-card-content>
      </ion-card>`).join('') || emptyState('Your growing forest starts here', 'Record your first planted tree and return to add growth updates.', 'sprout')}
  </div>`;
  root.querySelectorAll('ion-card[data-id]').forEach((el) => {
    el.addEventListener('click', () => (window.location.hash = `#/plant/${(el as HTMLElement).dataset.id}`));
  });
}

export async function renderPlantNew(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Record Planting</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <ion-item><ion-input label-placement="stacked" id="sp" label="Species (name)"></ion-input></ion-item>
    <div id="pick"></div>
    <ion-item><ion-input label-placement="stacked" id="date" label="Date planted" type="date"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="prov" label="Province"></ion-input></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="notes" label="Notes"></ion-textarea></ion-item>
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Save planting</button>
  </div>`;
  let speciesId: string | null = null;
  (root.querySelector('#sp') as HTMLIonInputElement).addEventListener('ionChange', async (e) => {
    const qv = (e.target as HTMLIonInputElement).value as string;
    if (qv.trim().length < 2) return;
    const found = await api<{ species: { id: string; primary_name: string | null; scientific_name: string }[] }>(
      `/api/v1/species?q=${encodeURIComponent(qv.trim())}&limit=5`).catch(() => ({ species: [] }));
    const box = root.querySelector('#pick')!;
    box.innerHTML = found.species.map((s) => `<ion-chip data-id="${s.id}">${esc(s.primary_name ?? s.scientific_name)}</ion-chip>`).join('');
    box.querySelectorAll('ion-chip').forEach((c) => c.addEventListener('click', () => {
      speciesId = (c as HTMLElement).dataset.id ?? null;
      box.innerHTML = '<p><small>Selected ✓</small></p>';
    }));
  });
  bindAsyncAction(root, '#go', async () => {
    const v = (s: string) => ((root.querySelector(s) as HTMLIonInputElement)?.value as string) ?? '';
    if (!speciesId) {
      (root.querySelector('#err') as HTMLElement).textContent = 'Select a species first';
      return;
    }
    try {
      const created = await api<{ plantedTree: { id: string } }>('/api/v1/planted-trees', {
        method: 'POST',
        body: JSON.stringify({
          species_id: speciesId,
          planted_date: v('#date') || undefined,
          province: v('#prov') || undefined,
          notes: ((root.querySelector('#notes') as HTMLIonTextareaElement).value as string) || undefined,
        }),
      });
      toast('Planting recorded 🌱');
      window.location.hash = `#/plant/${created.plantedTree.id}`;
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Failed';
    }
  });
}

export async function renderPlantDetail(root: HTMLElement, id: string) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  const d = await api<{
    plantedTree: { id: string; species_id: string; planted_date: string; province: string | null; notes: string | null; public_token: string };
    growth: { id: string; recorded_at: string; height_m: number | string | null; notes: string | null; file_url: string | null }[];
    species: { scientific_name: string } | null;
  }>(`/api/v1/planted-trees/${id}`).catch(() => null);
  if (!d) {
    root.innerHTML = `<div class="pad"><p>Planting not found.</p></div>`;
    return;
  }
  const qr = await QRCode.toDataURL(`${window.location.origin}/#/planted/${d.plantedTree.public_token}`, { width: 180, margin: 1 });
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-buttons slot="start"><button class="kp-btn clear" data-href="#/plantings" aria-label="Back">←</button></ion-buttons>
  <ion-title>Growth Timeline</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <p><b><i>${esc(d.species?.scientific_name ?? '')}</i></b><br/>Planted ${esc(d.plantedTree.planted_date)}${d.plantedTree.province ? ` · ${esc(d.plantedTree.province)}` : ''}</p>
    ${d.plantedTree.notes ? `<p>${esc(d.plantedTree.notes)}</p>` : ''}
    <h3>Timeline</h3>
    ${d.growth.map((g) => `
      <ion-card><ion-card-content>
        ${g.file_url ? `<img src="${esc(photoUrl(g.file_url))}" style="width:100%;border-radius:8px" />` : ''}
        <b>${esc(g.recorded_at.slice(0, 10))}</b>${g.height_m ? ` — ${esc(g.height_m)} m` : ''}<br/>${esc(g.notes ?? '')}
      </ion-card-content></ion-card>`).join('') || '<p>No growth records yet — add the first one below.</p>'}
    <h3>Add growth record</h3>
    <input type="file" id="photo" accept="image/*" />
    <ion-item><ion-input label-placement="stacked" id="h" label="Height (m)" type="number"></ion-input></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="n" label="Notes"></ion-textarea></ion-item>
    <button class="kp-btn block" id="add">Add record</button>
    <h3>QR tree tag</h3>
    <img src="${qr}" alt="QR code linking to this planted tree" style="border-radius:8px" />
    <p><small>Print and attach to the tree — scanning opens its public growth record.</small></p>
  </div>`;
  root.querySelector('#add')?.addEventListener('click', async () => {
    const h = ((root.querySelector('#h') as HTMLIonInputElement).value as string) ?? '';
    const notes = ((root.querySelector('#n') as HTMLIonTextareaElement).value as string) ?? '';
    const fd = new FormData();
    if (h) fd.append('height_m', h);
    if (notes) fd.append('notes', notes);
    const files = (root.querySelector('#photo') as HTMLInputElement).files;
    if (files?.[0]) fd.append('photo', files[0]);
    try {
      await api(`/api/v1/planted-trees/${id}/growth`, { method: 'POST', body: fd });
      toast('Growth record added');
      void renderPlantDetail(root, id);
    } catch (e) {
      toast(e instanceof Error ? e.message : 'Failed');
    }
  });
}

// Public QR landing (no login required).
export async function renderPlantedPublic(root: HTMLElement, token: string) {
  const d = await api<{
    plantedTree: { species_name: string | null; scientific_name: string; planted_date: string; province: string | null };
    growth: { recorded_at: string; height_m: number | string | null; notes: string | null; file_url: string | null }[];
  }>(`/api/v1/planted-trees/public/${token}`).catch(() => null);
  if (!d) {
    root.innerHTML = `<div class="pad"><p>Planting record not found.</p></div>`;
    return;
  }
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>🌳 Planted Native Tree</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <h2 class="brand-word">${esc(d.plantedTree.species_name ?? d.plantedTree.scientific_name)}</h2>
    <p><i>${esc(d.plantedTree.scientific_name)}</i><br/>Planted ${esc(d.plantedTree.planted_date)}${d.plantedTree.province ? ` · ${esc(d.plantedTree.province)}` : ''}</p>
    <h3>Growth timeline</h3>
    ${d.growth.map((g) => `<ion-card><ion-card-content>
      ${g.file_url ? `<img src="${esc(photoUrl(g.file_url))}" style="width:100%;border-radius:8px" />` : ''}
      <b>${esc(g.recorded_at.slice(0, 10))}</b>${g.height_m ? ` — ${esc(g.height_m)} m` : ''}<br/>${esc(g.notes ?? '')}
    </ion-card-content></ion-card>`).join('') || '<p>No growth records yet.</p>'}
  </div>`;
}

