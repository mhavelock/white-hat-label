Perform a blue-hat session synthesis. This command is designed to be run at the START of a session from a clean context, or handed off to an external model (Gemini) for an unbiased cross-session audit.

---

## Mode A — Blue Hat (Claude, fresh context)

You are in Blue Hat mode: process facilitator, not problem solver. You are not the author of this code. You are reading the project state to synthesise it objectively.

1. Read `docs/architecture/ARCHITECTURE.md` — absorb the structural decisions without judgment.
2. Read `docs/architecture/SYSTEM.md` — absorb the rules.
3. Read `docs/plan/handoff_[latest].md` — what happened last session.
4. Read `docs/plan/tasklist.md` — the full task register.
5. Read `docs/architecture/FEEDBACK-LOOPS.md` — past wins and guardrails.

Then produce a `session_synthesis.md` in `docs/plan/` with:

```markdown
# Session Synthesis — YYYY-MM-DD

## Objective Summary (Blue Hat)
One paragraph: what the project IS, where it IS RIGHT NOW, and what the open path forward is.
No opinions. No suggestions yet.

## Architecture Status
- What is solid (confirmed, tested, documented)
- What is uncertain (OPEN questions, untested paths)
- What is at risk (stale assumptions, drift from patterns)

## Task Prioritisation
Top 3 unblocked tasks, ordered by impact/dependency. One sentence each — what, why now.

## Patterns to Protect This Session
The 3 constraints from SYSTEM.md most likely to be under pressure given today's work.
Listed as: "Watch for: [risk] → Guard: [constraint from SYSTEM.md]"

## Recommended First Action
Single sentence. Not a list.
```

---

## Mode B — Gemini MCP (in-session audit)

Gemini is available directly via MCP — no copy-pasting required. Call it from within the current session.

**Tool selection:**
- `mcp__gemini__ask_gemini` — Flash model (fast, 8K output). Use for standard architecture audits and second opinions.
- `mcp__gemini__ask_gemini_pro` — Pro model (16K output). Use when stuck in a loop, making a hard-to-reverse decision, or when Flash lacks depth.

**Standard architecture audit call:**

```
system_prompt: "You are performing a cross-session architectural audit of a React Native iOS app called 'That AI Guy'. You are the AUDITOR, not the author. Find drift, regressions, and constraint violations — not new features."

prompt: """
ARCHITECTURE CONSTRAINTS:
[ARCHITECTURE.md §Core Structural Decisions + §What We Never Do]

SYSTEM RULES:
[SYSTEM.md §Rules of Engagement]

HARD RULES:
[FEEDBACK-LOOPS.md §Hard Rules Extracted]

CHANGED CODE / CONTEXT:
[Relevant files or diff only — not full codebase]

AUDIT QUESTION:
1. Any "What We Never Do" violations?
2. Any drift from documented architecture patterns?
3. Any Hard Rules regressions?
4. Any race conditions or sequencing risks?

Output: Confirmed solid | Potential drift (file + pattern) | Regressions to check | Recommended action
"""
```

**Additional Gemini MCP tools:**
- `mcp__gemini__web_search` — research: libraries, RN issues, API behaviour
- `mcp__gemini__web_reader` — read a specific URL (docs, release notes, Stack Overflow)
- `mcp__gemini__parse_document` — extract text from PDFs (patent filings, API specs)

**Trigger conditions for Gemini audit:**
- Same bug attempted 2+ times without root cause found
- About to add a dependency or make a hard-to-reverse choice
- Just completed a major refactor
- "This feels fragile" (Red Hat signal)

Full consultancy reference: `docs/architecture/GEMINI-CONSULTANCY.md`

---

## When to use this command

- Start of a new session after context compaction
- When you suspect architectural drift after several rapid iterations
- Before a significant feature addition (check the foundation is solid first)
- After a complex debugging session (verify no constraints were silently broken)
