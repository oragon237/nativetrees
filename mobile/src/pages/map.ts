import L from 'leaflet';
import 'leaflet/dist/leaflet.css';
import { api, esc } from '../api';

// V2: interactive native tree map. Only approximate (rounded) locations
// ever reach this feed — exact/private locations are excluded server-side.
export async function renderMap(root: HTMLElement) {
  root.innerHTML = `
  <ion-header><ion-toolbar><ion-title>Native Tree Map</ion-title></ion-toolbar></ion-header>
  <div id="kpmap" style="height:calc(100vh - 180px);min-height:320px"></div>
  <div class="pad"><p><small>📍 Approximate community observations. Exact locations stay private for conservation.</small></p></div>`;
  const el = root.querySelector('#kpmap') as HTMLElement;
  const map = L.map(el).setView([12.8797, 121.774], 6);
  L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
    maxZoom: 18,
    attribution: '&copy; OpenStreetMap contributors',
  }).addTo(map);
  try {
    const data = await api<{ points: { id: string; species_name: string | null; province: string | null; lat: number; lng: number }[] }>(
      '/api/v1/map/observations?limit=200');
    for (const p of data.points) {
      L.circleMarker([p.lat, p.lng], { radius: 8, color: '#0b4d2b', fillColor: '#2e7d32', fillOpacity: 0.7 })
        .addTo(map)
        .bindPopup(`<b>${esc(p.species_name ?? 'Native tree')}</b><br/>${esc(p.province ?? '')}<br/><small>Approximate location</small>`);
    }
    if (!data.points.length) {
      const div = document.createElement('div');
      div.className = 'pad';
      div.innerHTML = '<p><small>No map points yet.</small></p>';
      root.appendChild(div);
    }
  } catch {
    const div = document.createElement('div');
    div.className = 'pad';
    div.innerHTML = '<p>No map points yet — approved approximate observations will appear here.</p>';
    root.appendChild(div);
  }
  // Fix sizing when the tab/content settles.
  setTimeout(() => map.invalidateSize(), 300);
}

