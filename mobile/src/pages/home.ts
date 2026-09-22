import { api, getToken, SpeciesCard, esc } from '../api';
import { treeCard, bindCards, icon, purposeMeta, emptyState, loadingState, pageHeader } from './ui';

export async function renderHome(root: HTMLElement) {
  root.innerHTML = `${pageHeader('Katutubong Puno')}<div class="pad">${loadingState()}</div>`;
  let name = 'Kaibigan';
  if (getToken()) {
    try {
      const me = await api<{ user: { display_name: string } }>('/api/v1/auth/me');
      name = me.user.display_name.split(' ')[0];
    } catch { /* Keep guest greeting. */ }
  }
  let purposes: { slug: string; name: string }[] = [];
  let trees: SpeciesCard[] = [];
  let featured: SpeciesCard[] = [];
  let unavailable = false;
  try {
    const [p, s, f] = await Promise.all([
      api<{ purposes: { slug: string; name: string }[] }>('/api/v1/purposes'),
      api<{ species: SpeciesCard[] }>('/api/v1/species?limit=6'),
      api<{ species: SpeciesCard[] }>('/api/v1/species?featured=true&limit=3').catch(() => ({ species: [] })),
    ]);
    purposes = p.purposes;
    trees = s.species;
    featured = f.species;
  } catch { unavailable = true; }
  const preferred = Object.keys(purposeMeta).map(slug => purposes.find(p => p.slug === slug)).filter((p): p is { slug: string; name: string } => !!p);
  const visiblePurposes = preferred.length ? preferred : purposes.slice(0, 6);
  root.innerHTML = `
  <ion-header class="ion-no-border"><ion-toolbar><ion-title><span class="kp-apptitle"><img src="/logo-symbol-64.png" width="36" height="36" alt="" /> Katutubong Puno</span></ion-title><ion-buttons slot="end"><button class="kp-btn clear icon-button" data-href="#/me" aria-label="My profile">${icon('user')}</button></ion-buttons></ion-toolbar></ion-header>
  <div class="pad home-page">
    <p class="eyebrow">Rooted in the Philippines</p>
    <h1>Kumusta, ${esc(name)}!</h1>
    <p class="page-intro">Discover the native trees that belong here.</p>
    <ion-searchbar id="q" aria-label="Search native trees" placeholder="Search common or scientific name"></ion-searchbar>
    <button class="identify-banner" data-href="#/identify"><span class="banner-icon">${icon('camera')}</span><span><strong>What tree is this?</strong><span>Take a photo. Discover its story.</span></span>${icon('arrow')}</button>
    <div class="sec-head"><div><p class="eyebrow">Every tree has a purpose</p><h2>What would you like to grow?</h2></div><a href="#/search">View all</a></div>
    <div class="purpose-grid">${visiblePurposes.map(p => {
      const m = purposeMeta[p.slug];
      return `<button class="purpose-card" data-href="#/search?purpose=${encodeURIComponent(p.slug)}"><span class="purpose-icon">${icon(m?.icon ?? 'leaf')}</span><span class="plabel">${esc(m?.label ?? p.name)}</span><span class="purpose-hint">${esc(m?.hint ?? 'Explore native species')}</span></button>`;
    }).join('')}</div>
    ${unavailable ? emptyState('Let’s reconnect', 'We couldn’t load the tree collection. Check your connection and try again.', 'info', { label: 'Try again', href: '#/home' }) : ''}
    <div class="sec-head"><div><p class="eyebrow">Get to know our native trees</p><h2>${featured.length ? 'Featured native trees' : 'Discover something native'}</h2></div><a href="#/search">Explore all</a></div>
    <div class="tree-grid">${(featured.length ? featured : trees).map(treeCard).join('') || (!unavailable ? emptyState('A collection taking root', 'Native tree profiles will appear here as they are added.') : '')}</div>
    ${featured.length ? `<div class="sec-head"><h2>Explore native trees</h2></div><div class="tree-grid">${trees.map(treeCard).join('')}</div>` : ''}
    <section class="finder-banner"><span class="eyebrow">The right tree, in the right place</span><h2>A little guidance.<br/>A lasting difference.</h2><p>Find native trees suited to your space, sunlight and purpose.</p><button class="kp-btn" data-href="#/finder">Find my tree ${icon('arrow')}</button></section>
    <div class="sec-head"><h2>Keep growing</h2></div>
    <div class="action-list">
      <a href="#/observe/new">${icon('camera')}<span><strong>Document a tree</strong><small>Share what’s growing around you</small></span>${icon('arrow')}</a>
      <a href="#/map">${icon('pin')}<span><strong>Native tree map</strong><small>Explore community observations</small></span>${icon('arrow')}</a>
      <a href="#/market">${icon('sprout')}<span><strong>Find native seedlings</strong><small>Connect with growers and nurseries</small></span>${icon('arrow')}</a>
    </div>
    <p class="brand-footer">Discover. Identify. Plant Native.</p>
  </div>`;
  const q = root.querySelector<HTMLIonSearchbarElement>('#q');
  q?.addEventListener('ionChange', () => { window.location.hash = `#/search?q=${encodeURIComponent(q.value ?? '')}`; });
  root.querySelector('a[href="#/home"]')?.addEventListener('click', e => { e.preventDefault(); void renderHome(root); });
  bindCards(root);
}

