# ARCHITECTURE_EXTENSION.md — [PROJECT_NAME]

Operational and reference detail. The primary structural decisions and data flows live in `ARCHITECTURE.md`. Load this when doing a code audit, reviewing conventions, checking design tokens, or diagnosing a known pitfall.

---

## Technical Coding Standards

### CSS Conventions

**File per concern.** `theme.css` for tokens, `global.css` for base resets, `components.css` for reusable components, `custom.css` for page/feature overrides, `utilities.css` last. Never mix concerns.

**Component naming pattern:**
```css
.card               /* component root */
.card-title         /* component child */
.mod-featured       /* modifier */
.is-open            /* JS-applied state */
.js-toggle          /* JS selector only — never styled */
.u-sr-only          /* utility */
```

**Custom properties:**
All colours, spacing, and transitions defined in `theme.css`. Feature namespaces `--[feature]-*` in their own stylesheets. Referencing a token that doesn't exist in its expected file is a bug.

**Responsive:** Base styles target the smallest screen. `@media (min-width: ...)` adds complexity for larger screens. Never `max-width` for layout breakpoints. `max-height` is permitted for orientation queries only.

**Focus styles:** `:focus-visible` only — never bare `:focus`. This ensures visible keyboard focus rings without showing them on mouse click.

**Typography:** `rem` for spacing and layout distances. `em` for font sizes. `html`/`body` font-size never overridden — browser default (16px) preserved for accessibility.

**Cursor:** `cursor: pointer` on all buttons and button-styled links.

---

### Hook Conventions

Hooks in `.claude/hooks/*.sh` run on every relevant tool call. They must work on every developer's machine, never block legitimate work, and never leak the original author's username via hardcoded paths. Four rules:

**1. Env-var-driven paths.** Never hardcode `/Users/<name>/...`. Pattern:

```bash
LOG_DIR="${COWORK_LOG_DIR:-$(git rev-parse --show-toplevel 2>/dev/null || pwd)/.claude/logs}"
mkdir -p "$LOG_DIR" 2>/dev/null || exit 0
```

If a cross-project env var (`$COWORK_LOG_DIR`, `$COWORK_BACKUP_DIR`) is set, use it. Otherwise fall back to a project-local directory that's already in `.gitignore`. (See `CORE_PATTERNS.md` G14.)

**2. Diagnostic hooks always exit 0.** Logging, backup, telemetry hooks: never block the underlying tool call on failure. End the script with `exit 0`. Gating hooks (path-guards, secret-scanners) are the exception — they exit non-zero deliberately, and must document this at the top of the script.

**3. `set -u`, not `set -e`.** `set -u` catches typos; `set -e` turns "log directory missing" into "tool call blocked." If a section genuinely needs `set -e`, scope it inside a subshell.

**4. Validate inputs.** Tool inputs arrive via env vars (`$TOOL_NAME`, `$TOOL_INPUT`) and may contain newlines or shell metacharacters. Truncate and strip before piping into commands.

Full reference: `qref/qr-claude-code-hooks.md` (worked example, four-rules detail, sample header).

---

### JS Conventions

**Module pattern (IIFE):** Every JS file is a self-contained IIFE that exposes a named object. No globals. No shared mutable state between files.

```javascript
// Standard IIFE module pattern
const ModuleName = (function () {
  // private state
  let _state = 0;

  // public API
  return {
    init() { /* ... */ },
    getValue() { return _state; }
  };
})();
```

**rAF throttle pattern:** All animation loops compare elapsed time before doing frame work.

```javascript
const MIN_INTERVAL = 33; // ~30fps
let lastFrame = 0;
let rafHandle;

function tick(now) {
  rafHandle = requestAnimationFrame(tick);
  if (now - lastFrame < MIN_INTERVAL) return;
  lastFrame = now;
  // frame work here
}

function start() { rafHandle = requestAnimationFrame(tick); }
function stop()  { cancelAnimationFrame(rafHandle); rafHandle = null; }

document.addEventListener('visibilitychange', () => {
  if (document.hidden) stop();
  else start();
});
```

**localStorage access pattern:**

```javascript
// Always validate before use
function getStoredValue(key, defaultValue, min, max) {
  const raw = localStorage.getItem(key);
  if (raw === null) return defaultValue;
  const parsed = parseInt(raw, 10);
  if (isNaN(parsed)) return defaultValue;
  if (min !== undefined && max !== undefined) {
    return Math.max(min, Math.min(max, parsed));
  }
  return parsed;
}
```

---

## Design Token Reference

### Colour Tokens (`styles/theme.css`)

| Token | Light Mode | Dark Mode | Usage |
|-------|-----------|-----------|-------|
| `--color-bg` | `#f5f6f7` | `#0e0f12` | Page background |
| `--color-bg-alt` | `#ebeef0` | `#1a1c20` | Cards, panels, alternate rows |
| `--color-text` | `#1d1f24` | `#a1b1ca` | Body text |
| `--color-text-muted` | `#555e64` | `#7a8896` | Secondary/helper text |
| `--color-btn-primary` | `#a1b1ca` | `#1d1f24` | Primary button background |
| `--color-text-on-btn-primary` | `#1d1f24` | `#a1b1ca` | Primary button text |
| `--color-btn-secondary` | `#3e3b1b` | `#ebe6b7` | Secondary button background |
| `--color-text-on-btn-secondary` | `#a1b1ca` | `#1d1f24` | Secondary button text |
| `--color-link` | `#1d1f24` | `#a1b1ca` | Link colour |
| `--color-focus` | `#1d1f24` | `#a1b1ca` | Focus ring colour |

### Spacing Tokens

| Token | Value | px |
|-------|-------|----|
| `--space-xs` | `0.25rem` | 4px |
| `--space-sm` | `0.5rem` | 8px |
| `--space-md` | `1rem` | 16px |
| `--space-lg` | `1.5rem` | 24px |
| `--space-xl` | `2rem` | 32px |
| `--space-2xl` | `3rem` | 48px |
| `--space-3xl` | `4rem` | 64px |

### Typography Tokens

| Token | Value |
|-------|-------|
| `--font-heading` | `Verdana, Geneva, sans-serif` |
| `--font-body` | `Arial, Helvetica, sans-serif` |
| `--font-mono` | `'Courier New', Courier, monospace` |
| `--line-height-base` | `1.5` |
| `--line-height-relaxed` | `1.7` |

---

## Common Pitfalls

### Pitfall 1 — Specificity conflict from missing scope

**Symptom:** A style works in isolation but breaks when placed on a page with other components.

**Cause:** The component CSS is not scoped to a root class, so it collides with global or other component styles.

**Fix:** Every component should be scoped to its root class: `.card { ... }`, `.card-title { ... }`. Never write bare element selectors (`h2 { ... }`) in component files — only in `global.css`.

---

### Pitfall 2 — Dark mode not applying to a new component

**Symptom:** A new component ignores the dark mode theme.

**Cause:** The component uses hardcoded colour values instead of `--color-*` tokens from `theme.css`.

**Fix:** Replace all hardcoded values with the appropriate token. Add any missing tokens to `theme.css` with both light and dark values.

---

### Pitfall 3 — Form input not associated with label

**Symptom:** Clicking the label text doesn't focus the input. Screen readers don't read the label when the input is focused.

**Cause:** The `<label for="...">` ID doesn't match the input's `id`, or the input has no `id`.

**Fix:** Every `<input>` and `<textarea>` needs a unique `id`. Every `<label>` needs `for="[matching-id]"`.

---

### Pitfall 4 — Image causes CLS on load

**Symptom:** Content shifts down when an image loads. PageSpeed CLS score is non-zero.

**Cause:** The `<img>` is missing `width` and `height` attributes.

**Fix:** Add `width` and `height` matching the image's intrinsic dimensions. The browser reserves the correct space before the image loads.

---

### Pitfall 5 — localStorage silently returns null

**Symptom:** A feature behaves unexpectedly on first load or after cache clearing.

**Cause:** `localStorage.getItem()` returns `null` when the key doesn't exist. The code assumes it returns a number or string.

**Fix:** Always check for `null` before parsing. Provide a sensible default: `const raw = localStorage.getItem('key'); const value = raw !== null ? parseInt(raw, 10) : DEFAULT_VALUE;`

---

## Schema.org Reference

Add JSON-LD structured data to every page inside `<script type="application/ld+json">`.

### WebSite (home page)

```json
{
  "@context": "https://schema.org",
  "@type": "WebSite",
  "name": "[Project Name]",
  "url": "https://[domain.com]/",
  "description": "[Site description]"
}
```

### WebPage (interior pages)

```json
{
  "@context": "https://schema.org",
  "@type": "WebPage",
  "name": "[Page title]",
  "url": "https://[domain.com]/[page]/",
  "description": "[Page description]",
  "isPartOf": {
    "@type": "WebSite",
    "url": "https://[domain.com]/"
  }
}
```

---

## Logger System Reference

`js/logger.js` is the structured development logger. It is entirely separate from application code.

```javascript
// Log a named event with optional data payload
Logger.log('section', 'message', { optional: 'data' });

// Time measurements
Logger.time('hero-image');       // start a named timer
Logger.timeEnd('hero-image');    // stop timer, log elapsed ms

// Inspect
Logger.dump();    // print all entries to console
Logger.flush();   // write buffer to sessionStorage immediately
Logger.clear();   // empty buffer and remove sessionStorage entry
```

**Built-in test logs (included in starter):**
- `localStorage` availability check
- `sessionStorage` availability check
- Hero image load time (if applicable)
- Script load time measurement

**Production:** Remove `<script src="js/logger.js">` from HTML if not required in production.
