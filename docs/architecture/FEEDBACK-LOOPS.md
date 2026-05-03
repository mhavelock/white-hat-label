# Feedback Loops — Wins, Limits, and Redirections

Documented feedback from real project history. These are the moments where a win was locked in, a limit was set deliberately, or a "no" led somewhere better. The purpose is to keep these gains active — so future sessions build on them rather than regressing them.

**Format:** What happened → The rule extracted → How to apply it.

---

## Category 1: Wins That Became Rules

### FL-01: CSS custom properties → No hardcoded values anywhere

**What happened:** [Describe a moment where hardcoded values caused a problem — e.g. a colour update broke in multiple places because it was hardcoded. Add your project's example here.]

**Win locked in:** All colour and spacing values moved to `styles/theme.css` as `--custom-properties`. One token change updates everywhere.

**Rule extracted:** Never hardcode a colour, spacing value, or timing duration in a component or page stylesheet. Define the token in `theme.css` first.

**How to apply:** Before adding any CSS value, check whether it should be a token. If it's a colour, spacing, or timing value — it's a token.

---

### FL-02: Mobile-first → Cleaner cascade, no override conflicts

**What happened:** [Add your project's example — e.g. a layout that worked on desktop but broke on mobile, traced back to `max-width` overrides conflicting.]

**Win locked in:** All breakpoints converted to `min-width`. Specificity conflicts resolved.

**Rule extracted:** Use `@media (min-width: ...)` always. Never use `max-width` for layout breakpoints.

**How to apply:** If writing a new media query and your hand reaches for `max-width`, stop. Start with the mobile base style and add complexity with `min-width`.

---

### FL-03: [Add your project's win here]

**What happened:** [...]

**Win locked in:** [...]

**Rule extracted:** [...]

**How to apply:** [...]

---

## Category 2: Limits Set Deliberately

### FL-04: Git push requires explicit user confirmation — never autonomous

**Limit:** Claude Code sessions never push to the remote repository autonomously. `git push` requires explicit user instruction and confirmation.

**Why:** A push to `main` deploys immediately to production. The cost of an accidental or premature push is immediate user-visible failure. The cost of asking before pushing is one prompt.

**How to apply:** Before running any `git push` command, explicitly confirm with the user: "Ready to push to [branch] — this will deploy immediately. Confirm?"

---

### FL-05: Protected files — no behavioural changes without explicit instruction

**Limit:** Files listed in `ARCHITECTURE.md §"Protected files"` may not have their core behaviour changed without explicit instruction and a new ADR.

**Why:** Protected files define core functionality or structure that other parts of the project depend on. Casual changes to them are high-risk.

**How to apply:** If a change to a protected file is proposed, ask: "Is this a performance optimisation or bug fix, or is it changing behaviour?" If it's changing behaviour, stop and confirm.

---

## Category 3: Hard Rules (No Exceptions Without ADR)

### FL-06: No inline styles anywhere

Inline styles bypass the design token system, create specificity issues, and are invisible to CSS tooling. No exceptions without an explicit ADR.

### FL-07: No `max-width` layout breakpoints

`max-width` creates overrides that compound. Mobile-first `min-width` layers cleanly. All existing stylesheets comply. New code must comply.

### FL-08: No `!important`

`!important` is specificity debt. Find the correct specificity-ordered solution. One exception allowed: `!important` in `prefers-reduced-motion` blocks to ensure accessibility overrides work — but only there.

### FL-09: No `innerHTML` with dynamic content

XSS risk. Use `textContent`, `createElement`, or a trusted sanitisation library. No exceptions for user-supplied content.

---

## Category 4: Security & Public-Repo Hygiene

### FL-10: entire.io session-tracker leak — assume hostile defaults on third-party tools

**What happened:** On 2026-05-03 a routine `git branch -r` on this public repo revealed `origin/entire/checkpoints/v1` — 9 commits of full session transcripts pushed automatically by entire.io's default-on push behaviour. No credentials leaked, but full conversation context was world-readable. Remediation required `git filter-repo`, force-push, branch protection, and a repeatable security-sweep playbook. See `BREAKTHROUGHS.md` B-01 and `qref/qr-public-repo-hygiene.md`.

**Win locked in:** Two-phase security playbook adopted (ADR-005). Branch protection on `main` (ADR-006). Session-tracker opt-out before first use (ADR-007). Three new gitignore patterns: `.entire/`, `.aider/`, `.cursor/` derivatives.

**Rule extracted:** Any third-party tool that touches version control or pushes artefacts is a leak vector until proven otherwise. The cost of opting out before first use is trivial; the cost of remediation is permanent and incomplete (anything cloned during the leak window is already out).

**How to apply:**
1. Before adopting any AI tool that integrates with git (session trackers, AI commit-message generators, agentic dev tools), check the docs for default push / sync behaviour.
2. If default-on push exists, opt out before the first run — not as a remediation step.
3. Add a matching gitignore pattern even if the tool claims to manage its own paths.
4. Run Phase 0 of the security playbook (3-min triage) at every major release as a backstop.
5. On a public repo, treat every commit as world-readable and every branch as a publishing surface — include `entire/`, `aider/`, and similar patterns in the protected-branch posture.
