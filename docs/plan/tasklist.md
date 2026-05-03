# [PROJECT_NAME] — Task Register

Canonical task list. All tasks live here — open and completed. Never delete; mark done instead.
Last updated: YYYY-MM-DD

---

## Active Tasks

### Feature Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| F1 | [Task description] | FEAT | ⚠️ TODO | [Notes, constraints, spec reference] |

---

### Style Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| S1 | [Task description] | STYLE | ⚠️ TODO | [Notes] |

---

### HTML / Accessibility Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| H1 | W3C validation pass | HTML | ⚠️ TODO | Run `npx html-validate` on all HTML files before any deploy. |
| A1 | [Accessibility task] | A11Y | ⚠️ TODO | [Notes] |

---

### Architecture Quality Gates

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| ARC1 | Contradiction Hunt | DOCS | ⚠️ Pre-major-change | Feed all L1/L2 architecture docs to Gemini Pro. Top 5 internal contradictions. See `six-hats.md §Contradiction Hunt`. |
| ARC2 | Recursive Architecture Test | DOCS | ⚠️ Pre-major-change | Feed ARCHITECTURE.md + SYSTEM.md to a fresh model. Compare response to actual code — divergences = doc debt. See `template-examples/GEMINI-CONSULTANCY.md` Pattern 5. |
| ARC3 | Full codebase audit | DOCS | ⚠️ Periodic | Run `CODEBASE-AUDIT.md` chunk strategy. Each chunk audited against G1–G15. |
| ARC4 | Drift Check | DOCS | ⚠️ Periodic | Load ARCHITECTURE.md + CORE_PATTERNS.md, then read key source files. Flag divergences between what docs describe and what code actually does. See `docs/architecture/REFLECTIVE-SYNC.md §Drift Check`. |

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
| — | — | — | — | — |

---

## Task Status Key

| Symbol | Meaning |
|--------|---------|
| ⚠️ TODO | Not started |
| 🔲 Untested | Implemented but not yet confirmed in browser |
| ✅ Done YYYY-MM-DD | Completed and verified |
| ⛔ Blocked | Cannot proceed — see notes |
| ⏸️ Deferred | Intentionally postponed |
| ~~Struck through~~ | Abandoned — reason in notes |
