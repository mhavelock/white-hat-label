# STANDARDS.md — [PROJECT_NAME]

A living record of the quality standards established and maintained across this project. Update status as work progresses. Intended as a quality benchmark for future sessions and an honest account of what is still open.

---

## Performance Standards

### Targets

| Metric | Target | Status |
|--------|--------|--------|
| Google PageSpeed — Mobile | ≥ 95 | ⚠️ TBA |
| Google PageSpeed — Desktop | ≥ 95 | ⚠️ TBA |
| `defer` on all `<script>` tags | Required | ⚠️ TBA |
| All images with `alt`, `width`, `height` | Required | ⚠️ TBA |
| Below-fold images `loading="lazy"` | Required | ⚠️ TBA |
| Zero render-blocking resources | Required | ⚠️ TBA |
| No layout shift (CLS = 0) | Required | ⚠️ TBA |

### Animation Performance (if applicable)

| Standard | Status |
|----------|--------|
| `requestAnimationFrame` — not `setInterval` | ⚠️ TBA |
| `visibilitychange` pause on rAF loops | ⚠️ TBA |
| `transform` and `opacity` only for animation | ⚠️ TBA |

---

## HTML Standards

| Standard | Status |
|----------|--------|
| W3C valid — no errors, no warnings | ⚠️ TBA |
| `<!doctype html>` lowercase | ⚠️ TBA |
| `<meta charset="UTF-8">` first in `<head>` | ⚠️ TBA |
| `lang="en"` on `<html>` | ⚠️ TBA |
| One `<h1>` per page, sequential heading hierarchy | ⚠️ TBA |
| Semantic landmarks: `<main>`, `<header>`, `<nav>`, `<footer>` | ⚠️ TBA |
| Every `<input>` paired with `<label for="...">` | ⚠️ TBA |
| Every `<img>` has `alt`, `width`, `height` | ⚠️ TBA |
| `rel="noopener noreferrer"` on all `target="_blank"` | ⚠️ TBA |
| `defer` on all `<script>` tags | ⚠️ TBA |
| No inline `<script>` blocks | ⚠️ TBA |
| No inline `style` attributes | ⚠️ TBA |

---

## CSS Standards

| Standard | Status |
|----------|--------|
| All colours defined as CSS custom properties | ⚠️ TBA |
| All spacing defined as CSS custom properties | ⚠️ TBA |
| Mobile-first (`min-width` breakpoints only) | ⚠️ TBA |
| No `max-width` breakpoints for layout | ⚠️ TBA |
| `box-sizing: border-box` in every reset | ⚠️ TBA |
| Alphabetical properties within rule blocks | ⚠️ TBA |
| No `!important` | ⚠️ TBA |
| No inline styles | ⚠️ TBA |
| One responsibility per stylesheet | ⚠️ TBA |
| Load order: `theme.css` first, `utilities.css` last | ⚠️ TBA |
| `rem` for spacing, `em` for font sizes | ⚠️ TBA |
| `html`/`body` font-size never overridden | ⚠️ TBA |
| `cursor: pointer` on all buttons and button-styled links | ⚠️ TBA |

---

## JS Standards

| Standard | Status |
|----------|--------|
| IIFE / module pattern — no globals | ⚠️ TBA |
| `const`/`let` only — no `var` | ⚠️ TBA |
| `requestAnimationFrame` for all animations | ⚠️ TBA |
| `localStorage` sanitised before use | ⚠️ TBA |
| No `eval`, no `innerHTML` with dynamic content | ⚠️ TBA |
| `rel="noopener noreferrer"` on dynamic external links | ⚠️ TBA |

---

## Accessibility Standards (WCAG 2.1 AA)

| Standard | Status |
|----------|--------|
| Keyboard navigation: Tab order logical | ⚠️ TBA |
| Keyboard: Enter/Space on buttons | ⚠️ TBA |
| Keyboard: Escape to close overlays | ⚠️ TBA |
| `:focus-visible` rings on all interactive elements | ⚠️ TBA |
| `prefers-reduced-motion` respected | ⚠️ TBA |
| `prefers-color-scheme` dark mode | ⚠️ TBA |
| Colour contrast ≥ 4.5:1 for text | ⚠️ TBA |
| Colour contrast ≥ 3:1 for UI components | ⚠️ TBA |
| Touch targets ≥ 44×44px | ⚠️ TBA |
| `.u-sr-only` utility available | ⚠️ TBA |

---

## SEO Standards

| Standard | Status |
|----------|--------|
| `<title>` on every page | ⚠️ TBA |
| `<meta name="description">` on every page | ⚠️ TBA |
| Open Graph tags (`og:title`, `og:description`, `og:type`, `og:url`, `og:image`) | ⚠️ TBA |
| `<link rel="canonical">` on every page | ⚠️ TBA |
| JSON-LD structured data | ⚠️ TBA |
| `<meta name="robots" content="index, follow">` | ⚠️ TBA |
| `site.webmanifest` | ⚠️ TBA |
| `theme-color` meta | ⚠️ TBA |

---

## Open Issues

Issues identified but not yet resolved. Add entries here as the project progresses.

| # | Issue | File | Severity |
|---|-------|------|----------|
| — | — | — | — |

---

## Status Key

| Symbol | Meaning |
|--------|---------|
| ✅ | Confirmed passing |
| ⚠️ TBA | Not yet verified |
| ⚠️ Open | Known issue — not yet fixed |
| ❌ Fail | Confirmed failing — needs fixing |
