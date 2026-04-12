# Claude Templates — [PROJECT_NAME]

Prompt templates and document templates for use with Claude Code on this project.

---

## Template 1 — Code Review

Use after any significant change. Paste this prompt directly into Claude Code.

```
Taking into account the best practices docs in the project docs/ folder, please run a code review on what we have. Look for:
- Better code organisation
- Clean code improvements
- Performance improvements
- Browser memory usage issues
- Security issues

Update the md docs and memory file, then add and commit to git. Suggest any additional best practice improvements and anything important I may have forgotten. Check changes didn't break completed task functionality.
```

---

## Template 2 — Commit Message

Invoke the skill instead of writing manually:

```
/git-commit-messaging
```

Or describe the change and ask:

```
Write a commit message for: [describe what changed]
```

Format: `type(scope): description` — types: `feat` `fix` `style` `refactor` `docs` `perf` `test` `chore` `a11y` `seo`

Examples:
- `feat(nav): add mobile hamburger menu`
- `fix(form): validate email field on submit`
- `perf(images): add srcset for retina devices`
- `docs(architecture): update file structure section`
- `a11y(modal): add focus trap on open`

---

## Template 3 — New Feature Brief

Use to kick off a new feature implementation cleanly.

```
I want to add [feature name] to [PROJECT_NAME].

Context:
- [What it should do]
- [Where it lives — which page / component]
- [Any constraints — no external dependencies, must work without JS, etc.]

Before writing any code, please:
1. Read the relevant existing files
2. Confirm your approach with me
3. Then implement
```

---

## Template 4 — Bug Investigation

Use when diagnosing an unexpected behaviour.

```
[Describe the bug: what was expected, what actually happened]

Browser: [browser + version]
Console output:
[paste any console errors here]

Steps to reproduce:
1. [Step]
2. [Step]

Please:
1. Read the relevant files before proposing a fix
2. Identify the root cause (not just the symptom)
3. Confirm your diagnosis before changing code
```

---

## Template 5 — Session Handoff

### Light Handoff (tooling/config sessions with no code changes)

File path: `docs/plan/handoff-YYYY-MM-DD-[topic].md`

```markdown
# Session Handoff — YYYY-MM-DD — [Topic]

## Session Type
[Configuration / Docs / Research] — [brief qualifier]

## What Was Done

### Goal
[One sentence]

### Outcome
[Resolved / Partial / Blocked]

### Steps Covered
1. [Step]

## Key Facts Established

| Item | Value |
|------|-------|
| [Fact] | [Value] |

## State at Session End
- [What is working or resolved]

## Next Session
[What to pick up, or "No outstanding actions."]
```

### Full Handoff (feature/code sessions)

Use the full template in `docs/plan/handoff_template.md`.

---

## Template 6 — PageSpeed / Performance Audit

```
Please run a performance audit on the current state of the project.

Check against the criteria in CLAUDE.md (Performance Features section) and identify anything that would drop the PageSpeed score below 95 on mobile or desktop. List issues by priority.

Also check:
- CLS issues (missing image dimensions, layout shifts)
- Render-blocking resources
- Image optimisation opportunities
- Unused CSS or JS
```

---

## Template 7 — Accessibility Audit

```
Please run an accessibility audit on [page/component].

Check against WCAG 2.1 AA criteria:
- All images have descriptive alt text
- All form inputs have associated labels
- Colour contrast meets 4.5:1 for text, 3:1 for UI components
- All interactive elements are keyboard reachable
- Focus order is logical
- Focus indicators are visible
- Semantic HTML landmarks present
- Heading hierarchy is correct (one h1, sequential levels)
```

---

## Template 8 — GitHub Actions Workflow Debug

Use when a workflow fails in GitHub Actions.

```
The workflow [workflow-name] is failing. Here are the logs:
[paste logs]

Please identify the root cause and suggest a fix.
```

**Common causes checklist:**
- [ ] `CLAUDE_CODE_OAUTH_TOKEN` secret not set in repo Settings → Secrets → Actions
- [ ] Secret is a JSON blob — extract the raw token with:
  ```bash
  security find-generic-password -s "Claude Code-credentials" -w | jq -r '.claudeAiOauth.accessToken'
  ```
- [ ] `.github/aw/imports/` folder missing (must be copied manually when forking)
- [ ] Lock file (`.lock.yml`) missing — regenerate with `gh aw compile`

---

## Template 9 — Architecture Sync

Use to check whether docs still match code:

```
Read docs/ARCHITECTURE.md and docs/architecture/CORE_PATTERNS.md.
Then read [list of key files].

Are there any divergences between what the docs describe and what the code actually does?
List each divergence as: [Doc claim] vs [Actual code behaviour].
```

Use to check for internal contradictions:

```
Read docs/ARCHITECTURE.md, docs/SYSTEM.md, and docs/architecture/CORE_PATTERNS.md.
Identify the top 5 internal contradictions or tensions between these documents.
For each: quote both sides of the tension, and suggest a resolution.
```
