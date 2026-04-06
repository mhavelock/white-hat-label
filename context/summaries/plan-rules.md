# Plan Rules — [PROJECT_NAME]

Session operating rules. These govern how Claude Code sessions are run on this project.

---

## Rule 1 — Session Handoff

Every session that touches code or architecture ends with a handoff file written to `context/summaries/handoff_YYYY-MM-DD.md`.

**Minimum handoff content:**
- What was done
- Files changed and how
- Key decisions made (link to ADRs if relevant)
- Known constraints established
- What to pick up next

Use the handoff template in `context/summaries/handoff_template.md`.

---

## Rule 2 — No Autonomous Git Push

`git push` is never run without explicit user confirmation. Pushing to `main` deploys immediately to production. The cost of an accidental push is immediate and visible. Always confirm: "Ready to push to [branch]?"

---

## Rule 3 — Review Before Commit

Always run `git diff` before committing. Show the diff to the user and confirm before proceeding.

---

## Rule 4 — Protected Files

Files listed in `ARCHITECTURE.md §"Protected files"` may not have their core behaviour changed without explicit instruction and a new ADR entry.

---

## Rule 5 — Task Tracking

All tasks live in `context/summaries/tasklist.md`. Never delete a task — mark it done instead. Add new tasks as they are identified, not just when they're picked up.

---

## Rule 6 — Skills

Use the `git-commit-messaging` skill for all commit messages (Conventional Commits format).
Use the `frontend-standards` skill any time HTML, CSS, or JS is written or reviewed.

---

## Rule 7 — Constraint First

Before implementing a change, check `docs/architecture/CORE_PATTERNS.md` G1–G13. If the change would violate a constraint, stop and discuss rather than implementing a workaround.

---

## Entry Prompts for New Sessions

**Standard (default):**
```
Read context/summaries/handoff_[latest].md, context/summaries/tasklist.md, and docs/ARCHITECTURE.md.
The task is: [task description].
```

**Fresh read (no prior context):**
```
Read docs/ARCHITECTURE.md and docs/architecture/CORE_PATTERNS.md.
The task is: [task description]. Do not read any handoffs or session history.
Approach this as if you have never seen this code before.
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
