import { api, getToken, esc, photoUrl } from '../api';
import { bindAsyncAction, toast, icon, pageHeader, emptyState, photoField, bindPhotoField } from './ui';
import { onlineOrQueue } from './offline';

function needAuth(): boolean {
  if (!getToken()) {
    window.location.hash = '#/login';
    return false;
  }
  return true;
}

async function uploadPhotos(kind: 'identifications' | 'observations' | 'marketplace', id: string, files: FileList | null) {
  if (!files?.length) return;
  for (const f of Array.from(files).slice(0, 6)) {
    const fd = new FormData();
    fd.append('photo', f);
    if (kind !== 'marketplace') fd.append('photo_type', 'whole_tree');
    await api(`/${kind === 'marketplace' ? 'marketplace' : kind}/${id}/photos`, { method: 'POST', body: fd });
  }
}

// ---------- Identify a Tree ----------
export function renderIdentifyNew(root: HTMLElement) {
  if (!needAuth()) return;
  root.innerHTML = `
  ${pageHeader('Identify a tree', '#/identify')}
  <div class="pad">
    <p class="eyebrow">A closer look at nature</p><h1>Let’s meet this tree.</h1>
    <p class="page-intro">Share clear photos and a few details to help the community identify your tree.</p>
    ${photoField()}
    <div class="info-note">${icon('camera')}Start with the whole tree, then add a close-up of leaves or bark. Flowers and fruit help too. You don’t need every view.</div>
    <h2>What did you notice?</h2>
    <ion-item><ion-textarea label-placement="stacked" id="desc" label="Description"></ion-textarea></ion-item>
    <ion-item><ion-input label-placement="stacked" id="prov" label="Province"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="hab" label="Habitat"></ion-input></ion-item>
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Ask the community ${icon('arrow')}</button>
    <p class="field-help">Suggestions are possible matches until reviewed. Offline drafts save your details; photos need to be added again after syncing.</p>
  </div>`;
  bindPhotoField(root);
  bindAsyncAction(root, '#go', async () => {
    const v = (s: string) => ((root.querySelector(s) as HTMLIonInputElement)?.value as string) ?? '';
    const payload = {
      description: (root.querySelector('#desc') as HTMLIonTextareaElement).value ?? '',
      province: v('#prov') || undefined,
      habitat: v('#hab') || undefined,
    };
    try {
      const outcome = await onlineOrQueue('identification', payload, async () => {
        const created = await api<{ request: { id: string } }>('/api/v1/identifications', {
          method: 'POST',
          body: JSON.stringify(payload),
        });
        await uploadPhotos('identifications', created.request.id, (root.querySelector('#photos') as HTMLInputElement).files);
        window.location.hash = `#/identify/${created.request.id}`;
      });
      if (outcome === 'sent') toast('Request submitted — waiting for identification');
      else window.location.hash = '#/identify';
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Failed';
    }
  });
}

export async function renderIdentifyList(root: HTMLElement) {
  let unavailable = false;
  const mine = await api<{ requests: { id: string; status: string; province: string | null; created_at: string }[] }>(
    getToken() ? '/api/v1/identifications/mine' : '/api/v1/identifications?limit=20').catch(() => { unavailable = true; return { requests: [] }; });
  const open = await api<{ requests: { id: string; status: string; province: string | null }[] }>('/api/v1/identifications?limit=20').catch(() => { unavailable = true; return { requests: [] }; });
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Identify</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <p class="eyebrow">Discover through a lens</p><h1>Every tree has a story.</h1><p class="page-intro">Let our community help you learn its name.</p>
    <button class="identify-banner" data-href="#/identify/new"><span class="banner-icon">${icon('camera')}</span><span><strong>Identify a tree</strong><span>Add photos and ask the community</span></span>${icon('arrow')}</button>
    <div class="info-note" style="margin-top:20px">${icon('leaf')}Clear views of leaves, bark and the whole tree make identification easier.</div>
    <h3>Community requests</h3>
    ${unavailable ? (!getToken() ? emptyState('Discover with the community', 'Log in to view identification requests and share what you know.', 'camera', { label: 'Log in to join', href: '#/login' }) : emptyState('Requests couldn’t be loaded', 'Check your connection and try again.', 'info') + '<button class="kp-btn block outline" id="retry-identify">Try again</button>') : open.requests.map((r) => `<ion-card button data-id="${esc(r.id)}"><ion-card-content><span class="kp-badge ${esc(r.status)}">${esc(r.status.replace(/_/g, ' '))}</span><h3>Help identify this tree</h3><p>${icon('pin')} ${esc(r.province ?? 'Location not shared')}</p></ion-card-content></ion-card>`).join('') || emptyState('Be the first to ask', 'Found a tree you don’t recognize? Share it with the community.', 'camera')}
    ${getToken() ? `<h3>My requests</h3>${mine.requests.map((r) => `<ion-card button data-id="${esc(r.id)}"><ion-card-content>${esc(r.province ?? 'Location not shared')} · <span class="kp-badge ${esc(r.status)}">${esc(r.status.replace(/_/g, ' '))}</span></ion-card-content></ion-card>`).join('') || emptyState('Your discoveries start here', 'Your identification requests and their progress will appear here.', 'camera')}` : '<p><a href="#/login">Log in</a> to track your requests.</p>'}
  </div>`;
  root.querySelector('#retry-identify')?.addEventListener('click', () => void renderIdentifyList(root));
  root.querySelectorAll('ion-card[data-id]').forEach((el) => {
    el.addEventListener('click', () => (window.location.hash = `#/identify/${(el as HTMLElement).dataset.id}`));
  });
}

export async function renderIdentifyDetail(root: HTMLElement, id: string) {
  const d = await api<{
    request: { id: string; status: string; description: string | null; province: string | null; user_id: string };
    photos: { id: string; file_url: string; photo_type: string }[];
    suggestions: { id: string; species_id: string; species_name: string | null; scientific_name: string; reasoning: string | null; suggested_by_name: string }[];
    verifiedSpecies: { scientific_name: string } | null;
  }>(`/api/v1/identifications/${id}`).catch(() => null);
  if (!d) {
    root.innerHTML = `<div class="pad"><p>Request not found.</p></div>`;
    return;
  }
  const comments = await api<{ comments: { id: string; display_name: string; content: string }[] }>(
    `/api/v1/comments?entity_type=identification_request&entity_id=${id}`).catch(() => ({ comments: [] }));
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-buttons slot="start"><button class="kp-btn clear" data-href="#/identify" aria-label="Back">←</button></ion-buttons>
  <ion-title>Unknown Tree</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <p>Status: <span class="kp-badge ${d.request.status}">${esc(d.request.status.replace(/_/g, ' ').toUpperCase())}</span>${d.request.province ? ` · ${esc(d.request.province)}` : ''}</p>
    ${d.verifiedSpecies ? `<ion-card color="success"><ion-card-content>✓ VERIFIED: <i>${esc(d.verifiedSpecies.scientific_name)}</i></ion-card-content></ion-card>` : ''}
    <div class="imgrow">${d.photos.map((p) => `<img src="${esc(photoUrl(p.file_url))}" />`).join('')}</div>
    <p>${esc(d.request.description ?? '')}</p>
    <h3>Community suggestions (${d.suggestions.length})</h3>
    <button class="kp-btn outline small" id="ai">✨ AI POSSIBLE MATCHES</button>
    <div id="aimatches"></div>
    ${d.suggestions.map((s) => `<ion-card><ion-card-content><b>${esc(s.species_name ?? s.scientific_name)}</b> <small><i>${esc(s.scientific_name)}</i></small><br/>${esc(s.reasoning ?? '')}<br/><small>by ${esc(s.suggested_by_name)}</small></ion-card-content></ion-card>`).join('') || '<p>No suggestions yet.</p>'}
    ${getToken() ? `
    <ion-item><ion-input label-placement="stacked" id="sp" label="Species (scientific name)"></ion-input></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="rs" label="Reasoning"></ion-textarea></ion-item>
    <button class="kp-btn block" id="sug">Suggest identification</button>` : '<p><a href="#/login">Log in</a> to suggest.</p>'}
    <h3>Comments</h3>
    ${comments.comments.map((c) => `<p><b>${esc(c.display_name)}:</b> ${esc(c.content)}</p>`).join('') || '<p>No comments.</p>'}
    ${getToken() ? `<ion-item><ion-input label-placement="stacked" id="cm" label="Add a comment"></ion-input></ion-item><button class="kp-btn small" id="post">Post</button>` : ''}
    <p><a href="#/report/identification_request/${id}">Report this request</a></p>
  </div>`;

  root.querySelector('#ai')?.addEventListener('click', async () => {
    const box = root.querySelector('#aimatches') as HTMLElement;
    box.innerHTML = '<p><small>Analyzing…</small></p>';
    try {
      const ai = await api<{
        matches: { species_id: string; scientific_name: string; primary_name: string | null; confidence: string; reasons: string[] }[];
        disclaimer: string;
      }>(`/api/v1/identifications/${id}/ai-suggest`, { method: 'POST' });
      box.innerHTML = (ai.matches.map((m) => `
        <ion-card><ion-card-content><b>${esc(m.primary_name ?? m.scientific_name)}</b>
        <small> <i>${esc(m.scientific_name)}</i> · confidence: ${esc(m.confidence)}</small><br/>
        ${m.reasons.map((r) => `✓ ${esc(r)}`).join('<br/>')}<br/>
        <a href="#/tree/${m.species_id}">View species</a></ion-card-content></ion-card>`).join('')
        || '<p><small>No strong matches — add more details or photos.</small></p>')
        + `<p><small>${esc(ai.disclaimer)}</small></p>`;
    } catch {
      box.innerHTML = '<p><small>Analysis unavailable right now.</small></p>';
    }
  });

  root.querySelector('#sug')?.addEventListener('click', async () => {
    const sci = ((root.querySelector('#sp') as HTMLIonInputElement).value as string).trim();
    const reasoning = ((root.querySelector('#rs') as HTMLIonTextareaElement).value as string) ?? '';
    try {
      const found = await api<{ species: { id: string; primary_name: string | null; scientific_name: string }[] }>(`/api/v1/species?q=${encodeURIComponent(sci)}&limit=5`);
      const match = found.species.find((s) => s.scientific_name.toLowerCase() === sci.toLowerCase()) ?? found.species[0];
      if (!match) {
        toast('No matching species — check the scientific name');
        return;
      }
      await api(`/api/v1/identifications/${id}/suggestions`, { method: 'POST', body: JSON.stringify({ species_id: match.id, reasoning }) });
      toast('Suggestion posted');
      void renderIdentifyDetail(root, id);
    } catch (e) {
      toast(e instanceof Error ? e.message : 'Failed');
    }
  });
  root.querySelector('#post')?.addEventListener('click', async () => {
    const content = ((root.querySelector('#cm') as HTMLIonInputElement).value as string) ?? '';
    if (!content.trim()) return;
    await api('/api/v1/comments', { method: 'POST', body: JSON.stringify({ entity_type: 'identification_request', entity_id: id, content }) });
    void renderIdentifyDetail(root, id);
  });
}

// ---------- Record Observation ----------
export async function renderObserveNew(root: HTMLElement) {
  if (!needAuth()) return;
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Record Observation</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <ion-item><ion-input label-placement="stacked" id="sp" label="Species (scientific or common name)"></ion-input></ion-item>
    <div id="pick"></div>
    ${photoField()}
    <ion-item><ion-input label-placement="stacked" id="prov" label="Province"></ion-input></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="notes" label="Notes"></ion-textarea></ion-item>
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Submit for review</button>
  </div>`;
  bindPhotoField(root);
  let speciesId: string | null = null;
  (root.querySelector('#sp') as HTMLIonInputElement).addEventListener('ionChange', async (e) => {
    const qv = (e.target as HTMLIonInputElement).value as string;
    if (qv.trim().length < 2) return;
    const found = await api<{ species: { id: string; primary_name: string | null; scientific_name: string }[] }>(
      `/api/v1/species?q=${encodeURIComponent(qv.trim())}&limit=5`).catch(() => ({ species: [] }));
    const box = root.querySelector('#pick')!;
    box.innerHTML = found.species.map((s) => `<ion-chip data-id="${s.id}">${esc(s.primary_name ?? s.scientific_name)} <small><i>${esc(s.scientific_name)}</i></small></ion-chip>`).join('');
    box.querySelectorAll('ion-chip').forEach((c) => c.addEventListener('click', () => {
      speciesId = (c as HTMLElement).dataset.id ?? null;
      (root.querySelector('#sp') as HTMLIonInputElement).value = c.textContent ?? '';
      box.innerHTML = `<p><small>Selected ✓</small></p>`;
    }));
  });
  bindAsyncAction(root, '#go', async () => {
    const v = (s: string) => ((root.querySelector(s) as HTMLIonInputElement)?.value as string) ?? '';
    const payload = {
      species_id: speciesId,
      province: v('#prov') || undefined,
      notes: ((root.querySelector('#notes') as HTMLIonTextareaElement).value as string) || undefined,
    };
    try {
      const outcome = await onlineOrQueue('observation', payload, async () => {
        const created = await api<{ observation: { id: string } }>('/api/v1/observations', {
          method: 'POST',
          body: JSON.stringify(payload),
        });
        await uploadPhotos('observations', created.observation.id, (root.querySelector('#photos') as HTMLInputElement).files);
        window.location.hash = '#/observations';
      });
      if (outcome === 'sent') toast('Observation submitted — pending review');
      else window.location.hash = '#/observations';
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Failed';
    }
  });
}

export async function renderObservationsMine(root: HTMLElement) {
  if (!needAuth()) return;
  const data = await api<{ observations: { id: string; status: string; province: string | null; observation_date: string }[] }>('/api/v1/observations/mine').catch(() => ({ observations: [] }));
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>My Observations</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <p class="eyebrow">Your discoveries in the field</p><h1>Notice. Record. Learn.</h1><p class="page-intro">Each observation helps us know our native trees better.</p>
    <button class="kp-btn block" data-href="#/observe/new">${icon('camera')} Record a tree observation</button>
    ${data.observations.map((o) => `<ion-card><ion-card-content>${esc(o.province ?? '—')} · ${esc(o.observation_date)} · <span class="kp-badge ${o.status}">${esc(o.status.replace(/_/g, ' '))}</span></ion-card-content></ion-card>`).join('') || emptyState('What’s growing around you?', 'Record a native tree to start your personal observation journal.', 'leaf')}
  </div>`;
}

