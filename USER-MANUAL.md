# Katutubong Puno — User Manual

**Apps:** Mobile (`http://localhost:8100`) · Admin portal (`http://localhost:5173`)
**Accounts:** `user@example.com` / `moderator@example.com` / `admin@example.com`
(passwords in `TESTING.md` — local development only)

> Language rule used throughout: plain words, never jargon. Statuses always
> show as color **plus** text. Scientific names appear in *italics*.

---

## PART A — Everyday user guide

### Getting in
1. Open the mobile app → **Me** → Log in (or Register with display name, email, password 8+ chars).
2. New accounts verify automatically in this build; use your profile page to log out.

### 1. Discover a tree you know
- **Home → search** (common, local, or scientific name; `nar` finds Narra) or tap a purpose card.
- **Explore** → combine filters (purpose, sunlight, environment, space). Results explain *why* each tree matched.

### 2. Find the right tree for your place and purpose
- **Find Tree** → answer Purpose → Site → Sunlight → Space (choose **Not Sure** whenever unsure).
- Open a match → read size, conditions, distribution → **♡ Save Tree** or **Find Seedlings**.

### 3. Identify an unknown tree
- **Identify → 📷 Identify a Tree** → add photos (whole tree, leaf, bark, flower, fruit — any you have) → describe it → set **location privacy** (Municipality Only / Approximate / Keep Private) → submit.
- Track it under **My requests**; community suggestions and the **✨ AI possible matches** (experimental — always needs human verification) appear on the request page.
- A moderator verdict ends as **Verified** (species named) or **Unresolved** (not enough evidence) — both are normal outcomes.

### 4. Document a tree you recognize
- **Record Observation** → search and select the species → photos → province/notes → submit. Status starts `pending`; moderators may approve or ask for more info (you can edit and resubmit).
- Your exact coordinates are **never public**; strangers see generalized locations only.

### 5. Buy, sell, and get alerts
- **Market**: browse by species/province; logged-in users see seller contact. Listings show **✓ Verified Seller** or plain **Seller Listing** (unverified).
- **Sell**: select the exact species (never free-type a name) → details → photos → submit for review → mark **sold out** when done.
- **Alerts**: on a tree with no stock, **🔔 Notify me** — you are notified when a listing is approved.

### 6. Plant, track, and join in
- **My Plantings**: record what you planted → add growth records (height, photo, notes) over time → print the **QR tag** for the tree; anyone scanning sees its public growth page.
- **Projects**: browse → pledge trees → **Join**; or start your own project.
- **Organization**: register your school/NGO/LGU for verification.
- **Me** shows your stats, reputation score, and earned badges (Explorer, Identifier, sharer, keeper…).

### 7. Fix mistakes and stay safe
- **Suggest a correction** on any tree profile (field + proposed text + reason) — applied after admin review.
- **Report** listings, requests, or content that look wrong; reporters are notified of the outcome.
- **Notifications** (🔔/Me) collect verifications, approvals, comments, alerts, and resolutions. Tap to mark read.

### 8. Offline use
- With no connection, observation/ID forms **save a draft** instead of failing; they **sync automatically** on reconnect (Me shows pending drafts; re-add photos after sync).

---

## PART B — Moderator guide (`moderator@example.com`)

Open **Me → Moderation** (mobile) or the admin portal **Moderation** page.

| Queue | Your actions | Standard to apply |
|---|---|---|
| Observations | Approve / Request info / Reject (give a reason) | Clear photos + plausible species + location present |
| Identifications | Review suggestions → Verify species / Mark unresolved | Verify only with sufficient photographic evidence; otherwise Unresolved |
| Listings | Approve / Reject | Correct species link, honest photos/price, real location |
| Corrections | (Admin applies) flag issues | Check the cited source before endorsing |
| Nurseries / Organizations | (Admin verifies) flag fakes | Real-world presence required |
| Reports | Resolve with a note / Dismiss | Explain the outcome; reporter is notified |

All your actions are recorded under your name — they are visible in user histories and audit logs.

## PART C — Administrator guide (`admin@example.com`, portal :5173)

- **Dashboard**: totals, per-status breakdowns, top purposes, recent moderator activity.
- **Species**: search → **Edit** (7 tabs: General, Names, Purposes, Conditions, Distribution, References, Photos) → **Publish** to go public, **Archive** to hide, **☆ Feature** for the mobile Home spotlight. **Merge duplicates** from the editor (data moves to the kept record; the other archives).
- **Photos tab**: verify or remove uploads. Only verified photos go public.
- **Users**: search → **View** (contributions + moderation history) → suspend/reactivate, grant/revoke moderator/admin. Never remove your own admin role.
- **Moderation / Reports / Projects**: same queues as mobile plus resolution notes and project status control.
- **Audit Logs**: every scientific or account change, who/when included.

---

## Troubleshooting

| Problem | Fix |
|---|---|
| Cannot log in | Check email/password; accounts are pre-verified — no email step needed locally |
| Empty lists / connection errors | Backend (`backend: npm run dev`) must be running on :4000 |
| Photo upload fails | Max 8 MB per image; 6 per mobile submission |
| Drafts not syncing | Reconnect, open Me → **Sync now**; re-add photos afterward |
| "Forbidden" on admin pages | That account lacks the role — use the matching demo account |
| Old logo / stale screens | Hard-refresh (Ctrl+F5); dev servers serve cached bundles otherwise |

## Privacy & honesty rules for everyone

- Exact observation coordinates are never public; sensitive locations stay generalized.
- Seller contact shows to logged-in users only.
- Never promise outcomes ("prevents landslides", "perfect match", "guaranteed ID") — the app states suitability and possibility only.
