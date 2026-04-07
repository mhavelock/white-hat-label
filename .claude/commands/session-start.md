# /session-start — Engineered Hybrid Session Ritual

This command loads the minimum context needed to work effectively on That AI Guy without overwhelming the context window. It implements the **Engineered Hybrid** session style: structured context injection at the start, leaving the rest of the window for actual work.

**Takes ~2 minutes. Run before any code work.**

---

## Session Style Reference

Three styles exist. Choose the right one before starting:

| Style | When to use | What it loads |
|-------|-------------|---------------|
| **Engineered Hybrid** *(default)* | Day-to-day development, feature work, code changes | This command — structured prefix + task focus |
| **Fresh (Red Team)** | New feature design, architecture decisions, avoiding confirmation bias | New session, ARCHITECTURE.md + task only — no handoff history |
| **Bloated (Deep)** | Bug hunting, mysterious failures, "why is this broken?" | Full handoff history + pipeline docs + logs in context |

**Default is Hybrid.** Only switch styles when the task explicitly calls for it.

---

## Load Sequence (Engineered Hybrid)

1. Read `docs/plan/handoff_[latest].md` — find the most recent date-suffixed file in `docs/plan/`. Summarise: what was accomplished, what is currently open.

2. Read `docs/plan/tasklist.md` — identify the top 3 unblocked open tasks and note current sprint focus.

3. Read `docs/architecture/ARCHITECTURE.md` §"Core Structural Decisions" and §"What We Never Do".

4. Read `docs/architecture/CORE_PATTERNS.md` — the do-not-break checklist. Internalise the Global Constraints table (G1–G13). Do not skip this step before any code change.

5. **L3 Auto-Route** — Based on the session intent (user's question + open tasks identified above), identify which L3 files are needed *before* starting work. Load them now rather than waiting to be asked mid-session. State each file and the one-line reason.

| Session type | L3 files to load |
|---|---|
| Code change in hooks/, services/, store/ | Relevant pipeline doc (listening or roasting) |
| Bug investigation / mysterious failure | Pipeline doc for affected area + `DECISIONS.md` |
| Architecture or design decision | `DECISIONS.md` + `six-hats.md` |
| Full codebase or pre-release audit | `CODEBASE-AUDIT.md` + `FEEDBACK-LOOPS.md` |
| Gemini consultation | `GEMINI-CONSULTANCY.md` |
| Visual / UI / animation work | `FE-VISUALISATION.md` |
| Security or compliance work | `security.md` + `STANDARDS.md` |
| Architecture documentation sprint | `.ai/roadmap.md` + `.ai/memory/context.md` |
| Testing session | `docs/test-program.md` |
| ADR review or new architecture decision | `DECISIONS.md` + `ARCHITECTURE_EXTENSION.md` |

If the session intent is unclear, state that and ask before loading L3 files.

---

## Report After Loading

- **Current project state** (2–3 sentences)
- **Top open tasks** (unblocked first, blocked tasks with blocker noted)
- **Architecture constraints** relevant to today's likely work
- **Session style recommendation** — confirm Hybrid is appropriate, or flag if Fresh/Deep would serve better
- **Recommended first action**

Do not make any code changes during this step.

---

## When to Switch Styles Mid-Session

- Switch to **Fresh**: user asks "what would you do if you'd never seen this code?" → open a new session with task description only
- Switch to **Deep**: mysterious failure, more than 2 failed fix attempts → load pipeline docs + recent logs into context before continuing
- Return to **Hybrid**: after a Deep session resolves the bug, write a handoff and start fresh with the fix task

---

## Layer 3 Files (load on demand, not at start)

| File | Load when |
|------|-----------|
| `ARCHITECTURE_EXTENSION.md` | Doing a full audit, checking package versions, compliance check |
| `FEEDBACK-LOOPS.md` | Passing context to Gemini; before risky changes |
| `GEMINI-CONSULTANCY.md` | Before a Gemini consultancy call |
| `FE-VISUALISATION.md` | Before any visual/layout/design tool session |
| `six-hats.md` | Decision needs structured thinking; codebase audit |
| `CODEBASE-AUDIT.md` | Before a full audit — exclusion list, chunk strategy |
| `CHECKPOINTS.md` | Log awareness reference, auto-trigger conditions |
| `pipeline-listening.md` | Deep dive on listening pipeline bug or change |
| `pipeline-roasting.md` | Deep dive on roasting pipeline bug or change |
| `DECISIONS.md` | Reviewing or adding an ADR |
| `docs/test-program.md` | Before a testing session |
| `docs/code-review.md` | Before a security or compliance audit |
