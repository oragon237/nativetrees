import '@ionic/core/css/ionic.bundle.css';
import { defineCustomElements } from '@ionic/core/loader';
import './styles.css';
import { renderHome } from './pages/home';
import { renderSearch } from './pages/search';
import { renderTree } from './pages/tree';
import { renderFinder } from './pages/finder';
import { renderFavorites } from './pages/favorites';
import { renderLogin, renderRegister, renderMe } from './pages/auth';
import { renderIdentifyNew, renderIdentifyList, renderIdentifyDetail, renderObserveNew, renderObservationsMine } from './pages/community';
import { renderMarket, renderListingDetail, renderListingNew, renderListingsMine } from './pages/market';
import { renderNotifications, renderCorrection, renderReport, renderModeration } from './pages/activity';
import { renderContributeChoice, renderSpeciesForm, renderMyContributions, renderContributionDetail, renderPhotoForm } from './pages/contribute';
import { renderMap } from './pages/map';
import { renderPlantings, renderPlantNew, renderPlantDetail, renderPlantedPublic } from './pages/plantings';
import { renderProjects, renderProjectDetail, renderProjectNew, renderOrganization } from './pages/projects';
import { syncDrafts, loadDrafts } from './pages/offline';
import { icon, loadingState } from './pages/ui';

defineCustomElements();

const pageHost = document.getElementById('page') as HTMLIonContentElement;
const tabs = document.getElementById('tabs') as HTMLElement;
tabs.innerHTML = [
  ['home', '#/home', 'leaf', 'Discover'],
  ['identify', '#/identify', 'camera', 'Identify'],
  ['find', '#/finder', 'tree', 'Find tree'],
  ['saved', '#/favorites', 'heart', 'Saved'],
  ['me', '#/me', 'user', 'Me'],
].map(([key, href, symbol, label]) => `<ion-tab-button tab="${key}" href="${href}"><span class="nav-icon">${icon(symbol)}</span><ion-label>${label}</ion-label></ion-tab-button>`).join('');

// Bottom tab bar: manual navigation (ion-tab-button anchors are unreliable
// without an ion-tabs parent, so clicks are handled explicitly) + selected state.
const TAB_FOR_ROUTE: Record<string, string> = {
  home: 'home',
  search: 'home',
  tree: 'home',
  identify: 'identify',
  finder: 'find',
  favorites: 'saved',
  me: 'me',
};

function paintTabs(routeKey: string) {
  const tab = TAB_FOR_ROUTE[routeKey] ?? '';
  tabs.querySelectorAll('ion-tab-button').forEach((b) => {
    if ((b as HTMLElement).getAttribute('tab') === tab) { b.setAttribute('selected', ''); b.setAttribute('aria-current', 'page'); }
    else { b.removeAttribute('selected'); b.removeAttribute('aria-current'); }
  });
}

function wireTabs() {
  tabs.querySelectorAll('ion-tab-button').forEach((b) => {
    b.addEventListener('click', (e) => {
      e.preventDefault();
      e.stopPropagation();
      const href = (b as HTMLElement).getAttribute('href') ?? '#/home';
      if (window.location.hash === href) {
        route();
      } else {
        window.location.hash = href;
      }
    }, { capture: true });
  });
}

function route() {
  // Each navigation owns its render target, so slower requests cannot overwrite a newer screen.
  const page = document.createElement('main');
  page.innerHTML = `<div class="pad">${loadingState('Opening…')}</div>`;
  pageHost.replaceChildren(page);
  const raw = window.location.hash.replace(/^#/, '') || '/home';
  const [path, query] = raw.split('?');
  const params = new URLSearchParams(query ?? '');
  const seg = path.split('/').filter(Boolean);
  tabs.style.display = '';
  void pageHost.scrollToTop?.(0);
  paintTabs(seg[0] ?? 'home');

  if (seg[0] === 'home' || seg.length === 0) void renderHome(page);
  else if (seg[0] === 'search') void renderSearch(page, params);
  else if (seg[0] === 'tree' && seg[1]) void renderTree(page, seg[1]);
  else if (seg[0] === 'finder') void renderFinder(page);
  else if (seg[0] === 'favorites') void renderFavorites(page);
  else if (seg[0] === 'login') {
    tabs.style.display = 'none';
    renderLogin(page);
  } else if (seg[0] === 'register') {
    tabs.style.display = 'none';
    renderRegister(page);
  }   else if (seg[0] === 'me') void renderMe(page);
  else if (seg[0] === 'contribute' && seg[1] === 'species') renderSpeciesForm(page);
  else if (seg[0] === 'contribute' && seg[1] === 'photo' && seg[2]) renderPhotoForm(page, seg[2]);
  else if (seg[0] === 'contribute' && seg[1] === 'photo') void renderMyContributions(page);
  else if (seg[0] === 'contribute') renderContributeChoice(page);
  else if (seg[0] === 'contributions' && seg[1] === 'species' && seg[2]) void renderContributionDetail(page, 'species', seg[2]);
  else if (seg[0] === 'contributions' && seg[1] === 'photo' && seg[2]) void renderContributionDetail(page, 'photo', seg[2]);
  else if (seg[0] === 'contributions') void renderMyContributions(page);
  else if (seg[0] === 'identify' && seg[1] === 'new') renderIdentifyNew(page);
  else if (seg[0] === 'identify' && seg[1]) void renderIdentifyDetail(page, seg[1]);
  else if (seg[0] === 'identify') void renderIdentifyList(page);
  else if (seg[0] === 'observe' && seg[1] === 'new') renderObserveNew(page);
  else if (seg[0] === 'observations') void renderObservationsMine(page);
  else if (seg[0] === 'market' && seg[1] === 'new') void renderListingNew(page);
  else if (seg[0] === 'market' && seg[1] === 'mine') void renderListingsMine(page);
  else if (seg[0] === 'market' && seg[1]) void renderListingDetail(page, seg[1]);
  else if (seg[0] === 'market') void renderMarket(page, params);
  else if (seg[0] === 'notifications') void renderNotifications(page);
  else if (seg[0] === 'correct' && seg[1]) renderCorrection(page, seg[1]);
  else if (seg[0] === 'report' && seg[1] && seg[2]) renderReport(page, seg[1], seg[2]);
  else if (seg[0] === 'moderation') void renderModeration(page);
  else if (seg[0] === 'map') void renderMap(page);
  else if (seg[0] === 'plantings') void renderPlantings(page);
  else if (seg[0] === 'plant' && seg[1] === 'new') renderPlantNew(page);
  else if (seg[0] === 'plant' && seg[1]) void renderPlantDetail(page, seg[1]);
  else if (seg[0] === 'planted' && seg[1]) void renderPlantedPublic(page, seg[1]);
  else if (seg[0] === 'projects') void renderProjects(page);
  else if (seg[0] === 'project' && seg[1] === 'new') renderProjectNew(page);
  else if (seg[0] === 'project' && seg[1]) void renderProjectDetail(page, seg[1]);
  else if (seg[0] === 'organization') void renderOrganization(page);
  else window.location.hash = '#/home';
}

window.addEventListener('hashchange', route);
wireTabs();
// Keep the layout useful when a remote or uploaded photograph is unavailable.
document.addEventListener('error', (event) => {
  const img = event.target;
  if (!(img instanceof HTMLImageElement) || !img.closest('.tree-card, .listing-card')) return;
  const fallback = document.createElement('div');
  fallback.className = 'img-ph';
  fallback.innerHTML = `${icon('tree')}<span>Photo unavailable</span>`;
  img.replaceWith(fallback);
}, true);
// Native-button navigation (data-href).
document.addEventListener('click', (e) => {
  const t = (e.target as HTMLElement).closest?.('button[data-href]');
  const href = t?.getAttribute('data-href');
  if (href) window.location.hash = href;
});
route();
// V2 offline: attempt to sync queued drafts when connectivity returns.
window.addEventListener('online', () => {
  if (loadDrafts().length) void syncDrafts();
});
if (navigator.onLine && loadDrafts().length) void syncDrafts();
