# Core Patterns — [PROJECT_NAME]

The compact "do not break" reference. Read this before any significant code change. These are the patterns most likely to regress and the hardest to diagnose when they do.

Not a full architecture reference — that's `ARCHITECTURE.md`. This is the source of truth that fits in a prompt prefix.

---

## SOURCE OF TRUTH

### Global Constraints

Stated as rules. Each one is absolute — no exceptions without a new ADR.

| # | Never | Always | Why in one line |
|---|-------|--------|----------------|
| **G1** | Hard-code colour or spacing values in CSS | Use CSS custom properties from `theme.css` | One change to a token fixes everywhere; hardcoded values diverge silently |
| **G2** | Use `max-width` breakpoints | Mobile-first `min-width` only | `max-width` creates overrides that compound; `min-width` layers cleanly |
| **G3** | Use `setInterval` for animation | `requestAnimationFrame` with timestamp throttle | `setInterval` fires when tab is hidden; rAF is suppressed by the browser |
| **G4** | Let rAF loops run when tab is hidden | `visibilitychange` listener — pause on hidden, resume on visible | Background tab burns CPU for zero visible benefit |
| **G5** | Animate `width`, `height`, `top`, `left` | `transform` and `opacity` only | Only transform/opacity bypass layout and paint — everything else causes reflow |
| **G6** | Use `!important` in CSS | Find a lower-specificity solution | `!important` is a specificity debt that compounds |
| **G7** | Use inline styles (`style` attribute) | CSS classes and custom properties only | Inline styles override the cascade, skip the token system, and are invisible to tooling |
| **G8** | Use raw `localStorage` values directly in JS logic | Always sanitise: parse, type-check, clamp to valid range | Corrupted or stale storage can silently break UI state |
| **G9** | Use `var` in JavaScript | `const` and `let` only | `var` has function scope and hoisting behaviour that leads to bugs |
| **G10** | Add `target="_blank"` without security attributes | Always add `rel="noopener noreferrer"` | Omitting this allows the opened page to access `window.opener` — a security vulnerability |
| **G11** | Skip `alt`, `width`, `height` on images | Required on every `<img>` | Missing `alt` fails accessibility; missing dimensions cause CLS |
| **G12** | Use `innerHTML` with dynamic content | Sanitise input or use `textContent` / DOM methods | `innerHTML` with user-supplied data is an XSS vector |
| **G13** | Override `html` or `body` font-size | Leave browser default (16px) intact | Overriding breaks rem-based accessibility — users who set a larger base font lose that setting |

---

### Performance Floor

Minimum standards that all new code must meet.

| Floor | Applies to | Standard |
|-------|-----------|----------|
| **rAF throttle** | Any animation loop | Timestamp comparison inside rAF — never fire frame work on every callback |
| **visibilitychange** | Any rAF loop | Must pause when `document.hidden === true`, resume on visible |
| **Transform-only animation** | Any animated element | `transform` and `opacity` only — no layout-triggering properties |
| **Custom properties** | Any new colour, spacing, or timing value in CSS | Defined in `theme.css` (or the relevant namespace file) first, then referenced |
| **localStorage sanitisation** | Any localStorage read in JS | Validate type, parse, and clamp before use |
| **W3C validation** | Any HTML change | `npx html-validate` must pass with no errors or warnings |
| **Lazy loading** | Any below-fold image | `loading="lazy"` on all images not in the initial viewport |

---

### The "Why" — History Behind the Constraints

---

**G1 — CSS custom properties, never hardcoded values**
`background-color: #ebeef0` in a component file is invisible to the theme system. When the brand colour changes, every hardcoded instance must be found and updated manually — and one will be missed. A token in `theme.css` propagates everywhere automatically. Dark mode overrides cascade correctly. The compound benefit grows with codebase size.

**G2 — Mobile-first min-width breakpoints**
`max-width` breakpoints create a pattern where mobile styles are set at the base and then *overridden* for larger screens. These overrides compound: a `max-width: 767px` rule on one component conflicts with another, requiring increasingly specific selectors to unpick. `min-width` layers cleanly — base mobile, then additive complexity for larger viewports. Reversing this later is expensive.

**G3 / G4 — rAF not setInterval, with visibilitychange**
`setInterval` fires at wall-clock time regardless of tab visibility. Background tab runs burn CPU and trigger canvas operations for zero visible output. `requestAnimationFrame` is suppressed by the browser in most inactive-tab scenarios. The `visibilitychange` handler adds an explicit application-level guarantee: the loop is cancelled when `document.hidden` becomes `true`. Both are needed for reliable zero-background-CPU behaviour.

**G5 — Transform and opacity only**
`width`, `height`, `margin`, `top`, `left` — any property that affects box size or position — triggers a full browser layout pass on every frame. Layout recalculates positions for every element in the affected subtree. `transform` and `opacity` are handled entirely by the compositor thread after layout — they never re-trigger layout. For multiple animated elements, this is the difference between smooth and janky.

**G8 — localStorage sanitisation**
`localStorage` values are strings and can be: stale from a previous code version, set to an unexpected value by user manipulation, or absent entirely. A missing key returns `null`. `parseInt(null)` returns `NaN`. Using `NaN` in date calculations or comparisons produces silent failures. Always validate the type, parse to the expected format, and clamp to a valid range before use.

**G12 — No innerHTML with dynamic content**
`innerHTML` with user-supplied strings is an XSS vector. If the string contains `<script>`, `<img onerror=...>`, or other executable HTML, it runs in the user's browser context. Use `textContent` for text, `createElement` + `appendChild` for DOM construction, or sanitise the string with a trusted library before passing to `innerHTML`.

---

## Detailed Pattern Reference

### Pattern 1 — CSS custom properties, always

```css
/* CORRECT */
.card {
  background-color: var(--color-bg-alt);
  color: var(--color-text);
  padding: var(--space-md);
}

/* WRONG — hardcoded values invisible to design token system */
.card {
  background-color: #ebeef0;
  color: #1d1f24;
  padding: 1rem;
}
```

**File:** All stylesheets
**Regression signal:** Dark mode fails to apply; colour inconsistencies appear on theme update

---

### Pattern 2 — Mobile-first breakpoints

```css
/* CORRECT — base is mobile; min-width adds complexity */
.nav {
  flex-direction: column;
}

@media (min-width: 768px) {
  .nav {
    flex-direction: row;
  }
}

/* WRONG — overrides compound */
.nav {
  flex-direction: row;
}

@media (max-width: 767px) {
  .nav {
    flex-direction: column;
  }
}
```

**File:** All stylesheets
**Regression signal:** Layout breaks on small screens; media query conflicts

---

### Pattern 3 — rAF with timestamp throttle

```javascript
// CORRECT — timestamp comparison before frame work
const MIN_INTERVAL = 33; // ~30fps
let lastFrame = 0;

function tick(now) {
  rafHandle = requestAnimationFrame(tick);
  if (now - lastFrame < MIN_INTERVAL) return;
  lastFrame = now;
  // do frame work
}

// WRONG — executes work on every rAF callback (~60fps, no throttle)
function tick() {
  requestAnimationFrame(tick);
  doExpensiveWork();
}
```

---

### Pattern 4 — visibilitychange pause + resume

```javascript
// CORRECT
let rafHandle;

function start() {
  rafHandle = requestAnimationFrame(tick);
}

function stop() {
  cancelAnimationFrame(rafHandle);
  rafHandle = null;
}

document.addEventListener('visibilitychange', () => {
  if (document.hidden) stop();
  else start();
});
```

---

### Pattern 5 — localStorage sanitisation

```javascript
// CORRECT — parse and validate before use
function getStoredCount() {
  const raw = localStorage.getItem('item_count');
  const count = parseInt(raw, 10);
  return isNaN(count) ? 0 : Math.max(0, Math.min(999, count));
}

// WRONG — raw string used directly
function getStoredCount() {
  return localStorage.getItem('item_count'); // could be null, NaN, or stale
}
```

---

### Pattern 6 — Safe external links

```html
<!-- CORRECT -->
<a href="https://example.com" target="_blank" rel="noopener noreferrer">External link</a>

<!-- WRONG — opener vulnerability -->
<a href="https://example.com" target="_blank">External link</a>
```

---

### Pattern 7 — Safe DOM content insertion

```javascript
// CORRECT — use textContent for text
element.textContent = userInput;

// CORRECT — use DOM methods for structure
const p = document.createElement('p');
p.textContent = userInput;
container.appendChild(p);

// WRONG — XSS vector if userInput is untrusted
element.innerHTML = userInput;
```

---

## Quick Regression Checklist

Run before committing any change to `js/` or `styles/`:

- [ ] No `setInterval` in any new animation code — `requestAnimationFrame` with throttle
- [ ] `visibilitychange` listener present on any new rAF loop
- [ ] New CSS values use `--custom-properties` — no hardcoded colours or spacing
- [ ] No `max-width` breakpoints — mobile-first `min-width` only
- [ ] No inline `style` attribute in HTML
- [ ] No `!important` in CSS
- [ ] `localStorage` reads sanitised before use
- [ ] `npx html-validate` passes on any HTML change
- [ ] `rel="noopener noreferrer"` on all `target="_blank"` links
- [ ] No `innerHTML` with dynamic/user content
- [ ] Every `<img>` has `alt`, `width`, `height`
- [ ] `const` and `let` only — no `var`
