import { api, getToken, esc, photoUrl } from '../api';
import {
  icon, pageHeader, emptyState, loadingState, photoField, bindPhotoField,
  bindAsyncAction, toast,
} from './ui';

const PHOTO_TYPES = [
  'whole_tree', 'leaf', 'bark', 'flower', 'fruit', 'seed', 'seedling', 'other',
] as const;

const PRIVACY = [
  { v: 'municipality', label: 'Municipality only' },
  { v: 'approximate', label: 'Approximate location' },
  { v: 'exact_private', label: 'Keep exact location private' },
  { v: 'hidden', label: 'Hide location' },
] as const;

function needAuth(): boolean {
  if (!getToken()) {
    window.location.hash = '#/login';
    return false;
  }
  return true;
}

// ---------- choice ----------
export function renderContributeChoice(root: HTMLElement) {
  if (!needAuth()) return;
  root.innerHTML = `
  ${pageHeader('Contribute', '#/me')}
  <div class="pad">
    <p class="page-intro">Help grow the native-tree record. Every submission is reviewed by a moderator before it becomes official.</p>
    <div class="action-list">
      <a href="#/contribute/species">${icon('sprout')}<span><strong>Contribute a new species</strong><small>Believe a species is missing from the database</small></span>${icon('arrow')}</a>
      <a href="#/contribute/photo">${icon('camera')}<span><strong>Contribute a photo</strong><small>Add photos to an existing species</small></span>${icon('arrow')}</a>
    </div>
    <p class="brand-footer">Discover. Identify. Plant Native.</p>
  </div>`;
}

// ---------- new species: stepped form ----------
interface SpeciesDraft {
  common: string;
  scientific: string;
  unknownSci: boolean;
  description: string;
  location: string;
  privacy: string;
  observed: string;
  source: string;
  photoType: string;
  caption: string;
}

export function renderSpeciesForm(root: HTMLElement) {
  if (!needAuth()) return;
  let step = 0;
  const d: SpeciesDraft = {
    common: '', scientific: '', unknownSci: false, description: '',
    location: '', privacy: 'municipality', observed: '', source: '',
    photoType: 'whole_tree', caption: '',
  };
  let dupes: { id: string; scientific_name: string; primary_name: string | null }[] = [];

  async function checkDupes() {
    const box = root.querySelector('#dupes');
    if (!box) return;
    const q = `${d.common} ${d.unknownSci ? '' : d.scientific}`.trim();
    if (q.length < 3) {
      box.innerHTML = '';
      return;
    }
    try {
      const r = await api<{ matches: { id: string; scientific_name: string; primary_name: string | null }[] }>(
        `/api/v1/species-contributions/check-duplicates?q=${encodeURIComponent(q)}`);
      dupes = r.matches;
      box.innerHTML = dupes.length ? `
        <div class="info-note">${icon('info')}<div><strong>Possible existing species found.</strong>
        ${dupes.map((m) => `<br/><a href="#/tree/${m.id}">${esc(m.primary_name ?? m.scientific_name)} (<i>${esc(m.scientific_name)}</i>)</a>`).join('')}
        <br/>You can contribute photos to it instead — or continue below if yours is genuinely different.</div></div>` : '';
    } catch { /* offline: skip check */ }
  }

  function show() {
    const titles = ['Information', 'Photos', 'Location, privacy & review'];
    root.innerHTML = `
    ${pageHeader('Contribute a species', '#/contribute')}
    <div class="pad">
      <div class="wizard-progress" aria-hidden="true">${titles.map((_, i) => `<span class="${i <= step ? 'done' : ''}"></span>`).join('')}</div>
      <p class="wizard-meta"><span>Step ${step + 1} of 3</span><span>${titles[step]}</span></p>
      <div id="step"></div>
      <div class="wizard-actions">
        ${step > 0 ? '<button class="kp-btn clear" id="back">Back</button>' : '<span></span>'}
        ${step < 2 ? '<button class="kp-btn" id="next">Continue</button>' : '<button class="kp-btn" id="submit">Submit for review</button>'}
      </div>
      <p id="err" class="kp-error"></p>
    </div>`;
    const box = root.querySelector('#step') as HTMLElement;
    if (step === 0) {
      box.innerHTML = `
        <ion-item><ion-input id="f-common" label="Proposed common / local name *" value="${esc(d.common)}"></ion-input></ion-item>
        <ion-item><ion-input id="f-sci" label="Proposed scientific name" value="${esc(d.scientific)}" ${d.unknownSci ? 'disabled' : ''}></ion-input></ion-item>
        <label><input type="checkbox" id="f-unknown" ${d.unknownSci ? 'checked' : ''} /> I don't know the scientific name</label>
        <ion-item><ion-textarea id="f-desc" label="Description / notes *">${esc(d.description)}</ion-textarea></ion-item>
        <ion-item><ion-textarea id="f-source" label="Source / reference (optional)">${esc(d.source)}</ion-textarea></ion-item>
        <div id="dupes"></div>`;
      void checkDupes();
      (box.querySelector('#f-common') as HTMLIonInputElement).addEventListener('ionChange', (e) => {
        d.common = (e.target as HTMLIonInputElement).value as string;
        void checkDupes();
      });
      (box.querySelector('#f-sci') as HTMLIonInputElement).addEventListener('ionChange', (e) => {
        d.scientific = (e.target as HTMLIonInputElement).value as string;
        void checkDupes();
      });
      box.querySelector('#f-unknown')?.addEventListener('change', (e) => {
        d.unknownSci = (e.target as HTMLInputElement).checked;
        show();
      });
      (box.querySelector('#f-desc') as HTMLIonTextareaElement).addEventListener('ionChange', (e) => {
        d.description = (e.target as HTMLIonTextareaElement).value as string;
      });
      (box.querySelector('#f-source') as HTMLIonTextareaElement).addEventListener('ionChange', (e) => {
        d.source = (e.target as HTMLIonTextareaElement).value as string;
      });
    } else if (step === 1) {
      box.innerHTML = `
        <p>Multiple identifying photos help moderators verify: whole tree, leaf, bark, flower, fruit, seed.</p>
        <ion-item><ion-select id="f-ptype" label="Photo category" value="${d.photoType}">
          ${PHOTO_TYPES.map((t) => `<ion-select-option value="${t}">${t.replace(/_/g, ' ')}</ion-select-option>`).join('')}
        </ion-select></ion-item>
        ${photoField(8)}
        <ion-item><ion-input id="f-cap" label="Caption (optional)" value="${esc(d.caption)}"></ion-input></ion-item>`;
      bindPhotoField(root, 8);
      (box.querySelector('#f-ptype') as HTMLIonSelectElement).addEventListener('ionChange', (e) => {
        d.photoType = (e.target as HTMLIonSelectElement).value as string;
      });
      (box.querySelector('#f-cap') as HTMLIonInputElement).addEventListener('ionChange', (e) => {
        d.caption = (e.target as HTMLIonInputElement).value as string;
      });
    } else {
      box.innerHTML = `
        <ion-item><ion-input id="f-loc" label="Observation location" value="${esc(d.location)}"></ion-input></ion-item>
        <ion-item><ion-select id="f-priv" label="Who can see this location?" value="${d.privacy}">
          ${PRIVACY.map((p) => `<ion-select-option value="${p.v}">${p.label}</ion-select-option>`).join('')}
        </ion-select></ion-item>
        <p><small>Exact locations of sensitive species may be hidden for conservation purposes.</small></p>
        <ion-item><ion-input id="f-date" label="Date observed" type="date" value="${esc(d.observed)}"></ion-input></ion-item>
        <div class="info-note">${icon('info')}<div><strong>Review check.</strong> “${esc(d.common)}”${d.unknownSci ? '' : ` (<i>${esc(d.scientific) || '—'}</i>)`} will be sent as <strong>pending</strong>. It never becomes official data without moderator review.</div></div>`;
      (box.querySelector('#f-loc') as HTMLIonInputElement).addEventListener('ionChange', (e) => {
        d.location = (e.target as HTMLIonInputElement).value as string;
      });
      (box.querySelector('#f-priv') as HTMLIonSelectElement).addEventListener('ionChange', (e) => {
        d.privacy = (e.target as HTMLIonSelectElement).value as string;
      });
      (box.querySelector('#f-date') as HTMLIonInputElement).addEventListener('ionChange', (e) => {
        d.observed = (e.target as HTMLIonInputElement).value as string;
      });
    }
    root.querySelector('#back')?.addEventListener('click', () => {
      step--;
      show();
    });
    root.querySelector('#next')?.addEventListener('click', () => {
      if (step === 0 && (!d.common.trim())) {
        (root.querySelector('#err') as HTMLElement).textContent = 'Please add the proposed common name.';
        return;
      }
      step++;
      show();
    });
    const submit = root.querySelector('#submit');
    if (submit) {
      bindAsyncAction(root, '#submit', async () => {
        const created = await api<{ contribution: { id: string } }>('/api/v1/species-contributions', {
          method: 'POST',
          body: JSON.stringify({
            proposed_common_name: d.common.trim(),
            proposed_scientific_name: d.unknownSci ? null : d.scientific.trim() || null,
            description: d.description,
            location_text: d.location || undefined,
            location_precision: d.privacy,
            observed_at: d.observed || undefined,
            source_reference: d.source || undefined,
          }),
        });
        const files = (root.querySelector('#photos') as HTMLInputElement | null)?.files;
        if (files?.length) {
          for (const f of Array.from(files).slice(0, 8)) {
            const fd = new FormData();
            fd.append('photo', f);
            fd.append('photo_type', d.photoType);
            if (d.caption) fd.append('caption', d.caption);
            await api(`/api/v1/species-contributions/${created.contribution.id}/photos`, { method: 'POST', body: fd });
          }
        }
        toast('Contribution submitted — pending review');
        window.location.hash = `#/contributions/species/${created.contribution.id}`;
      });
    }
  }
  show();
}

// ---------- My Contributions ----------
type Filter = 'all' | 'pending' | 'needs_more_info' | 'approved' | 'rejected';

interface Item {
  kind: 'species' | 'photo';
  id: string;
  title: string;
  sub: string;
  thumbnail: string | null;
  status: string;
  created_at: string;
}

export async function renderMyContributions(root: HTMLElement, filter: Filter = 'all') {
  if (!needAuth()) return;
  root.innerHTML = `${pageHeader('My Contributions', '#/me')}<div class="pad">${loadingState()}</div>`;
  const [sp, ph] = await Promise.all([
    api<{ contributions: { id: string; proposed_common_name: string; proposed_scientific_name: string | null; status: string; created_at: string }[] }>('/api/v1/species-contributions/mine').catch(() => ({ contributions: [] })),
    api<{ contributions: { id: string; status: string; created_at: string; file_url: string; caption: string | null; species_name: string | null; scientific_name: string }[] }>('/api/v1/photo-contributions/mine').catch(() => ({ contributions: [] })),
  ]);
  const items: Item[] = [
    ...sp.contributions.map((c) => ({
      kind: 'species' as const, id: c.id,
      title: c.proposed_common_name, sub: c.proposed_scientific_name ?? 'Scientific name unknown',
      thumbnail: null, status: c.status, created_at: c.created_at,
    })),
    ...ph.contributions.map((c) => ({
      kind: 'photo' as const, id: c.id,
      title: c.species_name ?? c.scientific_name, sub: c.caption ?? 'Species photo',
      thumbnail: c.file_url, status: c.status, created_at: c.created_at,
    })),
  ].sort((a, b) => (a.created_at < b.created_at ? 1 : -1));
  const shown = filter === 'all' ? items : items.filter((i) => i.status === filter);
  const tabs: Filter[] = ['all', 'pending', 'needs_more_info', 'approved', 'rejected'];
  root.innerHTML = `
  ${pageHeader('My Contributions', '#/me')}
  <div class="pad">
    <div class="chips" role="tablist">
      ${tabs.map((t) => `<ion-chip data-f="${t}" class="${t === filter ? 'chip-active' : ''}" role="tab">${t.replace(/_/g, ' ')}</ion-chip>`).join('')}
    </div>
    ${shown.map((i) => `
      <ion-card button data-kind="${i.kind}" data-id="${i.id}">
        <ion-card-content>
          <b>${i.kind === 'species' ? 'New Species' : 'Species Photo'}</b> · ${esc(i.title)}<br/>
          <small>${esc(i.sub)} · ${esc(i.created_at.slice(0, 10))}</small><br/>
          <span class="kp-badge ${i.status}">${esc(i.status.replace(/_/g, ' '))}</span>
        </ion-card-content>
      </ion-card>`).join('') || emptyState('No contributions here', 'Contributions with this status will appear here.', 'leaf', { label: 'Contribute', href: '#/contribute' })}
  </div>`;
  root.querySelectorAll('.chips ion-chip').forEach((c) => c.addEventListener('click', () => {
    void renderMyContributions(root, (c as HTMLElement).dataset.f as Filter);
  }));
  root.querySelectorAll('ion-card[data-id]').forEach((el) => {
    el.addEventListener('click', () => {
      const k = (el as HTMLElement).dataset.kind;
      window.location.hash = k === 'species'
        ? `#/contributions/species/${(el as HTMLElement).dataset.id}`
        : `#/contributions/photo/${(el as HTMLElement).dataset.id}`;
    });
  });
}

// ---------- contribution detail ----------
export async function renderContributionDetail(root: HTMLElement, kind: 'species' | 'photo', id: string) {
  if (!needAuth()) return;
  root.innerHTML = `${pageHeader('Contribution', '#/contributions')}<div class="pad">${loadingState()}</div>`;
  try {
    if (kind === 'species') {
      const d = await api<{
        contribution: {
          id: string; proposed_common_name: string; proposed_scientific_name: string | null;
          description: string; status: string; review_notes: string | null;
          location_text: string | null; observed_at: string | null; source_reference: string | null;
          created_at: string;
        };
        photos: { id: string; file_url: string; photo_type: string; caption: string | null }[];
        // eslint-disable-next-line @typescript-eslint/no-explicit-any
        suggestions?: any;
      }>(`/api/v1/species-contributions/${id}`);
      const c = d.contribution;
      const editable = ['pending', 'needs_more_info'].includes(c.status);
      root.innerHTML = `
      ${pageHeader('Contribution', '#/contributions')}
      <div class="pad">
        <p><span class="kp-badge ${c.status}">${esc(c.status.replace(/_/g, ' '))}</span></p>
        <h2>${esc(c.proposed_common_name)}</h2>
        ${c.proposed_scientific_name ? `<p><i>${esc(c.proposed_scientific_name)}</i></p>` : '<p><small>Scientific name unknown</small></p>'}
        ${c.review_notes ? `<div class="info-note">${icon('info')}<div><strong>Moderator feedback:</strong> ${esc(c.review_notes)}</div></div>` : ''}
        <div class="imgrow">${d.photos.map((p) => `<img src="${esc(photoUrl(p.file_url))}" alt="${esc(p.photo_type)}" />`).join('')}</div>
        <p>${esc(c.description || '')}</p>
        <p><small>Submitted ${esc(c.created_at.slice(0, 10))}${c.location_text ? ` · ${esc(c.location_text)}` : ''}${c.observed_at ? ` · observed ${esc(c.observed_at.slice(0, 10))}` : ''}</small></p>
        ${editable ? `
          <h3>Add information</h3>
          <ion-item><ion-textarea id="more" label="Additional notes"></ion-textarea></ion-item>
          ${photoField(8)}
          <button class="kp-btn block" id="save-more">Save additions</button>
          ${c.status === 'needs_more_info' ? '<button class="kp-btn block" id="resub">Resubmit for review</button>' : ''}` : ''}
      </div>`;
      bindPhotoField(root, 8);
      root.querySelector('#save-more')?.addEventListener('click', async () => {
        const notes = ((root.querySelector('#more') as HTMLIonTextareaElement).value as string) ?? '';
        try {
          if (notes.trim()) {
            await api(`/api/v1/species-contributions/${id}`, {
              method: 'PATCH',
              body: JSON.stringify({ description: `${c.description}\n\n[Added ${new Date().toISOString().slice(0, 10)}] ${notes.trim()}` }),
            });
          }
          const files = (root.querySelector('#photos') as HTMLInputElement | null)?.files;
          if (files?.length) {
            for (const f of Array.from(files).slice(0, 8)) {
              const fd = new FormData();
              fd.append('photo', f);
              fd.append('photo_type', 'whole_tree');
              await api(`/api/v1/species-contributions/${id}/photos`, { method: 'POST', body: fd });
            }
          }
          toast('Additions saved');
          void renderContributionDetail(root, kind, id);
        } catch (e) {
          toast(e instanceof Error ? e.message : 'Failed');
        }
      });
      root.querySelector('#resub')?.addEventListener('click', async () => {
        try {
          await api(`/api/v1/species-contributions/${id}/resubmit`, { method: 'POST' });
          toast('Resubmitted — pending review');
          void renderContributionDetail(root, kind, id);
        } catch (e) {
          toast(e instanceof Error ? e.message : 'Failed');
        }
      });
    } else {
      const d = await api<{
        contribution: {
          id: string; status: string; review_notes: string | null; file_url: string;
          photo_type: string; caption: string | null; created_at: string;
        };
      }>(`/api/v1/photo-contributions/${id}`);
      const c = d.contribution;
      root.innerHTML = `
      ${pageHeader('Contribution', '#/contributions')}
      <div class="pad">
        <p><span class="kp-badge ${c.status}">${esc(c.status.replace(/_/g, ' '))}</span></p>
        <img class="hero" src="${esc(photoUrl(c.file_url))}" alt="Contributed photo" />
        ${c.review_notes ? `<div class="info-note">${icon('info')}<div><strong>Moderator feedback:</strong> ${esc(c.review_notes)}</div></div>` : ''}
        <p><small>${esc(c.photo_type.replace(/_/g, ' '))} · submitted ${esc(c.created_at.slice(0, 10))}</small></p>
      </div>`;
    }
  } catch {
    root.innerHTML = `${pageHeader('Contribution', '#/contributions')}<div class="pad">${emptyState('Not found', 'This contribution is unavailable.', 'leaf')}</div>`;
  }
}

// ---------- photo to existing species ----------
export function renderPhotoForm(root: HTMLElement, speciesId: string) {
  if (!needAuth()) return;
  root.innerHTML = `
  ${pageHeader('Contribute a photo', `#/tree/${speciesId}`)}
  <div class="pad">
    <p class="page-intro">Your photo stays <strong>pending</strong> until a moderator approves it into the official gallery.</p>
    <ion-item><ion-select id="f-ptype" label="Photo category">
      ${PHOTO_TYPES.map((t) => `<ion-select-option value="${t}">${t.replace(/_/g, ' ')}</ion-select-option>`).join('')}
    </ion-select></ion-item>
    ${photoField(8)}
    <ion-item><ion-input id="f-cap" label="Caption / notes (optional)"></ion-input></ion-item>
    <ion-item><ion-input id="f-credit" label="Credit name (optional, shown publicly)"></ion-input></ion-item>
    <ion-item><ion-input id="f-loc" label="Location (optional)"></ion-input></ion-item>
    <ion-item><ion-select id="f-priv" label="Who can see this location?" value="municipality">
      ${PRIVACY.map((p) => `<ion-select-option value="${p.v}">${p.label}</ion-select-option>`).join('')}
    </ion-select></ion-item>
    <ion-item><ion-input id="f-date" label="Date photographed" type="date"></ion-input></ion-item>
    <p id="err" class="kp-error"></p>
    <button class="kp-btn block" id="go">SUBMIT PHOTO FOR REVIEW</button>
  </div>`;
  bindPhotoField(root, 8);
  bindAsyncAction(root, '#go', async () => {
    const v = (s: string) => ((root.querySelector(s) as HTMLIonInputElement)?.value as string) ?? '';
    const files = (root.querySelector('#photos') as HTMLInputElement | null)?.files;
    if (!files?.length) throw new Error('Please add at least one photo.');
    const fd = new FormData();
    for (const f of Array.from(files).slice(0, 8)) fd.append('photo', f);
    fd.append('photo_type', ((root.querySelector('#f-ptype') as HTMLIonSelectElement).value as string) || 'whole_tree');
    if (v('#f-cap')) fd.append('caption', v('#f-cap'));
    if (v('#f-credit')) fd.append('credit_name', v('#f-credit'));
    if (v('#f-loc')) fd.append('location_text', v('#f-loc'));
    fd.append('location_precision', ((root.querySelector('#f-priv') as HTMLIonSelectElement).value as string) || 'municipality');
    if (v('#f-date')) fd.append('photographed_at', v('#f-date'));
    // NOTE: backend creates one contribution per photo in this batch call.
    const res = await fetch(`/api/v1/species/${speciesId}/photo-contributions`, {
      method: 'POST',
      headers: getToken() ? { Authorization: `Bearer ${getToken()}` } : {},
      body: fd,
    });
    // photo_type/caption/etc. ride along in the same multipart body.
    if (!res.ok) {
      const data = (await res.json().catch(() => ({}))) as { error?: string };
      throw new Error(data.error ?? 'Submission failed');
    }
    toast('Photo submitted — pending review');
    window.location.hash = '#/contributions';
  });
}
