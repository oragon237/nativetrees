# Katutubong Puno
## Database Schema, Screen Map & User Flow
### Technical Specification v1.0

**Product:** Katutubong Puno  
**Platforms:** Android Mobile App + Web Admin Portal  
**Database Recommendation:** PostgreSQL  
**Architecture:** API-first  
**Document Scope:** V1 / MVP

---

# PART I — DATABASE ARCHITECTURE

## 1. Database Design Principles

The database should follow these principles:

- Use UUIDs as primary identifiers.
- Do not use tree names as database relationships.
- Scientific, common, and local names must be stored separately.
- Tree characteristics must use structured fields whenever filtering is required.
- Community submissions must remain separate from verified species data until approved.
- Every important moderation action should be auditable.
- Exact observation coordinates must not automatically become public.
- Photos should use object storage rather than database BLOBs.
- Records should use `created_at` and `updated_at`.
- Important records should support soft deletion.
- Database design should support future AI and GIS functionality.

---

# 2. Core Entity Overview

The V1 database is divided into nine functional areas.

### Identity & Access

- users
- roles
- user_roles

### Tree Knowledge Base

- species
- species_names
- species_photos
- purposes
- species_purposes
- planting_conditions
- species_planting_conditions
- species_distribution
- species_references

### Community Observations

- observations
- observation_photos

### Identification

- identification_requests
- identification_photos
- identification_suggestions

### User Library

- favorites

### Community

- comments
- correction_requests

### Marketplace

- marketplace_listings
- listing_photos

### Moderation & Safety

- reports
- moderation_actions
- audit_logs

### Communication

- notifications

---

# 3. USERS

## Table: `users`

Stores application accounts.

| Field | Type | Description |
|---|---|---|
| id | UUID PK | User identifier |
| email | VARCHAR UNIQUE | Email |
| password_hash | VARCHAR | Secure password hash |
| display_name | VARCHAR | Public name |
| profile_photo_url | TEXT | Avatar |
| bio | TEXT NULL | Optional biography |
| region | VARCHAR NULL | Region |
| province | VARCHAR NULL | Province |
| municipality | VARCHAR NULL | Municipality/city |
| email_verified_at | TIMESTAMP NULL | Verification |
| account_status | ENUM | active, suspended, banned |
| last_login_at | TIMESTAMP NULL | Last login |
| created_at | TIMESTAMP | Created |
| updated_at | TIMESTAMP | Updated |
| deleted_at | TIMESTAMP NULL | Soft delete |

Do not require the user's precise home address.

---

# 4. ROLES

## Table: `roles`

| Field | Type |
|---|---|
| id | SMALLINT PK |
| name | VARCHAR UNIQUE |
| description | TEXT |

Initial roles:

- user
- moderator
- admin

---

# 5. USER ROLES

## Table: `user_roles`

| Field | Type |
|---|---|
| user_id | UUID FK |
| role_id | FK |
| assigned_by | UUID FK NULL |
| created_at | TIMESTAMP |

This structure allows future roles such as:

- nursery
- researcher
- organization_manager

without redesigning `users`.

---

# 6. SPECIES

## Table: `species`

This is the master verified tree record.

| Field | Type | Description |
|---|---|---|
| id | UUID PK | Species ID |
| scientific_name | VARCHAR UNIQUE | Scientific name |
| genus | VARCHAR | Genus |
| species_epithet | VARCHAR | Species |
| family | VARCHAR | Family |
| native_status | ENUM | native, endemic |
| description | TEXT | General description |
| leaf_description | TEXT NULL | Leaf |
| bark_description | TEXT NULL | Bark |
| flower_description | TEXT NULL | Flower |
| fruit_description | TEXT NULL | Fruit |
| seed_description | TEXT NULL | Seed |
| growth_form | ENUM | small, medium, large |
| min_height_m | DECIMAL NULL | Minimum mature height |
| max_height_m | DECIMAL NULL | Maximum mature height |
| min_canopy_m | DECIMAL NULL | Minimum canopy spread |
| max_canopy_m | DECIMAL NULL | Maximum canopy spread |
| growth_rate | ENUM NULL | slow, moderate, fast |
| fruit_bearing | BOOLEAN | Fruit |
| flowering | BOOLEAN | Flower |
| conservation_status | VARCHAR NULL | Status |
| conservation_source | VARCHAR NULL | Source |
| verification_status | ENUM | draft, verified, archived |
| created_by | UUID FK | Creator |
| verified_by | UUID FK NULL | Verifier |
| verified_at | TIMESTAMP NULL | Verification |
| created_at | TIMESTAMP | Created |
| updated_at | TIMESTAMP | Updated |
| deleted_at | TIMESTAMP NULL | Soft delete |

---

# 7. SPECIES NAMES

## Table: `species_names`

A tree may have many names.

| Field | Type |
|---|---|
| id | UUID PK |
| species_id | UUID FK |
| name | VARCHAR |
| name_type | ENUM |
| language | VARCHAR NULL |
| locality | VARCHAR NULL |
| is_primary | BOOLEAN |
| created_at | TIMESTAMP |

`name_type`:

- common
- local
- alternative

Example:

Species:

`Pterocarpus indicus`

Names:

- Narra — common
- Naga — local
- Asana — local

This allows search using regional names.

---

# 8. SPECIES PHOTOS

## Table: `species_photos`

| Field | Type |
|---|---|
| id | UUID PK |
| species_id | UUID FK |
| uploaded_by | UUID FK |
| file_url | TEXT |
| thumbnail_url | TEXT NULL |
| photo_type | ENUM |
| caption | TEXT NULL |
| verification_status | ENUM |
| verified_by | UUID FK NULL |
| created_at | TIMESTAMP |

Photo types:

- whole_tree
- leaf
- bark
- flower
- fruit
- seed
- seedling

This structure is intentionally useful for future AI datasets.

---

# 9. PURPOSES

## Table: `purposes`

Central taxonomy for tree uses.

| Field | Type |
|---|---|
| id | UUID PK |
| name | VARCHAR UNIQUE |
| slug | VARCHAR UNIQUE |
| description | TEXT |
| icon | VARCHAR NULL |
| sort_order | INTEGER |
| active | BOOLEAN |

Initial purposes:

- Shade
- Fruit-Bearing
- Flowering / Ornamental
- Wildlife Support
- Pollinator Support
- Reforestation
- Soil Erosion Control
- Slope Rehabilitation
- Watershed Rehabilitation
- Riverbank / Riparian Rehabilitation
- Coastal Rehabilitation
- Windbreak
- Agroforestry
- Urban Landscaping
- Carbon Storage

---

# 10. SPECIES PURPOSES

## Table: `species_purposes`

Many-to-many relationship.

| Field | Type |
|---|---|
| species_id | UUID FK |
| purpose_id | UUID FK |
| suitability | ENUM |
| notes | TEXT NULL |
| reference_id | UUID FK NULL |

Suitability:

- possible
- suitable
- highly_suitable

This must represent evidence-backed suitability rather than commercial promotion.

---

# 11. PLANTING CONDITIONS

## Table: `planting_conditions`

| Field | Type |
|---|---|
| id | UUID PK |
| category | ENUM |
| name | VARCHAR |
| slug | VARCHAR |
| description | TEXT NULL |
| active | BOOLEAN |

Categories include:

### SUNLIGHT

- Full Sun
- Partial Shade
- Shade

### SITE

- Open Field
- Backyard
- Farm
- Forest Edge
- Forest Understory
- Hillside
- Riverbank
- Watershed
- Coastal Area
- Urban Area
- Large Property

### SOIL

- Sandy
- Loamy
- Clay
- Rocky
- Well Drained
- Moist Soil

### MOISTURE

- Dry
- Moderate
- Moist
- Wet

### ELEVATION

- Lowland
- Mid-Elevation
- Highland

### SPACE

- Small
- Medium
- Large
- Very Large

---

# 12. SPECIES PLANTING CONDITIONS

## Table: `species_planting_conditions`

| Field | Type |
|---|---|
| species_id | UUID FK |
| condition_id | UUID FK |
| suitability | ENUM |
| notes | TEXT NULL |
| reference_id | UUID FK NULL |

This table powers:

**Right Tree for My Purpose**

---

# 13. SPECIES DISTRIBUTION

## Table: `species_distribution`

| Field | Type |
|---|---|
| id | UUID PK |
| species_id | UUID FK |
| region | VARCHAR NULL |
| province | VARCHAR NULL |
| island_group | ENUM NULL |
| distribution_type | ENUM |
| notes | TEXT NULL |
| reference_id | UUID FK NULL |

Possible island groups:

- Luzon
- Visayas
- Mindanao

Distribution must not be interpreted automatically as planting suitability.

---

# 14. REFERENCES

## Table: `species_references`

| Field | Type |
|---|---|
| id | UUID PK |
| species_id | UUID FK NULL |
| title | TEXT |
| author | VARCHAR NULL |
| organization | VARCHAR NULL |
| publication_year | INTEGER NULL |
| source_type | VARCHAR |
| source_url | TEXT NULL |
| notes | TEXT NULL |
| accessed_at | DATE NULL |
| created_at | TIMESTAMP |

This supports evidence-backed tree information.

---

# 15. OBSERVATIONS

## Table: `observations`

Represents an actual tree observed by a user.

| Field | Type |
|---|---|
| id | UUID PK |
| user_id | UUID FK |
| species_id | UUID FK NULL |
| observation_date | DATE |
| region | VARCHAR NULL |
| province | VARCHAR NULL |
| municipality | VARCHAR NULL |
| latitude | DECIMAL NULL |
| longitude | DECIMAL NULL |
| location_precision | ENUM |
| habitat | VARCHAR NULL |
| estimated_height_m | DECIMAL NULL |
| flowering | BOOLEAN NULL |
| fruiting | BOOLEAN NULL |
| notes | TEXT NULL |
| status | ENUM |
| reviewed_by | UUID FK NULL |
| reviewed_at | TIMESTAMP NULL |
| created_at | TIMESTAMP |
| updated_at | TIMESTAMP |

Statuses:

- draft
- pending
- approved
- needs_information
- rejected

`location_precision`:

- hidden
- municipality
- approximate
- exact_private

Precise coordinates must not automatically be exposed publicly.

---

# 16. OBSERVATION PHOTOS

## Table: `observation_photos`

| Field | Type |
|---|---|
| id | UUID PK |
| observation_id | UUID FK |
| file_url | TEXT |
| photo_type | ENUM |
| created_at | TIMESTAMP |

---

# 17. IDENTIFICATION REQUESTS

## Table: `identification_requests`

| Field | Type |
|---|---|
| id | UUID PK |
| user_id | UUID FK |
| description | TEXT NULL |
| habitat | VARCHAR NULL |
| region | VARCHAR NULL |
| province | VARCHAR NULL |
| municipality | VARCHAR NULL |
| latitude | DECIMAL NULL |
| longitude | DECIMAL NULL |
| estimated_height_m | DECIMAL NULL |
| flowering | BOOLEAN NULL |
| fruiting | BOOLEAN NULL |
| status | ENUM |
| verified_species_id | UUID FK NULL |
| verified_by | UUID FK NULL |
| verified_at | TIMESTAMP NULL |
| created_at | TIMESTAMP |
| updated_at | TIMESTAMP |

Statuses:

- open
- possible_identification
- moderator_review
- verified
- unresolved

---

# 18. IDENTIFICATION PHOTOS

## Table: `identification_photos`

| Field | Type |
|---|---|
| id | UUID PK |
| request_id | UUID FK |
| file_url | TEXT |
| photo_type | ENUM |
| created_at | TIMESTAMP |

---

# 19. IDENTIFICATION SUGGESTIONS

## Table: `identification_suggestions`

| Field | Type |
|---|---|
| id | UUID PK |
| request_id | UUID FK |
| suggested_by | UUID FK |
| species_id | UUID FK |
| reasoning | TEXT NULL |
| created_at | TIMESTAMP |

Later we can add community agreement/upvotes if needed.

---

# 20. FAVORITES

## Table: `favorites`

| Field | Type |
|---|---|
| user_id | UUID FK |
| species_id | UUID FK |
| created_at | TIMESTAMP |

Unique constraint:

`user_id + species_id`

---

# 21. COMMENTS

## Table: `comments`

| Field | Type |
|---|---|
| id | UUID PK |
| user_id | UUID FK |
| entity_type | ENUM |
| entity_id | UUID |
| parent_id | UUID NULL |
| content | TEXT |
| status | ENUM |
| created_at | TIMESTAMP |
| updated_at | TIMESTAMP |

Entity examples:

- identification_request
- observation

---

# 22. CORRECTION REQUESTS

## Table: `correction_requests`

| Field | Type |
|---|---|
| id | UUID PK |
| species_id | UUID FK |
| submitted_by | UUID FK |
| field_name | VARCHAR |
| current_value | TEXT NULL |
| proposed_value | TEXT |
| explanation | TEXT |
| source_url | TEXT NULL |
| status | ENUM |
| reviewed_by | UUID FK NULL |
| created_at | TIMESTAMP |

Statuses:

- pending
- approved
- rejected

Approved corrections should still create an audit record.

---

# 23. MARKETPLACE LISTINGS

## Table: `marketplace_listings`

| Field | Type |
|---|---|
| id | UUID PK |
| seller_id | UUID FK |
| species_id | UUID FK |
| title | VARCHAR |
| material_type | ENUM |
| approximate_age | VARCHAR NULL |
| approximate_height_cm | DECIMAL NULL |
| quantity | INTEGER |
| price | DECIMAL |
| description | TEXT |
| region | VARCHAR |
| province | VARCHAR |
| municipality | VARCHAR NULL |
| contact_method | ENUM |
| contact_value | VARCHAR |
| status | ENUM |
| reviewed_by | UUID FK NULL |
| created_at | TIMESTAMP |
| updated_at | TIMESTAMP |

Material types:

- seed
- seedling
- sapling

Statuses:

- draft
- pending
- active
- sold_out
- rejected
- removed

---

# 24. LISTING PHOTOS

## Table: `listing_photos`

| Field | Type |
|---|---|
| id | UUID PK |
| listing_id | UUID FK |
| file_url | TEXT |
| sort_order | INTEGER |
| created_at | TIMESTAMP |

---

# 25. REPORTS

## Table: `reports`

| Field | Type |
|---|---|
| id | UUID PK |
| reporter_id | UUID FK |
| entity_type | ENUM |
| entity_id | UUID |
| reason | ENUM |
| description | TEXT NULL |
| status | ENUM |
| assigned_to | UUID FK NULL |
| resolution | TEXT NULL |
| created_at | TIMESTAMP |
| resolved_at | TIMESTAMP NULL |

Reasons include:

- incorrect_information
- incorrect_identification
- suspicious_listing
- spam
- inappropriate_content
- misleading_seller
- other

---

# 26. NOTIFICATIONS

## Table: `notifications`

| Field | Type |
|---|---|
| id | UUID PK |
| user_id | UUID FK |
| type | VARCHAR |
| title | VARCHAR |
| message | TEXT |
| entity_type | VARCHAR NULL |
| entity_id | UUID NULL |
| read_at | TIMESTAMP NULL |
| created_at | TIMESTAMP |

---

# 27. MODERATION ACTIONS

## Table: `moderation_actions`

| Field | Type |
|---|---|
| id | UUID PK |
| moderator_id | UUID FK |
| entity_type | VARCHAR |
| entity_id | UUID |
| action | VARCHAR |
| reason | TEXT NULL |
| created_at | TIMESTAMP |

Examples:

- approved
- rejected
- requested_information
- verified
- removed
- restored

---

# 28. AUDIT LOGS

## Table: `audit_logs`

Used for important administrative changes.

| Field | Type |
|---|---|
| id | UUID PK |
| user_id | UUID FK |
| action | VARCHAR |
| entity_type | VARCHAR |
| entity_id | UUID |
| old_values | JSONB NULL |
| new_values | JSONB NULL |
| ip_address | VARCHAR NULL |
| created_at | TIMESTAMP |

This is especially important for scientific records.

---

# PART II — DATABASE RELATIONSHIP MAP

High-level relationship:

```text
USERS
 │
 ├── OBSERVATIONS ─── OBSERVATION_PHOTOS
 │        │
 │        └────────── SPECIES
 │
 ├── IDENTIFICATION_REQUESTS
 │        │
 │        ├── IDENTIFICATION_PHOTOS
 │        │
 │        └── IDENTIFICATION_SUGGESTIONS ── SPECIES
 │
 ├── FAVORITES ────── SPECIES
 │
 ├── MARKETPLACE_LISTINGS ── SPECIES
 │        │
 │        └── LISTING_PHOTOS
 │
 ├── COMMENTS
 ├── CORRECTION_REQUESTS ─── SPECIES
 └── REPORTS


SPECIES
 │
 ├── SPECIES_NAMES
 ├── SPECIES_PHOTOS
 ├── SPECIES_PURPOSES ───── PURPOSES
 ├── SPECIES_PLANTING_CONDITIONS ── PLANTING_CONDITIONS
 ├── SPECIES_DISTRIBUTION
 └── SPECIES_REFERENCES
```

---

# PART III — MOBILE SCREEN MAP

## 29. Main Application Navigation

Recommended Android bottom navigation:

```text
┌─────────────────────────────────┐
│                                 │
│         CURRENT SCREEN          │
│                                 │
├─────────────────────────────────┤
│ Home │ Explore │ + │ Market │ Me│
└─────────────────────────────────┘
```

The center **+** is the primary contribution action.

Tapping it opens:

```text
What would you like to do?

📷 Identify a Tree

🌳 Record a Tree Observation

🛒 Sell / List a Native Tree
```

This keeps contribution highly visible.

---

# 30. Splash Screen

```text
KATUTUBONG PUNO

[Logo]

Discover.
Identify.
Plant Native.
```

↓

Authentication check.

---

# 31. Welcome / Onboarding

Three introductory slides.

### Slide 1

**Discover Philippine Native Trees**

Learn about trees native to the Philippines.

### Slide 2

**Find the Right Tree**

Discover native trees suited to your purpose and planting environment.

### Slide 3

**Help Build the Community**

Photograph, identify, document, and share native trees.

Buttons:

**Get Started**

**I Already Have an Account**

---

# 32. Registration

Fields:

- Display Name
- Email
- Password
- Confirm Password

Optional:

- Region
- Province

Checkbox:

- Terms
- Privacy Policy

Button:

**Create Account**

---

# 33. Home Screen

Recommended structure:

```text
Good morning, Juan

[ Search native trees... ]

┌───────────────────────────────┐
│ 📷 IDENTIFY A TREE            │
│ Take photos and ask the       │
│ community                     │
└───────────────────────────────┘

What tree are you looking for?

[🌳 Shade] [🍈 Fruit]
[🌺 Flowering] [🐝 Pollinator]
[⛰️ Erosion] [🌊 Coastal]

[ FIND THE RIGHT TREE ]

Explore Native Trees

[Tree Card]
[Tree Card]
[Tree Card]

Recently Added

[Tree Card]
[Tree Card]
```

---

# 34. Search Screen

```text
Search trees...

[ Narra________________ ]

FILTER

Purpose
□ Shade
□ Fruit
□ Erosion Control
□ Reforestation

Sunlight
□ Full Sun
□ Partial Shade
□ Shade

Size
□ Small
□ Medium
□ Large

Environment
□ Backyard
□ Farm
□ Hillside
□ Riverbank
□ Coastal

[ APPLY FILTERS ]
```

---

# 35. Search Results

Each result card should show:

```text
[Tree Photo]

NARRA

Pterocarpus indicus

🌳 Large
☀️ Full Sun
🌿 Native

Shade • Wildlife • Reforestation

[VIEW TREE]
```

Do not overload cards with all database information.

---

# 36. Tree Profile

Recommended screen structure:

```text
[PHOTO GALLERY]

NARRA
Pterocarpus indicus

♡ Save Tree

Philippine Native

--------------------------------

OVERVIEW

General description...

--------------------------------

PURPOSE

🌳 Shade
🐦 Wildlife
🌱 Reforestation

--------------------------------

GROWING CONDITIONS

☀️ Full Sun
💧 Moderate
🌳 Large Space

--------------------------------

SIZE

Height: xx–xx m
Canopy: xx–xx m
Growth: Moderate

--------------------------------

BEST PLANTING ENVIRONMENTS

Backyard
Farm
Open Area
etc.

--------------------------------

NATIVE DISTRIBUTION

...

--------------------------------

IDENTIFICATION

Leaf
Bark
Flower
Fruit

--------------------------------

CONSERVATION

...

--------------------------------

REFERENCES

...

--------------------------------

[ FIND SEEDLINGS ]
```

---

# 37. Right Tree Wizard

Entry:

**Find the Right Tree**

### Step 1

**What is your main purpose?**

Selectable cards:

- Shade
- Fruit
- Flowering
- Wildlife
- Pollinators
- Reforestation
- Erosion Control
- Slope Rehabilitation
- Watershed
- Coastal
- Windbreak
- Agroforestry

↓

### Step 2

**Where will you plant it?**

- Backyard
- Farm
- Open Field
- Hillside
- Riverbank
- Coastal
- Forest Edge
- Forest Understory
- Urban Area

↓

### Step 3

**How much sunlight?**

- Full Sun
- Partial Shade
- Shade
- Not Sure

↓

### Step 4

**How much space is available?**

- Small
- Medium
- Large
- Not Sure

↓

### Step 5

Optional:

**Tell us more about the location**

- Region
- Province
- Soil
- Moisture
- Elevation

Allow:

**Skip / Not Sure**

↓

### Results

```text
Native trees matching your conditions

[Tree]
Match Reasons:
✓ Shade
✓ Full Sun
✓ Large Space
✓ Suitable Site

[VIEW TREE]

[Tree]
...
```

Do not show artificial percentage scores unless a meaningful scoring methodology is established.

---

# 38. Identify Tree Flow

User taps:

**Identify a Tree**

↓

Photo guide:

```text
For better identification, photograph:

✓ Whole Tree
✓ Leaves
✓ Bark
✓ Flower
✓ Fruit

You don't need all five.
```

↓

**Add Photos**

↓

User adds:

- Description
- Habitat
- Approximate height
- Flowering?
- Fruiting?
- Approximate location

↓

Privacy selection:

**Location Visibility**

- Municipality only
- Approximate
- Keep private

↓

Preview

↓

**Submit Identification Request**

↓

Status:

**Waiting for Identification**

---

# 39. Identification Detail

```text
[Photos]

UNKNOWN TREE

Location:
Sipocot, Camarines Sur

Status:
OPEN

Description...

COMMUNITY SUGGESTIONS

Possible:
Narra

Suggested by:
User123

Reason:
Leaf shape and fruit...

[VIEW SPECIES]

COMMENTS

...

[SUGGEST IDENTIFICATION]
```

When verified:

```text
✓ VERIFIED IDENTIFICATION

Narra
Pterocarpus indicus

Verified by Moderator
```

---

# 40. Observation Flow

```text
+ Add

→ Record Tree Observation
```

Fields:

- Species
- Photos
- Observation date
- Approximate location
- Habitat
- Height
- Flowering
- Fruiting
- Notes

↓

Submit

↓

**Pending Moderator Review**

---

# 41. Marketplace Home

```text
NATIVE TREE MARKETPLACE

[ Search seedlings... ]

Browse by:

Seed
Seedling
Sapling

Nearby / Region

Listings:

[Photo]
Narra Seedlings
₱xxx
Camarines Sur

[VIEW LISTING]
```

---

# 42. Marketplace Listing Detail

```text
[Photos]

NARRA SEEDLINGS

Pterocarpus indicus

₱xxx

Available: 20

Height:
30–50 cm

Location:
Camarines Sur

Seller:
Juan D.

Description...

[VIEW TREE PROFILE]

[CONTACT SELLER]

[REPORT LISTING]
```

---

# 43. Create Marketplace Listing

```text
Select Species

Material Type:
○ Seed
○ Seedling
○ Sapling

Upload Photos

Quantity

Price

Approximate Age

Approximate Height

Location

Description

Contact Method

[PREVIEW]

[SUBMIT FOR REVIEW]
```

↓

Pending Moderator Approval.

---

# 44. My Profile

```text
[Avatar]

Juan Dela Cruz
Camarines Sur

My Contributions

12 Observations
5 Identifications
3 Listings

------------------

♡ Saved Trees

🌳 My Observations

📷 Identification Requests

🛒 My Listings

🔔 Notifications

⚙ Settings
```

---

# 45. Notifications Screen

Examples:

```text
✓ Your tree observation was approved.

🌳 Someone suggested Narra for your
identification request.

✓ Your identification has been verified.

🛒 Your marketplace listing was approved.

⚠ Moderator requested additional photos.
```

---

# PART IV — MODERATOR MOBILE FLOW

## 46. Moderator Dashboard

Moderator accounts receive an additional menu:

**Moderation**

Dashboard:

```text
MODERATION

Identification Requests     12

Tree Observations            8

Marketplace Listings         4

Reports                      2
```

---

# 47. Moderator Identification Review

Moderator sees:

- Photos
- User description
- Location
- Community suggestions
- Suggested species
- Existing tree profile

Actions:

**Verify Species**

**Request More Photos**

**Mark Unresolved**

**Reject**

Every action creates a moderation record.

---

# 48. Observation Review

Moderator sees:

- Species
- Photos
- Location
- Observation details
- User

Actions:

- Approve
- Request Information
- Reject

---

# 49. Marketplace Review

Moderator checks:

- Species
- Photos
- Seller
- Material type
- Price
- Location
- Description

Actions:

- Approve
- Reject
- Request Changes
- Escalate

---

# PART V — WEB ADMIN SCREEN MAP

## 50. Admin Navigation

Recommended sidebar:

```text
KATUTUBONG PUNO ADMIN

Dashboard

TREE DATABASE
 ├ Species
 ├ Purposes
 ├ Planting Conditions
 ├ Distribution
 └ References

COMMUNITY
 ├ Observations
 ├ Identifications
 ├ Corrections
 └ Comments

MARKETPLACE
 ├ Listings
 └ Reports

USERS
 ├ Users
 └ Moderators

MODERATION
 ├ Pending Queue
 └ Moderation History

SYSTEM
 ├ Notifications
 ├ Audit Logs
 ├ Analytics
 └ Settings
```

---

# 51. Admin Dashboard

Cards:

```text
TOTAL USERS
4,521

VERIFIED SPECIES
320

PENDING IDENTIFICATIONS
42

PENDING OBSERVATIONS
18

MARKETPLACE REVIEW
9

OPEN REPORTS
4
```

Below:

- Recent submissions
- Recent moderation activity
- User growth
- Most searched species
- Most requested purposes

---

# 52. Species Management Screen

Table:

```text
Species | Scientific Name | Status | Updated | Actions
```

Actions:

- View
- Edit
- Archive
- References
- Photos

Button:

**+ Add Species**

---

# 53. Species Editor

Recommended tabs:

```text
GENERAL

NAMES

DESCRIPTION

IDENTIFICATION

PURPOSES

PLANTING CONDITIONS

DISTRIBUTION

CONSERVATION

PHOTOS

REFERENCES

CHANGE HISTORY
```

This prevents the species editor from becoming one enormous form.

---

# 54. Admin Moderation Queue

Unified queue:

```text
TYPE          STATUS       DATE       ASSIGNED

Identification Pending     Sept 20    Maria
Observation    Pending     Sept 21    -
Listing        Pending     Sept 21    Pedro
Correction     Pending     Sept 22    -
```

Admin can assign work to moderators.

---

# PART VI — PRIMARY USER FLOWS

## 55. Flow A — Discover a Known Tree

```text
HOME
 ↓
SEARCH
 ↓
SEARCH RESULTS
 ↓
TREE PROFILE
 ↓
SAVE TREE
     OR
FIND SEEDLINGS
```

---

# 56. Flow B — Find Tree by Purpose

```text
HOME
 ↓
FIND THE RIGHT TREE
 ↓
SELECT PURPOSE
 ↓
SELECT PLANTING SITE
 ↓
SELECT SUNLIGHT
 ↓
SELECT SPACE
 ↓
OPTIONAL CONDITIONS
 ↓
MATCHING TREES
 ↓
TREE PROFILE
 ↓
SAVE / FIND SEEDLINGS
```

---

# 57. Flow C — Unknown Tree

```text
HOME
 ↓
IDENTIFY A TREE
 ↓
TAKE PHOTOS
 ↓
ADD OBSERVATION DETAILS
 ↓
LOCATION PRIVACY
 ↓
SUBMIT
 ↓
COMMUNITY SUGGESTIONS
 ↓
MODERATOR REVIEW
 ↓
VERIFIED / UNRESOLVED
 ↓
TREE PROFILE
```

---

# 58. Flow D — Document Known Tree

```text
+
 ↓
RECORD OBSERVATION
 ↓
SELECT SPECIES
 ↓
ADD PHOTOS
 ↓
ADD LOCATION
 ↓
ADD OBSERVATION DATA
 ↓
SUBMIT
 ↓
MODERATOR REVIEW
 ↓
APPROVED
 ↓
MY OBSERVATIONS
```

---

# 59. Flow E — Find a Seedling

```text
TREE PROFILE
 ↓
FIND SEEDLINGS
 ↓
MARKETPLACE RESULTS
 ↓
FILTER LOCATION
 ↓
LISTING
 ↓
SELLER
 ↓
CONTACT SELLER
```

Alternative:

```text
MARKET
 ↓
SEARCH SPECIES
 ↓
LISTINGS
 ↓
LISTING DETAILS
 ↓
CONTACT SELLER
```

---

# 60. Flow F — Sell Seedlings

```text
+
 ↓
SELL / LIST NATIVE TREE
 ↓
SELECT SPECIES
 ↓
ADD PHOTOS
 ↓
PRICE / QUANTITY
 ↓
LOCATION
 ↓
CONTACT METHOD
 ↓
SUBMIT
 ↓
MODERATOR REVIEW
 ↓
ACTIVE LISTING
```

---

# 61. Flow G — Community Correction

```text
TREE PROFILE
 ↓
SUGGEST CORRECTION
 ↓
SELECT FIELD
 ↓
PROPOSE CORRECTION
 ↓
ADD EXPLANATION / SOURCE
 ↓
SUBMIT
 ↓
MODERATOR / ADMIN REVIEW
 ↓
APPROVED
 ↓
SPECIES UPDATED
 ↓
AUDIT LOG
```

---

# PART VII — PERMISSION MATRIX

| Feature | User | Moderator | Admin |
|---|:---:|:---:|:---:|
| Browse Trees | ✓ | ✓ | ✓ |
| Search Trees | ✓ | ✓ | ✓ |
| Right Tree Finder | ✓ | ✓ | ✓ |
| Favorite Tree | ✓ | ✓ | ✓ |
| Submit Observation | ✓ | ✓ | ✓ |
| Request Identification | ✓ | ✓ | ✓ |
| Suggest Identification | ✓ | ✓ | ✓ |
| Comment | ✓ | ✓ | ✓ |
| Suggest Correction | ✓ | ✓ | ✓ |
| Create Listing | ✓ | ✓ | ✓ |
| Report Content | ✓ | ✓ | ✓ |
| Verify Identification | — | ✓ | ✓ |
| Approve Observation | — | ✓ | ✓ |
| Moderate Listing | — | ✓ | ✓ |
| Handle Reports | — | ✓ | ✓ |
| Create Official Species | — | Limited | ✓ |
| Edit Official Species | — | Limited | ✓ |
| Manage Moderators | — | — | ✓ |
| Suspend Users | — | Limited | ✓ |
| System Settings | — | — | ✓ |
| Audit Logs | — | Limited | ✓ |

"Limited" permissions should be explicitly configurable.

---

# PART VIII — API GROUPS

Recommended API structure:

```text
/api/v1/auth/

/api/v1/users/

/api/v1/species/

/api/v1/search/

/api/v1/recommendations/

/api/v1/observations/

/api/v1/identifications/

/api/v1/favorites/

/api/v1/comments/

/api/v1/corrections/

/api/v1/marketplace/

/api/v1/reports/

/api/v1/notifications/

/api/v1/moderation/

/api/v1/admin/
```

Example request:

```text
GET /api/v1/species?
purpose=shade&
sunlight=full-sun&
site=backyard&
space=large
```

This same structured filtering engine can power the **Right Tree Finder**.

---

# PART IX — IMPORTANT IMPLEMENTATION RULES

## 62. Separate Facts from Community Content

Official species data and community submissions must not be mixed directly.

Community:

```text
Submission
     ↓
Moderation
     ↓
Verification
     ↓
Official Data
```

---

# 63. Never Use Free Text for Important Filters

Bad:

```text
description =
"Good for full sun and large backyard."
```

Better:

```text
sunlight = FULL_SUN
site = BACKYARD
space = LARGE
```

Then a description may explain why.

This is critical for recommendation filtering.

---

# 64. Preserve Source Evidence

Important ecological characteristics should ideally follow:

```text
SPECIES
   ↓
PURPOSE / CONDITION
   ↓
REFERENCE
```

Example concept:

```text
Species:
Tree A

Purpose:
Erosion Control

Evidence:
Reference #125
```

This prevents unsupported information from silently becoming authoritative.

---

# 65. Location Security Rule

Internally:

```text
14.123456
123.123456
```

Publicly:

```text
Sipocot, Camarines Sur
```

when exact coordinates should be protected.

Sensitive species may require even broader public location:

```text
Camarines Sur
```

---

# 66. Marketplace Rule

Marketplace listings must always point to an existing `species_id`.

Do not allow sellers to freely type:

> "Rare Philippine Tree"

without identifying the database species.

If the species is missing:

```text
Can't find your tree?

[REQUEST NEW SPECIES]
```

The request must be reviewed before the marketplace listing becomes active.

This significantly reduces marketplace species-name chaos.

---

# 67. Future AI Compatibility

Our current database already prepares AI functionality through categorized photographs:

```text
Species
 ├ Whole Tree
 ├ Leaf
 ├ Bark
 ├ Flower
 ├ Fruit
 └ Seed
```

Future AI flow:

```text
USER PHOTO
 ↓
AI MODEL
 ↓
TOP POSSIBLE MATCHES
 ↓
SPECIES DATABASE
 ↓
COMMUNITY / MODERATOR VERIFICATION
```

AI therefore becomes another identification assistant rather than replacing the trusted database.

---

# PART X — RECOMMENDED DEVELOPMENT ORDER

Development should **not** start by building every screen simultaneously.

Recommended sequence:

### PHASE 1 — Foundation

- Project repositories
- Database
- Authentication
- API foundation
- Roles & permissions
- File storage

### PHASE 2 — Tree Knowledge Engine

- Species
- Names
- Photos
- Purposes
- Planting conditions
- Distribution
- References
- Admin species editor

### PHASE 3 — Mobile Discovery

- Home
- Search
- Filters
- Tree profiles
- Favorites
- Right Tree Finder

At this point the app already provides useful value.

### PHASE 4 — Community

- Identification requests
- Observations
- Comments
- Corrections
- Moderator workflow

### PHASE 5 — Marketplace

- Listings
- Find Seedlings
- Seller contact
- Marketplace moderation

### PHASE 6 — Safety & Operations

- Reports
- Notifications
- Audit logs
- Analytics
- Privacy controls

### PHASE 7 — Beta

- Seed initial tree database
- Moderator testing
- Closed enthusiast testing
- Bug fixes
- Performance optimization
- Public beta

---

# FINAL V1 SYSTEM MAP

```text
                    KATUTUBONG PUNO
                           │
             ┌─────────────┴─────────────┐
             │                           │
        ANDROID APP                 WEB ADMIN
             │                           │
     ┌───────┼────────┐           ┌──────┼───────┐
     │       │        │           │      │       │
 Discover Identify Marketplace  Trees  Users Moderation
     │       │        │           │      │       │
     └───────┴────┬───┘           └──────┴───┬───┘
                  │                          │
                  └──────────┬───────────────┘
                             │
                         REST API
                             │
           ┌─────────────────┼────────────────┐
           │                 │                │
      PostgreSQL       Object Storage   Notifications
           │
   ┌───────┼────────────┐
   │       │            │
 Species Community  Marketplace
   │       │            │
Purposes Observations Listings
Conditions Identifications Sellers
References Moderation
```

## V1 Core Architecture Principle

The most important relationship in the application is:

```text
             USER NEED
                 │
       ┌─────────┴─────────┐
       │                   │
    PURPOSE             LOCATION
       │                   │
       ├──── CONDITIONS ────┤
       │                   │
       └─────────┬─────────┘
                 │
          SPECIES MATCHING
                 │
                 ▼
          NATIVE TREE PROFILE
                 │
        ┌────────┴─────────┐
        │                  │
      LEARN          FIND SEEDLINGS
        │                  │
     DOCUMENT          MARKETPLACE
        │
     COMMUNITY
        │
    VERIFICATION
```

This structure keeps the main product goal clear:

**Help people identify, understand, document, select, and responsibly obtain the right Philippine native tree for the right place and purpose.**
