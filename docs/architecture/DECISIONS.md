# DECISIONS.md — Architecture Decision Records

Key technical decisions made during development. Each entry captures the choice, the alternatives considered, and the actual reason — so future sessions don't relitigate them or regress them by accident.

---

## How to use this file

When a significant technical decision is made — a choice that would be expensive to reverse, or one where the reason isn't obvious from the code — add an ADR here. This is the institutional memory that keeps decisions visible.

**Format:**
- **Decision:** What was decided (one sentence).
- **Context:** Why this decision was needed.
- **Alternatives:** What else was considered.
- **Why [chosen option]:** The actual reason.

---

## ADR-001: [Decision name]

**Decision:** [One sentence — what was decided.]

**Context:** [Why this decision came up. What constraint, requirement, or problem triggered it.]

**Alternatives:**
- [Option A] — [why it was rejected]
- [Option B] — [why it was rejected]

**Why [chosen option]:** [The actual reason this option was selected. Be specific — vague reasons like "it's better" don't survive context loss.]

---

## ADR-002: CSS custom properties as single source of truth

**Decision:** All colours, spacing, font sizes, and timing values are defined as `--custom-properties` in `styles/theme.css`. Never hardcoded at usage sites.

**Context:** The project has light and dark modes and may have page- or feature-specific themes. All need to stay consistent.

**Alternatives:**
- Hardcoded values — silently diverge across files as the codebase grows
- SASS variables — adds a build step; custom properties work in plain CSS and cascade at runtime

**Why custom properties:** One change to a token propagates everywhere automatically. Dark mode overrides are applied at `:root` level and cascade. Feature-specific namespaces (e.g. `--[feature]-*`) allow isolated tokens without collision. Custom properties are live — they can be updated at runtime by JS, which enables dynamic theming.

---

## ADR-003: Mobile-first, min-width breakpoints only

**Decision:** All media queries use `@media (min-width: ...)`. No `max-width` layout breakpoints anywhere.

**Context:** Responsive CSS needs to support a range of screen sizes cleanly without specificity conflicts.

**Alternatives:**
- `max-width` breakpoints — common approach, but creates overrides that compound and conflict

**Why min-width:** Base styles are the simplest case (mobile). Additional styles for larger screens layer on top. This creates a clean additive cascade — no overrides, no conflicts. Reversing `max-width` patterns later is expensive.

---

## ADR-004: [Add decisions here as the project grows]

**Decision:** [...]

**Context:** [...]

**Alternatives:**
- [...]

**Why [...]:** [...]

---

## ADR-005: Two-phase security playbook for public repos

**Decision:** Every public repo runs **Phase 0** (3-min triage) before any major release and **Phase 1** (full status table) before going public for the first time. Playbook lives at `docs/security-sweep-playbook.md`.

**Context:** White-hat-label was made public without a structured security sweep, leading to the discovery on 2026-05-03 of the entire.io session-tracker leak (full conversation transcripts published to a public branch). A repeatable playbook is the only way to catch this category of leak before it reaches origin.

**Alternatives:**
- Ad-hoc audits — relies on memory; fails the moment a session is rushed.
- Third-party scanner only (e.g. truffleHog, gitleaks) — catches credentials but misses IP/process leaks (transcripts contain no secrets), client-bundle env-var leakage, hardcoded user paths.
- Manual review at PR time — doesn't help on direct-to-main projects, and humans skim.

**Why two-phase playbook:** Phase 0 is small enough to run unprompted (3 minutes). Phase 1 produces a status table that future audits diff against — drift is visible. The playbook explicitly covers the categories third-party scanners miss (session-tracker artefacts, plan workspaces, vendor-prefixed env-var leakage). See `BREAKTHROUGHS.md` B-01 for the incident that drove this.

---

## ADR-006: Branch protection on `main`

**Decision:** GitHub branch protection on `main` with `allow_force_pushes: false`, `allow_deletions: false`, `enforce_admins: false` (admin bypass on for the owner).

**Context:** The 2026-05-03 security sweep required a `git filter-repo` + force-push to strip leaked content. Mid-sweep, the realisation: nothing was preventing an accidental force-push at any other moment. Branch protection was added after the sweep, with admin bypass retained for legitimate emergency rewrites.

**Alternatives:**
- No protection — the previous default; one mistyped command rewrites public history.
- Full lockdown (`enforce_admins: true`) — blocks Mat from running another emergency filter-repo; would have prevented the very sweep that surfaced the need for this ADR.
- Per-PR review required — overkill for a solo project; adds ceremony to every commit.

**Why protection-with-admin-bypass:** Default behaviour is now safe. The owner can still bypass when a legitimate emergency rewrite is needed (and is now expected to flag the bypass in commit history / handoff). The bypass is explicit, not implicit.

---

## ADR-007: `--skip-push-sessions` for any AI session-tracker on a public repo

**Decision:** Any AI session-tracker tool used on a public-repo project (entire.io, aider, cursor-derived equivalents) must be opted out of auto-push to origin **before first use**, not retroactively.

**Context:** entire.io's default behaviour pushes checkpoint branches to origin. On a public repo, those checkpoints are world-readable conversation transcripts. The opt-out flag exists (`entire enable --skip-push-sessions`) but is not the default.

**Alternatives:**
- Gitignore the artefact dir only — does not prevent the tool's own push hook firing; it pushes branches that don't touch the working tree.
- Post-hoc cleanup — once content is on a public origin, force-push limits future readers but cannot un-clone existing copies.
- Don't use session-trackers — viable, but throws away the value.

**Why opt-out-before-first-use:** The window between adopting a tool and discovering it leaks is the window during which the leak compounds. Opt-out is a one-time cost; remediation is permanent and incomplete. This pattern generalises to any third-party tool with default-on push behaviour — assume hostile, verify benign.
