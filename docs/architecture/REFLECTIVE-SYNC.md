# Reflective Sync — Session Patterns for [PROJECT_NAME]

Prompts and patterns for keeping Claude's context accurate, architecture docs up to date, and sessions well-structured. Use these at session start, during work, and at close.

---

## Why This Exists

Without deliberate synchronisation, AI-assisted development accumulates drift: decisions made in one session aren't recorded, docs fall behind the code, and the next session has to re-derive context. This file provides the prompts and habits that prevent drift.

---

## Session Start

Load minimum context:
```text
Read docs/plan/handoff_[latest].md, docs/plan/tasklist.md, and docs/ARCHITECTURE.md.
The task is: [task description].
```

For architecture work, also load `docs/architecture/CORE_PATTERNS.md`.

For a completely fresh read (no prior session context):
```text
Read docs/ARCHITECTURE.md and docs/architecture/CORE_PATTERNS.md. The task is: [task description].
Do not read any handoffs or session history. Approach this as if you have never seen this code before.
```

---

## Before a Significant Code Change

Check against constraints:
```text
Read docs/architecture/CORE_PATTERNS.md.
I'm about to [describe change]. Does this violate any of G1–G15?
```

For changes to core files or patterns:
```text
Read docs/ARCHITECTURE.md §"What We Never Do" and docs/SYSTEM.md.
I want to [describe change]. Is this consistent with the architectural decisions recorded here?
If not, what would need to change in the docs to support it?
```

---

## After Completing Code Changes

Check if docs need updating:
```text
I changed [file]. Does docs/ARCHITECTURE.md or docs/SYSTEM.md need updating?
```

Check for constraint compliance:
```text
Review the changes in [file] against G1–G15 in docs/architecture/CORE_PATTERNS.md.
Flag any violations or potential regressions.
```

---

## Session End

Write handoff per `docs/plan/plan-rules.md` Rule 1:
```text
Write a session handoff to docs/plan/handoff_YYYY-MM-DD.md covering:
- What was done this session
- Files changed and how
- Key decisions made
- Known constraints established
- What to pick up next
```

---

## Architecture Sync (periodic — before major changes)

### Contradiction Hunt

Feed the architecture docs to Gemini or a fresh Claude session:
```text
Read docs/ARCHITECTURE.md, docs/SYSTEM.md, and docs/architecture/CORE_PATTERNS.md.
Identify the top 5 internal contradictions or tensions between these documents.
For each: quote both sides of the tension, and suggest a resolution.
```

### Drift Check

Test whether the docs still match the code:
```text
Read docs/ARCHITECTURE.md and docs/architecture/CORE_PATTERNS.md.
Then read [key files — e.g. styles/theme.css, js/main.js].
Are there any divergences between what the docs describe and what the code actually does?
```

---

## Security Sync (before any major release)

Run Phase 0 of `docs/security-sweep-playbook.md` as a 3-min triage. Use this prompt:

```text
Read docs/security-sweep-playbook.md.
Run Phase 0 (3-min triage) on this repo. Check:
- git log --all -- '.env*' for any committed env files
- git branch -r for shadow branches (entire/, aider/, cursor-derived)
- bundle output for vendor-prefixed env vars (NEXT_PUBLIC_*, VITE_*)
- .gitignore covers .entire/, .claude/logs/, .claude/.backups/, /docs/plan/**
- branch protection on main is intact (allow_force_pushes:false)
Report: PASS / FAIL with findings. If FAIL, list remediation steps in priority order.
```

Run before:

- Any major release.
- Adopting a new AI tool that integrates with git (session trackers, agentic dev tools, AI commit-message generators).
- Onboarding a new contributor with push access.
- Quarterly cadence as a backstop.

Cross-ref `FEEDBACK-LOOPS.md` FL-10 and `BREAKTHROUGHS.md` B-01 for the incident that drove this.

---

## Red Team Reset

**The premise:** After many iterations on a problem, context accumulates recency bias — optimising for the constraints learned recently, not the ideal solution. A fresh-context read bypasses this.

**How to use:**
1. Start a new session (fresh context)
2. Load only: `docs/ARCHITECTURE.md`, `docs/SYSTEM.md`, `docs/architecture/FEEDBACK-LOOPS.md`
3. Do NOT load the code in question yet
4. Ask: *"You are a senior web developer reviewing this project for the first time. Here is the architecture. Here is the problem we're trying to solve: [description]. How would you approach it?"*
5. Compare the fresh answer to the current approach. Differences = things worth interrogating.
