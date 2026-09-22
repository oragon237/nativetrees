# Mobile UI refresh

The mobile application keeps the existing Ionic/TypeScript architecture, logo assets, species photographs, hash routes, API requests and database integration.

## Shared design system

- `src/styles.css`: the supplied brand palette, Inter UI typography, Bree Serif display headings, spacing, 12px controls, 16px cards, semantic states, focus rings, safe-area navigation and responsive grids.
- `src/pages/ui.ts`: existing tree cards extended with readable purposes, native/endemic badges and accessible navigation; shared line icons, headers, empty/loading states, upload previews and asynchronous submission feedback.
- Reuse these helpers for future screens. Scientific names remain italic; never substitute a generic photograph for a missing species photograph.

## Navigation and screen changes

- Discover → Identify → Find tree → Saved → Me form the primary navigation. All previous routes remain supported.
- Search is reachable from Discover and shows the collection immediately. Filters retain their API keys and values; search updates after a short typing debounce and ignores obsolete responses.
- Discovery prioritizes identification, learning and planting purpose. Native seedlings remain available from home, tree profiles and the profile menu.
- The finder preserves all options and recommendation parameters, adding explicit selections, Continue/Back, progress, retained answers and editable results.
- Tree profiles emphasize names and learning before seedling actions.
- Identification, observations and listing uploads share photo previews and clearly explain existing limits. Identification copy also explains the existing offline photo limitation.
- Shared form labels, busy buttons, error announcements, keyboard focus and status treatments apply across existing contribution screens.
- Account features are grouped without removing destinations. Guest states respect the backend's existing authentication requirement for identification requests and seedling listings.

## Validation

Run from `mobile`:

```powershell
npm test
npm run build
```

Six regression tests cover finder answer retention and skipped parameters, search races and filter clearing, retry behavior, duplicate submission prevention and error focus, photo preview limits/object URL cleanup, and safe accessible tree-card rendering. Tests use an isolated DOM and mocked requests; they do not write to the database.

Live browser checks covered discovery, native-tree search, the four-step finder and real recommendation explanations, tree profiles, species-linked seedling navigation, guest access states and sign-in layout. Narrow phone and tablet layouts were checked at 320px, 390px and 1024px, including horizontal overflow checks.

Authenticated submissions and physical Android behavior were not exercised. Android keyboard, TalkBack, system back navigation and device safe areas still need release QA. Existing sample species records and backend launch readiness are outside this UI change.
