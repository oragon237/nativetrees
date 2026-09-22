import { esc, SpeciesCard, photoUrl } from '../api';

// Small, consistent line icons. Meaningful controls always include a text label.
const icons: Record<string, string> = {
  leaf: '<path d="M20 4C10 2 3 6 4 13s12 9 16-9Z"/><path d="M4 20 15 9"/>',
  tree: '<path d="m12 3-6 7h3l-5 7h7v4h2v-4h7l-5-7h3Z"/>',
  camera: '<path d="M8 5 6 8H3v12h18V8h-3l-2-3Z"/><circle cx="12" cy="13" r="4"/>',
  search: '<circle cx="10" cy="10" r="6"/><path d="m15 15 6 6"/>',
  arrow: '<path d="M4 12h16m-6-6 6 6-6 6"/>',
  heart: '<path d="M20 5c-3-3-7-1-8 2-1-3-5-5-8-2-5 5 8 15 8 15S25 10 20 5Z"/>',
  user: '<circle cx="12" cy="8" r="4"/><path d="M4 21v-2a8 8 0 0 1 16 0v2"/>',
  pin: '<path d="M19 10c0 6-7 11-7 11S5 16 5 10a7 7 0 0 1 14 0Z"/><circle cx="12" cy="10" r="2"/>',
  sun: '<circle cx="12" cy="12" r="4"/><path d="M12 2v2m0 16v2M2 12h2m16 0h2M5 5l2 2m10 10 2 2M5 19l2-2M17 7l2-2"/>',
  fruit: '<path d="M12 7c-8-6-12 8-5 13 2 1 3-1 5-1s3 2 5 1c7-5 3-19-5-13Zm0 0V3m0 2c1-3 4-3 6-2-1 3-4 3-6 2Z"/>',
  flower: '<path d="M12 9C5-3 0 10 9 12c-12 7 1 12 3 3 7 12 12-1 3-3 12-7-1-12-3-3Z"/><circle cx="12" cy="12" r="3"/>',
  wildlife: '<path d="M3 17c6 1 5-9 10-10 5-2 5 4 8 4l-4 2c0 6-7 9-14 4Z"/><path d="m5 16 7-3m0 7v2m3-3v3"/>',
  mountain: '<path d="m2 20 7-14 5 8 3-5 5 11H2Zm4-8 3 2 3-2"/>',
  sprout: '<path d="M12 21V10M12 14C3 15 2 10 3 6c6 0 9 3 9 8Zm0-4c0-6 4-8 9-7 0 5-4 8-9 7Z"/>',
  check: '<path d="m5 12 4 4L19 6"/>',
  info: '<circle cx="12" cy="12" r="9"/><path d="M12 11v6m0-10v1"/>',
  upload: '<path d="M12 16V3m-5 5 5-5 5 5M4 15v6h16v-6"/>',
  filter: '<path d="M3 6h18M3 12h18M3 18h18"/><circle cx="8" cy="6" r="2"/><circle cx="16" cy="12" r="2"/><circle cx="9" cy="18" r="2"/>',
};

export function icon(name: string): string {
  return `<svg class="kp-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.7" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true">${icons[name] ?? icons.leaf}</svg>`;
}

export const purposeMeta: Record<string, { icon: string; label: string; hint: string }> = {
  shade: { icon: 'tree', label: 'Shade', hint: 'A cooler, greener space' },
  'fruit-bearing': { icon: 'fruit', label: 'Fruit', hint: 'Grow something nourishing' },
  'flowering-ornamental': { icon: 'flower', label: 'Flowering', hint: 'Bring your garden to life' },
  'wildlife-support': { icon: 'wildlife', label: 'Wildlife', hint: 'Make room for nature' },
  'soil-erosion-control': { icon: 'mountain', label: 'Erosion control', hint: 'Help protect the soil' },
  reforestation: { icon: 'sprout', label: 'Reforestation', hint: 'Restore native landscapes' },
};

export function readable(value: string): string {
  return purposeMeta[value]?.label ?? value.replace(/[-_]/g, ' ').replace(/^./, c => c.toUpperCase());
}

export function pageHeader(title: string, back?: string): string {
  return `<ion-header class="ion-no-border"><ion-toolbar>${back ? `<ion-buttons slot="start"><button class="kp-btn clear back-btn" data-href="${esc(back)}" aria-label="Back">${icon('arrow')}</button></ion-buttons>` : ''}<ion-title>${esc(title)}</ion-title></ion-toolbar></ion-header>`;
}

export function emptyState(title: string, description: string, symbol = 'leaf', action?: { label: string; href: string }): string {
  return `<div class="kp-empty" role="status"><span class="state-icon">${icon(symbol)}</span><h3>${esc(title)}</h3><p>${esc(description)}</p>${action ? `<a class="kp-btn outline" href="${esc(action.href)}">${esc(action.label)}</a>` : ''}</div>`;
}

export function loadingState(label = 'Loading your trees…'): string {
  return `<div class="loading-state" role="status" aria-live="polite"><ion-spinner name="crescent" aria-hidden="true"></ion-spinner><span>${esc(label)}</span></div><div class="skeleton" aria-hidden="true"></div>`;
}

export function photoField(limit = 6): string {
  return `<div class="photo-field"><label for="photos">${icon('upload')}<strong>Add tree photos</strong><span>Choose up to ${limit} clear photos</span></label><input type="file" id="photos" aria-label="Add tree photos" accept="image/*" multiple /><div class="photo-previews" id="photo-previews"></div><p id="photo-count" class="field-help" role="status">Whole tree, leaves, bark, flowers or fruit.</p></div>`;
}

export function bindPhotoField(root: HTMLElement, limit = 6) {
  const input = root.querySelector<HTMLInputElement>('#photos');
  input?.addEventListener('change', () => {
    const preview = root.querySelector<HTMLElement>('#photo-previews')!;
    preview.replaceChildren();
    const files = Array.from(input.files ?? []);
    for (const file of files.slice(0, limit)) {
      const img = document.createElement('img');
      const url = URL.createObjectURL(file);
      img.alt = file.name;
      img.onload = img.onerror = () => URL.revokeObjectURL(url);
      img.src = url;
      preview.append(img);
    }
    root.querySelector('#photo-count')!.textContent = files.length ? `${Math.min(files.length, limit)} photo${files.length === 1 ? '' : 's'} selected${files.length > limit ? ` · Only the first ${limit} will be uploaded.` : ' · Choose files again to replace.'}` : 'Whole tree, leaves, bark, flowers or fruit.';
  });
}

/** Keep submission feedback consistent without changing each form's API workflow. */
export function bindAsyncAction(root: HTMLElement, selector: string, action: () => Promise<void>) {
  const button = root.querySelector<HTMLButtonElement>(selector);
  button?.addEventListener('click', async () => {
    if (button.disabled) return;
    const label = button.innerHTML;
    button.disabled = true;
    button.setAttribute('aria-busy', 'true');
    button.textContent = 'Please wait…';
    const error = root.querySelector<HTMLElement>('#err');
    if (error) error.textContent = '';
    try { await action(); }
    catch (e) {
      if (error) error.textContent = e instanceof Error ? e.message : 'Something went wrong. Please try again.';
      else toast('Something went wrong. Please try again.');
    } finally {
      button.disabled = false;
      button.removeAttribute('aria-busy');
      button.innerHTML = label;
      if (error?.textContent) { error.tabIndex = -1; error.focus(); }
    }
  });
}

export function treeCard(t: SpeciesCard): string {
  const img = photoUrl(t.primary_photo);
  return `
  <ion-card button class="tree-card" data-id="${esc(t.id)}" aria-label="Learn about ${esc(t.primary_name ?? t.scientific_name)}">
    <div class="tree-photo">${img ? `<img loading="lazy" src="${esc(img)}" alt="${esc(t.primary_name ?? t.scientific_name)}" />` : `<div class="img-ph">${icon('tree')}<span>Photo coming soon</span></div>`}<span class="photo-badge">${icon('leaf')}${t.native_status === 'endemic' ? 'Endemic' : 'Native'}</span></div>
    <ion-card-header>
      <ion-card-title>${esc(t.primary_name ?? 'Unknown')}</ion-card-title>
      <ion-card-subtitle><i>${esc(t.scientific_name)}</i></ion-card-subtitle>
    </ion-card-header>
    <ion-card-content>
      <div class="tree-tags">${t.purposes?.slice(0, 2).map(p => `<span>${esc(readable(p))}</span>`).join('') ?? ''}</div>
      <div class="tree-footer"><span>${t.growth_form ? `${esc(readable(t.growth_form))} tree` : 'Explore this species'}</span>${icon('arrow')}</div>
    </ion-card-content>
  </ion-card>`;
}

export function bindCards(root: HTMLElement) {
  root.querySelectorAll<HTMLElement>('.tree-card').forEach((el) => {
    el.addEventListener('click', () => {
      window.location.hash = `#/tree/${el.dataset.id}`;
    });
  });
}

export function toast(msg: string) {
  const t = document.createElement('ion-toast');
  t.message = msg;
  t.duration = 2200;
  t.position = 'bottom';
  t.cssClass = 'kp-toast';
  t.buttons = [{ text: 'Dismiss', role: 'cancel' }];
  t.addEventListener('ionToastDidDismiss', () => t.remove(), { once: true });
  document.body.appendChild(t);
  void t.present();
}

