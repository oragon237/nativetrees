# Katutubong Puno — Monorepo (V1 / MVP)

> Discover. Identify. Plant Native.

## Layout

- `backend/` — Node + TypeScript + Express REST API (Phase 1: auth, RBAC, Postgres, storage abstraction)
- `admin-web/` — Web admin portal (starts Phase 2 with species editor)
- `mobile/` — Android app (starts Phase 3)
- `prd.md` — Product Requirements Document v1.0
- `code-database.md` — Database schema, screen map & user flow spec v1.0

## Phase 1 quickstart (backend)

```powershell
# 1. Create database
psql -U postgres -h localhost -c "CREATE DATABASE katutubong_puno;"

# 2. Configure
cd backend
Copy-Item .env.example .env
# edit .env -> set JWT_SECRET to a long random string

# 3. Install + migrate + run
npm install
npm run migrate
npm run dev
```

Health check: `GET http://localhost:4000/api/v1/health`

## API groups (Phase 1–2 live)

- `/api/v1/health`
- `/api/v1/auth` — register, login, verify-email, password-reset-*, me
- `/api/v1/users` — PATCH /me
- `/api/v1/species` — search, filters, tree profile (verified only)
- `/api/v1/recommendations` — Right Tree finder engine (filtering + match reasons, no AI scores)
- `/api/v1/purposes`, `/api/v1/planting-conditions` — catalogs
- `/api/v1/admin` — users, roles, audit-logs, full species editor backend

## API groups (V2–V3 live)

- `POST /api/v1/identifications/:id/ai-suggest` — possible-match engine (confidence + disclaimer, never a guaranteed ID)
- `GET /api/v1/map/observations` — public map feed (approximate locations only)
- `/api/v1/nurseries` — verification requests + admin review; verified sellers badged in marketplace
- `/api/v1/users/me/reputation` — score + earned badges (auto-awarded on contributions)
- `/api/v1/alerts` — seedling availability alerts (fan-out on listing approval)
- `/api/v1/devices` — push device tokens (stub sender; set `PUSH_ENABLED=true` with a provider)
- `/api/v1/planted-trees` — planting tracker + growth records + public QR landing (`/planted-trees/public/:token`)
- `/api/v1/projects` — community planting projects (create, join/pledge, progress)
- `/api/v1/organizations` — organization profiles + admin verification

Email uses real SMTP when `SMTP_HOST` (+`SMTP_PORT/SMTP_USER/SMTP_PASS/SMTP_FROM`) is set, otherwise logs in dev.

Full API surface per `code-database.md` Part VIII continues in Phases 3–6.

## Admin web (Phase 2)

```powershell
cd admin-web
npm install
npm run dev   # http://localhost:5173 (proxies /api to :4000)
```

Log in with an admin/moderator account, then manage the tree database
under Species (list/search, editor tabs, publish/archive, photos).

## Mobile app (Phase 3)

```powershell
# backend must be running on :4000 first
cd backend
npm run dev

# then in another window:
cd mobile
npm install
npm run dev   # http://localhost:8100
```

Bottom tabs: Discover · Identify · Find tree · Saved · Me. Search and native seedling listings remain accessible from Discover and tree profiles.

## Full local run (V1)

```powershell
# database (once)
psql -U postgres -h localhost -c "CREATE DATABASE katutubong_puno;"

# backend :4000
cd backend
Copy-Item .env.example .env   # set a long JWT_SECRET
npm install
npm run migrate
npm run dev

# admin web :5173 (new window)
cd admin-web
npm install
npm run dev

# mobile :8100 (new window)
cd mobile
npm install
npm run dev
```

## V1 Definition of Done (prd §60) — status

Mobile/user flows:

1. Create an account — `POST /auth/register` + mobile Register ✅
2. Browse curated native-tree database — Home/Explore + 6 sample species ✅
3. Search by common/local/scientific name — `GET /species?q=` ✅
4. Filter by purpose/planting conditions — `GET /species` filters ✅
5. Right Tree for My Purpose — Finder wizard + `/recommendations` ✅
6. Complete structured tree profiles — Tree profile page ✅
7. Upload photos + request identification — Identify flow ✅
8. Submit an observation — Record Observation ✅
9. Receive moderator review — review actions + notifications ✅
10. Save favorite trees — Favorites API + Saved tab ✅
11. View personal observations — My Observations ✅
12. Participate in ID discussions — suggestions + comments ✅
13. Suggest corrections — correction flow (applies on admin approval) ✅
14. Browse marketplace listings — Market tab ✅
15. Find planting material for a species — Find Seedlings ✅
16. Contact a seller — contact card for logged-in users ✅
17. Report inaccurate/inappropriate content — Report forms ✅

Admin flows:

18. Users and moderators — user list, roles, suspend ✅
19. Native-tree species — species editor ✅
20. Tree purposes — purpose catalog management ✅
21. Planting conditions — condition catalog management ✅
22. Identification requests — review queue + verify ✅
23. Observations — review queue + approve/reject ✅
24. Marketplace listings — review queue + approve/reject ✅
25. Reports — reports page + resolve ✅
26. References — species editor references tab ✅
27. Moderation records — `moderation_actions` + audit logs ✅
28. Basic system analytics — Dashboard + `/admin/analytics` ✅

Sample data is clearly marked and must be replaced with curated,
reference-backed records before public launch. Push notifications,
payments, AI identification, and offline mode remain out of scope
(prd §51) with architecture hooks in place (photo-type dataset,
storage abstraction, token-based auth).

