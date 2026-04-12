# System Rules — [PROJECT_NAME]

> L1 — Load for any session involving code changes. These are the developer rules: naming, structure, and hard constraints.

---

## Rules of Engagement

1. **Read before writing.** Always read the file you are about to change. Never edit on assumption.
2. **Check architecture first.** Run `/arch-check` before any significant code change.
3. **One concern per file.** No file mixes HTML structure, CSS presentation, and JS behaviour.
4. **CSS-first.** Use CSS for all UI state — `:checked`, `:focus-visible`, `@media`, `@keyframes`. Add JS only when CSS cannot achieve the goal.
5. **No speculation.** Do not add error handling, fallbacks, or abstractions for scenarios that do not exist yet.
6. **git diff before commit.** Always review every change before committing.
7. **`git push` requires explicit confirmation.** Never push autonomously — push deploys to production.

---

## Naming Conventions

| Element | Convention | Example |
|---------|-----------|---------|
| CSS component root | `.component` | `.card` |
| CSS child element | `.component-element` | `.card-title` |
| CSS modifier | `.mod-variant` | `.mod-featured` |
| JS-applied state | `.is-state` | `.is-open`, `.is-active` |
| JS selector hook | `.js-hook` (never styled) | `.js-toggle` |
| Utility class | `.u-name` | `.u-sr-only` |
| JS files | `camelCase.js` | `siteHeader.js` |
| CSS files | `kebab-case.css` | `site-header.css` |
| [Add project-specific conventions] | | |

---

## HTML Standards

- `<!doctype html>` lowercase on every page.
- `lang="en"` (or appropriate language) on every `<html>`.
- `<meta charset="UTF-8">` first in `<head>`.
- One `<h1>` per page; heading hierarchy sequential (no skipping levels).
- Semantic landmarks: `<main>`, `<header>`, `<nav>`, `<footer>` where appropriate.
- Every `<input>` and `<textarea>` paired with `<label for="…">`.
- Every `<img>` has `alt`, `width`, `height`.
- `defer` on all `<script>` tags.

---

## CSS Standards

- **Load order:** `colors.css` → `fonts.css` → `global.css` → `components.css` → `[page].css` → `utilities.css`
- `box-sizing: border-box` in every stylesheet reset.
- All colours, spacing, and timing values as `--custom-properties` in `colors.css`. Never hard-code.
- Mobile-first: `@media (min-width: …)` only. Never `max-width`.
- Alphabetical properties within each rule block.
- `:focus-visible` not `:focus` — keyboard focus indicators only.
- No `!important`. No inline `style` attribute.

---

## JavaScript Standards

- `const` and `let` only — no `var`.
- Each JS file is a self-contained IIFE or ES module. No globals. No shared mutable state across files.
- No inline event handlers in HTML (`onclick`, `onchange`, etc.).
- `requestAnimationFrame` for animation — never `setInterval`.
- `visibilitychange` listener on any `rAF` loop — pause when tab is hidden.
- Sanitise all `localStorage` reads before use (parse, type-check, clamp).
- `rel="noopener noreferrer"` on all `target="_blank"` links.
- Never use `innerHTML` with dynamic or user-supplied content.

---

## Accessibility Standards

- WCAG 2.1 AA minimum.
- WCAG AA colour contrast: 4.5:1 for text, 3:1 for UI components.
- `prefers-color-scheme` for automatic dark mode.
- `prefers-reduced-motion: reduce` to opt out of animations.
- Keyboard: Tab → interactive elements, Enter/Space → activate, Escape → dismiss.
- Visible `:focus-visible` ring on all interactive elements.
- Touch targets ≥ 44 × 44 px.

---

## Security Rules

- Never commit API keys, secrets, or `.env` files to git.
- Never log sensitive data (API keys, user PII, auth tokens).
- [Add project-specific security rules as they are established]

---

## Test Programme

After each significant change:

### Claude's Checklist

- [ ] HTML validates (W3C / `npx html-validate`) — no errors or warnings
- [ ] All `<img>` have `alt`, `width`, `height`
- [ ] All `<input>` have an associated `<label for="…">`
- [ ] No `!important` in CSS
- [ ] No inline styles in HTML
- [ ] No `max-width` media queries
- [ ] `box-sizing: border-box` in every stylesheet reset
- [ ] CSS custom properties used for all colours and spacing
- [ ] `defer` on all `<script>` tags
- [ ] `rel="noopener noreferrer"` on all `target="_blank"` links
- [ ] `prefers-color-scheme: dark` verified visually
- [ ] `prefers-reduced-motion: reduce` verified
- [ ] Schema.org JSON-LD present on each page (if applicable)
- [ ] Open Graph meta tags present on each page (if applicable)

### [Project-specific checks]

- [ ] [Add project-specific test items here]
