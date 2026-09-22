import { test, before, after, beforeEach } from 'node:test';
import assert from 'node:assert/strict';
import { mkdtemp, mkdir, readFile, writeFile, rm } from 'node:fs/promises';
import { tmpdir } from 'node:os';
import { join } from 'node:path';
import { pathToFileURL } from 'node:url';
import ts from 'typescript';
import { JSDOM } from 'jsdom';

let temp, dom, root, ui, finder, search;
const tick = () => new Promise(resolve => setTimeout(resolve, 0));
const tree = { id: 'native-1', primary_name: 'Narra', scientific_name: 'Pterocarpus indicus', native_status: 'native', growth_form: 'large', primary_photo: null, purposes: ['shade'], conditions: [] };
const purposes = [{ slug: 'shade', name: 'Shade' }, { slug: 'reforestation', name: 'Reforestation' }];
function respond(data) { return { ok: true, json: async () => data }; }
function click(selector) { const el = root.querySelector(selector); assert.ok(el, selector); el.click(); }

before(async () => {
  temp = await mkdtemp(join(tmpdir(), 'kp-ui-tests-'));
  await mkdir(join(temp, 'pages'));
  for (const name of ['api', 'pages/ui', 'pages/search', 'pages/finder']) {
    const source = await readFile(new URL(`../src/${name}.ts`, import.meta.url), 'utf8');
    const js = ts.transpileModule(source, { compilerOptions: { target: ts.ScriptTarget.ES2022, module: ts.ModuleKind.ESNext } }).outputText
      .replace(/from (['"])(\.{1,2}\/[^'"]+)\1/g, 'from $1$2.mjs$1');
    // Vite supplies this in the app; isolated Node tests use relative mocked URLs.
    await writeFile(join(temp, `${name}.mjs`), 'import.meta.env = { VITE_API_BASE: "" };\n' + js);
  }
  dom = new JSDOM('<ion-content></ion-content>', { url: 'http://localhost/#/home' });
  for (const key of ['window', 'document', 'localStorage', 'history', 'HTMLElement', 'FormData']) globalThis[key] = dom.window[key];
  class Field extends dom.window.HTMLElement {
    get value() { return this.getAttribute('value') ?? ''; }
    set value(v) { this.setAttribute('value', v); }
  }
  dom.window.customElements.define('ion-select', class extends Field {});
  dom.window.customElements.define('ion-searchbar', class extends Field {});
  dom.window.customElements.define('ion-content', class extends dom.window.HTMLElement { scrollToTop() { return Promise.resolve(); } });
  ui = await import(pathToFileURL(join(temp, 'pages/ui.mjs')));
  finder = await import(pathToFileURL(join(temp, 'pages/finder.mjs')));
  search = await import(pathToFileURL(join(temp, 'pages/search.mjs')));
});
beforeEach(() => {
  document.querySelector('ion-content').innerHTML = '<main></main>';
  root = document.querySelector('main');
  localStorage.clear();
});
after(async () => { dom.window.close(); await rm(temp, { recursive: true, force: true }); });

test('finder retains answers on Back and sends skipped steps without invented values', async () => {
  let recommendation;
  globalThis.fetch = async path => {
    if (path.includes('recommendations')) { recommendation = path; return respond({ total: 1, matches: [{ ...tree, matchReasons: ['Suitable for shade'] }] }); }
    return respond({ purposes });
  };
  await finder.renderFinder(root);
  assert.equal(root.querySelector('#next').disabled, true);
  click('[data-v="shade"]');
  assert.equal(root.querySelector('[data-v="shade"]').getAttribute('aria-pressed'), 'true');
  click('#next');
  click('[data-v="backyard"]');
  click('#next');
  click('#back');
  assert.equal(root.querySelector('[data-v="backyard"]').getAttribute('aria-pressed'), 'true');
  click('#next');
  click('#skip');
  click('[data-v="space-large"]');
  click('#next');
  await tick();
  const params = new URL(recommendation, 'http://localhost').searchParams;
  assert.equal(params.get('purpose'), 'shade');
  assert.equal(params.get('site'), 'backyard');
  assert.equal(params.get('space'), 'space-large');
  assert.equal(params.has('sunlight'), false);
  assert.match(root.textContent, /Suitable for shade/);
  click('#edit');
  assert.equal(root.querySelector('[data-v="shade"]').getAttribute('aria-pressed'), 'true');
});

test('search loads immediately, preserves filter values, and ignores stale responses', async () => {
  const pending = [];
  globalThis.fetch = async path => {
    if (path.includes('purposes')) return respond({ purposes });
    return new Promise(resolve => pending.push({ path, resolve }));
  };
  await search.renderSearch(root, new URLSearchParams('purpose=shade'));
  assert.equal(pending.length, 1);
  assert.match(pending[0].path, /purpose=shade/);
  const input = root.querySelector('#q');
  input.value = 'Narra';
  input.dispatchEvent(new dom.window.Event('ionInput'));
  assert.equal(pending.length, 2);
  pending[1].resolve(respond({ total: 1, species: [tree] }));
  await tick();
  pending[0].resolve(respond({ total: 0, species: [] }));
  await tick();
  assert.match(root.querySelector('#results').textContent, /Narra/);
  assert.equal(root.querySelectorAll('.tree-card').length, 1);
  assert.match(pending[1].path, /q=Narra/);
  click('#reset');
  assert.equal(root.querySelector('#q').value, '');
  assert.equal(root.querySelector('#f-purpose').value, '');
  assert.equal(new URL(pending[2].path, 'http://localhost').searchParams.has('purpose'), false);
  pending[2].resolve(respond({ total: 0, species: [] }));
  await tick();
  assert.match(root.textContent, /No trees found/);
});

test('search failures offer a working retry instead of a false empty result', async () => {
  let fail = true;
  globalThis.fetch = async path => {
    if (path.includes('purposes')) return respond({ purposes });
    if (fail) throw new TypeError('Network unavailable');
    return respond({ total: 1, species: [tree] });
  };
  await search.renderSearch(root, new URLSearchParams());
  await tick();
  assert.ok(root.querySelector('#retry-search'));
  fail = false;
  click('#retry-search');
  await tick();
  assert.equal(root.querySelectorAll('.tree-card').length, 1);
});

test('submission feedback prevents duplicate requests and restores the form after failure', async () => {
  root.innerHTML = '<p id="err" role="alert"></p><button id="go">Submit</button>';
  let calls = 0, complete;
  ui.bindAsyncAction(root, '#go', async () => { calls++; await new Promise(resolve => { complete = resolve; }); throw new Error('Please check the details'); });
  click('#go'); click('#go');
  assert.equal(calls, 1);
  assert.equal(root.querySelector('#go').disabled, true);
  assert.equal(root.querySelector('#go').getAttribute('aria-busy'), 'true');
  complete(); await tick();
  assert.equal(root.querySelector('#go').disabled, false);
  assert.equal(root.querySelector('#go').textContent, 'Submit');
  assert.equal(document.activeElement, root.querySelector('#err'));
  assert.match(root.querySelector('#err').textContent, /check the details/);
});

test('photo selection previews only the upload limit and clearly discloses extra files', () => {
  root.innerHTML = ui.photoField(4);
  const created = [], revoked = [];
  const originalCreate = URL.createObjectURL, originalRevoke = URL.revokeObjectURL;
  URL.createObjectURL = file => { const url = `blob:test-${file.name}`; created.push(url); return url; };
  URL.revokeObjectURL = url => revoked.push(url);
  try {
    ui.bindPhotoField(root, 4);
    const input = root.querySelector('#photos');
    Object.defineProperty(input, 'files', { value: Array.from({ length: 6 }, (_, i) => ({ name: `photo-${i}.jpg` })) });
    input.dispatchEvent(new dom.window.Event('change'));
    assert.equal(root.querySelectorAll('.photo-previews img').length, 4);
    assert.match(root.querySelector('#photo-count').textContent, /Only the first 4/);
    root.querySelectorAll('.photo-previews img').forEach(img => img.dispatchEvent(new dom.window.Event('load')));
    assert.deepEqual(revoked, created);
  } finally { URL.createObjectURL = originalCreate; URL.revokeObjectURL = originalRevoke; }
});

test('tree cards keep scientific names secondary and escape user-provided content', () => {
  root.innerHTML = ui.treeCard({ ...tree, primary_name: '<script>alert(1)</script>' });
  assert.equal(root.querySelector('script'), null);
  assert.equal(root.querySelector('ion-card-title').textContent, '<script>alert(1)</script>');
  assert.equal(root.querySelector('ion-card-subtitle i').textContent, tree.scientific_name);
  assert.match(root.textContent, /Photo coming soon/);
  assert.equal(root.querySelector('ion-card').hasAttribute('button'), true);
});
