Generate a dense, cacheable state summary for this session. This serves two purposes:
1. **Prompt prefix caching** — the static prefix (architecture + constraints) that doesn't change between calls
2. **Context reload** — re-prime a degraded or fresh context with the project's current state

---

## Step 1 — Load static prefix (architecture layer)

Read these files in order. These are the STATIC layer — they change rarely:
1. `docs/architecture/ARCHITECTURE.md` §"Core Structural Decisions" and §"What We Never Do"
2. `docs/architecture/SYSTEM.md` §"Rules of Engagement" and §"What's Where"
3. `docs/architecture/FEEDBACK-LOOPS.md` §"Hard Rules Extracted" (the distilled guardrails)

**Caching note:** In API usage, these files should be the `system` prompt prefix with a `cache_control: { type: "ephemeral" }` breakpoint after them. This means you pay full price once; subsequent calls in the session get ~90% discount on these tokens.

---

## Step 2 — Generate dynamic suffix (current state)

Read:
- `docs/plan/handoff_[latest].md` (most recent)
- `docs/plan/tasklist.md` (open tasks only)

Then write a `state_summary_YYYY-MM-DD.md` to `docs/plan/` with this exact structure:

```markdown
# State Summary — YYYY-MM-DD [HH:MM]

## Project Identity
App: That AI Guy | iOS only | Expo SDK 54 | No backend
Bundle: com.thatguy.app | Relay: api.that-ai-guy.app

## Current Build State
[1 line: last known good build + date]
[1 line: any known regressions or breakage]

## Active Constraints (this session)
[Max 5 bullet points — the SYSTEM.md rules most relevant to today's work]

## Open Tasks (unblocked)
[Table: # | Task | Type | Why now]
Max 5 rows.

## Open Questions
[OPEN/ASSUMED items that affect today's work]

## Session Focus
[1 sentence: what we're doing today and why]
```

---

## Step 3 — Prompt caching split (for API / multi-call sessions)

The static/dynamic split for this project:

**STATIC prefix** (cache this — changes < once per week):
```
[ARCHITECTURE.md: Core Structural Decisions + What We Never Do]
[SYSTEM.md: Rules of Engagement + Component Patterns + iOS Constraints]
[FEEDBACK-LOOPS.md: Hard Rules Extracted]
```

**DYNAMIC suffix** (fresh each call):
```
[state_summary_YYYY-MM-DD.md]
[The actual task / question]
```

This structure means:
- Architecture constraints are always present without re-reading large files
- Changing the task doesn't invalidate the cached prefix
- New sessions load from the summary, not from re-reading the codebase

---

## When to use this command

- Start of a long working session (>2 hours expected)
- After any context compaction event
- When starting a new session and needing to orient quickly
- Before handing work to a sub-agent (give it the summary, not the raw files)
