# Katutubong Puno — QA Test Execution

**Version:** V1 + V2 + V3 (all phases built)
**Date:** September 2026

> - Feature catalog: `CAPABILITIES.md`
> - End-user how-to: `USER-MANUAL.md`
> - This file: accounts, environment, role test scripts, bug reporting.

---

## 1. Test accounts

| Role | Email | Password |
|---|---|---|
| User | `user@example.com` | `UserPass123!` |
| Moderator | `moderator@example.com` | `ModPass123!` |
| Admin | `admin@example.com` | `AdminPass123!` |

All pre-verified. The admin also holds moderator rights. **Local-dev only — never reuse these passwords.**

---

## 3. How to run

```powershell
# 1. Backend :4000 (required by everything)
cd backend
npm install
npm run migrate
npm run dev

# 2. Admin portal :5173 (new window)
cd admin-web
npm install
npm run dev      # open http://localhost:5173/login

# 3. Mobile app :8100 (new window)
cd mobile
npm install
npm run dev      # open http://localhost:8100
```

---

## 4. USER test script (login: `user@example.com`)

1. **Discover**: Home → search `nar` → open Narra → check profile sections, photo, references.
2. **Finder**: Find Tree → Shade → Backyard → Full Sun → Large → confirm results show ✓ match reasons (no percentages).
3. **Save**: ♡ Save Tree → Saved tab lists it → Me shows updated counts.
4. **Identify**: Identify → submit request with 1–2 photos → it appears in My requests as `open`.
5. **Observe**: Record Observation → pick Narra → submit → My Observations shows `pending`.
6. **Correct**: on a tree profile → Suggest correction → submit → (ask admin to approve; description updates).
7. **Marketplace**: Market → open a listing → contact visible (log out → contact hidden). Create a listing → status `pending` in My listings.
8. **Alerts**: on a tree with no listings → Notify me → (ask moderator to approve a listing for it; notification arrives).
9. **Plantings**: record a planting → add 2 growth records with heights → QR tag displays → open the QR link in a logged-out browser (timeline visible, no exact coords).
10. **Projects**: join a project with a pledge → participant list updates.
11. **Report**: report a listing → (ask moderator to resolve; notification arrives).
12. **Offline**: disconnect network → submit an observation → reconnect → draft syncs (Me shows sync confirmation).

## 5. MODERATOR test script (login: `moderator@example.com`)

1. Me → **Moderation** queue shows: the user's observation (`pending`), ID request (`open`), listing (`pending`), correction, report.
2. Approve the observation → user gets notified; observation becomes publicly visible with generalized location.
3. On the ID request: add a suggestion as the moderator → then Verify with Narra → status `verified`, user notified.
4. Approve the listing → it appears in Market; alert subscriber notified.
5. Approve the correction → species record updates.
6. Resolve the report with a note → reporter notified.
7. Confirm you **cannot**: open Admin analytics, manage users/roles, publish species (403 expected).

## 6. ADMIN test script (login: `admin@example.com` at :5173)

1. **Dashboard**: counts load (users, species by status, queues, top purposes, recent moderation).
2. **Species**: search Narra → edit description → Save → verify on mobile. Upload a photo → verify it → appears in gallery. Toggle ★ Feature → appears on mobile Home.
3. **Merge**: create a draft duplicate → Merge into Narra → duplicate archived, data carried over.
4. **Users**: open `user@example.com` → contribution counts → grant moderator → revoke it. Suspend + reactivate.
5. **Moderation**: process nursery + organization verifications.
6. **Reports**: resolve/dismiss with notes.
7. **Projects**: change a project status.
8. **Audit Logs**: every action above left a traceable entry.

## 7. What testers should NOT expect (known limits)

- Only 6 sample species with sample photos — real curation is pending.
- Email sends log to the backend console (no SMTP configured); push notifications are stubbed.
- No native APK yet (needs Android SDK); test the mobile app in a mobile-size browser window.
- No payments, delivery, iOS app, or real AI model — AI matches are heuristic + labeled experimental.

## 8. Reporting an issue

Include: **role used** (user/moderator/admin), **URL or screen**, **steps**, **expected vs actual**, **screenshot**, and (for API issues) the backend console error. Check Audit Logs first for moderator/admin actions — the trail usually shows what happened.
