# White Hat Label

A white-label boilerplate starter for AI-assisted web development with Claude Code. Clone this repo, fill in the `[PROJECT_NAME]` placeholders, and start building — the documentation scaffold, architecture guardrails, and session management system are already in place.

---

## What This Is

A structured foundation for co-developing web projects with Claude Code (or any AI coding assistant). It is not a code framework — it is a **documentation and workflow framework** that keeps AI sessions coherent, consistent, and grounded across multiple conversations.

### Objectives

- Provide a complete, reusable starting point for any HTML/CSS/JS (or React/Next.js) web project
- Eliminate the cost of re-establishing context at the start of every AI session
- Enforce quality guardrails (standards, constraints, conventions) that survive context resets
- Record architectural decisions, feedback loops, and breakthroughs so they are never lost
- Give any developer — or AI model — a clear reading order to get up to speed on any project

---

## What's Included

### Architecture Documentation

A layered doc system designed so an AI session can load the minimum necessary context:

| File | Purpose |
|------|---------|
| `docs/ARCHITECTURE.md` | Golden thread — structural decisions, file structure, dependency diagram, CSS architecture, data flow, "What We Never Do" |
| `docs/SYSTEM.md` | Developer rules — naming conventions, CSS/JS/HTML rules, commit conventions |
| `docs/architecture/CORE_PATTERNS.md` | **G1–G13 do-not-break constraints** — with the history behind each rule and correct/wrong code examples |
| `docs/architecture/DECISIONS.md` | Architecture Decision Records (ADRs) — why specific technical choices were made |
| `docs/architecture/FEEDBACK-LOOPS.md` | Wins, limits, and hard rules — evolves as the project accumulates learnings |
| `docs/architecture/BREAKTHROUGHS.md` | Reflective record of key problem-solving moments |
| `docs/architecture/ARCHITECTURE_EXTENSION.md` | Design token reference, CSS/JS conventions detail, common pitfalls, Schema.org reference |
| `docs/architecture/CODEBASE-AUDIT.md` | Audit chunk strategy, G1–G13 checklist, standard audit prompt |
| `docs/architecture/REFLECTIVE-SYNC.md` | Session-start/mid/end prompts, Contradiction Hunt, Drift Check, Red Team Reset |
| `docs/architecture/CLAUDE_ARCHITECTURE.md` | Document hierarchy (L1/L2/L3), reading order, and entry prompts for 3 session styles |
| `docs/architecture/CHECKPOINTS.md` | 9 auto-checkpoint triggers, mini-checkpoint format, log awareness |
| `docs/architecture/FE-VISUALISATION.md` | Visual debugging approach — tool decision tree, viewport testing matrix |
| `docs/architecture/six-hats.md` | Six Hats thinking model, Inversion, Anchoring Prompts for AI sessions |

### Guardrails

Quality rules built into the architecture system — not enforced by tooling, but documented clearly enough that any AI session applies them consistently:

- **G1–G13 constraints** in `CORE_PATTERNS.md` — no `!important`, no inline styles, no `max-width` breakpoints, CSS custom properties for all tokens, `requestAnimationFrame` only, `localStorage` sanitisation, safe external links, etc.
- **"What We Never Do"** table in `ARCHITECTURE.md` — a short, memorable list of hard prohibitions
- **Feedback Loops** in `FEEDBACK-LOOPS.md` — records of past mistakes and confirmed patterns; prevents the same errors recurring across sessions
- **ADRs** in `DECISIONS.md` — rationale for every significant technical decision; prevents revisiting settled questions
- **Protected files** convention — specific files can be marked do-not-modify with clear reasons

### Reflective Architecture

The system is designed to self-correct over time:

- **Reflective Sync** (`REFLECTIVE-SYNC.md`) — structured prompts to run at session start, mid-session, and end to catch drift between docs and code
- **Contradiction Hunt** — feed all L1/L2 docs to a second model; surface the top 5 internal contradictions
- **Recursive Architecture Test** — feed `ARCHITECTURE.md` + `SYSTEM.md` to a fresh model; compare its description to the actual code; divergences = doc debt
- **Breakthroughs log** — root causes of past hard problems; avoids re-diagnosing known issues
- **Codebase Audit** (`CODEBASE-AUDIT.md`) — periodic full audit against G1–G13; chunks files into manageable batches

### Session Plan System

Keeps state across AI sessions — context resets don't cause lost work:

| File | Purpose | Tracked? |
|------|---------|----------|
| `docs/plan/tasklist.md` | Canonical task register — all tasks (open and completed) live here, never deleted | ✅ Tracked (sanitized template) |
| `docs/plan/handoff_YYYY-MM-DD-*.md` | Per-session handoff written at session end — covers what was done, current state, open questions, next entry prompt | 🚫 Gitignored (`/docs/plan/**`) |
| `docs/plan/plan-rules.md` | 8 operating rules for every session — checkpoint format, OPEN vs ASSUMED, when to write handoffs | 🚫 Gitignored (local workspace) |
| `docs/plan/handoff_template.md` | Handoff document template | 🚫 Gitignored |
| `docs/plan/example-*.md` | Worked examples | 🚫 Gitignored |

> **Why most of `docs/plan/` is gitignored:** session handoffs and plan rules contain ongoing project work and would clutter a public boilerplate. Only the empty `tasklist.md` template is tracked. Forks start with the same `tasklist.md` template and build their own session history locally. See [`docs/security-sweep-playbook.md`](./docs/security-sweep-playbook.md) and [`docs/security-phase1-2026-05-03.md`](./docs/security-phase1-2026-05-03.md) for the rationale.

**Three session styles** (conceptual — `plan-rules.md` is local-only):

| Style | When |
|-------|------|
| **Hybrid** *(default)* | Day-to-day development — load handoff + ARCHITECTURE.md |
| **Fresh / Red Team** | Architecture decisions — no handoff, fresh perspective only |
| **Deep / Bloated** | Mystery bugs, >2 failed attempts — load everything |

### Template Examples

Reference files for server-side, standards tracking, and second-model consultation:

- `docs/architecture/template-examples/GEMINI-CONSULTANCY.md` — 7 patterns for using a second model (Gemini or similar) as a consultant: architecture audits, stuck-in-loop recovery, decision validation, quality advocate
- `docs/architecture/template-examples/SERVERSIDE.md` — server-side architecture template (hosting, domain, env vars, CI/CD, monitoring)
- `docs/architecture/template-examples/STANDARDS.md` — quality standards tracking table (Performance, HTML, CSS, JS, A11Y, SEO) — all `⚠️ TBA` until verified

---

## Stack

This starter ships with a documentation scaffold for vanilla HTML/CSS/JS. The same architecture system works with any of these:

- **Frontend:** HTML5, CSS3, Vanilla JS, React, Next.js, SASS, Tailwind, AlpineJS
- **Backend:** Node.js, TypeScript, PHP, MySQL, PostgreSQL
- **Hosting:** GitHub Pages, Vercel, Cloudflare Pages
- **CI/CD:** GitHub Actions, GitLab CI
- **Infrastructure:** Cloudflare Workers, NGINX, Service Workers, OpenRouter
- **Tools:** Google Maps, Google APIs, Encore, Entire.io, SequelPro

---

## Standards & Conventions

Documented in `docs/SYSTEM.md` and `docs/ARCHITECTURE.md`:

- Mobile-first responsive design — `min-width` breakpoints only, 12-column grid, 1rem gutter, 288px min element width, 1440px max content width
- CSS custom properties for all colours, spacing, and transitions — single source of truth in `styles/theme.css`
- W3C valid HTML5, WCAG 2.1 AA accessibility
- Google PageSpeed ≥ 95 target — `defer` on scripts, `loading="lazy"` below fold, `srcset` for images, `requestAnimationFrame` for animations
- Light/dark mode via `prefers-color-scheme` and `[data-theme]`
- `em` for font sizes, `rem` for spacing
- Schema.org JSON-LD + Open Graph meta on every page
- No inline styles, no `!important`, no `var`, no globals

---

## Security

This is a **public** boilerplate. Anything committed becomes world-readable. The repo ships with a two-phase security playbook to keep your fork-or-derivative clean:

- **[`docs/security-sweep-playbook.md`](./docs/security-sweep-playbook.md)** — Phase 0 (3-min critical-only triage), Phase 1 (10-min top-level sweep), Phase 2 (rotation + history rewrite). Use before turning a private project public, after suspecting a leak, or quarterly.
- **[`docs/security-phase1-2026-05-03.md`](./docs/security-phase1-2026-05-03.md)** — Phase 1 status table from this repo's own sweep. Worked example.

### Public-repo gotchas this scaffold hardens against

| Risk | What this repo does about it |
|------|------------------------------|
| Session-tracker tools (entire.io, etc.) auto-pushing transcripts to public branches | `.gitignore` excludes `.entire/`. If you use entire.io, run `entire enable --skip-push-sessions` so session branches are never pushed. |
| Force-push accidents on `main` | GitHub branch-protection rule on `main` (pattern `*`, `allow_force_pushes:false`, admin bypass on for legitimate emergency rewrites). |
| Hook-script paths leaking developer-specific dirs | `.claude/hooks/change-log.sh` and `pre-edit-backup.sh` read `$COWORK_LOG_DIR` / `$COWORK_BACKUP_DIR` (cross-project aggregation) with project-local `.claude/logs/` and `.claude/.backups/` defaults. Both fallback dirs are `.gitignore`d. |
| Private workspace docs in public history | `/docs/plan/**` is gitignored except for the empty `tasklist.md` template. Real session handoffs and plan rules stay local. |

### If you fork this

1. Run Phase 0 of the playbook against your new fork before adding any real content.
2. Update `index.html` SEO canonicals (the four `mhavelock.github.io/white-hat-label/` URLs) to your own domain.
3. Add `SECURITY.md` and `.well-known/security.txt` for disclosure contact (this scaffold doesn't include them — best practice for any public repo).
4. Consider adding a pre-commit hook + CI secret-scan (`gitleaks`, `trufflehog`) — see playbook §"Lock the door behind you".

---

## Getting Started

1. Clone the repo and rename `[PROJECT_NAME]` throughout `CLAUDE.md`, `docs/ARCHITECTURE.md`, and `docs/SYSTEM.md`
2. Start a Claude Code session with the entry prompt from `docs/architecture/CLAUDE_ARCHITECTURE.md`
3. Create `docs/plan/tasklist.md` for your project (use the template)
4. Build your first page — the guardrails are already in place

---

## Local Development

```bash
npx live-server
```

Open `http://127.0.0.1:5500` in your browser.

---

## Repository Structure

```
[project-root]/
├── CLAUDE.md                    # Claude Code session instructions
├── README.md                    # This file
├── index.html                   # Main page (create per project)
├── assets/                      # Audio, backgrounds, graphics, icons, photos
├── styles/                      # CSS — theme, global, grid, components, utilities
├── js/                          # JavaScript modules
└── docs/
    ├── ARCHITECTURE.md          # System overview and structural decisions
    ├── SYSTEM.md                # Developer rules and naming conventions
    ├── architecture/            # Detailed architecture docs (11 files)
    │   └── template-examples/   # Reference templates (server-side, standards, Gemini)
    ├── plan/                    # Session management system
    │   └── tasklist.md          # Tracked template (rest of dir is gitignored)
    ├── security-sweep-playbook.md  # Two-phase security playbook
    └── init/                    # Setup instructions (delete once configured)
```

---

## Documentation

- [ARCHITECTURE.md](./docs/ARCHITECTURE.md) — system overview, data flows, structural decisions
- [SYSTEM.md](./docs/SYSTEM.md) — developer rules, naming conventions, never-do constraints
- [CORE_PATTERNS.md](./docs/architecture/CORE_PATTERNS.md) — G1–G13 constraints and code patterns
- [DECISIONS.md](./docs/architecture/DECISIONS.md) — architecture decision records
- [plan-rules.md](./docs/plan/plan-rules.md) — session operating rules
- [CLAUDE_ARCHITECTURE.md](./docs/architecture/CLAUDE_ARCHITECTURE.md) — how to read this doc system

---

See `CLAUDE.md` for full development conventions, coding standards, and workflow rules.

---

## Why Use This With Claude

Claude Code is a powerful coding partner — but it has no memory between sessions. Every time you start a new conversation, Claude begins from scratch. Without a structured context system, you spend the first part of every session re-explaining the project, rediscovering decisions that were already made, and hoping Claude doesn't drift from the patterns you established last time.

This scaffold solves that problem.

**The fundamental issue:** AI-assisted development accumulates drift. Decisions made in one session aren't recorded. Docs fall behind the code. The next session re-derives context from scratch — and sometimes gets it wrong. The same mistakes recur. Good patterns silently erode.

**What this gives you instead:**

- Claude loads a known, minimal set of docs at session start — enough to work effectively, not so much that context is wasted
- Every code change is checked against documented constraints before it's written
- Architecture docs stay in sync with the code via a post-session sync step
- Decisions are recorded with their rationale, so they're never revisited without reason
- A second model (Gemini) can audit from outside the session when you're stuck or making a hard-to-reverse choice

**The session loop in practice:**

```
/session-start   → Load context (handoff + tasks + architecture constraints)
/arch-check      → Verify planned change doesn't violate any constraint
[code work]
/sync-arch       → Update docs to match what changed
/session-synthesis → Cross-session audit; write handoff for next session
```

Each session hands off cleanly to the next. Context doesn't degrade. Architectural quality compounds rather than drifts.

**This is particularly valuable when:**
- You work across multiple sessions on the same project
- Multiple people (or AI sessions) touch the same codebase
- You want Claude to enforce consistent code quality without repeating yourself every session
- You're making architectural decisions that need to survive future context resets

 -- Claude Sonnet 4.6
