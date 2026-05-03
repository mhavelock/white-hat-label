# How to Use the Architecture Docs — [PROJECT_NAME]

A quick guide to what each architecture document is for and when to load it.

---

## The Document Hierarchy

```
docs/
├── ARCHITECTURE.md                     # L1 — What the project is; structural decisions; never-do rules
├── SYSTEM.md                           # L1 — Developer rules; naming conventions; HTML/CSS/JS standards
└── architecture/
    ├── CLAUDE_MAINDOCS_INDEX.md        # L1 — Live state-of-play; loaded at every session start
    ├── CORE_PATTERNS.md                # L1 — G1–G15 constraints; pattern reference; regression checklist
    ├── DECISIONS.md                    # L2 — ADR register — why each key decision was made
    ├── FEEDBACK-LOOPS.md               # L2 — Wins, limits, hard rules from project history
    ├── BREAKTHROUGHS.md                # L2 — Root-cause records; non-obvious lessons
    ├── ARCHITECTURE_EXTENSION.md       # L2 — Coding standards detail; token reference; pitfalls
    ├── CODEBASE-AUDIT.md               # L3 — Audit approach, chunks, and guidelines
    ├── REFLECTIVE-SYNC.md              # L3 — Session prompts for sync and drift prevention
    ├── qref/                           # L2 — Quick-reference files for surgical traps
    └── template-examples/              # L3 — Templates for handoffs, audits, infra docs
```

**L1 — Always load for any code session.** Four files: `CLAUDE_MAINDOCS_INDEX.md` (current state), `ARCHITECTURE.md` (rules + structure), `SYSTEM.md` (developer rules), `CORE_PATTERNS.md` (constraint checklist). The MAINDOCS_INDEX is the live state — read it first; it points to anything else the current session needs.

**L2 — Load when relevant.** DECISIONS.md when making choices with precedent. FEEDBACK-LOOPS.md when a pattern feels uncertain. BREAKTHROUGHS.md when diagnosing a hard problem. ARCHITECTURE_EXTENSION.md for coding standards detail and token reference. `qref/<file>` when MAINDOCS_INDEX's Quick Reference table points to one for the topic at hand.

**L3 — Load for meta-work.** CODEBASE-AUDIT.md for running audits (cross-refs `template-examples/audit-template/`). REFLECTIVE-SYNC.md for session structure prompts. `template-examples/` for handoff and audit-chunk scaffolding.

---

## Reading Order for a New Session

1. `docs/plan/handoff_[latest].md` — what happened last session
2. `docs/plan/tasklist.md` — open tasks
3. `docs/architecture/CLAUDE_MAINDOCS_INDEX.md` — current state of play (live)
4. `docs/ARCHITECTURE.md` — project blueprint (rules + structure)
5. The specific file being worked on

For architecture or refactor sessions, also load:
6. `docs/SYSTEM.md` — developer rules
7. `docs/architecture/CORE_PATTERNS.md` — constraint checklist (G1–G15)

If MAINDOCS_INDEX's Quick Reference table points to a `qref/<file>` for the topic at hand, load that too.

---

## Entry Prompts

**Standard (default):**
```
Read docs/plan/handoff_[latest].md, docs/plan/tasklist.md,
docs/architecture/CLAUDE_MAINDOCS_INDEX.md, and docs/ARCHITECTURE.md.
The task is: [task description].
```

**Fresh read (no prior context):**
```
Read docs/architecture/CLAUDE_MAINDOCS_INDEX.md, docs/ARCHITECTURE.md,
and docs/architecture/CORE_PATTERNS.md.
The task is: [task description].
Do not read any handoffs or session history. Approach this as if you have never seen this code before.
```

**Deep (bug investigation):**
```
Read docs/plan/handoff_[latest].md, docs/plan/tasklist.md,
docs/architecture/CLAUDE_MAINDOCS_INDEX.md, docs/ARCHITECTURE.md,
docs/architecture/CORE_PATTERNS.md, and docs/architecture/ARCHITECTURE_EXTENSION.md.
The issue is: [bug description]. Include browser console output below.
```

---

## Reference

| File | Purpose |
|------|---------|
| `docs/architecture/CLAUDE_MAINDOCS_INDEX.md` | **Live state-of-play.** Loaded every session. Current constraints, env vars, phase status, common commands |
| `docs/ARCHITECTURE.md` | What the project is, structural decisions, data flow |
| `docs/SYSTEM.md` | Developer rules, naming conventions, never-do constraints |
| `docs/architecture/DECISIONS.md` | Why specific technical choices were made (ADRs) |
| `docs/architecture/CORE_PATTERNS.md` | Compact do-not-break checklist (G1–G15) — read before code changes |
| `docs/architecture/qref/` | Surgical quick-references for AI-trap topics (≥ 200 words, ≥ 1 worked failure case each) |
| `docs/architecture/template-examples/audit-template/` | Chunked codebase-audit pattern |
| `CLAUDE.md` (project root) | Full project context for AI sessions |
