import { api, getToken, SpeciesCard } from '../api';
import { treeCard, bindCards, emptyState, loadingState, pageHeader } from './ui';

export async function renderFavorites(root: HTMLElement) {
  if (!getToken()) {
    window.location.hash = '#/login';
    return;
  }
  root.innerHTML = `${pageHeader('Saved trees')}<div class="pad">${loadingState()}</div>`;
  try {
    const data = await api<{ favorites: SpeciesCard[] }>('/api/v1/favorites');
    root.innerHTML = `
    <ion-header><ion-toolbar><ion-title>Saved Trees</ion-title></ion-toolbar></ion-header>
    <div class="pad">
      <p class="eyebrow">Your personal field guide</p><h1>Keep your favorites close.</h1><p class="page-intro">A growing collection of trees to learn about and plant.</p>
      <div class="tree-grid">${data.favorites.length ? data.favorites.map(treeCard).join('') : emptyState('Make room for your favorites', 'Save a tree from its profile to build your own native tree collection.', 'heart', { label: 'Discover native trees', href: '#/search' })}</div>
    </div>`;
    bindCards(root);
  } catch {
    root.innerHTML = `${pageHeader('Saved trees')}<div class="pad">${emptyState('Your saved trees couldn’t be loaded', 'Check your connection and try again.', 'info')}<button class="kp-btn block outline" id="retry">Try again</button></div>`;
    root.querySelector('#retry')?.addEventListener('click', () => void renderFavorites(root));
  }
}

