# Phase Status — [PROJECT_NAME]

> **Lightweight kanban-in-prose. Used as the `## Phase Status` section inside `CLAUDE_MAINDOCS_INDEX.md`, OR maintained as a standalone file when the phase list grows past ~15 rows.**
>
> Replace `[PROJECT_NAME]` and the placeholder rows. Status icons live at the bottom; reuse them across the project.

---

## Why this template

A project with multiple parallel workstreams (e.g. core + extensions + bugfix passes + pre-launch) outgrows a single linear task list. A status table answers "where are we?" in one screen, without the reader having to read every task.

This template is **example shape, not example content**. Rows like "Phase 0 — Architecture & Planning" are starter prompts; replace them with your project's actual phases.

---

## Phase Status

| Phase | Status | Notes |
|---|---|---|
| 0 — Architecture & Planning | [✅ / 🔄 / ⚠️] | [one-line summary of what's done or open] |
| 1 — [PROJECT_PHASE_NAME] | [✅ / 🔄 / ⚠️] | [...] |
| 2 — [PROJECT_PHASE_NAME] | [✅ / 🔄 / ⚠️] | [...] |
| 2A — [Sub-phase if relevant] | [✅ / 🔄 / ⚠️] | [...] |
| 3 — [PROJECT_PHASE_NAME] | [✅ / 🔄 / ⚠️] | [...] |
| Pre-launch | [✅ / 🔄 / ⚠️] | [items orthogonal to phase work — rotation, smoke tests, content review] |
| Final — Audit, Testing, Launch | [✅ / 🔄 / ⚠️] | [...] |

---

## Status icons

| Icon | Meaning |
|---|---|
| ✅ | Complete — phase delivered, no open work |
| 🔄 | In progress — actively being worked |
| ⚠️ | TODO / blocked / partial — flagged for attention |
| 🚫 | Cancelled / superseded — kept in table for history |

---

## Conventions

- **Phase numbers are not rigid.** `1`, `2A`, `2B`, `2+` are all valid. Use what reads well.
- **Notes column is one line max.** Detail belongs in `tasklist.md` or a feature doc.
- **Don't delete completed phases.** History at-a-glance is part of the value. Move them to the bottom of the table if needed, but keep them visible.
- **Update before writing the session handoff.** The phase table is *current state*; if it's stale, the handoff is wrong.
- **Sub-phases inherit the parent.** If 2A and 2B are 🔄 and 2C is ✅, parent Phase 2 is 🔄.

---

## When to use a standalone file vs inline in MAINDOCS_INDEX

- **Inline in `CLAUDE_MAINDOCS_INDEX.md`** — default. Most projects have ≤ 15 phase rows; the table fits comfortably in the live state-of-play file.
- **Standalone `docs/PHASE-STATUS.md`** — when:
  - Row count exceeds ~15 and the MAINDOCS_INDEX file is becoming hard to scan.
  - Multiple stakeholders need to read phase status without loading the full session-context file.
  - You want to link to phase status from external docs (README, design briefs).

When standalone, MAINDOCS_INDEX should still have a `## Phase Status` section — but kept to a 3-line summary that points at the standalone file:

```markdown
## Phase Status

Currently in **Phase 3 — [name]**. See `docs/PHASE-STATUS.md` for full table.

Headline: [one sentence on the most material in-flight or recently-shipped item]
```

---

## See also

- `CLAUDE_MAINDOCS_INDEX.md` — the file this section normally lives inside.
- `STATE-OF-PLAY.md` (this directory) — companion template for the deeper "Settings — Current State of Play" sub-sections.
- `docs/plan/tasklist.md` — task-level granularity (phases here, tasks there).
