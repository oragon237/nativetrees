# Katutubong Puno — System Capabilities

**Version:** V1 + V2 + V3 · **Date:** September 2026

What the platform can and cannot do. For how-to steps see `USER-MANUAL.md`;
for test execution see `TESTING.md`.

---

## 1. Capability map

| # | Module | Capability | Roles | Status |
|---|---|---|---|---|
| 1 | Tree database | 6 curated-structure species profiles (names, description, ID notes, size, conditions, distribution, references, photos) | Public browse; Admin curates | Live (sample data) |
| 2 | Search & filters | Partial-match search + 12 structured filters (purpose, sunlight, site, soil, moisture, elevation, space, size, bloom/fruit, growth, status) | Public | Live |
| 3 | Right Tree Finder | 5-step wizard with explained matches, no fake scores | Public | Live |
| 4 | Featured trees | Admin-curated home spotlight | Public view; Admin sets | Live |
| 5 | Observation map | Approved approximate observations on a Leaflet map | Public | Live |
| 6 | Identification requests | Photo requests, community suggestions, AI possible-matches, moderator verification | User+ | Live |
| 7 | Observations | Submissions with location-privacy control, photo types, moderator review | User+ | Live |
| 8 | Offline drafts | Queue observation/ID drafts offline, auto-sync online | User+ | Live |
| 9 | Favorites & stats | Saved trees, contribution statistics, reputation + badges | User+ | Live |
| 10 | Comments & corrections | Discussion threads; correction proposals applied on admin approval with audit | User+ | Live |
| 11 | Marketplace | Species-linked listings with moderation, seller-contact privacy, verified-seller badges, availability alerts | User+ | Live |
| 12 | Planting tracker | Planted-tree records, photo growth timelines, printable QR tags with public landing pages | User+ | Live |
| 13 | Projects | Community planting projects with pledges and progress | User+ | Live |
| 14 | Organizations | Profiles with admin verification + public directory | User+ | Live |
| 15 | Notifications | In-app event inbox (verification, approvals, comments, alerts, resolutions) | User+ | Live |
| 16 | Reports | Content/user reports with moderator resolution workflow | User+ | Live |
| 17 | Moderation | Unified review queue + full audit trail of every action | Moderator+ | Live |
| 18 | User management | Search, profiles, contribution/moderation history, roles, suspend | Admin (view: Moderator) | Live |
| 19 | Species management | Full editor, publish/archive, merge duplicates, photo verification, catalogs | Admin (view: Moderator) | Live |
| 20 | Analytics & audit | Aggregate dashboard, audit-log browser | Admin (audit view: Moderator) | Live |
| 21 | Auth & security | Email register/login, verification, password reset/change, JWT, RBAC, rate limits, upload validation | All | Live |
| 22 | Email / push | SMTP delivery when configured (log fallback); push token registry + stub sender | System | Partial |

## 2. Explicit non-capabilities (by design)

- No guaranteed AI identification (matches are experimental and labeled)
- No exact public coordinates (generalized or hidden by privacy rule)
- No payments, delivery, or order processing in marketplace
- No integrated chat/messaging (seller contact only), no public social feed
- No iOS app, no native APK in repo (Capacitor config ready; needs Android SDK)
- No real email/push delivery without operator credentials
- No landslide or ecological-outcome guarantees anywhere in copy or logic

## 3. Data & limits

- 6 sample species + sample photos (Wikipedia-sourced, marked replaceable)
- Uploads: 8 MB per image; 6 photos per mobile submission; unlimited species-gallery photos via admin
- Lists paginated (default 20, max 100); map feed capped at 500 points
- 15 purposes, 31 planting conditions seeded; extensible by admin
