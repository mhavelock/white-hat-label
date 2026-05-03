# Audit Template — Chunked Codebase Audit

> **A pattern for running a periodic structured audit of a project, broken into 8–15 focused chunks. Each chunk addresses one concern. Findings flow to `FEEDBACK-LOOPS.md` (wins/limits/rules) and `DECISIONS.md` (new ADRs). The audit itself lives in a dated directory: `docs/architecture/audit-YYYY-MM-DD/`.**

---

## Why a chunked audit

A monolithic "review the whole codebase" prompt produces shallow output. The model can't hold every concern at once, and the user can't review a 4,000-word response.

Chunking solves both:

- **Each chunk is 5–15 minutes of focused work.** One concern. One section of the codebase. One output.
- **Each chunk is independently committable.** You can pause between chunks; you can skip chunks that don't apply.
- **Findings accumulate.** The final cross-chunk synthesis writes to `FEEDBACK-LOOPS.md` once, with the full context.

For tiny projects (< 5 conventions, < 10 source files), skip the audit pattern entirely. For projects that have grown past the point where one person can hold the whole thing in their head, it earns its bureaucratic weight.

---

## When to run an audit

- **Before a major release.** Verify the current state matches the rules.
- **After a major refactor.** Verify the new state is consistent.
- **Quarterly cadence** for active projects. Drift accumulates faster than you think.
- **When something feels off** but you can't articulate what. The audit's structure surfaces unknown unknowns.

Don't run an audit:

- Mid-feature (you'll just add noise to your in-flight work).
- During a freeze (audits surface findings that may need urgent action; freezes prevent action).
- Because of vague anxiety (chase the specific concern first; if that turns out structural, *then* audit).

---

## Directory structure

```
docs/architecture/audit-YYYY-MM-DD/
├── README.md           # what this audit covers, who ran it, summary findings
├── 1-structure.md      # project structure, file organisation, naming
├── 2-conventions.md    # CSS / JS / HTML conventions, code patterns
├── 3-performance.md    # Core Web Vitals, Lighthouse, bundle size
├── 4-security.md       # public-repo posture, secrets handling, env vars
├── 5-accessibility.md  # WCAG conformance, keyboard nav, screen readers
├── 6-seo.md            # meta tags, structured data, canonical URLs
├── ...                 # add chunks as the project's surface grows
└── FINDINGS.md         # cross-chunk synthesis — what to do next
```

The naming convention `N-topic.md` keeps the chunks ordered for sequential reading. The number is presentational only — gaps are fine, reordering is fine, skipping numbers is fine.

---

## Chunk file structure

Every chunk follows this skeleton:

```markdown
# Audit YYYY-MM-DD — N. <Topic>

> **One-sentence framing.** What this chunk audits and why.

## Scope
- What's in scope (file globs, conventions, behaviours).
- What's deliberately out of scope (covered by another chunk, or not relevant).

## Questions
1. <First question to answer — phrased as a yes/no or a measurement>
2. <Second>
3. <...>

## Findings

### ✅ Wins
- Things that match the rules / are working well.

### ⚠️ Limits
- Things that work but have known constraints.

### ❌ Issues
- Things that violate rules or fail standards.

## Actions
- [ ] Action item 1 (severity: H/M/L)
- [ ] Action item 2

## See also
- Cross-refs to ADRs, BREAKTHROUGHS, qref files.
```

`✅ / ⚠️ / ❌` are intentional — they grep cleanly across the audit dir for a quick scan.

---

## Naming convention

```
docs/architecture/audit-YYYY-MM-DD/<N>-<kebab-topic>.md
```

- Lowercase. Kebab-case. Numeric prefix.
- The date is the audit *start* date (audits can span days; the directory name doesn't change).
- One chunk per file. Don't multiplex.

---

## Output format — what each chunk produces

A chunk's deliverable is **the chunk file itself**, plus updates to:

- **`FEEDBACK-LOOPS.md`** — for wins and limits worth keeping (rules confirmed, patterns validated, traps noted).
- **`DECISIONS.md`** — for any new ADR the chunk surfaces (typically: a finding that requires a decision the project hasn't yet made).
- **`tasklist.md`** — for action items.

The chunk file is the *evidence*; `FEEDBACK-LOOPS.md` and `DECISIONS.md` are the *durable outcome*. Don't skip the durable outcome — a chunk that just produces a chunk file decays into noise.

---

## Cross-chunk synthesis (FINDINGS.md)

After all chunks land, write `FINDINGS.md`:

```markdown
# Audit YYYY-MM-DD — Findings

## Top-level summary
<2–3 sentences. The shape of the project's current state.>

## Headline issues
1. <Issue> — chunk N. Severity. What to do.
2. <...>

## Wins worth preserving
- <Pattern> — chunk N. Why it works.

## Decisions surfaced
- <Decision needed> — chunk N. What's at stake.

## Action queue (priority order)
- [ ] (H) <action> — owner, due date.
- [ ] (M) <action>
- [ ] (L) <action>
```

`FINDINGS.md` is what the project lead reads. The chunk files are the receipts.

---

## Sample chunks

This template includes two worked starter chunks:

- `1-structure.md` — project structure audit
- `2-conventions.md` — convention conformance audit

Adapt them. They're starting points, not constraints.

---

## When to skip the audit pattern

- Project has < 5 conventions to audit against.
- Project has < 10 source files.
- Project is < 1 month old (run it as a one-off after the first month, when the shape has settled).
- The team is one person and the codebase fits in their head. (Cadence audits are still useful; the chunked structure is overkill.)

For small projects, the security playbook (`docs/security-sweep-playbook.md`) and the test programme in `CLAUDE.md` cover the same ground at lower ceremony.

---

## See also

- `CODEBASE-AUDIT.md` — the parent doc explaining audit approach.
- `REFLECTIVE-SYNC.md` — sync prompts that pair with audit cadences.
- `FEEDBACK-LOOPS.md` — durable home for findings.
- `DECISIONS.md` — durable home for new ADRs.
