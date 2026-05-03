# Audit YYYY-MM-DD — 2. Conventions

> **Sample chunk — convention conformance: HTML, CSS, and JS patterns versus the rules documented in `SYSTEM.md` and `CORE_PATTERNS.md`. Replace `YYYY-MM-DD` with your audit date and copy into `docs/architecture/audit-YYYY-MM-DD/2-conventions.md`.**

---

## Scope

In scope:

- HTML semantic correctness, accessibility attributes, validation.
- CSS conventions: load order, custom properties, mobile-first, `!important` usage.
- JS conventions: `const`/`let`, IIFE/module pattern, DOM API safety.
- Class naming pattern conformance (`.component`, `.component-element`, `.mod-variant`, `.is-state`, `.js-hook`, `.u-utility`).
- Inline styles, inline event handlers, hardcoded values.

Out of scope:

- File organisation (covered by `1-structure.md`).
- Performance metrics (covered by `3-performance.md`).
- Accessibility deep-dive (covered by `5-accessibility.md`).

---

## Questions

### HTML

1. Does every page have a single `<h1>`? Sequential heading hierarchy?
2. Does every `<input>` and `<textarea>` pair with `<label for="...">`?
3. Does every `<img>` have `alt`, `width`, `height`?
4. Does every `<script>` use `defer` (or `type="module"`)?
5. Does every `target="_blank"` link have `rel="noopener noreferrer"`?
6. Are semantic landmarks present (`<main>`, `<header>`, `<nav>`, `<footer>`)?
7. Does HTML validate with `npx html-validate`?

### CSS

1. Is the load order correct (`theme.css` → `global.css` → `grid.css` → `components.css` → `custom.css` → `utilities.css`)?
2. Are all colours, spacing values, and timing values referenced as CSS custom properties (no hardcoded hex / rem in component CSS)?
3. Are media queries mobile-first (`min-width` only)? Any `max-width` queries?
4. Any `!important` declarations? (Ideal: zero.)
5. Are properties alphabetical within each rule block?
6. Is `box-sizing: border-box` set in every stylesheet reset?
7. Is `:focus-visible` used (not bare `:focus`)?

### JS

1. Any `var` declarations? (Ideal: zero — `const`/`let` only.)
2. Any `eval()` calls? Any `innerHTML` with dynamic content?
3. Are files self-contained (IIFE/module) — no globals leaking?
4. Is `localStorage` data parsed, type-checked, and clamped before use?
5. Any `setInterval` for animation? (Should be `requestAnimationFrame`.)
6. Are animations paused on `visibilitychange` (tab hidden)?

### Class naming

1. Components match `.component` pattern (kebab-case, no prefix)?
2. Elements use `.component-element` pattern (no `__` BEM unless project standard)?
3. Modifiers use `.mod-variant` pattern?
4. State classes use `.is-state` pattern (applied by JS, never styled directly when conventionally `.js-hook`)?
5. JS hooks use `.js-hook` pattern (never styled)?
6. Utilities use `.u-utility` pattern?

### Inline content

1. Any `style="..."` attributes in HTML? (Should be zero.)
2. Any `onclick="..."` / `onload="..."` attributes? (Should be zero — use `addEventListener`.)
3. Any inline `<style>` blocks? (Critical CSS in `<head>` is acceptable, but should be small and explicit.)

---

## How to gather evidence

```bash
# HTML validation
npx html-validate "**/*.html"

# Find !important in CSS
grep -rn '!important' styles/

# Find inline styles in HTML
grep -rn 'style="' --include='*.html' .

# Find inline event handlers
grep -rnE 'on(click|load|change|submit|focus|blur|input)="' --include='*.html' .

# Find max-width media queries (should be zero — mobile-first only)
grep -rn 'max-width' styles/

# Find var declarations in JS
grep -rn '\bvar ' --include='*.js' .

# Find innerHTML with dynamic content (manual review of each hit)
grep -rn 'innerHTML' --include='*.js' .

# Find setInterval (should be rAF for animation)
grep -rn 'setInterval' --include='*.js' .

# Find hardcoded colours in component CSS (rough heuristic)
grep -rnE '#[0-9a-fA-F]{3,8}' styles/ | grep -v theme.css

# Find hardcoded rem/px values in component CSS (rough heuristic)
grep -rnE '[0-9]+(\.[0-9]+)?(rem|px)' styles/ | grep -v theme.css | head
```

Each grep produces candidate lines for review. Many will be false positives (e.g., `var(...)` matches `\bvar `; `style.css` matches `style="`). Manual triage required.

---

## Findings

### ✅ Wins

- [e.g. "All `<img>` elements have `alt`, `width`, `height` — verified across 12 pages"]
- [e.g. "Zero `!important` declarations across all stylesheets"]
- [e.g. "All animations use `requestAnimationFrame` and pause on `visibilitychange`"]

### ⚠️ Limits

- [e.g. "One inline `<style>` block in `index.html` — critical CSS, accepted"]
- [e.g. "Two `localStorage` reads without type-checking — non-critical (defaults are sane); track for hardening"]

### ❌ Issues

- [e.g. "`styles/components.css:142` uses `!important` — fix by raising specificity of competing rule"]
- [e.g. "`js/legacy.js` uses `var` throughout — refactor or delete"]
- [e.g. "Three `<script>` tags missing `defer` attribute"]

---

## Actions

- [ ] (H) [Action] — [owner], [due]
- [ ] (M) [Action]
- [ ] (L) [Action]

---

## See also

- `SYSTEM.md` — developer rules and naming conventions.
- `CORE_PATTERNS.md` — G1–G13 constraints (the "do not break" checklist).
- `ARCHITECTURE_EXTENSION.md` — coding standards detail.
- `FEEDBACK-LOOPS.md` — durable home for confirmed wins/limits.
