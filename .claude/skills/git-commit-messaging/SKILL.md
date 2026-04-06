---
name: git-commit-messaging
description: >
  Generates git commit messages following the Conventional Commits specification (type(scope): description format).
  Trigger this skill whenever the output is a git commit message — regardless of how the user phrases it.
  Trigger phrases include: "write a commit", "commit message", "commit this", "what should my commit say",
  "help me commit", "git commit -m", "commit message for this PR/change/fix/feature", or any time the user
  describes code changes and wants them summarised for a commit. Works from diffs, staged changes, or plain
  English descriptions of what was done. Also trigger for "conventional commits" questions.
  Do NOT trigger for: PR descriptions, changelogs, release notes, git explanations, PR reviews, or rebase help —
  those are different outputs even if they mention commits.
---

# Git Commit Messaging

Generate commit messages that conform to the [Conventional Commits](https://www.conventionalcommits.org/) specification. These messages are machine-readable, human-friendly, and form the backbone of semantic versioning and automated changelogs.

---

## Message Structure

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

Every part serves a purpose. The type + description line is the minimum viable commit. Body and footers add depth when changes are complex or have downstream implications.

---

## Types

| Type | When to use |
|------|-------------|
| `feat` | New feature or capability added to the codebase |
| `fix` | Bug fix — patches broken behaviour |
| `docs` | Documentation only (README, comments, JSDoc) |
| `style` | Formatting, whitespace, semicolons — no logic change |
| `refactor` | Code restructured without adding features or fixing bugs |
| `perf` | Performance improvement |
| `test` | Adding or correcting tests |
| `build` | Build system, dependencies, package.json, webpack, etc. |
| `ci` | CI/CD configuration (GitHub Actions, CircleCI, etc.) |
| `chore` | Maintenance tasks that don't affect src or test files |
| `revert` | Reverts a previous commit |

When in doubt between two types, pick the one that best describes the *primary intent* of the change.

---

## Scope (optional)

A noun in parentheses describing which part of the codebase was changed:

```
feat(auth): add OAuth2 login flow
fix(cart): prevent negative quantity values
refactor(api): extract rate-limiting middleware
```

Use scope when it meaningfully narrows context. Omit it when the change is broad or the repo is small. Scope should match the team's existing conventions if any exist — check recent commits for patterns.

---

## Description

- Immediately follows the `: ` after type/scope
- Imperative mood, present tense: `add`, `fix`, `update` — not `added`, `fixes`, `updating`
- No capital letter at the start
- No full stop at the end
- Under 72 characters ideally; definitely under 100

Good: `fix(parser): handle empty array edge case`
Bad: `Fixed the parser to handle arrays that are empty.`

---

## Body (optional)

Include a body when the *why* or *how* isn't obvious from the description alone. Separate from the description with one blank line.

```
feat(checkout): add address validation on submit

Previously, invalid addresses could reach the payment step, causing
silent failures in the Stripe webhook. Validation now runs client-side
on form submit and server-side before charge creation.
```

The body is free-form. Write as many paragraphs as needed. Focus on motivation and context, not a line-by-line description of code (the diff does that).

---

## Footers (optional)

Footers follow the body (or description, if no body), separated by a blank line. Each footer is a token, a separator, and a value:

```
Reviewed-by: Alice <alice@example.com>
Refs: #142
BREAKING CHANGE: the `parseConfig` function now requires an options object
```

**Breaking changes** must be flagged one of two ways:

1. Footer: `BREAKING CHANGE: <description of what changed and migration path>`
2. `!` in the type/scope prefix: `feat(config)!: require options object in parseConfig`

Both are valid. You can use both together. If using `!`, you may omit the footer, but the footer gives consumers more migration detail.

---

## Worked examples

**Simple bugfix:**
```
fix(nav): correct active link highlight on mobile
```

**New feature with scope:**
```
feat(search): add debounced autocomplete to product search
```

**Refactor with body:**
```
refactor(db): replace raw queries with query builder

Direct SQL strings were scattered across three service files, making
schema changes risky. Centralised through Knex query builder to
improve testability and allow easier schema migrations.
```

**Breaking change with footer:**
```
feat(api)!: remove v1 endpoints

BREAKING CHANGE: /api/v1/* routes have been removed. Migrate to /api/v2/*.
See migration guide at docs/v2-migration.md.
```

**Dependency update:**
```
build(deps): upgrade Tailwind to v4

Refs: #201
```

**Multi-footer commit:**
```
fix(auth): prevent session hijack on logout

Clear all active session tokens on logout rather than just the
current one, to invalidate concurrent sessions.

Reviewed-by: Mat Havelock <mat@example.com>
Fixes: #87
```

---

## Working from staged changes or a diff

When the user asks you to generate a commit message from their current changes:

1. Run `git diff --staged` (or `git diff HEAD` if nothing is staged) to read the actual diff
2. Identify the primary intent — what is fundamentally changing?
3. Identify the scope — which module, component, or file area is the focus?
4. Check for breaking changes — are any public APIs, interfaces, or contracts altered?
5. Draft the message and show it to the user before running `git commit`

If the diff spans multiple unrelated concerns, flag this. A commit should ideally represent one logical change. You can suggest splitting if appropriate, but don't be pedantic about it — real projects often have mixed commits.

---

## Working from a description

When the user describes what they did in plain English:

- Extract the type from what was accomplished
- Extract the scope from what area was affected
- Rewrite the description in imperative form
- Ask if there's a body-worthy reason for the change (only if it's non-obvious)
- Propose the message and confirm before committing

---

## Checking existing conventions

Before generating a message, if the repo has a commit history, it's worth a quick glance:

```bash
git log --oneline -10
```

Match existing scope naming conventions if they're consistent. If the project already uses `feat(ui):` don't introduce `feat(frontend):` without reason.

---

## Output format

Always present the commit message in a code block so it's easy to copy:

```
feat(auth): add JWT refresh token rotation

Refresh tokens are now single-use and rotated on each request.
Previous tokens are invalidated immediately, reducing the window
for token theft.

BREAKING CHANGE: clients must handle 401 responses and re-authenticate
when a refresh token is rejected.
```

Then offer to run the commit directly if the user wants, using:

```bash
git commit -m "$(cat <<'EOF'
<message here>
EOF
)"
```

Use the heredoc form to preserve multiline messages correctly.
