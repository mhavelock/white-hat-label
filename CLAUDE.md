# [PROJECT_NAME] — CLAUDE.md

> **Instruction file for Claude Code.** Single source of truth for how Claude should approach this project. Follow these instructions exactly and in preference to any defaults.

---

## Summary

**[PROJECT_NAME]** is a [one-sentence description of what the project does and for whom].

[Optional: one more sentence on the core purpose, unique aspect, or key technical constraint.]

---

## Stack

| Layer | Technology |
|-------|-----------|
| Markup | HTML5 — semantic, W3C valid |
| Presentation | CSS3 — custom properties, Flexbox/Grid; no framework |
| Behaviour | Vanilla JavaScript — ES2020+, IIFE modules |
| Fonts | [System fonts / specify if custom] |
| Hosting | [GitHub Pages / Vercel / Cloudflare Pages] |
| CI | [GitHub Actions / GitLab CI] |
| Domain | [domain.com] |
| Local dev | `npx live-server` — `http://127.0.0.1:5500` |

> **Optional stack additions available in this project:** React, Next.js, TypeScript, SASS, Tailwind, AlpineJS, Node.js, PHP, MySQL, PostgreSQL, Cloudflare Workers, Service Workers, OpenRouter, NGINX.

**No build step unless specified. Pure HTML/CSS/JS by default.**

---

## Repository & Deployment

| Item | Value |
|------|-------|
| GitHub / GitLab | https://github.com/mhavelock/white-hat-label |
| Live site | https://mhavelock.github.io/white-hat-label/ |
| Branches | `dev` → `main` → production |
| Git workflow | See [Git Workflow](#git-workflow) below |

---

## File Structure

```
[project-root]/
├── CLAUDE.md               # This file — project instructions for Claude Code
├── README.md               # Public-facing project readme
│
├── assets/
│   ├── audio/              # Audio files
│   ├── bgs/                # Background images
│   ├── components/         # Component-level assets
│   ├── graphics/           # Illustrations, SVG artwork
│   ├── icons/              # SVG icons
│   └── photos/             # Photography
│
├── styles/
│   ├── theme.css           # ⭐ Design tokens — single source of truth
│   ├── global.css          # Base element defaults, reset, links, buttons, forms
│   ├── grid.css            # 12-column grid system
│   ├── components.css      # Reusable UI components — header, modal, alert, tooltip
│   ├── badges.css          # Badge and tag components
│   ├── custom.css          # Page/feature-specific overrides
│   └── utilities.css       # Helper classes — u-sr-only, u-flex-center, etc.
│
├── js/
│   ├── main.js             # Entry point — shared utilities, init
│   └── logger.js           # Dev logger — buffered in memory, separate from app
│
└── docs/
    ├── ARCHITECTURE.md     # System overview and structural decisions
    ├── SYSTEM.md           # Developer rules, naming conventions
    ├── security-sweep-playbook.md       # Two-phase security playbook (run before going public)
    ├── security-phase1-2026-05-03.md    # Phase 1 status table — this repo's own sweep
    ├── plan/                            # Session workspace (mostly gitignored)
    │   └── tasklist.md                  # Task register — only tracked plan file (template)
    └── architecture/                    # Extended reference docs
        ├── CLAUDE_MAINDOCS_INDEX.md     # ⭐ Live state-of-play — loaded every session start
        ├── CORE_PATTERNS.md             # G1–G15 constraints — read before any code change
        ├── DECISIONS.md                 # Architecture decision records (ADRs)
        ├── FEEDBACK-LOOPS.md            # Wins, limits, rules from project history
        ├── BREAKTHROUGHS.md             # Key problem-solving records
        ├── ARCHITECTURE_EXTENSION.md    # Coding standards detail, token reference
        ├── CODEBASE-AUDIT.md            # Audit approach and prompts
        ├── REFLECTIVE-SYNC.md           # Session sync prompts (incl. Security Sync)
        ├── CLAUDE_ARCHITECTURE.md       # How to use the docs / reading order
        ├── CHECKPOINTS.md               # Auto-checkpoint triggers and format
        ├── FE-VISUALISATION.md          # Visual debugging approach
        ├── six-hats.md                  # Thinking approach models
        ├── qref/                        # Surgical quick-references (≥200 words, ≥1 worked failure)
        │   ├── README.md                # When/how to add a qref
        │   ├── qr-public-repo-hygiene.md
        │   ├── qr-static-site-cls.md
        │   └── qr-claude-code-hooks.md
        └── template-examples/           # Example implementations to adapt
            ├── GEMINI-CONSULTANCY.md    # Second-model review protocol
            ├── SERVERSIDE.md            # Serverside infrastructure template (incl. Vercel)
            ├── STANDARDS.md             # Standards tracking template
            ├── PHASE-STATUS.md          # Kanban-in-prose phase table template
            ├── STATE-OF-PLAY.md         # Settings — Current State of Play sub-section template
            ├── handoff_template.md      # Per-session handoff template
            └── audit-template/          # Chunked codebase-audit pattern
                ├── README.md            # Pattern + when to skip
                ├── 1-structure.md       # Sample chunk: file organisation
                └── 2-conventions.md     # Sample chunk: convention conformance
```

> **`docs/plan/`** is gitignored except for `tasklist.md`. Session handoffs (`handoff_YYYY-MM-DD.md`), plan rules, and worked examples live there locally but never reach the public repo.

### ⚠️ Protected files — do not modify without explicit instruction

| File | Why protected |
|------|--------------|
| TBA | TBA |

---

## Technical Development Approach

- **No unnecessary dependencies.** Prefer plain HTML/CSS/JS. Add a framework only when it solves a real problem that cannot be solved without it.
- **CSS-first.** Use CSS for UI state wherever possible (`:checked`, `:focus-visible`, `@media`, custom properties, `@keyframes`). Add JS only when CSS cannot achieve the goal.
- **Separation of concerns.** HTML = structure and content. CSS = all presentation. JS = behaviour only. No inline styles. No inline event handlers.
- **Progressive enhancement.** Core content and function must work without JS. JS then layers on interactive enhancement.
- **Modular JS.** Each JS file is a self-contained IIFE or module. No globals. No shared mutable state across files.
- **CSS custom properties.** All colours, spacing, and timing values are defined as `--custom-properties` in `styles/theme.css`. Never hard-code values in component CSS.
- **Mobile-first CSS.** Base styles target the smallest screen. Use `min-width` media queries. Never use `max-width` for responsive breakpoints.
- **Flex for layout, Grid for components.** Flexbox for page-level flow. CSS Grid where 2D structure is semantically correct.
- **Chained classes.** Separate structural and presentational concerns using chained classes where it improves clarity.
- **`requestAnimationFrame` for animation.** Never `setInterval` for animations. Always pause via `visibilitychange` when the tab is hidden.

### HTML

- Semantic HTML5. One `<h1>` per page. Sequential heading hierarchy.
- Every `<input>` paired with `<label for="...">`.
- Every `<img>` has `alt`, `width`, `height`.
- `defer` on all `<script>` tags.

### CSS

- Load order: `theme.css` → `global.css` → `grid.css` → `components.css` → `custom.css` → `utilities.css`.
- `box-sizing: border-box` in every stylesheet reset.
- Alphabetical properties within each rule block.
- `:focus-visible` not `:focus` — keyboard focus rings only.
- Hover, focus, active states only. No `:visited` state.

### JS

- `const` and `let` only. No `var`.
- No `eval`, no `innerHTML` with dynamic content.
- Sanitise `localStorage` before use: parse, type-check, clamp to valid range.

---

## UX Goals

- **Immediate feedback.** Content renders and is usable without delay.
- **Large touch targets.** All interactive controls ≥ 44 × 44 px.
- **Clean and minimal.** No decoration that doesn't serve the experience.
- **Settings persist automatically.** No save button needed — `localStorage` updates on every change.
- **Orientation aware.** Layouts adapt to landscape on small-screen devices.
- **Reduced motion respect.** Animations respect `prefers-reduced-motion: reduce`.
- **Keyboard accessible.** Every interactive element reachable by Tab, operable by Enter/Space, dismissable by Escape.

---

## SEO Features

- Descriptive `<title>` on every page.
- `<meta name="description">` on every page.
- Open Graph `og:` tags — title, description, type, image, url.
- `<link rel="canonical">` on every page.
- Schema.org JSON-LD structured data on each page.
- Semantic HTML5 landmarks on every page.
- `lang="en"` on `<html>`.
- `<meta name="robots" content="index, follow">` on indexable pages.
- `site.webmanifest` for PWA and search discoverability.

---

## Performance Features

- Critical CSS loaded as a single `<link>` in `<head>`.
- All `<img>` elements have `width`, `height`, `alt`; below-fold images use `loading="lazy"`.
- `srcset` with `250w` and `500w` resolution variants; retina images served to retina devices.
- `sizes` reflects layout breakpoints.
- Explicit image dimensions prevent Cumulative Layout Shift (CLS).
- Images cannot shrink outside their container — always check at low viewport widths.
- `defer` attribute on all `<script>` tags.
- CSS animations use `transform` and `opacity` only.
- `aspect-ratio` on image containers prevents CLS on load.
- `logger.js` buffers log entries in memory — no synchronous storage I/O on every call.
- **Target: Google PageSpeed ≥ 95 on both mobile and desktop.**

---

## Content Summary

| Page | Content |
|------|---------|
| `index.html` | TBA |

---

## Layout & Style Guide

### Grid

- **12-column grid** for page-level layouts — `.container`, `.row`, `.col-*`.
- **Flex for page layout.** Grid only for components where 2D structure is correct.
- **Gutter:** `1rem` (16px at browser default).
- **Max content width:** `1440px`.
- **Minimum element width:** `288px` (prevents over-compression on small devices).

### Typography

| Role | Font stack | Weight |
|------|-----------|--------|
| Headings h1–h6 | `Verdana, Geneva, sans-serif` | bold |
| Body, paragraphs | `Arial, Helvetica, sans-serif` | normal |
| Monospace / code | `'Courier New', Courier, monospace` | normal |

- Base: `1rem = 16px` — do not override `font-size` on `html` or `body`.
- All font sizes in `em`. All spacing distances in `rem`.
- Responsive line height: `1.5` base; `1.7` at ≥ 768px.

### Colour Palette

| Token | Light Mode | Dark Mode |
|-------|-----------|-----------|
| `--color-bg` | `#f5f6f7` | `#0e0f12` |
| `--color-bg-alt` | `#ebeef0` | `#1a1c20` |
| `--color-text` | `#1d1f24` | `#a1b1ca` |
| `--color-text-muted` | `#555e64` | `#7a8896` |
| `--color-btn-primary` | `#a1b1ca` | `#1d1f24` |
| `--color-text-on-btn-primary` | `#1d1f24` | `#a1b1ca` |
| `--color-btn-secondary` | `#3e3b1b` | `#ebe6b7` |
| `--color-text-on-btn-secondary` | `#a1b1ca` | `#1d1f24` |
| `--color-link` | `#1d1f24` | `#a1b1ca` |
| `--color-focus` | `#1d1f24` | `#a1b1ca` |

All tokens defined in `styles/theme.css`. Dark-mode overrides via `@media (prefers-color-scheme: dark)` and `[data-theme="dark"]`.

Custom component styles that deviate from global brand should extend via a separate stylesheet.

### Spacing Scale

| Token | Value | px equivalent |
|-------|-------|--------------|
| `--space-xs` | `0.25rem` | 4px |
| `--space-sm` | `0.5rem` | 8px |
| `--space-md` | `1rem` | 16px |
| `--space-lg` | `1.5rem` | 24px |
| `--space-xl` | `2rem` | 32px |
| `--space-2xl` | `3rem` | 48px |
| `--space-3xl` | `4rem` | 64px |

### Breakpoints (mobile-first, min-width only)

| Name | Value | Context |
|------|-------|---------|
| `sm` | `480px` | Large phones |
| `md` | `768px` | Tablets |
| `lg` | `1024px` | Laptops |
| `xl` | `1280px` | Desktops |
| `2xl` | `1440px` | Wide screens |

---

## CSS Conventions

- **File per concern.** One responsibility per stylesheet. Never mix concerns.
- **Load order:** `global.css` → `layout.css` → `components.css` → `utilities.css` → `theme.css` → `custom.css`.
- **Component naming pattern:**
  - `.component` — root: `.card`
  - `.component-element` — child: `.card-title`, `.card-body`
  - `.mod-variant` — modifier: `.mod-featured`
  - `.is-state` — JS-applied state: `.is-open`, `.is-active`
  - `.js-hook` — JS selector only, never styled: `.js-toggle`
  - `.u-utility` — utility: `.u-sr-only`, `.u-flex-center`
- **No inline styles.** Never use the `style` attribute.
- **No `!important`.** Find a lower-specificity solution.
- **Alphabetical properties** within each rule block.
- **`:focus-visible` not `:focus`** — keyboard focus indicators only.
- **Hover, focus, active states — no visited state.**
- **Mobile-first always.** `@media (min-width: …)` only. Never `max-width`.
- **`box-sizing: border-box`** in every stylesheet reset.
- **CSS custom properties** for every colour, spacing value, and transition duration.
- **`cursor: pointer`** on all buttons and button-styled links.

---

## Standards Compliance

- HTML5, W3C valid. Run `npx html-validate` before committing HTML.
- WCAG 2.1 AA.
- `lang="en"` on `<html>`. `<meta charset="UTF-8">` first in `<head>`. `<!doctype html>` lowercase.
- Semantic landmarks: `<main>`, `<header>`, `<nav>`, `<footer>`.
- Every `<input>` and `<textarea>` paired with a `<label for="…">`.
- Every `<img>` has `alt`, `width`, `height`.
- Keyboard: Tab → interactive elements, Enter/Space → activate, Escape → dismiss overlays.
- Visible `:focus-visible` ring on all interactive elements.
- WCAG AA colour contrast: 4.5:1 for text, 3:1 for UI components.
- `prefers-color-scheme` for automatic dark mode.
- `prefers-reduced-motion` for animation opt-out.
- Schema.org JSON-LD structured data on each page.
- One `<h1>` per page; heading hierarchy sequential.
- `defer` on all `<script>` tags.
- `rel="noopener noreferrer"` on all `target="_blank"` links.

---

## Security (public-repo posture)

This repo is **public**. Treat everything committed as world-readable. Operating rules:

- **Never commit `.env*` files or values.** `.env*` is in `.gitignore`. If a secret hits staging, abort the commit and rotate.
- **Run Phase 0 of `docs/security-sweep-playbook.md`** before any major release or quarterly: 3-min triage for `.env` history, vendor-prefixed token leaks, and client-side env-var leaks.
- **`.entire/` is gitignored.** If you use entire.io for session tracking, make sure `entire enable --skip-push-sessions` is set so session branches never auto-push.
- **`/docs/plan/**` is gitignored** except for `tasklist.md`. Session handoffs and plan rules are local-only — never put real session work into a tracked file.
- **Branch protection on `main`:** `allow_force_pushes:false`, `allow_deletions:false`. Admin (Mat) can bypass for legitimate emergency rewrites — don't use this casually.
- **GitHub `secret_scanning_push_protection`** is enabled. If a push is rejected for a detected secret, **rotate** the secret first, then strip from history with `git filter-repo`.
- **Hook paths are env-var driven.** `.claude/hooks/change-log.sh` and `pre-edit-backup.sh` use `$COWORK_LOG_DIR` / `$COWORK_BACKUP_DIR` (cross-project aggregation if set), falling back to project-local `.claude/logs/` and `.claude/.backups/` (both gitignored). Don't hardcode user-specific paths.
- **Path guards:** the user-level guard hook restricts edits to `~/Claudette/Cowork` and `~/AI`. Honour `.claude` ask-list — every settings.json edit prompts the user.

When in doubt, prefer rotation over history-rewriting — force-push to a public repo doesn't undo what's already cloned.

---

## Skills

| Skill | When to invoke |
|-------|---------------|
| `frontend-standards` | Any time HTML, CSS, or JS is written, reviewed, or refactored |
| `git-commit-messaging` | Every commit — produces Conventional Commits format messages |
| `fe-visualisation` | Any time a visual or layout issue needs debugging before proposing a fix |

---

## Test Programme

After each significant change, run this review prompt:

> "Taking into account the best practices docs in the project `docs/` folder, please run a code review on what we have. Look for better code organisation, clean code improvements, performance improvements, browser memory usage issues, and a security check. Update the md docs and memory file then add and commit to git. Suggest any additional best practice improvements and anything important I may have forgotten. Check changes didn't break completed task functionality."

### Your Checklist

- [ ] [Feature works as expected — add specific feature checks here]
- [ ] Responsive at 320 / 480 / 768 / 1024 / 1440px
- [ ] Landscape mode fits viewport
- [ ] Dark mode verified at OS level
- [ ] PageSpeed ≥ 95 (mobile and desktop)

### Claude's Checklist

- [ ] HTML validates — W3C validator (no errors, no warnings)
- [ ] All `<img>` have `alt`, `width`, `height`
- [ ] All `<input>` have an associated `<label for="…">`
- [ ] No `!important` in CSS
- [ ] No inline styles in HTML
- [ ] No `max-width` media queries (must be mobile-first `min-width`)
- [ ] `box-sizing: border-box` present in every stylesheet reset
- [ ] CSS custom properties used for all colours and spacing values
- [ ] `defer` on all `<script>` tags
- [ ] No console errors or warnings in browser devtools
- [ ] `prefers-color-scheme: dark` verified visually
- [ ] `prefers-reduced-motion: reduce` verified (animations pause/reduce)
- [ ] Schema.org JSON-LD present on each page
- [ ] Open Graph meta tags present on each page
- [ ] `rel="noopener noreferrer"` on all external links

---

## Common Commands

```bash
# Local dev server
npx live-server

# Validate HTML
npx html-validate index.html

# Show staged + unstaged diff before committing
git diff

# Show what would be committed
git diff --cached

# Stage specific files and commit
git add styles/theme.css styles/global.css
git commit -m "style(css): update brand colour tokens"
```

---

## Git Workflow

- **Branches:** `dev` for development work; `main` for production. Merge via PR.
- **Commit messages:** Conventional Commits — `type(scope): description`
  - Types: `feat` `fix` `style` `refactor` `docs` `perf` `test` `chore` `a11y` `seo`
  - Examples: `feat(nav): add mobile hamburger menu` · `fix(form): validate email on submit` · `style(css): update brand tokens`
- **Always `git diff` before committing** — review every change.
- **Stop and show `git diff` after each task** — confirm with user before proceeding.
- **`git push` requires explicit user confirmation** — push deploys immediately to production.
- Use the `git-commit-messaging` skill for all commit messages.
- `docs/plan/plan-rules.md` (gitignored, local-only) holds full session operating rules. Forks: copy in your own equivalent or use this scaffold's three-style heuristic (Hybrid / Fresh / Deep).

---

## Logging System

`js/logger.js` provides a structured development logger, kept entirely separate from application code.

```js
// Log a named event with optional data payload
Logger.log('section', 'message', { optional: 'data' });

// Time measurements
Logger.time('hero-image');       // start a named timer
Logger.timeEnd('hero-image');    // stop timer, log elapsed ms

// Inspect stored logs
Logger.dump();                   // print all session logs to console
Logger.clear();                  // clear sessionStorage log store
```

- Entries buffered in memory — no synchronous storage I/O on `log()` calls.
- On `beforeunload`, buffer is flushed to `sessionStorage`; a summary snapshot is written to `localStorage`.
- Logger is passive: never throws, never blocks execution.
- `Logger.flush()` — write buffer to sessionStorage immediately (e.g. before an expected crash).
- **Default test logs included:** localStorage availability, sessionStorage availability, hero image load time, script load times.
- Remove `<script src="js/logger.js">` from HTML before production if not required.
