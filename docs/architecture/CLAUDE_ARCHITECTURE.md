# How to Use the Architecture Docs — [PROJECT_NAME]

A quick guide to what each architecture document is for and when to load it.

---

## The Document Hierarchy

```
docs/
├── ARCHITECTURE.md                     # L1 — What the project is; structural decisions; never-do rules
├── SYSTEM.md                           # L1 — Developer rules; naming conventions; HTML/CSS/JS standards
└── architecture/
    ├── CORE_PATTERNS.md                # L1 — G1–G13 constraints; pattern reference; regression checklist
    ├── DECISIONS.md                    # L2 — ADR register — why each key decision was made
    ├── FEEDBACK-LOOPS.md               # L2 — Wins, limits, hard rules from project history
    ├── BREAKTHROUGHS.md                # L2 — Root-cause records; non-obvious lessons
    ├── ARCHITECTURE_EXTENSION.md       # L2 — Coding standards detail; token reference; pitfalls
    ├── CODEBASE-AUDIT.md               # L3 — Audit approach, chunks, and guidelines
    └── REFLECTIVE-SYNC.md              # L3 — Session prompts for sync and drift prevention
```

**L1 — Always load for any code session.** These three files (ARCHITECTURE.md, SYSTEM.md, CORE_PATTERNS.md) together define the constraints and context for any work.

**L2 — Load when relevant.** DECISIONS.md when making choices with precedent. FEEDBACK-LOOPS.md when a pattern feels uncertain. BREAKTHROUGHS.md when diagnosing a hard problem. ARCHITECTURE_EXTENSION.md for coding standards detail and token reference.

**L3 — Load for meta-work.** CODEBASE-AUDIT.md for running audits. REFLECTIVE-SYNC.md for session structure prompts.

---

## Reading Order for a New Session

1. `context/summaries/handoff_[latest].md` — what happened last session
2. `context/summaries/tasklist.md` — open tasks
3. `docs/ARCHITECTURE.md` — project blueprint (start here for context)
4. The specific file being worked on

For architecture or refactor sessions, also load:
5. `docs/SYSTEM.md` — developer rules
6. `docs/architecture/CORE_PATTERNS.md` — constraint checklist

---

## Entry Prompts

**Standard (default):**
```
Read context/summaries/handoff_[latest].md, context/summaries/tasklist.md, and docs/ARCHITECTURE.md.
The task is: [task description].
```

**Fresh read (no prior context):**
```
Read docs/ARCHITECTURE.md and docs/architecture/CORE_PATTERNS.md.
The task is: [task description].
Do not read any handoffs or session history. Approach this as if you have never seen this code before.
```

**Deep (bug investigation):**
```
Read context/summaries/handoff_[latest].md, context/summaries/tasklist.md, docs/ARCHITECTURE.md,
docs/architecture/CORE_PATTERNS.md, and docs/architecture/ARCHITECTURE_EXTENSION.md.
The issue is: [bug description]. Include browser console output below.
```

---

## Reference

| File | Purpose |
|------|---------|
| `docs/ARCHITECTURE.md` | What the project is, structural decisions, data flow |
| `docs/SYSTEM.md` | Developer rules, naming conventions, never-do constraints |
| `docs/architecture/DECISIONS.md` | Why specific technical choices were made (ADRs) |
| `docs/architecture/CORE_PATTERNS.md` | Compact do-not-break checklist — read before code changes |
| `CLAUDE.md` (project root) | Full project context for AI sessions |
