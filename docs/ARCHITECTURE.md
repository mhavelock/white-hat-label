# ARCHITECTURE.md — [PROJECT_NAME]

**Site:** [domain.com]
**Type:** [Static site / Web app / SPA / Full-stack]
**Purpose:** The golden thread — structural decisions, data flows, and what must never regress.

---

## What It Is

[One paragraph describing the project — what it does, who it's for, and what makes it distinct. This is the context that every future session should start with.]

---

## Platform & Deployment

- **[Static site / Web app].** [No backend / Node backend / PHP backend / etc.]
- **Build:** [No build step — pure HTML/CSS/JS / npm run build / Next.js / etc.]
- **Hosting:** [GitHub Pages / Vercel / Cloudflare Pages] — branch `main` auto-deploys
- **Domain:** [domain.com] (CNAME to [hosting provider])
- **Repository:** [https://github.com/[owner]/[repo]]
- **Local dev:** `npx live-server` — http://127.0.0.1:5500

---

## Core Structural Decisions

These are the expensive-to-change choices. Each one has a reason that must survive the decision.

### 1. [Decision name]

[What was decided, and why. Include alternatives considered and the reason this option was chosen.]

### 2. CSS custom properties as single source of truth

All colours, spacing, and timing values are defined as `--custom-properties` in `styles/theme.css`. Never hard-coded in component CSS. Page- or feature-specific tokens live in their own namespace (e.g. `--[feature]-*`) in their own stylesheet.

### 3. Mobile-first, min-width breakpoints only

Base styles target the smallest screen. `@media (min-width: ...)` layers on complexity for larger screens. `max-width` breakpoints are never used for layout — they create overrides that compound.

### 4. CSS-first behaviour

UI state is handled by CSS (`:checked`, `:focus-visible`, custom properties, `@keyframes`) wherever possible. JS is added only when CSS cannot achieve the goal.

### 5. No inline styles

The `style` attribute is never used. All presentation is in CSS. This keeps the design token system intact and makes tooling effective.

### 6. localStorage sanitisation

Any value read from `localStorage` is validated before use: type-checked, parsed, and clamped to a valid range. Raw strings are never used directly in logic.

---

## File Structure

```
[project-root]/
├── index.html              # Main entry point
│
├── assets/
│   ├── audio/
│   ├── bgs/
│   ├── components/
│   ├── graphics/
│   ├── icons/
│   └── photos/
│
├── styles/
│   ├── theme.css           # ⭐ Design tokens — single source of truth
│   ├── global.css          # Base element defaults, reset, buttons, forms
│   ├── grid.css            # 12-column grid system
│   ├── components.css      # Reusable UI components
│   ├── badges.css          # Badge and tag components
│   ├── custom.css          # Page/feature-specific overrides
│   └── utilities.css       # u-* helper classes (always load last)
│
├── js/
│   ├── main.js             # Entry point — shared utilities
│   └── logger.js           # Dev logger — buffered in memory
│
├── docs/
│   ├── ARCHITECTURE.md     # This file
│   ├── SYSTEM.md           # Developer rules and naming conventions
│   └── architecture/       # Extended reference docs
│
└── context/
    ├── summaries/           # Tasklist and handoff summaries
    └── [context files]
```

### ⚠️ Protected files

| File | Rule |
|------|------|
| `styles/theme.css` | Never hardcode colour or spacing values in other files. Tokens must be defined here first. |
| `[file]` | [Reason it's protected] |

---

## Page / Script Dependency Diagram

```
index.html
├── styles/theme.css          (design tokens — always first)
├── styles/global.css         (base resets and element defaults)
├── styles/grid.css           (12-column grid)
├── styles/components.css     (reusable UI components)
├── styles/custom.css         (page-specific overrides)
├── styles/utilities.css      (u-* helpers — always last)
└── js/main.js                (defer)
```

---

## CSS Architecture

### CSS load order

All pages load stylesheets in this order:

1. `theme.css` — design tokens (must be first — everything else references these)
2. `global.css` — reset, base elements, buttons, forms, typography
3. `grid.css` — 12-column grid system
4. `components.css` — header, modal, alert, tooltip, card, etc.
5. `custom.css` — page or feature-specific overrides
6. `utilities.css` — `u-*` helper classes (must be last to allow overrides)

### Design token system

`theme.css` is the single source of truth for all CSS custom properties. Light mode defaults are declared on `:root`. Dark mode overrides are applied via `@media (prefers-color-scheme: dark)`, which can be further overridden by `[data-theme="light"]` or `[data-theme="dark"]` on `<html>` for manual theme control.

Font sizes use `em` so they scale relative to the element's inherited font size. Spacing uses `rem` so distances remain consistent regardless of local font-size inheritance.

---

## Data Flow

```
[Describe the main data flow for this project — e.g. user interaction → JS → state → DOM update]

Example:
[User submits form]
    ↓
main.js validates input client-side
    ↓
fetch() POST to /api/[endpoint]
    ↓
Server responds with JSON
    ↓
UI updates via DOM manipulation / state change
```

---

## Conventions Quick Reference

| What | Where |
|------|-------|
| All design tokens | `styles/theme.css` |
| Font declarations | `styles/theme.css` |
| Shared base resets | `styles/global.css` |
| 12-column grid | `styles/grid.css` |
| Reusable UI components | `styles/components.css` |
| Page-specific styles | `styles/custom.css` |
| Utility helpers | `styles/utilities.css` |
| Shared utilities / init | `js/main.js` |
| Dev logging | `js/logger.js` |

---

## What We Never Do

| Never | Always |
|-------|--------|
| Hard-code colour or spacing values | CSS custom properties from `theme.css` |
| Use `max-width` breakpoints | Mobile-first `min-width` only |
| Inline styles in HTML | No `style` attribute, ever |
| `!important` in CSS | Specificity-correct rule ordering |
| Use `setInterval` for animation | `requestAnimationFrame` with timestamp throttle |
| Let animation loops run when tab is hidden | `visibilitychange` listener pauses loops |
| Animate `width`, `height`, `top`, `left` | `transform` and `opacity` only |
| Raw `localStorage` values in JS logic | Always sanitise/validate before use |
| Skip `alt`, `width`, `height` on images | Required on every `<img>` |
| `var` in JavaScript | `const` and `let` only |

---

*Developer rules in full: `docs/SYSTEM.md`*
*Coding standards and token reference: `docs/architecture/ARCHITECTURE_EXTENSION.md`*
*Pre-commit patterns: `docs/architecture/CORE_PATTERNS.md`*
