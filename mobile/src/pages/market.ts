import { api, getToken, esc, photoUrl } from '../api';
import { bindAsyncAction, toast, icon, pageHeader, emptyState, photoField, bindPhotoField, readable } from './ui';

interface Listing {
  id: string;
  title: string;
  species_name: string | null;
  scientific_name?: string;
  material_type: string;
  quantity: number;
  price: number;
  province: string;
  municipality: string | null;
  cover_photo: string | null;
  status?: string;
  seller_name?: string;
  seller_verified?: boolean;
  contact_value?: string;
  description?: string;
  approximate_height_cm?: number | null;
}

export async function renderMarket(root: HTMLElement, params: URLSearchParams) {
  const species = params.get('species') ?? '';
  const ps = new URLSearchParams();
  if (species) ps.set('species_id', species);
  let unavailable = false;
  const data = await api<{ listings: Listing[] }>(`/api/v1/marketplace?${ps}`).catch(() => { unavailable = true; return { listings: [] }; });
  root.innerHTML = `
  ${pageHeader('Find native seedlings', '#/home')}
  <div class="pad">
    <p class="eyebrow">From discovery to planting</p><h1>Give a native tree a home.</h1><p class="page-intro">Find seeds, seedlings and saplings from local growers.</p>
    <div class="sec-head"><h2>${species ? 'Seedlings for this species' : 'Available from growers'}</h2><a href="#/market/mine">My listings</a></div>
    ${species ? '<p><a href="#/market">Browse all species</a></p>' : ''}
    <div class="tree-grid">${data.listings.map((l) => `
      <ion-card button class="listing-card" data-id="${esc(l.id)}">
        ${l.cover_photo ? `<img loading="lazy" src="${esc(photoUrl(l.cover_photo))}" alt="${esc(l.species_name ?? l.title)}" />` : `<div class="img-ph">${icon('sprout')}<span>Photo coming soon</span></div>`}
        <ion-card-header><ion-card-title>${esc(l.species_name ?? l.title)}</ion-card-title>
        <ion-card-subtitle>${l.scientific_name ? `<i>${esc(l.scientific_name)}</i>` : esc(l.title)}</ion-card-subtitle></ion-card-header>
        <ion-card-content><span class="kp-badge active">${esc(readable(l.material_type))}</span><p class="field-help">${esc(l.province)}</p>${l.seller_verified ? '<p class="field-help">✓ Verified nursery</p>' : ''}<div class="listing-price"><strong>₱${esc(l.price)}</strong><small>${esc(l.quantity)} available</small></div></ion-card-content>
      </ion-card>`).join('') || (unavailable ? (!getToken() ? emptyState('Meet your local growers', 'Log in to browse available native trees and connect with sellers.', 'sprout', { label: 'Log in to browse', href: '#/login' }) : emptyState('Grower listings couldn’t be loaded', 'Check your connection and try again.', 'info')) : emptyState('More native trees are taking root', 'Check back for seedlings, or share available planting material with the community.', 'sprout'))}</div>
    ${unavailable && getToken() ? '<button class="kp-btn block outline" id="retry-market">Try again</button>' : ''}
    <section class="finder-banner"><h2>Growing native trees?</h2><p>Help someone start planting. Share the native seeds and seedlings you have available.</p><button class="kp-btn outline" data-href="#/market/new">${icon('sprout')} List a native tree</button></section>
  </div>`;
  root.querySelector('#retry-market')?.addEventListener('click', () => void renderMarket(root, params));
  root.querySelectorAll('ion-card[data-id]').forEach((el) => {
    el.addEventListener('click', () => (window.location.hash = `#/market/${(el as HTMLElement).dataset.id}`));
  });
}

export async function renderListingDetail(root: HTMLElement, id: string) {
  const d = await api<{ listing: Listing; photos: { id: string; file_url: string }[] }>(`/api/v1/marketplace/${id}`).catch(() => null);
  if (!d) {
    root.innerHTML = `<div class="pad"><p>Listing not found.</p></div>`;
    return;
  }
  const l = d.listing;
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-buttons slot="start"><button class="kp-btn clear" data-href="#/market" aria-label="Back">←</button></ion-buttons>
  <ion-title>Listing</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    ${d.photos[0] ? `<img class="hero" src="${esc(photoUrl(d.photos[0].file_url))}" />` : `<div class="img-ph big">🌱</div>`}
    <h2>${esc(l.title)}</h2>
    <p><i>${esc(l.scientific_name ?? '')}</i><br/>₱${esc(l.price)} · Available: ${esc(l.quantity)}<br/>
    ${esc(l.province)}${l.municipality ? `, ${esc(l.municipality)}` : ''} · Seller: ${esc(l.seller_name ?? '—')}</p>
    <p>${l.seller_verified ? '<span class="kp-badge verified">✓ Verified Seller</span>' : '<small>Seller Listing — Katutubong Puno does not guarantee sellers until nursery verification.</small>'}</p>
    <p>${esc(l.description ?? '')}</p>
    ${getToken() && l.contact_value ? `<ion-card color="light"><ion-card-content>Contact seller: <b>${esc(l.contact_value)}</b></ion-card-content></ion-card>`
      : '<p><a href="#/login">Log in</a> to see seller contact.</p>'}
    <p><a href="#/report/marketplace_listing/${id}">Report this listing</a></p>
  </div>`;
}

export async function renderListingNew(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>New Listing</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    <ion-item><ion-input label-placement="stacked" id="sp" label="Species (name)"></ion-input></ion-item>
    <div id="pick"></div>
    <ion-item><ion-select label-placement="stacked" id="mt" label="Material"><ion-select-option value="seed">Seed</ion-select-option><ion-select-option value="seedling">Seedling</ion-select-option><ion-select-option value="sapling">Sapling</ion-select-option></ion-select></ion-item>
    <ion-item><ion-input label-placement="stacked" id="title" label="Title"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="qty" label="Quantity" type="number" value="1"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="price" label="Price (₱)" type="number" value="0"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="prov" label="Province"></ion-input></ion-item>
    <ion-item><ion-input label-placement="stacked" id="contact" label="Contact (phone/email)"></ion-input></ion-item>
    <ion-item><ion-textarea label-placement="stacked" id="desc" label="Description"></ion-textarea></ion-item>
    ${photoField(4)}
    <p id="err" role="alert"></p>
    <button class="kp-btn block" id="go">Submit for review</button>
  </div>`;
  bindPhotoField(root, 4);
  let speciesId: string | null = null;
  (root.querySelector('#sp') as HTMLIonInputElement).addEventListener('ionChange', async (e) => {
    const qv = (e.target as HTMLIonInputElement).value as string;
    if (qv.trim().length < 2) return;
    const found = await api<{ species: { id: string; primary_name: string | null; scientific_name: string }[] }>(
      `/api/v1/species?q=${encodeURIComponent(qv.trim())}&limit=5`).catch(() => ({ species: [] }));
    const box = root.querySelector('#pick')!;
    box.innerHTML = found.species.map((s) => `<ion-chip data-id="${s.id}">${esc(s.primary_name ?? s.scientific_name)}</ion-chip>`).join('') || '<p><small>Cannot find your tree? Request the species first (admin).</small></p>';
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
      const created = await api<{ listing: { id: string } }>('/api/v1/marketplace', {
        method: 'POST',
        body: JSON.stringify({
          species_id: speciesId,
          title: v('#title'),
          material_type: ((root.querySelector('#mt') as HTMLIonSelectElement).value as string) || 'seedling',
          quantity: parseInt(v('#qty') || '1', 10),
          price: parseFloat(v('#price') || '0'),
          region: v('#prov'),
          province: v('#prov'),
          contact_method: 'other',
          contact_value: v('#contact'),
          description: ((root.querySelector('#desc') as HTMLIonTextareaElement).value as string) ?? '',
        }),
      });
      const files = (root.querySelector('#photos') as HTMLInputElement).files;
      if (files?.length) {
        for (const f of Array.from(files).slice(0, 4)) {
          const fd = new FormData();
          fd.append('photo', f);
          await api(`/api/v1/marketplace/${created.listing.id}/photos`, { method: 'POST', body: fd });
        }
      }
      toast('Listing submitted — pending review');
      window.location.hash = '#/market/mine';
    } catch (e) {
      (root.querySelector('#err') as HTMLElement).textContent = e instanceof Error ? e.message : 'Failed';
    }
  });
}

export async function renderListingsMine(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  const data = await api<{ listings: Listing[] }>('/api/v1/marketplace/mine').catch(() => ({ listings: [] }));
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>My Listings</ion-title></ion-toolbar></ion-header>
  <div class="pad">
    ${data.listings.map((l) => `<ion-card><ion-card-content><b>${esc(l.title)}</b> · <span class="kp-badge ${l.status ?? ''}">${esc(l.status ?? '')}</span> · ₱${esc(l.price)}
      ${l.status === 'active' ? `<br/><button data-id="${l.id}">Mark sold out</button>` : ''}</ion-card-content></ion-card>`).join('') || '<p>No listings yet.</p>'}
  </div>`;
  root.querySelectorAll('button[data-id]').forEach((b) => b.addEventListener('click', async () => {
    await api(`/api/v1/marketplace/${(b as HTMLElement).dataset.id}/sold-out`, { method: 'POST' });
    toast('Marked as sold out');
    void renderListingsMine(root);
  }));
}

