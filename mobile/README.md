# Katutubong Puno Mobile (Phase 3 — Mobile Discovery)

Mobile-first app built with **Ionic UI components + TypeScript + Vite**.
Runs in the browser now; packages to Android via Capacitor later.

## Screens (per `code-database.md` Part III)

- Home (`#/home`) — greeting, search, purpose chips, Find the Right Tree, explore list
- Explore (`#/search`) — text search + structured filters (purpose/sunlight/site/space)
- Tree profile (`#/tree/:id`) — full profile, Save Tree, Find Seedlings (Phase 5)
- Find Tree wizard (`#/finder`) — 5-step purpose/site/sunlight/space flow with match reasons
- Saved (`#/favorites`) + Me (`#/me`) — favorites + profile (auth via backend JWT)
- Login / Register (`#/login`, `#/register`)

Identify-a-Tree, observations, marketplace arrive in Phases 4–5
(the Home CTA notes this instead of dead-ending).

## Run

```powershell
# backend must be running on :4000 first
cd backend
npm run dev

# then in another window:
cd mobile
npm install
npm run dev   # http://localhost:8100
```

## Android packaging (later)

```powershell
cd mobile
npm install @capacitor/core @capacitor/cli @capacitor/android
npx cap init "Katutubong Puno" ph.katutubongpuno.app --web-dir=dist
npm run build
npx cap add android
```

`capacitor.config.ts` is already in place. Set `API_BASE` to the
deployed backend URL before building the native shell.

## UI regression checks

npm test runs isolated UI interaction checks. npm run build checks TypeScript and creates the production bundle.

