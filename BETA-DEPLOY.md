# Katutubong Puno — Beta Deployment on Hostinger VPS

**Goal:** one VPS runs PostgreSQL + API (localhost-only DB) + both web apps,
so admin and beta testers can install, test, and report improvements.

Architecture (beta):

```text
Testers (browser / Android APK)
   │ HTTPS
   ▼
Nginx (:443) ──┬── www.clientwebsitedemo.com/native-api/* ──► Node API (:4000, pm2)
               ├── www.clientwebsitedemo.com/native/backend ─► admin-web/dist (static)
               └── app.yourdomain.com ───► mobile/dist (static)
PostgreSQL (:5432, localhost only — never exposed to the internet)
```

> The beta API lives under the existing site at
> `https://www.clientwebsitedemo.com/native-api`
> (so API calls look like `.../native-api/api/v1/species`). Admin and
> mobile web can stay on subdomains, or be served as further subpaths
> behind the same Nginx host.

---

## 0. Prereqs

- Hostinger **VPS (KVM 1 or larger)**, Ubuntu 22.04/24.04
- A domain pointed at the VPS IP: `app.` subdomain for the mobile web
  (API and admin live as subpaths on `www.clientwebsitedemo.com`)
- SSH access (hPanel → VPS overview, or PuTTY/Terminal)

## 1. PostgreSQL on the VPS

### Option A — one-click template (easiest)
hPanel → VPS → **OS & Panel / Templates** → deploy the **PostgreSQL Docker** template.
Note the postgres password it generates, then skip to step 2.

### Option B — manual install (Ubuntu)
```bash
sudo apt update && sudo apt install -y postgresql postgresql-contrib
sudo systemctl enable --now postgresql
```

### Create the app database (least-privilege user)
```bash
# strong password — store it in a password manager
APP_DB_PASS='PASTE-LONG-RANDOM-PASSWORD'

sudo -u postgres psql -c "CREATE USER katutubong WITH PASSWORD '$APP_DB_PASS';"
sudo -u postgres psql -c "CREATE DATABASE katutubong_puno OWNER katutubong;"
```

### Lock it down (important)
Postgres must listen on **localhost only** (beta testers never touch the DB directly):

```bash
# /etc/postgresql/*/main/postgresql.conf → listen_addresses = 'localhost'
sudo sed -i "s/^#listen_addresses.*/listen_addresses = 'localhost'/" /etc/postgresql/*/main/postgresql.conf
sudo systemctl restart postgresql
# firewall: do NOT open 5432
sudo ufw deny 5432 2>/dev/null; sudo ufw allow OpenSSH; sudo ufw --force enable
```

Verify: `sudo -u postgres psql -c "SHOW listen_addresses;"` → `localhost`.

## 2. Backend API

```bash
# Node 20+
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs git nginx certbot python3-certbot-nginx
sudo npm i -g pm2

git clone <your-repo-url> katutubong-puno && cd katutubong-puno/backend
npm ci
cp .env.example .env
```

Edit `.env` (production values — never commit this file):

```text
PORT=4000
DATABASE_URL=postgres://katutubong:APP_DB_PASS@localhost:5432/katutubong_puno
JWT_SECRET=<output of: openssl rand -hex 32>
CORS_ORIGINS=https://app.yourdomain.com,https://www.clientwebsitedemo.com
# PG_SSL=  (leave unset — same-machine connection)
```

```bash
npm run migrate     # creates all tables + seeds (15 purposes, 31 conditions, 66 sample species + 56 sample photos)
npm run build
pm2 start dist/server.js --name kp-api
pm2 startup && pm2 save
curl http://localhost:4000/api/v1/health   # {"ok":true,...}
```

> Sample photos: migrations only insert the gallery *rows*. Copy the
> image files from your dev machine, preserving paths:
>
> ```powershell
> # Windows → VPS (WinSCP/FileZilla also works — keep folder structure!)
> scp -r backend\uploads\* root@YOUR-VPS-IP:/home/kp/backend/uploads/
> ```
>
> Then confirm: `https://www.clientwebsitedemo.com/native-api/api/v1/species?limit=3`
> shows `primary_photo` URLs, and one image URL loads in a browser.

## 3. Web apps (Nginx static + HTTPS)

```bash
cd ../admin-web && npm ci && npm run build
cd ../mobile && npm ci && npm run build
sudo mkdir -p /var/www/kp-admin /var/www/kp-app
sudo cp -r ../admin-web/dist/* /var/www/kp-admin/
sudo cp -r ../mobile/dist/* /var/www/kp-app/
```

> Admin beta build (served from `/native/backend/` — needs the base path):
>
> ```powershell
> cd admin-web
> $env:VITE_BASE_PATH = '/native/backend'
> npm run build
> ```

Nginx example (`/etc/nginx/sites-available/katutubong`):

```nginx
# API under the existing site subpath. The trailing slash on proxy_pass
# STRIPS /native-api/ so the backend keeps seeing /api/v1/... and /uploads/...
server {
  server_name www.clientwebsitedemo.com;
  # ... existing site config ...
  location /native-api/ {
    proxy_pass http://127.0.0.1:4000/;
    proxy_http_version 1.1;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    client_max_body_size 10m;
  }
}
server {
  server_name www.clientwebsitedemo.com;
  # ... existing site config ...

  # Admin SPA under a subpath (build with VITE_BASE_PATH=/native/backend).
  location /native/backend/ {
    alias /var/www/kp-admin/;
    try_files $uri $uri/ /native/backend/index.html;
  }
}
server {
  server_name app.yourdomain.com;
  root /var/www/kp-app;
  location / { try_files $uri $uri/ /index.html; }
  # same-origin API for the mobile web app:
  location /api/ { proxy_pass http://127.0.0.1:4000; proxy_set_header Host $host; }
  location /uploads/ { proxy_pass http://127.0.0.1:4000; }
}
```

```bash
sudo ln -s /etc/nginx/sites-available/katutubong /etc/nginx/sites-enabled/
sudo nginx -t && sudo systemctl reload nginx
sudo certbot --nginx -d www.clientwebsitedemo.com -d app.yourdomain.com
```

> Health check: `https://www.clientwebsitedemo.com/native-api/api/v1/health`
> should return `{"ok":true,...}`.

> Web apps use relative `/api/...` URLs served through the Nginx
> proxies above, so no rebuild is needed per environment. Only the
> Android APK needs an absolute URL (it has no same-origin proxy):
>
> ```powershell
> cd mobile
> $env:VITE_API_BASE = 'https://www.clientwebsitedemo.com/native-api'
> npm run build
> ```

## 4. Seed the beta admin + tester accounts

```bash
# register, then promote via psql (replace email/password)
curl -s -X POST https://www.clientwebsitedemo.com/native-api/api/v1/auth/register \
  -H 'Content-Type: application/json' \
  -d '{"email":"admin@yourdomain.com","password":"CHANGE-ME-STRONG","display_name":"Beta Admin"}'

sudo -u postgres psql -d katutubong_puno -c \
  "UPDATE users SET email_verified_at = now() WHERE email='admin@yourdomain.com';"
sudo -u postgres psql -d katutubong_puno -c \
  "INSERT INTO user_roles (user_id, role_id) SELECT u.id, r.id FROM users u, roles r \
   WHERE u.email='admin@yourdomain.com' AND r.name IN ('moderator','admin') ON CONFLICT DO NOTHING;"
```

Repeat for moderator/tester accounts (role `user`, or `moderator` for QA leads).
Testers log in at `https://app.yourdomain.com` (users) and
`https://www.clientwebsitedemo.com/native/backend/login` (staff).

## 5. Android APK for testers (after §3)

1. In `mobile/src/api.ts`, the API base is build-time configurable — set `VITE_API_BASE=https://www.clientwebsitedemo.com/native-api` and rebuild.
2. `npm i @capacitor/core @capacitor/cli @capacitor/android && npx cap init ... && npx cap add android`
3. Open in Android Studio → **Build → Build APK(s)** → distribute the debug APK
   (for wider distribution later: signed release APK + Play internal testing).
4. Android 9+ requires HTTPS — covered by Certbot above.

## 6. Backups & updates

```bash
# nightly database backup (crontab)
0 2 * * * sudo -u postgres pg_dump katutubong_puno | gzip > /var/backups/kp-$(date +\%F).sql.gz

# updating the beta: pull, install, migrate, rebuild, restart
cd ~/katutubong-puno && git pull && cd backend && npm ci && npm run migrate && npm run build && pm2 restart kp-api
```

## 7. Tester reporting loop

- Testers follow `TESTING.md` scripts and file issues with role + URL + steps + screenshot.
- Triage daily in admin **Reports** + **Moderation**; fixes ship via §6 update flow.
- Never share `.env`, DB passwords, or the Postgres superuser with testers.
