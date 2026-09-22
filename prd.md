# Katutubong Puno
## Product Requirements Document — Version 1.0

**Product:** Katutubong Puno  
**Platform:** Android Mobile App + Web Administration Portal  
**Market:** Philippines  
**Version:** MVP / V1  
**Membership Model:** Free  
**Primary Roles:** User, Moderator, Administrator

---

# 1. Product Overview

Katutubong Puno is a mobile-first platform dedicated to the discovery, identification, documentation, planting, conservation, and responsible distribution of Philippine native trees.

The platform will allow users to discover native tree species, identify trees through photographs and community assistance, contribute observations, learn where particular species are appropriate to plant, and find seedlings or saplings offered by community members and nurseries.

The central concept of the platform is:

**Identify → Learn → Document → Verify → Plant → Propagate**

A major differentiator of Katutubong Puno is its **Right Tree for the Right Place and Purpose** system.

Instead of requiring users to already know the name of a tree, the application will help users discover suitable Philippine native species based on their intended purpose and planting conditions.

Examples:

- Shade
- Fruit production
- Wildlife habitat
- Pollinator support
- Ornamental planting
- Reforestation
- Soil erosion control
- Slope rehabilitation
- Watershed rehabilitation
- Riverbank planting
- Coastal rehabilitation
- Windbreak
- Agroforestry
- Urban landscaping

The platform should promote native-tree awareness while avoiding unsupported ecological or safety claims.

---

# 2. Problem Statement

Information about Philippine native trees is fragmented across websites, books, social-media groups, nurseries, government resources, researchers, and individual enthusiasts.

An ordinary person may encounter several problems:

- They see a tree but do not know its species.
- They know a local name but not its scientific name.
- They want to plant native trees but do not know which species are suitable.
- They need a tree for a specific purpose but do not know what species to choose.
- They do not know whether a tree prefers full sun, partial shade, or forest understory.
- They do not know the expected mature size of a tree.
- They do not know whether the species naturally occurs in their region.
- They have difficulty finding legitimate sources of native-tree seedlings.
- Native-tree enthusiasts have observations and knowledge but no centralized community database for sharing them.

Katutubong Puno aims to address these problems through a structured, community-supported native-tree platform.

---

# 3. Product Vision

Create a trusted digital ecosystem for Philippine native trees where people can:

**Identify native trees.**

**Learn about native trees.**

**Discover the right tree for their location and purpose.**

**Document trees growing around them.**

**Contribute knowledge and photographs.**

**Help verify tree identities.**

**Find native-tree seedlings and saplings.**

**Support native-tree propagation and conservation.**

The long-term vision is for Katutubong Puno to become a comprehensive community-supported digital reference for Philippine native trees.

---

# 4. Target Users

## 4.1 Native Tree Enthusiasts

People interested in Philippine native trees who want to discover, photograph, document, grow, exchange, or purchase native species.

## 4.2 Homeowners

Users searching for native trees suitable for:

- Backyards
- Large properties
- Shade
- Landscaping
- Flowering
- Fruit
- Wildlife attraction

## 4.3 Farmers and Landowners

Users searching for trees suitable for:

- Farms
- Agroforestry
- Windbreaks
- Boundary planting
- Soil rehabilitation
- Watershed areas

## 4.4 Environmental Groups

Organizations involved in:

- Reforestation
- Watershed restoration
- Native-tree propagation
- Community planting projects
- Biodiversity programs

## 4.5 Students and Educators

Users who want accessible information about Philippine native trees.

## 4.6 Seedling Growers and Nurseries

Individuals or organizations that propagate native species and want to list available seedlings or saplings.

---

# 5. User Roles

The system will support three primary roles.

## 5.1 User

A registered User can:

- Browse tree species
- Search trees
- Filter trees
- View tree profiles
- Submit photographs
- Request tree identification
- Submit tree observations
- Suggest new species records
- Save favorite trees
- Maintain My Trees
- Comment on identification requests
- Suggest corrections
- Create marketplace listings
- Contact sellers
- Report inappropriate or inaccurate content

## 5.2 Moderator

Moderators receive User permissions plus the ability to:

- Review tree submissions
- Review identification requests
- Approve or reject observations
- Verify photographs
- Suggest or correct species identification
- Review marketplace listings
- Moderate comments
- Review reported content
- Flag questionable species records
- Escalate cases to administrators

Moderator actions must be logged.

## 5.3 Administrator

Administrators have complete system management capabilities.

Administrators can:

- Manage users
- Manage moderators
- Manage species
- Manage taxonomy
- Manage tree-purpose categories
- Manage planting-condition categories
- Manage photographs
- Review submissions
- Manage marketplace listings
- Manage reports
- Manage content
- Configure application settings
- Review system analytics
- Review moderation history
- Suspend or restrict accounts

---

# 6. V1 Platforms

## Android Mobile Application

Primary platform for Users and Moderators.

The mobile application should prioritize:

- Tree discovery
- Photography
- Tree identification requests
- Observations
- Community participation
- Tree recommendations
- Marketplace discovery

## Web Administration Portal

Designed primarily for Administrators.

Moderators may eventually receive web access where useful.

Desktop administration is recommended because reviewing large numbers of records, photographs, reports, and species information is easier on a larger screen.

---

# 7. Authentication

V1 should support:

- Email registration
- Email login
- Password reset
- Email verification

Recommended future options:

- Google Sign-In
- Facebook Sign-In
- Apple Sign-In if an iOS version is developed

User accounts should contain:

- Display name
- Profile photo
- Province/region
- Optional biography
- Contribution statistics
- Account status
- Role
- Join date

Precise residential addresses should not be required.

---

# 8. Native Tree Database

The native-tree database is the core information system of Katutubong Puno.

Each species receives a dedicated Tree Profile.

---

# 9. Tree Profile

Each tree profile should support the following information.

## Identity

**Common Name**

Example:

Narra

**Scientific Name**

Example:

Pterocarpus indicus

**Local / Alternative Names**

Multiple names may be stored.

**Family**

Botanical family.

**Genus**

Botanical genus.

**Species**

Species name.

**Native Status**

Examples:

- Philippine Native
- Philippine Endemic

Native status must be supported by reliable references.

---

# 10. Tree Description

The profile may contain:

- General description
- Leaf description
- Bark description
- Flower description
- Fruit description
- Seed description
- Growth habit

Photographs may be categorized as:

- Whole tree
- Leaf
- Bark
- Flower
- Fruit
- Seed
- Seedling

This structure will later help support AI-assisted identification.

---

# 11. Tree Size and Growth Characteristics

Where reliable information exists, profiles should include:

**Growth Form**

- Small Tree
- Medium Tree
- Large Tree

**Mature Height**

Example:

15–25 meters

**Canopy Spread**

Example:

8–15 meters

**Growth Rate**

- Slow
- Moderate
- Fast

Growth-rate descriptions should be treated as general guidance rather than guarantees.

---

# 12. Tree Purpose

Trees can have multiple purpose tags.

Examples include:

### Shade

Suitable for providing shade where the mature size and planting environment are appropriate.

### Fruit-Bearing

Produces edible or otherwise traditionally useful fruit where properly documented.

### Flowering / Ornamental

Notable for flowers, foliage, form, or landscape value.

### Wildlife Support

Provides documented food, shelter, nesting habitat, or other ecological value.

### Pollinator Support

Provides documented resources for pollinators.

### Reforestation

Potentially useful for appropriate native-forest restoration projects.

### Soil Erosion Control

Species with characteristics documented as useful in suitable erosion-management applications.

### Slope Rehabilitation

Species potentially useful as part of appropriate slope revegetation or rehabilitation programs.

The application must **not claim that planting a particular tree prevents landslides**.

Landslide risk depends on multiple geological, hydrological, environmental, and engineering factors.

### Watershed Rehabilitation

Species appropriate for documented watershed-restoration contexts.

### Riverbank / Riparian Rehabilitation

Species suited to appropriate riparian environments.

### Coastal Rehabilitation

Native species suitable for appropriate coastal conditions.

### Windbreak

Trees potentially useful as part of windbreak planting.

### Agroforestry

Species with documented agroforestry applications.

### Urban Landscaping

Native trees potentially suitable for managed urban environments.

### Carbon Storage

Large or long-lived native trees may have carbon-storage value where supported by appropriate information.

---

# 13. Planting Requirements

Each species should contain structured planting information.

## Sunlight

- Full Sun
- Partial Shade
- Shade

Multiple values may be supported when appropriate.

## Suitable Environment

Examples:

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

## Soil

Examples:

- Sandy
- Loamy
- Clay
- Rocky
- Well-drained
- Moist
- Seasonally wet

## Moisture

- Dry
- Moderate
- Moist
- Wet

## Elevation

Where reliable information is available:

- Lowland
- Mid-elevation
- Highland

Actual elevation ranges may also be stored.

Example:

100–800 meters above sea level.

---

# 14. Space Requirements

Profiles should help users understand the approximate space required by a mature tree.

Categories:

- Small
- Medium
- Large
- Very Large

Where reliable information exists, the system can display:

- Mature height
- Canopy diameter
- Recommended planting considerations

The application should warn users when a large tree may be inappropriate near:

- Buildings
- Power lines
- Roads
- Drainage systems
- Other infrastructure

Exact planting distances should only be shown where supported by reliable guidance.

---

# 15. Right Tree for My Purpose

This is one of the primary V1 features.

Users can discover trees without knowing their names.

Example:

**What do you need the tree for?**

User selects:

> Shade

The system can then ask:

**Where will you plant it?**

> Backyard

**How much sunlight?**

> Full Sun

**Available Space**

> Large

**Environment**

> Lowland

The system searches species metadata and returns matching native-tree records.

This is a **filtering/matching system**, not an AI recommendation engine in V1.

Results should explain why each tree matched.

Example:

> Matches your search because this species is documented for full-sun conditions, develops a large canopy, and is associated with lowland environments.

---

# 16. Tree Search

Users can search using:

- Common name
- Scientific name
- Local name

Filters should include:

- Purpose
- Tree size
- Mature height
- Sunlight
- Environment
- Soil
- Moisture
- Elevation
- Native distribution
- Fruit-bearing
- Flowering
- Growth rate

Multiple filters may be combined.

---

# 17. Explore Trees

The application home screen may contain discovery sections such as:

**Explore by Purpose**

Shade Trees  
Fruit-Bearing Native Trees  
Flowering Native Trees  
Wildlife-Friendly Trees  
Trees for Restoration

**Explore by Environment**

Backyard  
Farm  
Hillside  
Riverbank  
Coastal  
Forest

**Featured Native Tree**

Administrators can feature selected species.

---

# 18. Tree Identification Request

Users who do not know a tree's identity can create an identification request.

The app should encourage users to photograph:

1. Whole tree
2. Leaves
3. Bark
4. Flowers
5. Fruit

Not every photograph is mandatory.

The user can provide:

- Description
- Approximate location
- Habitat
- Estimated height
- Flowering information
- Fruiting information
- Additional observations

Community members and moderators may suggest an identification.

---

# 19. Identification Status

Identification requests can have statuses:

**Open**

Awaiting suggestions.

**Possible Identification**

One or more species have been suggested.

**Moderator Review**

Awaiting moderator confirmation.

**Verified**

Identification accepted by an authorized moderator/admin.

**Unresolved**

Insufficient evidence for reliable identification.

Verification should never imply absolute scientific certainty when photographic evidence is insufficient.

---

# 20. Submit New Tree / Observation

Users can document trees they encounter.

Submission fields:

- Photos
- Suggested species
- Observation date
- Approximate location
- Habitat
- Notes
- Flowering status
- Fruiting status

Submission workflow:

**User Submission**

↓

**Pending Review**

↓

**Moderator Review**

↓

**Approved / Needs More Information / Rejected**

↓

**Published Observation**

Moderators should be able to explain rejection or request additional information.

---

# 21. Location Privacy

Location information requires special protection.

Users may optionally provide location information for observations.

The system should support:

- Province
- Municipality/City
- Approximate map location
- Private precise coordinates where necessary for legitimate data collection

Exact coordinates should **not automatically be publicly displayed**.

Sensitive, rare, threatened, or potentially exploitable species may have their locations generalized.

Example public display:

> Camarines Sur, Bicol Region

instead of exact GPS coordinates.

Administrators should be able to configure location visibility rules.

---

# 22. My Trees

Users can maintain a personal collection.

Two main categories:

**Saved Trees**

Species the user wants to remember.

**My Observations**

Trees the user has documented.

Future versions can expand this into planted-tree monitoring.

---

# 23. Favorites

Users can favorite tree species.

Favorites can later support:

- Planting wishlists
- Availability alerts
- Marketplace matching

---

# 24. Community

V1 includes lightweight community functionality.

Users can:

- Request identification
- Suggest identification
- Comment
- Add useful observations
- Suggest corrections
- Report inaccurate content

The platform should avoid becoming a completely general social network during V1.

The community exists primarily around **native-tree knowledge and identification**.

---

# 25. Community Corrections

Tree information may be corrected through community contribution.

Users can select:

**Suggest Correction**

They identify:

- Incorrect information
- Proposed correction
- Optional source/reference

The correction enters a moderator queue.

It does not immediately modify the official species record.

---

# 26. Native Tree Marketplace

The marketplace helps connect people seeking native-tree planting material with growers and nurseries.

V1 primarily supports:

- Seedlings
- Saplings
- Seeds where legally and ecologically appropriate

The marketplace is initially a **listing and discovery system**.

Katutubong Puno does not need to process payments during V1.

---

# 27. Marketplace Listing

A seller listing should contain:

- Species
- Listing title
- Photos
- Planting material type
- Approximate age
- Approximate height
- Quantity available
- Price
- Seller location
- Description
- Seller
- Availability status

Planting material types may include:

- Seed
- Seedling
- Sapling

Listing statuses:

- Draft
- Pending Review
- Active
- Sold Out
- Rejected
- Removed

---

# 28. Find Seedlings

Each tree profile may contain:

**Find Seedlings**

Selecting this displays available marketplace listings associated with that species.

Users may filter by:

- Province
- Region
- Price
- Seller
- Availability

---

# 29. Seller Contact

V1 does not require an integrated checkout system.

Users can contact sellers through supported contact options.

Future versions may introduce:

- In-app messaging
- Reservation
- Orders
- Payments
- Delivery

---

# 30. Marketplace Safety

Administrators and moderators must be able to:

- Review listings
- Remove misleading listings
- Flag potentially misidentified species
- Suspend sellers
- Review user reports

The marketplace should display that species identification and conservation/legal requirements remain important when acquiring, transporting, propagating, or planting native material.

Species subject to special conservation or legal restrictions should receive appropriate handling.

---

# 31. Reports

Users can report:

- Incorrect tree identification
- Incorrect species information
- Suspicious marketplace listing
- Inappropriate content
- Spam
- Misleading seller information
- Other concerns

Reports enter a moderation queue.

---

# 32. Notifications

V1 notifications should include:

- Identification received
- Identification verified
- Submission approved
- Submission rejected
- Moderator requests more information
- Comment received
- Marketplace listing approved
- Marketplace listing rejected
- Report resolution where appropriate

Push notifications are recommended.

In-app notifications should also be maintained.

---

# 33. Admin Web Dashboard

The Admin Portal should provide a dashboard showing:

- Total users
- New users
- Total species
- Pending tree submissions
- Pending identification requests
- Pending marketplace listings
- Reports awaiting review
- Recent moderator activity

---

# 34. Species Management

Administrators can:

- Create species
- Edit species
- Archive species
- Merge duplicate records
- Manage names
- Manage taxonomy
- Manage descriptions
- Manage purposes
- Manage planting conditions
- Manage distribution
- Manage conservation information
- Manage photographs
- Manage references

Changes to important scientific information should be logged.

---

# 35. User Management

Administrators can:

- Search users
- View profiles
- Change account status
- Assign moderator role
- Remove moderator role
- Suspend accounts
- Review contribution history
- Review moderation history

---

# 36. Moderator Management

Administrators can monitor:

- Number of reviews
- Approvals
- Rejections
- Corrections
- Reports handled

Moderator actions should create audit records.

---

# 37. Moderation Queue

The admin/moderator system should have queues for:

- Identification requests
- Tree observations
- New species suggestions
- Corrections
- Marketplace listings
- Reports
- Flagged photos

Filters should support:

- Date
- Status
- Contributor
- Species
- Location
- Moderator

---

# 38. Evidence and References

Scientific and ecological information should be traceable to reliable sources.

Tree records should therefore support references.

A reference record may contain:

- Title
- Organization/author
- Source type
- Publication year
- URL/reference identifier
- Notes
- Date accessed

Claims such as native distribution, conservation status, habitat, mature size, ecological function, and planting suitability should be sourceable where possible.

Community knowledge may be displayed but should be distinguishable from verified/reference-backed information.

---

# 39. Conservation Status

Species records may contain conservation information where supported by authoritative sources.

The system should record:

- Status
- Source
- Assessment date/version

The app should avoid assuming that global and Philippine conservation classifications are identical.

---

# 40. Core Database Entities

Recommended V1 entities:

**users**

**roles**

**species**

**species_names**

**species_photos**

**species_purposes**

**purposes**

**planting_conditions**

**species_planting_conditions**

**species_distribution**

**species_references**

**observations**

**observation_photos**

**identification_requests**

**identification_suggestions**

**favorites**

**marketplace_listings**

**listing_photos**

**comments**

**correction_requests**

**reports**

**notifications**

**moderation_actions**

**audit_logs**

Relationships should use stable internal IDs rather than relying on species names.

---

# 41. Search Architecture

Search should support partial matching.

Example:

Searching:

> nar

may return:

> Narra

Scientific and local names should also be indexed.

Filters should be handled using structured database fields rather than searching descriptions.

This makes **Right Tree for My Purpose** much more reliable.

---

# 42. Photo Storage

Images should not normally be stored directly inside the relational database.

Recommended architecture:

Mobile App

↓

API

↓

Object/File Storage

↓

Optimized image/CDN delivery

The database stores:

- File URL/key
- Owner
- Species
- Photo type
- Upload date
- Moderation status
- Metadata

Uploaded photographs should be compressed and resized appropriately.

Original images may optionally be retained depending on storage cost and future research requirements.

---

# 43. Recommended Technical Architecture

V1 should use an API-first architecture.

### Android

Recommended options:

**Flutter**

or

**React Native**

Flutter is a strong option if future iOS support is anticipated.

### Admin Web

Possible options:

- React
- Next.js
- Vue

### Backend API

Possible technologies:

- Laravel
- Node.js / NestJS
- Django / FastAPI

The final technology should match the development team's strongest stack.

### Database

Recommended:

**PostgreSQL**

PostGIS may eventually be added for advanced geographic queries.

### Storage

S3-compatible object storage is recommended.

### API

REST API is sufficient for V1.

Example:

`GET /species`

`GET /species/{id}`

`GET /species/search`

`POST /observations`

`POST /identifications`

`POST /marketplace/listings`

`GET /recommendations`

---

# 44. Security Requirements

The platform must implement:

- HTTPS
- Secure password hashing
- Token/session security
- Role-based access control
- Server-side authorization
- API validation
- File upload validation
- Rate limiting
- Protection against SQL injection
- Protection against XSS
- Secure administrator sessions
- Audit logs
- Backup procedures

Admin permissions must never rely only on client-side interface restrictions.

---

# 45. Privacy Requirements

The system should collect only information necessary for platform operation.

Special care must be applied to:

- User location
- Observation coordinates
- Contact information
- Seller information
- Sensitive species locations

Users should understand when location information will be public, approximate, or private.

---

# 46. Performance Requirements

Initial target:

- Normal API response under approximately 2 seconds under expected MVP load
- Search results returned quickly
- Images lazy-loaded
- Mobile images optimized
- Pagination used for large datasets
- Search/filter results paginated

Architecture should allow future scaling without requiring a complete rewrite.

---

# 47. Offline Considerations

Full offline support is not required for V1.

However, future field-use requirements should be considered when designing the architecture.

Potential V2 feature:

**Offline Observation Draft**

Users could photograph trees without connectivity and synchronize observations later.

---

# 48. Analytics

The platform should collect privacy-conscious product analytics.

Important metrics:

- Registered users
- Monthly active users
- Searches performed
- Most searched species
- Most viewed species
- Identification requests
- Identification verification rate
- Observations submitted
- Approved observations
- Marketplace listings
- Seller contacts
- Most selected tree purposes
- Most selected planting environments
- Moderator processing time

---

# 49. V1 Success Indicators

Initial success should not depend only on downloads.

More meaningful indicators include:

**Database Growth**

Number of properly documented native species.

**Community Contributions**

Number of useful observations and photographs.

**Verification Quality**

Percentage of submissions successfully reviewed.

**Discovery Usage**

Number of users using purpose/location filters.

**Marketplace Utility**

Number of legitimate native-tree listings and seller contacts.

**Retention**

Users returning to search, identify, document, or locate planting material.

---

# 50. MVP Scope

The following are considered **required for V1**:

### Mobile

- Registration/login
- User profile
- Native-tree database
- Tree profile
- Search
- Filters
- Purpose tags
- Planting-condition tags
- Right Tree for My Purpose
- Tree identification requests
- Photo uploads
- Observation submission
- Moderator verification
- Favorites
- My Trees / My Observations
- Community comments
- Correction suggestions
- Marketplace
- Find Seedlings
- Seller contact
- Reports
- Notifications

### Admin Web

- Dashboard
- User management
- Moderator management
- Species management
- Tree-purpose management
- Planting-condition management
- Observation moderation
- Identification moderation
- Marketplace moderation
- Reports
- References
- Audit logs
- Basic analytics

---

# 51. Out of Scope for V1

To prevent the MVP from becoming too large, the following should **not be required for launch**:

- AI tree identification
- Integrated payments
- Integrated delivery
- Full social-media feed
- iOS application
- Advanced GIS analysis
- Automated landslide-risk assessment
- Full offline mode
- Nursery subscription plans
- Organization dashboards
- QR tree tagging
- Advanced gamification
- Direct messaging
- AI chatbot

The architecture should allow these features later.

---

# 52. AI Identification Strategy

AI identification should be considered for V2 rather than being a launch dependency.

During V1, Katutubong Puno can gradually build a valuable dataset consisting of:

- Verified species
- Verified photographs
- Leaves
- Bark
- Flowers
- Fruit
- Whole-tree photographs
- Geographic context

This dataset may eventually help evaluate or develop AI-assisted identification.

AI results should be presented as **possible matches**, not guaranteed identification.

Example:

> Possible Match: Narra  
> Confidence: High  
> Verification recommended.

Community or expert verification should remain available.

---

# 53. V2 Roadmap

Potential V2 features:

### AI-Assisted Identification

Upload photograph → receive possible species matches.

### Interactive Native Tree Map

Explore observations geographically while protecting sensitive locations.

### Nursery Verification

Verified nursery profiles.

### Contributor Reputation

Points or reputation based on useful verified contributions.

### Badges

Examples:

- Native Tree Explorer
- Tree Identifier
- Contributor
- Conservation Contributor

### Offline Observation Capture

Create field observations without an internet connection.

### Availability Alerts

Example:

> Notify me when Narra seedlings become available near my province.

---

# 54. V3 Roadmap

Potential V3 features:

### Planting Tracker

Users record trees they planted.

Information:

- Species
- Date planted
- Approximate location
- Photos
- Growth records

### QR Tree Tags

A planted tree can receive a QR code linking to its public record.

### Growth Timeline

Users periodically upload photographs.

Example:

2027 — Seedling  
2028 — 1.5 m  
2030 — 3.2 m

### Community Planting Projects

Organizations can create projects such as:

> 1,000 Native Trees for Watershed Restoration

### Organization Accounts

Potential users:

- Schools
- NGOs
- LGUs
- Environmental organizations
- Native-tree societies

---

# 55. Future Business Model

Core tree information should remain freely accessible.

Possible future sustainable revenue sources include:

- Verified nursery accounts
- Promoted marketplace listings
- Organization accounts
- Sponsorships
- Donations
- Environmental partnerships
- Project-management tools for organizations

Monetization should not compromise the credibility of species recommendations.

A seller paying for promotion must not cause their species to appear scientifically “more suitable” in Right Tree recommendations.

---

# 56. Major Product Risks

## Incorrect Identification

**Risk:** Community incorrectly identifies a species.

**Mitigation:** Verification workflow, evidence requirements, moderator review, unresolved status.

## Incorrect Planting Recommendation

**Risk:** User assumes a species will thrive anywhere.

**Mitigation:** Show conditions and evidence instead of guarantees.

## Sensitive Species Exploitation

**Risk:** Exact locations could expose rare trees.

**Mitigation:** Hide/generalize sensitive coordinates.

## Marketplace Misidentification

**Risk:** Seller lists a different species under a native-tree name.

**Mitigation:** Moderation, reports, species-linked listings, future verified sellers.

## Unsupported Environmental Claims

**Risk:** Statements such as "this tree prevents landslides."

**Mitigation:** Use scientifically appropriate language such as:

> Suitable for certain erosion-control or slope-rehabilitation applications.

Never guarantee landslide prevention.

---

# 57. Core User Journey

A typical new user opens Katutubong Puno.

They see:

**Identify a Tree**

**Find the Right Tree**

**Explore Native Trees**

**Find Seedlings**

Example journey:

User selects:

> Find the Right Tree

Then:

> Purpose: Shade

> Planting Area: Backyard

> Sunlight: Full Sun

> Space: Large

The application searches its structured species database.

Several matching Philippine native trees appear.

The user opens one.

They learn:

- Common name
- Scientific name
- Native distribution
- Mature size
- Canopy size
- Growth characteristics
- Ecological uses
- Planting conditions
- Photos
- References

The user decides the species is interesting.

They tap:

**Save Tree**

or:

**Find Seedlings**

The marketplace displays available planting material.

This journey represents the central value of Katutubong Puno.

---

# 58. Product Principle

Every major feature should support at least one part of this lifecycle:

**DISCOVER**

Find native trees.

↓

**IDENTIFY**

Determine what tree the user encountered.

↓

**LEARN**

Understand the species.

↓

**DOCUMENT**

Contribute observations and photographs.

↓

**VERIFY**

Improve information quality through moderation.

↓

**SELECT**

Choose an appropriate native tree for a specific purpose and environment.

↓

**FIND**

Locate legitimate planting material.

↓

**PLANT**

Encourage appropriate native-tree planting.

↓

**CONSERVE**

Build awareness and knowledge of Philippine native-tree biodiversity.

---

# 59. V1 Product Positioning

Katutubong Puno should not be positioned simply as a tree-identification application.

Its stronger positioning is:

> **Katutubong Puno is a community-powered platform for discovering, identifying, learning about, documenting, and finding Philippine native trees — helping people choose the right native tree for the right place and purpose.**

---

# 60. V1 Definition of Done

Katutubong Puno V1 is ready for public MVP testing when a user can successfully:

1. Create an account.
2. Browse a curated native-tree database.
3. Search for a tree by common, local, or scientific name.
4. Filter trees by purpose and planting conditions.
5. Use Right Tree for My Purpose.
6. View complete structured tree profiles.
7. Upload photographs and request identification.
8. Submit an observation.
9. Receive moderator review.
10. Save favorite trees.
11. View personal observations.
12. Participate in identification discussions.
13. Suggest corrections.
14. Browse native-tree marketplace listings.
15. Find planting material for a selected species.
16. Contact a seller.
17. Report inaccurate or inappropriate information.

At the same time, administrators must be able to manage:

18. Users and moderators.
19. Native-tree species.
20. Tree purposes.
21. Planting conditions.
22. Identification requests.
23. Observations.
24. Marketplace listings.
25. Reports.
26. References.
27. Moderation records.
28. Basic system analytics.

When these workflows operate reliably and the initial tree database contains sufficiently reviewed content for meaningful testing, **Katutubong Puno V1 can enter public beta.**

---

## Final V1 Concept

**Katutubong Puno**

**Discover. Identify. Plant Native.**

A Philippine native-tree knowledge, identification, community, planting-guidance, and seedling-discovery platform built around one important question:

**What native tree is right for my place and my purpose?**

