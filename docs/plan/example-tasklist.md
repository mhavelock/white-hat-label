# [PROJECT_NAME] — Task Register (Example)

> **This is an example tasklist** showing what two completed build sessions look like.
> Copy `tasklist.md` to start your own project. This file is for reference only.

Canonical task list. All tasks live here — open and completed. Never delete; mark done instead.
Last updated: 2026-04-06

---

## Active Tasks

### Testing / QA Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| T1 | PageSpeed audit — mobile + desktop | USER | ⚠️ TODO | Target ≥ 95. Run after first deploy. |
| T2 | Full manual test checklist | USER | ⚠️ TODO | Responsive, dark mode, keyboard, landscape. See `CLAUDE.md §Test Programme`. |
| T3 | W3C validation pass | USER | ⚠️ TODO | `npx html-validate index.html` — must pass with no errors. |

---

### Architecture Quality Gates

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| ARC1 | Contradiction Hunt | DOCS | ⚠️ Pre-major-change | Feed all L1/L2 architecture docs to Gemini Pro. Top 5 internal contradictions. See `six-hats.md §Contradiction Hunt`. |
| ARC2 | Recursive Architecture Test | DOCS | ⚠️ Pre-major-change | Feed ARCHITECTURE.md + SYSTEM.md to a fresh model. Compare response to actual code — divergences = doc debt. |
| ARC3 | Full codebase audit | DOCS | ⚠️ Periodic | Run `CODEBASE-AUDIT.md` chunk strategy. Each chunk audited against G1–G13. |

---

## Completed Tasks

| # | Task | Type | Completed | Notes |
|---|------|------|-----------|-------|
| SETUP-01 | Create `docs/ARCHITECTURE.md` | DOCS | ✅ Done 2026-04-06 | Generic architecture template with [PROJECT_NAME] placeholders |
| SETUP-02 | Create `docs/SYSTEM.md` | DOCS | ✅ Done 2026-04-06 | Developer rules: naming conventions, file organisation, CSS/JS/HTML rules |
| SETUP-03 | Create `docs/architecture/CORE_PATTERNS.md` | DOCS | ✅ Done 2026-04-06 | G1–G13 generic constraints, code patterns with correct/wrong examples |
| SETUP-04 | Create `docs/architecture/DECISIONS.md` | DOCS | ✅ Done 2026-04-06 | ADR template with ADR-001 to ADR-003 as examples |
| SETUP-05 | Create `docs/architecture/FEEDBACK-LOOPS.md` | DOCS | ✅ Done 2026-04-06 | FL-01 to FL-09 feedback loop template |
| SETUP-06 | Create `docs/architecture/BREAKTHROUGHS.md` | DOCS | ✅ Done 2026-04-06 | B-01/B-02 placeholders + worked generic example |
| SETUP-07 | Create `docs/architecture/ARCHITECTURE_EXTENSION.md` | DOCS | ✅ Done 2026-04-06 | CSS/JS conventions detail, design tokens, common pitfalls, Schema.org reference |
| SETUP-08 | Create `docs/architecture/CODEBASE-AUDIT.md` | DOCS | ✅ Done 2026-04-06 | Audit chunks A1–A5, G1–G13 check table, standard audit prompt |
| SETUP-09 | Create `docs/architecture/REFLECTIVE-SYNC.md` | DOCS | ✅ Done 2026-04-06 | Session start/mid/end prompts, architecture sync prompts |
| SETUP-10 | Create `docs/architecture/CLAUDE_ARCHITECTURE.md` | DOCS | ✅ Done 2026-04-06 | Document hierarchy L1/L2/L3, reading order, entry prompts |
| SETUP-11 | Create `docs/architecture/CHECKPOINTS.md` | DOCS | ✅ Done 2026-04-06 | Trigger table, mini-checkpoint format, Log Awareness section |
| SETUP-12 | Create `docs/architecture/FE-VISUALISATION.md` | DOCS | ✅ Done 2026-04-06 | Tool decision tree, viewport testing matrix, tool reference |
| SETUP-13 | Create `docs/architecture/six-hats.md` | DOCS | ✅ Done 2026-04-06 | Six Hats model, inversion, anchoring prompts — all genericised |
| SETUP-14 | Create `docs/architecture/template-examples/GEMINI-CONSULTANCY.md` | DOCS | ✅ Done 2026-04-06 | 7 Gemini consultation patterns, payload assembly guide |
| SETUP-15 | Create `docs/architecture/template-examples/SERVERSIDE.md` | DOCS | ✅ Done 2026-04-06 | Server-side architecture template — all values placeholder |
| SETUP-16 | Create `docs/architecture/template-examples/STANDARDS.md` | DOCS | ✅ Done 2026-04-06 | Quality standards table — all status values ⚠️ TBA |
| SETUP-17 | Create `CLAUDE.md` | DOCS | ✅ Done 2026-04-06 | White-label Claude Code instructions skeleton |
| SETUP-18 | Create `README.md` | DOCS | ✅ Done 2026-04-06 | Initial public-facing readme |
| SETUP-19 | Create `docs/plan/plan-rules.md` | DOCS | ✅ Done 2026-04-06 | 8-rule session management system |
| SETUP-20 | Create `docs/plan/tasklist.md` | DOCS | ✅ Done 2026-04-06 | Blank task register template |
| SETUP-21 | Create `docs/plan/handoff_template.md` | DOCS | ✅ Done 2026-04-06 | Full handoff template with both checklists |
| SETUP-22 | Create `docs/plan/example-tasklist.md` | DOCS | ✅ Done 2026-04-06 | This file |
| SETUP-23 | Create `docs/plan/example-handoff_2026-04-06.md` | DOCS | ✅ Done 2026-04-06 | Example handoff for session 1 |
| BUILD-01 | Expand README.md | DOCS | ✅ Done 2026-04-06 | Added architecture system, guardrails, plan system, objectives from setup.txt |
| BUILD-02 | Create `index.html` | FEAT | ✅ Done 2026-04-06 | Homepage: hero, accordion sections, guardrails cards, plan system table, stack modal, get-started steps, UI component showcase |
| BUILD-03 | Create `css/global.css` | STYLE | ✅ Done 2026-04-06 | Design tokens, reset, base elements, typography, layout; imports grid, utilities, global-xtra |
| BUILD-04 | Create `css/theme.css` | STYLE | ✅ Done 2026-04-06 | Fredoka font, light/dark tokens, fluid headings, glassmorphism nav; imports svg-variables, contact-form |
| BUILD-05 | Create `css/desktop.css` | STYLE | ✅ Done 2026-04-06 | Desktop layout overrides — loaded conditionally at min-width: 768px |
| BUILD-06 | Create `css/grid.css` | STYLE | ✅ Done 2026-04-06 | 12-col flex grid + 1x2, 1x3, 1x4 component grids |
| BUILD-07 | Create `css/utilities.css` | STYLE | ✅ Done 2026-04-06 | sr-only, skip link, display, text, spacing, flex helpers, dividers |
| BUILD-08 | Create `css/global-xtra.css` | STYLE | ✅ Done 2026-04-06 | Buttons, forms, alerts, tooltips, modal/dialog, icons, accordion, header, footer |
| BUILD-09 | Create `css/svg-variables.css` | STYLE | ✅ Done 2026-04-06 | SVG custom properties (chevron-down, external link) |
| BUILD-10 | Copy favicon assets | FEAT | ✅ Done 2026-04-06 | favicon.svg/ico/png, apple-touch-icon, web-app-manifest, site.webmanifest |
| BUILD-11 | Create `css/contact-form.css` | STYLE | ✅ Done 2026-04-06 | Neumorphic contact card (mobile) + horizontal pill bar (desktop); dark mode; Bluesky flutter animation; sent :target flash |
| BUILD-12 | Add contact form section to `index.html` | FEAT | ✅ Done 2026-04-06 | Form with name/email/message, Bluesky icon, options line; action is a placeholder |
| BUILD-13 | Add Bluesky flutter icon to footer | FEAT | ✅ Done 2026-04-06 | SVG butterfly icon in footer nav; separate `<defs>` id to avoid conflict with contact section |
| BUILD-14 | Create `js/logger.js` | FEAT | ✅ Done 2026-04-06 | Buffered dev logger: log/time/timeEnd/flush/dump/clear; self-test: storage, nav timing, hero image load, script exec time |
| BUILD-15 | Set Bluesky links to anthropicprinciple.ai | FIX | ✅ Done 2026-04-06 | All three Bluesky hrefs updated to bsky.app/profile/anthropicprinciple.ai |

---

## Task Status Key

| Symbol | Meaning |
|--------|---------|
| ⚠️ TODO | Not started |
| 🔲 Untested | Implemented but not yet confirmed in browser |
| ✅ Done YYYY-MM-DD | Completed and verified |
| ⛔ Blocked | Cannot proceed — see notes |
| ~~Struck through~~ | Abandoned — reason in notes |
