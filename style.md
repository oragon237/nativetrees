# Katutubong Puno
# UI/UX Style & Design System PRD

**Document:** UI/UX Style PRD  
**Version:** 1.0  
**Product:** Katutubong Puno  
**Platforms:** Android Mobile App + Web Admin  
**Status:** V1 Design Specification

---

## 1. Purpose

This document defines the visual identity, UI system, UX principles, reusable components, responsive behavior, and implementation rules for the Katutubong Puno Android application and Web Admin Portal.

This document must be used together with the main Katutubong Puno Product Requirements Document.

The functional PRD defines **what the system does**.

This document defines **how the system should look, feel, and behave visually**.

All developers and AI coding agents working on the frontend must follow this specification to maintain visual consistency.

---

# 2. Brand Direction

Katutubong Puno should communicate:

- Philippine nature
- Native biodiversity
- Trust
- Knowledge
- Conservation
- Growth
- Community
- Accessibility
- Environmental responsibility

The application must feel:

**Natural + Modern + Trustworthy + Educational + Friendly**

It should NOT look like:

- A government portal
- A generic e-commerce website
- A gaming application
- A children's application
- An overly decorative environmental NGO website

The product should feel like a modern technology platform built around Philippine native trees.

---

# 3. Brand Personality

The visual personality is:

### Natural

Inspired by forests, leaves, soil, sunlight, and native landscapes.

### Trustworthy

Scientific and ecological information must feel credible.

### Calm

Avoid excessive visual noise and overly saturated interfaces.

### Modern

Use contemporary mobile UI patterns.

### Community-Oriented

Contributions and identification should feel welcoming.

### Purposeful

Important information must be easy to find.

---

# 4. Logo

The official Katutubong Puno logo contains:

- Native tree
- Green foliage
- Natural landscape
- Sunrise
- Circular ecosystem composition
- Katutubong Puno wordmark

The tree represents:

**Native biodiversity and growth.**

The surrounding landscape represents:

**Habitat and ecosystem.**

The sunrise represents:

**Hope, regeneration, and the future of Philippine native trees.**

---

# 5. Logo Variants

The project should maintain the following logo variants.

### Primary Logo

Symbol + Katutubong Puno wordmark.

Used for:

- Landing screens
- Login
- About
- Website header
- Marketing materials

### Symbol Only

Tree emblem without text.

Used for:

- Android app icon
- Favicon
- Avatar
- Small navigation elements
- Loading screen

### Horizontal Logo

Symbol positioned beside:

**Katutubong Puno**

Used for:

- Admin header
- Desktop layouts
- Website navigation

### Monochrome Logo

Single-color version for special situations.

---

# 6. Logo Clear Space

Always maintain clear space around the logo.

Minimum recommended clear space:

**25% of the logo symbol width**

No text, icon, border, or UI element should enter this area.

---

# 7. Logo Restrictions

Do NOT:

- Stretch the logo
- Rotate the logo
- Change its proportions
- Add random effects
- Add heavy shadows
- Change individual logo colors
- Place it over visually busy photographs without sufficient contrast
- Place text directly over the symbol
- Recreate the logo using another font

---

# 8. Primary Color System

The UI color system is derived from the Katutubong Puno logo.

## Forest Green

```css
--kp-forest: #0B4D2B;
```

Primary brand color.

Use for:

- Primary navigation
- Important headings
- Primary buttons
- Active states
- Admin sidebar
- Brand elements

---

## Deep Forest

```css
--kp-forest-dark: #06351E;
```

Use for:

- Dark navigation
- Dark surfaces
- Strong emphasis
- Admin sidebar
- Splash screen backgrounds

---

## Leaf Green

```css
--kp-leaf: #2E7D32;
```

Use for:

- Secondary actions
- Nature-related indicators
- Selected filters
- Verified ecological tags where appropriate

---

## Fresh Green

```css
--kp-fresh: #7CB342;
```

Use sparingly for:

- Highlights
- Growth indicators
- Selected chips
- Decorative accents

---

## Sunrise Gold

```css
--kp-gold: #F5B51B;
```

Represents the sun in the logo.

Use for:

- Highlights
- Important calls to attention
- Featured content
- Special icons
- Selected emphasis

Gold must NOT replace the primary green CTA color.

---

# 9. Supporting Earth Color

```css
--kp-earth: #6D4423;
```

Use very sparingly.

Suitable for:

- Botanical illustrations
- Tree trunk indicators
- Natural educational graphics

Do not use brown as a major UI background.

---

# 10. Neutral Colors

```css
--kp-background: #F8FAF5;

--kp-surface: #FFFFFF;

--kp-surface-alt: #F0F5EB;

--kp-text-primary: #17301F;

--kp-text-secondary: #607066;

--kp-text-muted: #88958B;

--kp-border: #DCE5DA;

--kp-disabled: #B9C4BA;
```

---

# 11. Semantic Colors

Semantic colors must remain separate from brand colors.

```css
--success: #2E7D32;

--warning: #D99100;

--error: #C63D32;

--info: #2878B5;
```

Never communicate status using color alone.

Always combine:

**Color + Icon + Text**

Example:

✓ Verified

rather than showing only a green dot.

---

# 12. Background Strategy

The main mobile background should use:

```css
#F8FAF5
```

Cards:

```css
#FFFFFF
```

Alternative content sections:

```css
#F0F5EB
```

This creates a softer nature-inspired interface compared with pure gray backgrounds.

---

# 13. Typography

UI typography should prioritize readability.

Recommended primary UI font:

**Inter**

Fallback:

```css
Inter, Roboto, Arial, sans-serif
```

Use for:

- Buttons
- Forms
- Navigation
- Cards
- Tables
- Labels
- Body text

---

# 14. Brand Typography

A serif font may be used selectively for:

- Major marketing headlines
- Species presentation
- Splash branding

Recommended:

**Lora**

or

**Merriweather**

Do not use serif typography throughout the entire interface.

---

# 15. Scientific Names

Scientific names must be displayed in italics.

Example:

**Narra**

*Pterocarpus indicus*

Recommended visual hierarchy:

```text
Narra
Pterocarpus indicus
```

Common name = prominent.

Scientific name = secondary + italic.

---

# 16. Typography Scale

Recommended mobile scale:

```text
Display       32px
H1            28px
H2            24px
H3            20px
Title         18px
Body          16px
Body Small    14px
Caption       12px
```

Buttons:

```text
16px / Semi Bold
```

Avoid body text below 14px.

---

# 17. Font Weights

Recommended:

```text
Regular       400
Medium        500
Semi Bold     600
Bold          700
```

Avoid excessive use of bold text.

---

# 18. Spacing System

Use an 8-point spacing system.

```text
4px   micro
8px   small
12px
16px  standard
24px  section
32px  large
48px  major
64px  page section
```

Primary component spacing should use multiples of 8 whenever possible.

---

# 19. Border Radius

The design should feel organic and friendly without becoming overly rounded.

Recommended:

```css
--radius-small: 8px;
--radius-medium: 12px;
--radius-large: 16px;
--radius-xl: 24px;
--radius-pill: 999px;
```

Buttons:

**12px**

Cards:

**16px**

Chips:

**999px**

---

# 20. Shadows

Use subtle elevation.

Example:

```css
box-shadow:
0 2px 8px rgba(11, 77, 43, 0.08);
```

Elevated cards:

```css
box-shadow:
0 6px 20px rgba(11, 77, 43, 0.10);
```

Avoid heavy black shadows.

---

# 21. Iconography

Icons should use a clean outlined or lightly filled style.

Recommended icon themes:

- Tree
- Leaf
- Camera
- Location
- Sun
- Water
- Mountain
- Seedling
- Marketplace
- Heart
- User
- Search
- Filter

Avoid mixing multiple unrelated icon styles.

---

# 22. Photography

Tree photography is one of the most important visual elements.

Photos should prioritize:

- Real Philippine native trees
- Natural lighting
- Clear botanical details
- Leaves
- Bark
- Flowers
- Fruit
- Whole tree

Avoid generic stock photography whenever real species photographs are available.

---

# 23. Primary Button

Example:

```text
┌────────────────────────────┐
│      FIND THE RIGHT TREE   │
└────────────────────────────┘
```

Style:

```css
background: #0B4D2B;
color: #FFFFFF;
border-radius: 12px;
height: 48-52px;
font-weight: 600;
```

---

# 24. Secondary Button

```css
background: transparent;
border: 1px solid #0B4D2B;
color: #0B4D2B;
```

---

# 25. Destructive Button

Use only for actions such as:

- Delete
- Remove
- Ban
- Reject where destructive consequences apply

Use:

```css
background: #C63D32;
```

Do not use red for ordinary cancel buttons.

---

# 26. Inputs

Inputs should have:

- Visible label
- Comfortable height
- Clear border
- Focus state
- Error state
- Helper text

Recommended:

```text
Label

┌─────────────────────────────┐
│ Search native trees...      │
└─────────────────────────────┘
```

Height:

**48–52px**

---

# 27. Input Focus

Focus:

```css
border-color: #2E7D32;
```

Optional subtle focus ring:

```css
0 0 0 3px rgba(46,125,50,0.12)
```

---

# 28. Search Component

Search should be highly visible throughout the app.

Example:

```text
🔍 Search native trees...
```

Search should support:

- Common name
- Scientific name
- Local name

Filter button should appear beside or within the search component.

---

# 29. Chips

Use chips for structured tree information.

Example:

```text
[ Shade ]

[ Full Sun ]

[ Large ]

[ Wildlife ]
```

Avoid giving every chip a different bright color.

Use primarily:

- Soft green background
- Dark green text

---

# 30. Purpose Cards

Purpose discovery should use visual cards.

Example:

```text
┌──────────────┐
│      🌳      │
│    Shade     │
└──────────────┘
```

Possible cards:

- Shade
- Fruit
- Flowering
- Wildlife
- Pollinator
- Erosion Control
- Reforestation
- Coastal

Cards should remain simple and scan-friendly.

---

# 31. Tree Card

Standard tree card:

```text
┌──────────────────────────────┐
│                              │
│        TREE PHOTO            │
│                              │
├──────────────────────────────┤
│ Narra                        │
│ Pterocarpus indicus          │
│                              │
│ 🌳 Large   ☀ Full Sun        │
│                              │
│ [Shade] [Wildlife]           │
└──────────────────────────────┘
```

The photo should remain the dominant visual element.

---

# 32. Tree Profile Visual Hierarchy

Tree profile order:

1. Photo gallery
2. Common name
3. Scientific name
4. Native/endemic indicator
5. Save button
6. Overview
7. Purpose
8. Growing conditions
9. Size
10. Suitable environments
11. Distribution
12. Identification characteristics
13. Conservation
14. References
15. Find Seedlings

Do not display everything in one dense block.

---

# 33. Environmental Condition UI

Use icon + text.

Examples:

```text
☀ Full Sun

◐ Partial Shade

💧 Moderate Moisture

↕ 15–25 m

🌳 Large Canopy

⛰ Hillside
```

Never depend entirely on icons.

---

# 34. Right Tree Wizard

This should feel simple rather than scientific.

Each screen asks one major question.

Example:

```text
What do you need the tree for?

┌────────────┐ ┌────────────┐
│     🌳     │ │     🍈     │
│   Shade    │ │   Fruit    │
└────────────┘ └────────────┘

┌────────────┐ ┌────────────┐
│     🌺     │ │     🐦     │
│ Flowering  │ │ Wildlife   │
└────────────┘ └────────────┘
```

Progress indicator:

```text
● ● ○ ○
```

Always provide:

**Not Sure**

when the user may not know environmental details.

---

# 35. Match Results

Do NOT create fake AI percentages.

Avoid:

```text
98% MATCH
```

unless a legitimate scoring methodology exists.

Instead show:

```text
GOOD MATCH

Why this tree matches:

✓ Suitable for full sun
✓ Large canopy
✓ Matches selected planting environment
✓ Associated with selected purpose
```

---

# 36. Identification Photo UI

Photo collection should visually guide the user.

```text
Help us identify this tree

[ + Whole Tree ]

[ + Leaf ]

[ + Bark ]

[ + Flower ]

[ + Fruit ]
```

Completed:

```text
✓ Leaf added
```

Missing photographs should not automatically prevent submission.

---

# 37. Verification Status

Recommended states:

### Open

Neutral / blue.

### Possible Identification

Gold.

### Moderator Review

Gold/orange.

### Verified

Green + check icon.

### Unresolved

Neutral gray.

### Rejected

Red.

Always include text.

---

# 38. Location Privacy UI

Location visibility should be extremely clear.

Example:

```text
Location Privacy

● Municipality Only
○ Approximate Location
○ Keep Exact Location Private
```

Add helper text:

> Exact locations of sensitive species may be hidden for conservation purposes.

---

# 39. Marketplace Design

Marketplace should visually remain part of Katutubong Puno.

Do not redesign it like Shopee/Lazada.

Focus on:

- Species
- Planting material
- Location
- Seller
- Availability

Listing card:

```text
[PHOTO]

Narra Seedlings

Pterocarpus indicus

₱250

20 available

📍 Camarines Sur
```

---

# 40. Marketplace Species Identity

Scientific name should appear below the listing name.

This helps reduce misidentification.

Example:

```text
Narra Seedlings

Pterocarpus indicus
```

---

# 41. Bottom Navigation

Recommended Android navigation:

```text
HOME

EXPLORE

+

MARKET

ME
```

The center contribution button should be visually prominent.

Tapping `+`:

```text
Identify a Tree

Record Tree Observation

List Native Tree
```

---

# 42. Mobile App Bar

Recommended:

```text
[Logo] Katutubong Puno       🔔
```

For detail pages:

```text
←    Tree Profile            ⋮
```

---

# 43. Admin Visual Direction

Admin should use the same brand but be more data-oriented.

Recommended layout:

```text
┌──────────────┬────────────────────────────┐
│              │                            │
│ SIDEBAR      │       MAIN CONTENT         │
│              │                            │
│ Dark Forest  │       Light Surface        │
│              │                            │
└──────────────┴────────────────────────────┘
```

Sidebar:

```css
background: #06351E;
```

Content:

```css
background: #F8FAF5;
```

---

# 44. Admin Sidebar

Logo at top.

Navigation groups:

```text
Dashboard

TREE DATABASE
Species
Purposes
Planting Conditions
Distribution
References

COMMUNITY
Observations
Identifications
Corrections

MARKETPLACE
Listings
Reports

USERS
Users
Moderators

SYSTEM
Analytics
Audit Logs
Settings
```

Active item:

Soft green background + white or high-contrast text.

---

# 45. Dashboard Cards

Example:

```text
┌──────────────────┐
│ VERIFIED SPECIES │
│                  │
│       320        │
│                  │
│ +12 this month   │
└──────────────────┘
```

Use large numeric hierarchy.

Avoid excessive charts.

---

# 46. Admin Tables

Tables must prioritize readability.

Requirements:

- Sticky header where useful
- Search
- Filters
- Pagination
- Status badges
- Row actions
- Sortable columns where relevant

Example:

```text
Species | Scientific Name | Status | Updated | Actions
```

---

# 47. Status Badges

Example:

```text
[ VERIFIED ]

[ PENDING ]

[ REJECTED ]

[ DRAFT ]
```

Badge must contain text.

Color is supplementary.

---

# 48. Modal Usage

Use modal dialogs for:

- Confirmation
- Short edits
- Delete confirmation
- Moderator actions

Do not place large species-editing forms inside modal windows.

---

# 49. Empty States

Empty states should be helpful.

Example:

```text
🌱

No observations yet.

Start documenting Philippine native
trees you encounter.

[ RECORD A TREE ]
```

---

# 50. Loading State

Use skeleton loading for:

- Tree cards
- Tree profile
- Marketplace
- Dashboard cards

Avoid showing only a spinning loader for content-heavy screens.

---

# 51. Error State

Example:

```text
We couldn't load the trees.

Check your connection and try again.

[ TRY AGAIN ]
```

Avoid technical error messages for ordinary users.

---

# 52. Success State

Example:

```text
✓ Observation Submitted

Your observation has been sent
for moderator review.

[ VIEW OBSERVATION ]
```

---

# 53. Confirmation Dialog

Destructive action example:

```text
Remove this listing?

This listing will no longer appear
in the marketplace.

[CANCEL]    [REMOVE]
```

---

# 54. Accessibility

Minimum requirements:

- WCAG-conscious contrast
- Touch targets minimum approximately 44×44
- Text should remain readable at larger font sizes
- Do not communicate information using color alone
- Images require meaningful accessibility labels
- Form inputs require visible labels
- Error messages must explain the problem
- Keyboard navigation required for Admin
- Visible focus states required for Admin
- Screen-reader-friendly component labels

---

# 55. Conservation Status Accessibility

Conservation information must use:

**Status text + icon + optional color**

Never:

```text
🔴
```

alone.

Instead:

```text
⚠ Endangered
```

with source information available.

---

# 56. Responsive Admin Layout

Recommended breakpoints:

```text
Mobile       < 768px

Tablet       768–1023px

Desktop      1024–1439px

Large        ≥ 1440px
```

Primary Admin experience targets desktop.

Sidebar collapses on smaller screens.

---

# 57. Mobile Content Width

Mobile screens should generally use:

```text
16px horizontal padding
```

Larger devices:

```text
20–24px
```

Avoid placing content directly against screen edges.

---

# 58. Desktop Content Width

Admin main content should have reasonable maximum widths where forms are involved.

Tables may use the available viewport width.

Forms should not stretch inputs unnecessarily across very wide screens.

---

# 59. Dark Mode

Dark mode is NOT required for V1.

Architecture should avoid hardcoding colors directly inside components so future dark mode remains possible.

Use semantic design tokens.

Bad:

```css
color: #17301F;
```

inside hundreds of components.

Better:

```css
color: var(--text-primary);
```

---

# 60. Developer Design Tokens

Recommended initial CSS token structure:

```css
:root {

  /* BRAND */

  --kp-forest: #0B4D2B;
  --kp-forest-dark: #06351E;
  --kp-leaf: #2E7D32;
  --kp-fresh: #7CB342;
  --kp-gold: #F5B51B;
  --kp-earth: #6D4423;

  /* SURFACES */

  --background: #F8FAF5;
  --surface: #FFFFFF;
  --surface-alt: #F0F5EB;

  /* TEXT */

  --text-primary: #17301F;
  --text-secondary: #607066;
  --text-muted: #88958B;

  /* UI */

  --border: #DCE5DA;
  --disabled: #B9C4BA;

  /* SEMANTIC */

  --success: #2E7D32;
  --warning: #D99100;
  --error: #C63D32;
  --info: #2878B5;

  /* RADIUS */

  --radius-sm: 8px;
  --radius-md: 12px;
  --radius-lg: 16px;
  --radius-xl: 24px;
  --radius-pill: 999px;

  /* SPACING */

  --space-1: 4px;
  --space-2: 8px;
  --space-3: 12px;
  --space-4: 16px;
  --space-6: 24px;
  --space-8: 32px;
  --space-12: 48px;
  --space-16: 64px;
}
```

Equivalent tokens should be created for Flutter/React Native if the mobile application does not consume CSS.

---

# 61. Component Naming

Recommended component naming:

```text
KPButton

KPInput

KPSearchBar

KPChip

KPBadge

KPCard

KPTreeCard

KPPurposeCard

KPPhotoUploader

KPLocationSelector

KPStatusBadge

KPEmptyState

KPErrorState

KPSkeleton

KPBottomNavigation

KPAppBar
```

This encourages creation of a reusable Katutubong Puno component library.

---

# 62. Mobile Screen Visual Priority

The visual hierarchy should generally be:

```text
PHOTO / PRIMARY CONTENT

↓

NAME / MAIN QUESTION

↓

ESSENTIAL INFORMATION

↓

PRIMARY ACTION

↓

SECONDARY DETAILS

↓

REFERENCES / TECHNICAL INFORMATION
```

Users should not need botanical expertise to understand the interface.

---

# 63. UX Writing Style

Interface language should be:

- Clear
- Friendly
- Short
- Non-technical when possible
- Scientifically responsible

Avoid:

> Submit botanical specimen metadata.

Prefer:

> Tell us about the tree.

Avoid:

> Geospatial coordinate confidentiality.

Prefer:

> Who can see this location?

---

# 64. Scientific Terminology

Scientific terminology is acceptable when useful, but explain unfamiliar concepts.

Example:

**Riparian Area**

> Land beside rivers and streams.

---

# 65. Recommendation Language

Do NOT use:

> This tree will prevent landslides.

Use:

> This species may be suitable for certain slope-rehabilitation or erosion-control applications.

Do NOT use:

> Perfect for your location.

Prefer:

> Matches the planting conditions you selected.

---

# 66. Marketplace UX Language

Do not imply that Katutubong Puno guarantees every seller or plant unless a formal verification system exists.

Use:

> Seller Listing

Future:

> Verified Nursery

only when verification criteria have been implemented.

---

# 67. Animation

Animations should be subtle.

Recommended:

- 150–250 ms transitions
- Soft card expansion
- Smooth filter selection
- Image fade-in
- Button feedback
- Wizard transitions

Avoid:

- Excessive bouncing
- Constant animations
- Decorative particles
- Large parallax effects

The product should feel calm.

---

# 68. Splash Animation

Optional:

Logo tree symbol gently appears.

Possible sequence:

```text
Seed / Leaf
     ↓
Tree Symbol
     ↓
Katutubong Puno
```

Total duration should remain short.

Do not delay app startup unnecessarily.

---

# 69. Primary Mobile Home Hierarchy

Recommended order:

```text
APP BAR

SEARCH

IDENTIFY A TREE

FIND THE RIGHT TREE

EXPLORE BY PURPOSE

FEATURED NATIVE TREES

RECENT COMMUNITY ACTIVITY

MARKETPLACE PREVIEW
```

Identification and Right Tree Finder should receive stronger emphasis than marketplace content.

---

# 70. Marketplace Visual Priority

The marketplace is an important feature but should remain secondary to the knowledge/conservation mission.

Do not place:

**BUY NOW**

as the dominant application-wide action.

The platform's hierarchy remains:

```text
DISCOVER

IDENTIFY

LEARN

DOCUMENT

SELECT

FIND PLANTING MATERIAL
```

---

# 71. Design Consistency Rule

Developers must NOT create arbitrary colors, spacing, buttons, or card styles for individual screens.

New UI should first attempt to use an existing design-system component.

If a new component is necessary:

1. Define its purpose.
2. Check whether an existing component can be extended.
3. Use existing tokens.
4. Document the component.
5. Maintain accessibility requirements.

---

# 72. AI Coding Agent Rule

Any AI coding assistant implementing Katutubong Puno UI must:

1. Read this document before creating frontend components.
2. Reuse existing components.
3. Reuse design tokens.
4. Avoid introducing arbitrary colors.
5. Avoid introducing unrelated fonts.
6. Maintain mobile accessibility.
7. Maintain responsive Admin behavior.
8. Preserve scientific-name formatting.
9. Preserve location privacy UX.
10. Preserve moderation-status clarity.

When functionality conflicts with visual decoration:

**Usability wins.**

When branding conflicts with accessibility:

**Accessibility wins.**

---

# 73. Final Visual Identity

Katutubong Puno should visually communicate:

> **A modern Philippine technology platform built around native trees, trusted knowledge, community participation, and responsible planting.**

The UI should make a first-time user feel:

**“I can easily discover which native tree is appropriate for what I need.”**

A tree enthusiast should feel:

**“This platform respects native-tree knowledge.”**

A moderator should feel:

**“I can efficiently review and improve community information.”**

An administrator should feel:

**“The system is organized, manageable, and trustworthy.”**

---

# 74. Core Brand Summary

## Product

**Katutubong Puno**

## Primary Color

**Forest Green — #0B4D2B**

## Secondary Color

**Leaf Green — #2E7D32**

## Highlight

**Sunrise Gold — #F5B51B**

## Background

**Warm Nature White — #F8FAF5**

## Primary UI Font

**Inter**

## Brand Accent Font

**Lora / Merriweather**

## Component Style

**Clean + Soft + Natural + Modern**

## Corner Style

**Moderately Rounded**

## Photography

**Authentic Philippine native trees**

## UX Personality

**Helpful + Trustworthy + Educational**

## Main Product Emphasis

**Native-tree discovery and identification**

## Core UX Principle

> **The right native tree for the right place and purpose.**

---

# 75. Source-of-Truth Rule

For Katutubong Puno V1:

**Main PRD**  
Defines product functionality and scope.

**Database Schema & Screen Flow Specification**  
Defines data structure, permissions, and application flows.

**UI/UX Style PRD**  
Defines visual implementation and interaction standards.

When implementing any frontend feature, all three documents must be considered together.

No individual screen mockup should override core product, privacy, conservation, or accessibility requirements defined by these documents.