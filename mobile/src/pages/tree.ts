import { api, getToken, esc, photoUrl } from '../api';
import { toast, icon, pageHeader, emptyState, readable } from './ui';

interface Profile {
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  species: any;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  names: any[];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  photos: any[];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  purposes: any[];
  plantingConditions: Record<string, { name: string }[]>;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  distribution: any[];
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  references: any[];
}

export async function renderTree(root: HTMLElement, id: string) {
  let d: Profile;
  try {
    d = await api<Profile>(`/api/v1/species/${id}`);
  } catch {
    root.innerHTML = `${pageHeader('Tree profile', '#/search')}<div class="pad">${emptyState('Tree profile unavailable', 'This profile may be unavailable, or your connection was interrupted.', 'tree', { label: 'Explore trees', href: '#/search' })}</div>`;
    return;
  }
  const s = d.species;
  const primary = d.names.find((n) => n.is_primary && n.name_type === 'common')?.name ?? s.scientific_name;
  let saved = false;
  if (getToken()) {
    try {
      const f = await api<{ favorites: { id: string }[] }>('/api/v1/favorites');
      saved = f.favorites.some((x) => x.id === id);
    } catch {
      /* ignore */
    }
  }
  const size = [s.min_height_m, s.max_height_m].filter(Boolean).join('–');

  root.innerHTML = `
  <ion-header><ion-toolbar>
    <ion-buttons slot="start"><button class="kp-btn clear" data-href="#/home" aria-label="Back">←</button></ion-buttons>
    <ion-title>${esc(primary)}</ion-title>
  </ion-toolbar></ion-header>
  <div class="pad">
    ${d.photos[0] ? `<img class="hero" src="${esc(photoUrl(d.photos[0].file_url))}" alt="${esc(primary)}" />` : `<div class="img-ph big">${icon('tree')}<span>Photo coming soon</span></div>`}
    <p><span class="kp-badge verified">${icon('leaf')} ${s.native_status === 'endemic' ? 'Philippine endemic' : 'Philippine native'}</span></p>
    <h1>${esc(primary)}</h1>
    <p class="page-intro"><i>${esc(s.scientific_name)}</i> · ${esc(s.family)}</p>
    <button id="saveBtn" aria-pressed="${saved}" class="kp-btn block ${saved ? '' : 'outline'}">${icon('heart')} ${saved ? 'Saved to my trees' : 'Save this tree'}</button>
    <section class="profile-details">
    <h3>Overview</h3><p>${esc(s.description || '—')}</p>
    <h3>Good for</h3><div class="chips">${d.purposes.map((p) => `<ion-chip>${esc(p.name)}</ion-chip>`).join('') || 'Not recorded'}</div>
    <h3>Growing Conditions</h3>
    ${Object.entries(d.plantingConditions).map(([cat, list]) => `<p><b>${esc(readable(cat))}:</b> ${list.map((c) => esc(c.name)).join(', ')}</p>`).join('') || '<p>Not recorded</p>'}
    <h3>Size</h3><p>Height: ${esc(size || '—')} m · Canopy: ${esc([s.min_canopy_m, s.max_canopy_m].filter(Boolean).join('–') || '—')} m · Growth: ${esc(s.growth_rate ?? '—')}</p>
    <h3>Native Distribution</h3><p>${d.distribution.map((x) => esc([x.province, x.region, x.island_group].filter(Boolean).join(', '))).join('; ') || '—'}</p>
    <h3>Identification</h3>
    <p><b>Leaf:</b> ${esc(s.leaf_description ?? '—')}</p>
    <p><b>Bark:</b> ${esc(s.bark_description ?? '—')}</p>
    <p><b>Flower:</b> ${esc(s.flower_description ?? '—')}</p>
    <p><b>Fruit:</b> ${esc(s.fruit_description ?? '—')}</p>
    ${d.references.length ? `<h3>References</h3>${d.references.map((r) => `<p><small>${esc(r.title)}${r.organization ? ` — ${esc(r.organization)}` : ''}</small></p>`).join('')}` : ''}
    </section>
    <section class="finder-banner"><h2>Ready to grow one?</h2><p>Find native planting material from local growers.</p><button id="seedBtn" class="kp-btn block">${icon('sprout')} Find seedlings</button><button class="kp-btn clear block" id="alertBtn">Notify me when seedlings are available</button></section>
    <p><a href="#/contribute/photo/${esc(id)}">Contribute a photo</a> · <a href="#/correct/${esc(id)}">Suggest a correction</a> · <a href="#/report/species/${esc(id)}">Report</a></p>
  </div>`;

  root.querySelector('#seedBtn')?.addEventListener('click', () => (window.location.hash = `#/market?species=${id}`));
  root.querySelector('#alertBtn')?.addEventListener('click', async () => {
    if (!getToken()) {
      window.location.hash = '#/login';
      return;
    }
    try {
      await api('/api/v1/alerts', { method: 'POST', body: JSON.stringify({ species_id: id }) });
      toast('We will notify you when seedlings appear 🔔');
    } catch (e) {
      toast(e instanceof Error ? e.message : 'Failed');
    }
  });
  root.querySelector('#saveBtn')?.addEventListener('click', async () => {
    if (!getToken()) {
      window.location.hash = '#/login';
      return;
    }
    try {
      if (saved) {
        await api(`/api/v1/favorites/${id}`, { method: 'DELETE' });
        toast('Removed from Saved');
      } else {
        await api('/api/v1/favorites', { method: 'POST', body: JSON.stringify({ species_id: id }) });
        toast('Saved ♥');
      }
      void renderTree(root, id);
    } catch (e) {
      toast(e instanceof Error ? e.message : 'Failed');
    }
  });
}

