# Settings — Current State of Play [DATE]

> **The deepest sub-section of `CLAUDE_MAINDOCS_INDEX.md`. Kept current at the top of every session — sessions update this before writing the handoff. Replace `[DATE]` with the date you last verified each subsection (not the file's creation date).**
>
> This template shows the *shape*. Forks delete subsections that don't apply (e.g. a static site has no "Production runtime" with vendor migration state, but does have a "Pre-launch checklist").

---

## Production runtime

> What is currently live, and in what state. The first thing a session needs to know.

- **Public site:** [URL] — [live on host / not deployed / paused] · [build status]
- **Render mode:** [normal / degraded / static-only / SSR / hybrid]
- **Health:** [healthy / known issues / TODO list below]
- **Last deploy:** [date / commit hash]
- [Add or remove bullets per project: AI service status, third-party integrations, monitoring services]

---

## Migration / Cutover state (if applicable)

> Use this subsection when the project is mid-migration (vendor swap, store cutover, account move). Delete entirely if not migrating.

| | Old [system] | New [system] |
|---|---|---|
| [Identifier] | [old value] | [new value] |
| [Status field] | [old status] | [new status] |
| [Token / credential] | [tracked status] | [tracked status] |

---

## Long-running flags

> Feature flags, env-var switches, or temporary patches that are intentionally on/off and span multiple sessions. Document each: state, reason, exit condition.

| Flag | State | Notes |
|---|---|---|
| [Flag name] | [ON / OFF] | [why it's in this state, when it'll change] |
| Build resilience patch | [ON] | [example: wraps third-party calls during a vendor migration; remove after cutover] |
| [Vendor switch] | [example: AI provider switched to gateway 2026-MM-DD] | [...] |

---

## Open work

> Sequential, blocking items — work that must happen in order to unblock other phases. Different from `tasklist.md` (which is granular) — this is the headline blockers.

1. **[Task ID]** — [title]. [one-line description]. [owner if non-default]
2. **[Task ID]** — [title]. [...]
3. [...]

---

## Pre-launch checklist

> Orthogonal to phase work — things that must be done before going live, regardless of feature progress. Rotate, audit, document, smoke-test.

- [ ] Rotate [secret name] — [why, where to update]
- [ ] Update webhook URLs to production host
- [ ] Set primary domain on [vendor] dashboard
- [ ] Run Phase 0 of `docs/security-sweep-playbook.md` — 3-min triage
- [ ] [Project-specific item]

---

## Recent decisions

> The 2–5 most recent decisions that materially affect the project. Older decisions live in `DECISIONS.md` (full ADR format); this is the "since last week" digest.

- **[Date]** — [decision title]. [one-sentence rationale]. (Full ADR: `DECISIONS.md` ADR-XXX)
- **[Date]** — [...]

---

## Entry prompt for next session

> The verbatim prompt to paste into the next session. Should reference the latest handoff and this section, plus the immediate goal.

```text
Read docs/plan/handoff_[YYYY-MM-DD].md and
docs/architecture/CLAUDE_MAINDOCS_INDEX.md "## Settings — Current State of Play".
Continuing [phase / task]. Need to:
(a) [first concrete step];
(b) [second step];
(c) [third step].
Plan / reference: [file path or task ID]
```

---

## Conventions

- **Date stamp the section header** — `## Settings — Current State of Play (2026-MM-DD)`. If the date is older than 2 weeks, the section is suspect and a session should refresh it before relying on it.
- **One source of truth.** This section *is* the current state. If a downstream doc disagrees, this wins; update the downstream doc.
- **Subsection prune ruthlessly.** A static site doesn't need "Migration state"; an iOS app doesn't need "Webhook URLs"; a CLI tool doesn't need "Public site URL." Keep what applies; delete what doesn't.
- **Update *before* writing the handoff.** The handoff describes the session; this section describes the *project at the end of the session*. Two different documents.

---

## See also

- `CLAUDE_MAINDOCS_INDEX.md` — the parent file this section lives inside.
- `PHASE-STATUS.md` (this directory) — companion template for the kanban-style phase table that sits immediately above this section.
- `handoff_template.md` (this directory) — the per-session handoff that pairs with the State of Play snapshot.
