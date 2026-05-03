# [PROJECT_NAME] — Project Main Settings

> **Live state-of-play. Loaded at every session start.**
>
> The 12 architecture docs in `docs/architecture/` are *rules + history* — slow to change, reference-grade. **This file is *current state*** — it changes session-to-session as the project evolves. Different concerns. Don't merge them.
>
> Forks: every section starts `[FILL PER PROJECT]`. Delete what doesn't apply rather than leaving placeholder prose. Keep the order; future sessions rely on it.

---

## Project

- **Name:** [FILL PER PROJECT]
- **Type:** [FILL PER PROJECT — one-line description: "static portfolio site", "headless Shopify storefront", "iOS app", etc.]
- **Repo:** [FILL PER PROJECT — GitHub/GitLab URL · branch → deploy target]
- **Domain:** [FILL PER PROJECT — live URL, or "not deployed"]
- **Stack:** [FILL PER PROJECT — layered tech list, e.g. "HTML5 / CSS3 / vanilla JS / GitHub Pages"]
- **Local dev:** [FILL PER PROJECT — command + URL, e.g. `npx live-server` → `http://127.0.0.1:5500`]

---

## Quick Reference

> Detailed quick-reference files live in `qref/`. Use them when a topic needs surgical depth (rule of thumb: ≥ 200 words and ≥ 1 worked failure case). Summaries below are intentionally terse — link out for the full version.

| File | Topic |
|---|---|
| `qref/qr-public-repo-hygiene.md` | entire.io session-tracker leak prevention; `--skip-push-sessions`; branch protection; secret-scanning push protection |
| `qref/qr-static-site-cls.md` | Cumulative Layout Shift killers — image `width`/`height`, font loading, `defer` scripts, `aspect-ratio` containers |
| `qref/qr-claude-code-hooks.md` | Env-var-driven hook paths (`$COWORK_LOG_DIR`, `$COWORK_BACKUP_DIR`); exit codes; never-block rule |
| [FILL PER PROJECT] | [add new entries as the fork accrues traps that need depth] |

---

## Key Architecture Decisions

> Bullet list of the constraints that shaped this codebase. Why the project looks the way it does. Not the full ADR register — that's `DECISIONS.md`. This is the headline.

- [FILL PER PROJECT — e.g. "No build step; pure HTML/CSS/JS"]
- [FILL PER PROJECT — e.g. "Mobile-first; `min-width` media queries only"]
- [FILL PER PROJECT — e.g. "CSS custom properties for every colour, spacing, timing value"]
- [FILL PER PROJECT — e.g. "Progressive enhancement; core content works without JS"]

---

## Known Constraints

> The "do-not-trip" list. Anything that has bitten us before, anything a vendor surprises us with, anything Claude is likely to assume wrongly. Append every session — this is the costliest section to lose.

- [FILL PER PROJECT — e.g. "Tailwind v4 scans `docs/`; add `@source not '../docs/**'` to globals to prevent arbitrary classes"]
- [FILL PER PROJECT — e.g. "GitHub Pages serves `index.html` for unmatched routes; client-side routing must handle 404 fallback"]

---

## Changes Since Training Data

> **IMPORTANT — check this section before planning vendor / API work.** Flags behaviour that has changed since Claude's training cutoff. Empty for greenfield static sites; populate as the fork integrates fast-moving SaaS APIs.

- [FILL PER PROJECT — e.g. "Vendor X renamed `oldEndpoint` → `newEndpoint` on 2026-MM-DD"]
- [FILL PER PROJECT — e.g. "Framework Y deprecated `middleware.ts` in favour of `proxy.ts` from version 15.6"]

---

## File Structure (key paths)

> Annotated bullets, not the full tree. The full tree lives in `CLAUDE.md`. List only the paths a session needs to land at quickly.

- [FILL PER PROJECT — e.g. `styles/theme.css` — design tokens, single source of truth]
- [FILL PER PROJECT — e.g. `js/main.js` — entry point, IIFE module pattern]
- [FILL PER PROJECT — e.g. `docs/security-sweep-playbook.md` — two-phase security playbook, run before going public]

---

## Design Tokens

> Tokens live in `styles/theme.css` (or equivalent for the stack). Listed here for fast reference; never hardcode values in component CSS.

- [FILL PER PROJECT — e.g. `--color-bg`, `--color-bg-alt`, `--color-text`, `--color-text-muted`]
- [FILL PER PROJECT — e.g. `--space-xs` `0.25rem` → `--space-3xl` `4rem`]
- [FILL PER PROJECT — e.g. Breakpoints: `sm: 480px`, `md: 768px`, `lg: 1024px`, `xl: 1280px`, `2xl: 1440px` (mobile-first, `min-width` only)]

---

## Environment Variables

> All vars live in `.env.local` locally. Never commit `.env*` files — they're gitignored. Update this table when adding/rotating a var.

| Variable | Local | Prod | Source |
|---|---|---|---|
| [FILL PER PROJECT] | | | |

**Credentials inventory** (where to find each secret):

- [FILL PER PROJECT — e.g. "Vendor X API key: dashboard.vendor.com → Settings → API → Keys"]

---

## Common Commands

```bash
# [FILL PER PROJECT — the 5–10 commands a session actually runs]
# e.g.
# npx live-server           # local dev
# npx html-validate *.html  # HTML validation
# git diff                  # review before commit
```

---

## Coding Conventions

> Short bullets. Long-form lives in `SYSTEM.md` and `ARCHITECTURE_EXTENSION.md`. This is the in-session reference.

- [FILL PER PROJECT — e.g. "Conventional Commits: `type(scope): description`"]
- [FILL PER PROJECT — e.g. "Component class pattern: `.component`, `.component-element`, `.mod-variant`, `.is-state`, `.js-hook`, `.u-utility`"]
- [FILL PER PROJECT — e.g. "Alphabetical CSS properties within each rule block"]
- [FILL PER PROJECT — e.g. "`:focus-visible` not `:focus` — keyboard focus only"]

---

## Phase Status

> Lightweight kanban-in-prose. Update before writing the session handoff.

| Phase | Status |
|---|---|
| [FILL PER PROJECT — e.g. "0 — Scaffold"] | [FILL PER PROJECT — e.g. "✅ Complete"] |
| [FILL PER PROJECT — e.g. "1 — Content"] | [FILL PER PROJECT — e.g. "🔄 In progress"] |
| [FILL PER PROJECT — e.g. "Final — Audit + launch"] | [FILL PER PROJECT — e.g. "⚠️ TODO"] |

---

## Settings — Current State of Play ([DATE])

### Production runtime

- [FILL PER PROJECT — e.g. "Public site: https://example.com — live on GitHub Pages, builds green"]
- [FILL PER PROJECT — e.g. "Render mode: static; no server runtime"]

### Long-running flags

| Flag | State | Notes |
|---|---|---|
| [FILL PER PROJECT] | | |

### Open work

- [FILL PER PROJECT — sequential, blocking items]

### Pre-launch checklist

- [FILL PER PROJECT — orthogonal, must-be-done-before-launch items]

### Entry prompt for next session

```
[FILL PER PROJECT — the verbatim prompt to paste into the next session;
 should reference the latest handoff and this file's "Settings" section]
```
