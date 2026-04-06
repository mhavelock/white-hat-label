# [PROJECT_NAME] — Task Register (Example)

> **This is an example tasklist** showing what a completed setup session looks like.
> Copy `tasklist.md` to start your own project. This file is for reference only.

Canonical task list. All tasks live here — open and completed. Never delete; mark done instead.
Last updated: 2026-04-06

---

## Active Tasks

### Feature Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| F1 | Build index.html — first page | FEAT | ⚠️ TODO | Implement the project's main page per ARCHITECTURE.md §Content Summary |

---

### Style Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| S1 | Populate CSS design tokens | STYLE | ⚠️ TODO | Fill brand colours, spacing scale, and typography into `styles/theme.css` |

---

### HTML / Accessibility Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| H1 | W3C validation pass | HTML | ⚠️ TODO | Run `npx html-validate` on all HTML files before any deploy. |

---

### Architecture Quality Gates

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| ARC1 | Contradiction Hunt | DOCS | ⚠️ Pre-major-change | Feed all L1/L2 architecture docs to Gemini Pro. Top 5 internal contradictions. See `six-hats.md §Contradiction Hunt`. |
| ARC2 | Recursive Architecture Test | DOCS | ⚠️ Pre-major-change | Feed ARCHITECTURE.md + SYSTEM.md to a fresh model. Compare response to actual code — divergences = doc debt. See `template-examples/GEMINI-CONSULTANCY.md` Pattern 5. |
| ARC3 | Full codebase audit | DOCS | ⚠️ Periodic | Run `CODEBASE-AUDIT.md` chunk strategy. Each chunk audited against G1–G13. |

---

### Testing / QA Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| T1 | PageSpeed audit — mobile + desktop | USER | ⚠️ After any JS/CSS change | Target ≥ 95. |
| T2 | Full manual test checklist | USER | ⚠️ After significant changes | Responsive, dark mode, keyboard, landscape. See `CLAUDE.md §Test Programme`. |
| T3 | W3C validation pass | USER | ⚠️ After any HTML change | `npx html-validate [files]` — must pass with no errors. |

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
| SETUP-18 | Create `README.md` | DOCS | ✅ Done 2026-04-06 | Public-facing project readme with repo structure |
| SETUP-19 | Create `docs/plan/plan-rules.md` | DOCS | ✅ Done 2026-04-06 | 8-rule session management system |
| SETUP-20 | Create `docs/plan/tasklist.md` | DOCS | ✅ Done 2026-04-06 | Blank task register template |
| SETUP-21 | Create `docs/plan/handoff_template.md` | DOCS | ✅ Done 2026-04-06 | Full handoff template with both checklists |
| SETUP-22 | Create `docs/plan/example-tasklist.md` | DOCS | ✅ Done 2026-04-06 | This file — example tasklist for the setup session |
| SETUP-23 | Create `docs/plan/example-handoff_2026-04-06.md` | DOCS | ✅ Done 2026-04-06 | Example handoff for the setup session |

---

## Task Status Key

| Symbol | Meaning |
|--------|---------|
| ⚠️ TODO | Not started |
| 🔲 Untested | Implemented but not yet confirmed in browser |
| ✅ Done YYYY-MM-DD | Completed and verified |
| ⛔ Blocked | Cannot proceed — see notes |
| ~~Struck through~~ | Abandoned — reason in notes |
