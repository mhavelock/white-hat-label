# [PROJECT_NAME] — Task Register

Canonical task list. All tasks live here — open and completed. Never delete; mark done instead.
Last updated: [YYYY-MM-DD]

---

## Active Tasks

### Feature Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| F1 | [Task description] | FEAT | ⚠️ TODO | [Notes] |

### Style Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| S1 | [Task description] | STYLE | ⚠️ TODO | [Notes] |

### HTML Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| H1 | W3C validation pass | HTML | ⚠️ TODO | Run `npx html-validate` on all HTML files. Must be clean before any deploy. |

### Architecture Quality Gates

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| ARC1 | Contradiction Hunt | DOCS | ⚠️ Pre-major-change | Feed all L1/L2 architecture docs to Gemini Pro. Ask for top 5 internal contradictions. See `REFLECTIVE-SYNC.md §Architecture Sync`. |
| ARC2 | Drift Check | DOCS | ⚠️ Periodic | Check docs still match code. See `REFLECTIVE-SYNC.md §Drift Check`. |
| ARC3 | Full codebase audit | DOCS | ⚠️ Periodic | Run `CODEBASE-AUDIT.md` chunk strategy. Each chunk audited against G1–G13. |

### Testing / QA Tasks

| # | Task | Type | Status | Notes |
|---|------|------|--------|-------|
| T1 | PageSpeed audit — mobile + desktop | USER | ⚠️ After any JS/CSS change | Target ≥ 95. |
| T2 | Responsive test — 320 / 480 / 768 / 1024 / 1440px | USER | ⚠️ After layout changes | Check each breakpoint manually. |
| T3 | Dark mode verification | USER | ⚠️ After any CSS change | Verify at OS system preference level. |
| T4 | Keyboard navigation test | USER | ⚠️ After any HTML/JS change | Tab through all interactive elements. |

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
| 🔄 In progress | Currently being worked on |
| ✅ Done [date] | Completed |
| ❌ Blocked | Cannot proceed — reason in notes |
| ⏸️ Deferred | Intentionally postponed |
