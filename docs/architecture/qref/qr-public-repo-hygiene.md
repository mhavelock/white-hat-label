# qr-public-repo-hygiene: Keeping a public repo actually private where it counts

> **A public GitHub/GitLab repo leaks more than just the source. Session-tracker artefacts, plan workspaces, hardcoded paths, and stale `settings.local.json` entries all become world-readable. This qref documents the four most common leak vectors and the controls that close them.**

---

## Symptom

You make a repo public (or it has been public all along) and discover one or more of:

- A `entire/checkpoints/v1` (or similar) shadow branch on `origin` containing full Claude Code session transcripts — IP, process, conversation history.
- `docs/plan/` or equivalent workspace containing handoffs, working notes, draft plans — visible at the canonical URL.
- `.claude/hooks/*.sh` scripts containing `/Users/<your-name>/...` hardcoded paths — leaks your local username.
- `.claude/settings.local.json` accumulated with permissions like `Read(~/.zshrc)` or `Bash(git filter-repo *)` — reveals your tooling and home-dir layout.
- Vendor-prefixed environment variables (`NEXT_PUBLIC_*`, `VITE_*`) leaked through client bundle output that sits in a public deploy artefact.

None of these need a credential to leak. Just `git clone` and `cat`.

---

## Root cause

Public repos default to "everything tracked is public." Tracked-by-accident is the common failure mode:

1. **Session trackers like entire.io auto-push checkpoint branches** unless explicitly opted out (`entire enable --skip-push-sessions`). Those checkpoints are full transcript dumps.
2. **Plan workspaces start as scratch files** and get committed before they're sanitised. A `.gitignore` exception for `tasklist.md` is fine; the rest of `docs/plan/**` should never reach origin.
3. **Hooks written on one machine** carry that machine's absolute paths. Forks inherit them and start logging to a directory they don't have.
4. **`settings.local.json` accumulates** as Claude Code asks for permission and you allow. The granted permissions persist; the rationale doesn't. After 6 months, the file is a portrait of your dev environment.
5. **Client bundles are static artefacts.** Vercel / Netlify / Cloudflare Pages serve `_next/static/*` (or equivalent) including any value injected via `NEXT_PUBLIC_*`. That's the contract — `NEXT_PUBLIC_` means "I'm okay with the world reading this."

---

## Worked example — the `.entire/` leak (white-hat-label, 2026-05-03)

A routine `git branch -r` on this repo showed:

```
origin/main
origin/entire/checkpoints/v1   ← unexpected
```

`git log origin/entire/checkpoints/v1 --oneline | wc -l` returned 9. Each commit was an `entire.io` session checkpoint pushed automatically. `git show` on any of them revealed full conversation transcripts — code, prompts, my reasoning, vendor names, internal process notes. **No credentials**, but high-context IP and signal about how I work.

What had happened:

```bash
# entire.io's default behaviour
$ entire enable
# silently subscribes to push checkpoint branches to origin
```

The fix sequence (do not skip steps — order matters):

```bash
# 1. Stop future leakage
entire enable --skip-push-sessions

# 2. Remove from history (filter-repo, not filter-branch — much faster)
git filter-repo --invert-paths --path .entire/

# 3. Delete the remote shadow branches
git push origin --delete entire/checkpoints/v1

# 4. Delete the local shadow branches
git branch | grep entire/ | xargs git branch -D

# 5. Force-push the cleaned main
git push --force-with-lease origin main

# 6. Add to .gitignore
echo ".entire/" >> .gitignore && git commit -am "chore: ignore .entire/"
```

Force-push to a public repo does **not** undo what's already been cloned. If a credential leaked, the only safe path is rotation. For IP/process leaks, a force-push limits future readers — accept that anyone who cloned during the leak window has a copy.

---

## Remedy — the four controls

### 1. Branch protection on `main`

```bash
gh api -X PUT repos/<owner>/<repo>/branches/main/protection \
  --input - <<'JSON'
{
  "required_status_checks": null,
  "enforce_admins": false,
  "required_pull_request_reviews": null,
  "restrictions": null,
  "allow_force_pushes": false,
  "allow_deletions": false
}
JSON
```

`enforce_admins: false` lets the owner bypass for legitimate emergency rewrites (like the filter-repo above). Don't use it casually.

### 2. Secret-scanning push protection

GitHub: Settings → Code security → Secret scanning → **Push protection: enabled**. Rejects pushes that contain detected secrets *before* they reach origin. If a push is rejected, **rotate the secret first**, then strip from history. Never bypass.

### 3. `.gitignore` for session and plan artefacts

```
# Session trackers
.entire/
.aider/
.cursor/

# Hook outputs (project-local fallback for $COWORK_LOG_DIR / $COWORK_BACKUP_DIR)
.claude/logs/
.claude/.backups/

# Plan workspace — only tasklist.md template is tracked
/docs/plan/**
!/docs/plan/tasklist.md
```

The `!` exception keeps the tracked template alive while ignoring everything else under `docs/plan/`.

### 4. Env-var driven hook paths

In `.claude/hooks/*.sh`:

```bash
LOG_DIR="${COWORK_LOG_DIR:-$(git rev-parse --show-toplevel)/.claude/logs}"
mkdir -p "$LOG_DIR"
```

If `$COWORK_LOG_DIR` is set (e.g. for cross-project log aggregation), use it. Otherwise fall back to a project-local directory that `.gitignore` already excludes. **Never** `/Users/<name>/...` literals.

See `qr-claude-code-hooks.md` for the full hook portability pattern.

---

## Two-phase playbook

This repo's `docs/security-sweep-playbook.md` formalises a routine sweep:

- **Phase 0** — 3-min triage: check `git log -- .env*`, search bundle output for `NEXT_PUBLIC_*` / `VITE_*` leaks, scan `.gitignore` for session-tracker entries.
- **Phase 1** — full audit: produces a status table (this repo's lives at `docs/security-phase1-2026-05-03.md`).

Run Phase 0 before any major release or quarterly. Run Phase 1 before going public for the first time.

---

## See also

- `docs/security-sweep-playbook.md` — the full playbook this qref distils.
- `docs/security-phase1-2026-05-03.md` — Phase 1 deliverable for this repo.
- `BREAKTHROUGHS.md` — root-cause record for the `.entire/` leak.
- `DECISIONS.md` — ADR for branch protection on `main`.
- GitHub docs: [Branch protection rules](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches), [Secret scanning push protection](https://docs.github.com/en/code-security/secret-scanning/protecting-pushes-with-secret-scanning).
