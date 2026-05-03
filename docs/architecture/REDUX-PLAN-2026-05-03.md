# Architecture Redux Plan — 2026-05-03

> **🔵 Blue-hat planning document.** Senior-architect survey of `hardy-succulents/docs/architecture` against `white-hat-label/docs/architecture`. Captures the maturation patterns observed in hardy-succulents and proposes a 5-phase redux for white-hat-label. Each phase is independently committable; the redux can pause and resume.

---

## Why a redux

White-hat-label's `docs/architecture/` was the original scaffold. Hardy-succulents has since evolved that scaffold through real production use (Headless Shopify storefront) and surfaced five maturation patterns the boilerplate is missing. The redux ports those patterns back as **templates**, so future forks inherit a more sophisticated foundation.

Crucially, hardy-succulents' state-of-play index is project-specific (Shopify, Vercel, Sanity); for a *boilerplate*, the same structure becomes a **fill-in-the-blanks template** that fork projects populate as they accrue context.

---

## Comparative survey — what each repo has

```
hardy-succulents/docs/architecture/                white-hat-label/docs/architecture/
├── ARCHITECTURE.md                                ├── ARCHITECTURE.md
├── ARCHITECTURE_EXTENSION.md                      ├── ARCHITECTURE_EXTENSION.md
├── BREAKTHROUGHS.md                               ├── BREAKTHROUGHS.md
├── CHECKPOINTS.md                                 ├── CHECKPOINTS.md
├── CLAUDE_ARCHITECTURE.md                         ├── CLAUDE_ARCHITECTURE.md
├── 🆕 CLAUDE_MAINDOCS_INDEX.md ←── live state      ├── (missing)
├── CODEBASE-AUDIT.md                              ├── CODEBASE-AUDIT.md
├── CORE_PATTERNS.md                               ├── CORE_PATTERNS.md
├── DECISIONS.md                                   ├── DECISIONS.md
├── FE-VISUALISATION.md                            ├── FE-VISUALISATION.md
├── FEEDBACK-LOOPS.md                              ├── FEEDBACK-LOOPS.md
├── REFLECTIVE-SYNC.md                             ├── REFLECTIVE-SYNC.md
├── SYSTEM.md                                      ├── SYSTEM.md
├── six-hats.md                                    ├── six-hats.md
├── 🆕 audit-2026-04-28/                            ├── (missing)
│   ├── 1.1-connections.md                         ├──
│   ├── 1.1b-shopify-app-mismatch.md               ├──
│   ├── 1.2-tailwind-globals.md                    ├──
│   ├── ...12 chunks total                          ├──
└── template-examples/                             └── template-examples/
    ├── GEMINI-CONSULTANCY.md                          ├── GEMINI-CONSULTANCY.md
    ├── SERVERSIDE.md                                  ├── SERVERSIDE.md
    └── STANDARDS.md                                   ├── STANDARDS.md
                                                       └── handoff_template.md  ←── doesn't exist in HS
                                                  (no qref/ directory)

hardy-succulents/qref/  ←── 10 quick-ref files     white-hat-label has no qref/ at all
```

The five gaps:

1. **`CLAUDE_MAINDOCS_INDEX.md`** — single-source-of-truth state-of-play, loaded at session start. Combines project metadata + quick-reference table + key decisions + file structure + design tokens + env vars + common commands + **"Changes Since Training Data"** + known constraints + phase status + settings of play + entry prompt.
2. **`qref/` directory** — surgical quick-reference files for AI-trap traps that need depth (e.g., Turbopack constraints, Shopify scopes, Edge runtime imports). Linked from MAINDOCS_INDEX.
3. **Chunked audit pattern** (`audit-YYYY-MM-DD/`) — periodic structured audit broken into 8–15 focused chunks. Each chunk addresses one concern; results inform `FEEDBACK-LOOPS.md` and `DECISIONS.md`.
4. **"Changes Since Training Data"** section — flags vendor / framework / API behaviour that has changed since Claude's training cutoff. Critical for any project using fast-moving SaaS APIs.
5. **Phase Status / Settings — Current State of Play** — lightweight kanban-in-prose, kept current. Every session reads it; sessions update it before writing the handoff.

---

## Proposed redux — 5 phases

### Phase A — Foundation (template files, no deletion)

**Goal:** Add the missing template files. No existing doc gets removed; redux is purely additive in this phase.

| File | Source | Status template |
|---|---|---|
| `docs/architecture/CLAUDE_MAINDOCS_INDEX.md` | Template adapted from hardy-succulents | All sections marked `[FILL PER PROJECT]` placeholders |
| `docs/architecture/qref/README.md` | New | Explains qref pattern, naming convention (`qr-<topic>.md`), when to add one |
| `docs/architecture/qref/qr-public-repo-hygiene.md` | New (white-hat-label specific) | First worked example: entire.io skip-push, branch protection, secret-scanning push-protection (mirrors `docs/security-sweep-playbook.md` but at qref grain) |
| `docs/architecture/qref/qr-static-site-cls.md` | New | Image dimensions, font loading, defer scripts — the CLS-killer trio |
| `docs/architecture/qref/qr-claude-code-hooks.md` | New | Env-var-driven hook paths (lessons from this session), how to add new hooks |
| `docs/architecture/template-examples/audit-template/README.md` | New | Audit chunk structure, naming, output format |
| `docs/architecture/template-examples/audit-template/1-structure.md` | New | Sample chunk: project structure audit |
| `docs/architecture/template-examples/audit-template/2-conventions.md` | New | Sample chunk: convention conformance audit |

**Commit:** `feat(architecture): add MAINDOCS_INDEX template + qref/ + audit-template`

---

### Phase B — Update existing 12 docs (integration)

**Goal:** Cross-reference new templates from existing docs; add this session's findings as concrete examples.

| File | Update |
|---|---|
| `ARCHITECTURE.md` | Add MAINDOCS_INDEX as the new "Loaded at every session start" entry. Existing content unchanged. |
| `CLAUDE_ARCHITECTURE.md` | Update reading order: MAINDOCS_INDEX → ARCHITECTURE → CORE_PATTERNS → others. Hybrid / Fresh / Deep session styles each reference the new index. |
| `CORE_PATTERNS.md` | Add **G14: Env-var-driven hook paths** (no hardcoded `/Users/<name>/...` in tracked scripts) and **G15: Gitignore session-tracker artefacts** (`.entire/`, `.aider/`, `.cursor/`-derived) — both born from this session's work. |
| `FEEDBACK-LOOPS.md` | New entry: "entire.io session-tracker leak — what we learned about public-repo hygiene." Wins / limits / rules. |
| `DECISIONS.md` | New ADRs: ADR-XXX adopt 2-phase security playbook; ADR-XXX branch protection on `main`; ADR-XXX `--skip-push-sessions` for any AI session-tracker on a public repo. |
| `BREAKTHROUGHS.md` | New entry: "entire.io session-tracker leak diagnosis" — root cause (hooks + auto-push), symptoms (public `entire/checkpoints/v1` branch), fix sequence (filter-repo + skip-push + branch protection). |
| `REFLECTIVE-SYNC.md` | New prompt option: **"Security Sync"** — runs Phase 0 of the playbook before any major release. |
| `CODEBASE-AUDIT.md` | Cross-ref `template-examples/audit-template/` for the chunked-audit pattern. |
| `CHECKPOINTS.md` | Add **Trigger 10: Security-relevant change** (any commit touching `.gitignore`, `.claude/hooks/`, `settings.json`, secrets handling) — mid-session checkpoint. |
| `FE-VISUALISATION.md` | No change — already current. |
| `ARCHITECTURE_EXTENSION.md` | Add a "Coding Conventions for Hooks" subsection (env-var paths, exit codes, never block). |
| `SYSTEM.md` | Add reference to MAINDOCS_INDEX as the live-state file (template, fill in per fork). |

**Commit:** `docs(architecture): integrate MAINDOCS_INDEX + capture this session's lessons across CORE_PATTERNS / DECISIONS / BREAKTHROUGHS / FEEDBACK-LOOPS`

---

### Phase C — `template-examples/` polish

**Goal:** The `template-examples/` directory should now have three categories: consultation (Gemini), infrastructure (serverside), and **process** (audit-template). Add fourth: a **Phase Status template** showing how to track project milestones.

| File | Change |
|---|---|
| `template-examples/PHASE-STATUS.md` | New — table format from hardy-succulents Phase Status, with placeholders. |
| `template-examples/STATE-OF-PLAY.md` | New — "Settings — Current State of Play" template (production runtime, env vars table, long-running flags, open phase work, pre-launch checklist, entry prompt for next session). Mirrors hardy-succulents §317 onwards. |
| `template-examples/STANDARDS.md` | Existing — minor update: cross-ref MAINDOCS_INDEX. |
| `template-examples/SERVERSIDE.md` | Existing — minor update: add Vercel section if missing. |
| `template-examples/GEMINI-CONSULTANCY.md` | Existing — promote in reading order; cross-ref from REFLECTIVE-SYNC and CHECKPOINTS. |
| `template-examples/handoff_template.md` | Existing — already the handoff template; cross-ref from CLAUDE_ARCHITECTURE.md reading order. |

**Commit:** `feat(architecture): add PHASE-STATUS + STATE-OF-PLAY templates`

---

### Phase D — Validate by simulating a fresh session

**Goal:** Ensure the new structure is actually loadable and useful.

1. Run a fresh Claude Code session against the redux'd repo with the entry prompt from `CLAUDE_ARCHITECTURE.md`.
2. Verify Claude:
   - Loads MAINDOCS_INDEX first
   - Can answer "what are the project's known constraints?" without re-reading files
   - Picks up the qref directory and knows when to consult one
   - Understands the audit-template structure
3. If anything is unclear or missing, update the relevant doc and commit a follow-up.

**Commit (if needed):** `docs(architecture): clarify reading-order ambiguity surfaced in fresh-session test`

---

### Phase E — Update CLAUDE.md + README.md + index.html for new architecture

**Goal:** Surface the new architecture in the project's outward-facing docs.

| File | Change |
|---|---|
| `CLAUDE.md` | Update `File Structure` section to show `qref/`, `audit-*/`, MAINDOCS_INDEX. Update reading order. |
| `README.md` | Add a "What's Included" entry for the new patterns. |
| `index.html` | Plan System section: add a "Quick References" card pointing at `qref/`. |

**Commit:** `docs: surface MAINDOCS_INDEX + qref + audit pattern in user-facing docs`

---

## Risks & mitigations

| Risk | Mitigation |
|---|---|
| Existing 12 docs feel "doubled up" with MAINDOCS_INDEX | MAINDOCS_INDEX is **state**; the 12 docs are **rules + history**. Different concerns. Make the distinction explicit at the top of MAINDOCS_INDEX. |
| Forks inherit a complex structure they don't need | Phase A's MAINDOCS_INDEX is a TEMPLATE — every section starts as `[FILL PER PROJECT]`. Forks delete sections that don't apply rather than fill in. |
| qref/ becomes a graveyard | Only add a qref when a topic genuinely needs surgical depth (rule of thumb: ≥ 200 words, ≥ 1 worked failure case). Keep `qref/README.md` strict on this. |
| Audit-template feels bureaucratic for small projects | Audits are optional — skip Phase D's audit-template adoption for tiny projects. The pattern exists for projects that grow past ~5 conventions. |
| The redux itself causes context bloat in sessions | Hybrid sessions only load MAINDOCS_INDEX + ARCHITECTURE + handoff — total ~15-20K tokens. Deep sessions can load more. The 12 detailed docs stay reference-grade, not session-load. |

---

## What this redux is NOT

- **Not a rewrite.** Existing docs stay; new ones are added; integration touches headers and cross-refs only.
- **Not a content-fill exercise.** Templates stay as `[FILL PER PROJECT]`. Forks fill in their own.
- **Not a one-session job.** Phase A alone is meaningful; subsequent phases can land separately.
- **Not infrastructure-specific.** This redux applies whether the fork is a static site, Next.js app, React Native app, or Shopify storefront.

---

## Estimated effort

| Phase | Effort | Dependencies |
|---|---|---|
| A — Foundation | 90–120 min | None |
| B — Integration | 60–90 min | A complete |
| C — template-examples polish | 30–45 min | None (parallelisable with B) |
| D — Fresh-session validation | 30 min | A + B + C complete |
| E — Outward-facing docs | 30 min | A complete (can interleave with later phases) |
| **Total** | **~4–5 hours of focused session time** | |

Single session can handle A + start of B. Two sessions safer. Three sessions comfortable.

---

## Suggested entry prompt for next session

```
Read docs/architecture/REDUX-PLAN-2026-05-03.md and the latest handoff
in docs/plan/. Continue the architecture redux at Phase A. The plan is
additive — no existing docs are deleted; new template files are added
(CLAUDE_MAINDOCS_INDEX.md, qref/, audit-template/). Show the proposed
structure for one new file, get sign-off, then proceed file-by-file.
Stop after Phase A and commit; B onwards is a separate session.
```

---

## Closing note (this session — 2026-05-03)

This plan was authored at the end of a security-sweep session that closed an `entire.io` session-tracker leak, stripped `docs/plan/` from history, hardened settings, added branch protection, and committed playbook + Phase 1 deliverable docs. The redux extends that work — security hardening surfaced the real-world maturation of hardy-succulents' architecture, which is now ready to flow back into the boilerplate.

Author: Claude (Opus 4.7) under the senior-architect / blue-hat thinking style. Approved-as-plan by Mat for Phase A execution next session.
