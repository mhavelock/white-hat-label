# Security Sweep — Phase 1 status table (2026-05-03)

Run against `mhavelock/white-hat-label` per the playbook in `docs/security-sweep-playbook.md`. Threat model: **public-repo + beginner-clone-and-run.**

---

## Phase 0 deliverable (3-line summary)

```text
.env in history:        NONE
Vendor token hits:      NONE
Client-side env leaks:  NONE  (no client bundler — static HTML/CSS/JS for GitHub Pages)
```

All three checks clean — no urgent rotation needed. Proceeded to Phase 1 at normal pace.

---

## Phase 1 status table

| # | Area | Finding | Severity | Owner | Action / Status |
|---|------|---------|----------|-------|-----------------|
| 1 | Repo visibility | Public — `git@github.com:mhavelock/white-hat-label.git`, GitHub Pages live at `https://mhavelock.github.io/white-hat-label/` | INFO | — | Treat all committed history as published |
| 2 | Branches | Pre-sweep: 12 local + remote refs, including 9 `entire/*` shadow branches (8 local, 1 pushed to origin as `entire/checkpoints/v1`) | **CRITICAL** | Mat + Claude | **CLOSED** — see #4 |
| 3 | Tags | 0 | INFO | — | — |
| 4 | entire.io session-tracker leak | `.entire/` tracked on `main` (`.entire/.gitignore`, `.entire/settings.json`); session transcripts (`full.jsonl`, `prompt.txt`, `checkpoint.json`) committed to `entire/*` shadow branches; one branch (`entire/checkpoints/v1`) public on origin. Auto-pushed by entire.io's `pre-push` hook on every push. **Token scan across all transcripts: 0 hits** — no live vendor credentials leaked, but full session transcripts (file paths, prompts, tool outputs) world-readable. | **HIGH** | Mat + Claude | **CLOSED 2026-05-03** — `.entire/` added to `.gitignore`; tracked files removed; `git filter-repo --path .entire/` rewrote 62 commits; local + remote `entire/*` refs deleted; `entire enable --skip-push-sessions` configured (`.entire/settings.json` now has `"push_sessions": false`); GitHub branch protection added on `main` (`allow_force_pushes:false`, `allow_deletions:false`, `enforce_admins:false` so admin can still emergency-rewrite); force-push of cleaned history landed at `c4ece29`. |
| 5 | docs/plan/ private workspace exposure | 7 path×commit pairs in history: handoff templates, examples, archived handoffs, session summaries, plan-rules. Real session-work content on a public repo. | MEDIUM | Mat + Claude | **CLOSED 2026-05-03** — `git filter-repo --path docs/plan/` rewrote history; 4 commits dropped (touched only `docs/plan/`); only `docs/plan/tasklist.md` (sanitized template) re-added with `.gitignore` exception |
| 6 | `.gitignore` sanity | Pre-sweep: missing `.entire/`, missing `.claude/logs/` + `.claude/.backups/` (project-local hook fallbacks), missing `docs/plan/`. Had `# .claude` (commented) — visually misleading. | MEDIUM | Mat + Claude | **CLOSED** — all four added; `# .claude` left as a comment but no longer load-bearing |
| 7 | Five-grep history sweep | (1) `.env*`/secrets/credentials: NONE. (2) Vendor-prefixed tokens (Shopify/Stripe/OpenAI/Anthropic/OpenRouter/Resend/GitHub/GitLab/AWS/Slack/Webhook): 0 unique hits. (3) PEM private keys: 0. (4) JWTs: not run (low signal for static site). (5) `SECRET=`/`TOKEN=`/`PASSWORD=`/`API_KEY=`/`PRIVATE_KEY=`/`ACCESS_KEY=` lines: not run (low signal for static site). | INFO | — | Repo's history is genuinely clean of vendor credentials |
| 8 | Live-site headers | `https://mhavelock.github.io/white-hat-label/` — GitHub Pages serves with `https_enforced:true`. **No** `robots.txt`, `sitemap.xml`, `.well-known/security.txt` (all 404). No `X-Powered-By`, no Sentry DSN. | LOW | Mat | Add `SECURITY.md` + `.well-known/security.txt` for disclosure contact (best practice for public repos). Add `robots.txt` if you want to control crawlers. |
| 9 | Codebase env-var leaks (Phase-0 check 3) | Project is vanilla HTML/CSS/JS for GitHub Pages — no `app/`, `src/`, `components/` dirs; no client bundler. Sanity grep across `*.html`/`*.css`/`*.js`/`*.json` for token-shaped strings: 0. | INFO | — | N/A — static site, no `process.env.*` references possible |
| 10 | Hardcoded paths in tracked files (fork-readiness) | `.claude/hooks/change-log.sh:19` and `.claude/hooks/pre-edit-backup.sh:39` hardcoded `<USER>/Claudette/Cowork/...` log + backup dirs (broken for forks). `docs/init/setup.txt:210` referenced an absolute favicon path. | LOW | Claude | **CLOSED 2026-05-03** — hooks now read `$COWORK_LOG_DIR` / `$COWORK_BACKUP_DIR` env vars with project-local `.claude/logs/` and `.claude/.backups/` defaults; `docs/init/setup.txt` rewritten to use repo-relative path. |
| 11 | `.claude/settings.local.json` portability | 3 literal `<USER>/...` paths (1 broad-Read allow + 2 `<USER>/Documents` deny rules). | LOW (informational) | Mat | **Mat-decided**: keeps literal paths intentionally; deemed not worth the `${HOME}` portability change for forks |
| 12 | GitHub Pages deploy chain | Pages serves `main` branch root via `legacy` build (no Action workflow). `is_template: true`, `secret_scanning_push_protection: enabled` (server-side safety net would block any future push containing detected secrets). | INFO | — | Both findings are positive — push protection is the right control |
| 13 | Branch protection (pre-sweep) | None — `gh api .../branches/main/protection` returned 404. Force-push allowed. | LOW (was) | Mat | **CLOSED** — protection rule added on `main`: pattern `*`, `allow_force_pushes:false`, `allow_deletions:false`, `enforce_admins:false` |
| 14 | Open issues / PRs | 4 open issues (unaffected by force-push); no open PRs found. | INFO | — | — |
| 15 | Personal-account hygiene | Out of scope — see playbook §"Personal account hygiene". | — | Mat | Recommend periodic review of GitHub OAuth grants + SSH keys |

---

## Closed actions log

| Action | Commit / change | Date |
|--------|----------------|------|
| Untrack `.entire/` from index | `c4ece29` (was `1ae00b5` pre-second-rewrite) | 2026-05-03 |
| Strip `.entire/` from history | `git filter-repo --path .entire/` | 2026-05-03 |
| Delete local `entire/*` shadow branches | 8 branches via `git branch -D` | 2026-05-03 |
| Delete remote `entire/checkpoints/v1` | `git push origin --delete entire/checkpoints/v1` (Mat) | 2026-05-03 |
| Configure entire.io to skip auto-push | `entire enable --skip-push-sessions` (writes `"push_sessions": false`) | 2026-05-03 |
| Force-push cleaned `main` | `git push --force-with-lease origin main` (Mat) | 2026-05-03 |
| GitHub branch protection rule on `main` | UI: `allow_force_pushes:false` + `allow_deletions:false`, admin bypass on | 2026-05-03 |
| Hook paths made fork-portable | `fe42418` | 2026-05-03 |
| `docs/security-sweep-playbook.md` committed | `fe42418` | 2026-05-03 |
| Strip `docs/plan/` from history | `git filter-repo --path docs/plan/` (4 commits dropped) | 2026-05-03 |
| Re-add sanitized tasklist + `.gitignore` exception | `0da7a05` | 2026-05-03 |

---

## Recommended follow-ups

- [ ] Add `SECURITY.md` (disclosure contact) and `.well-known/security.txt` to lift item #8 above LOW.
- [ ] Consider adding a pre-commit hook that scans staged diff for token prefixes (`shpat_`, `sk_live_`, `ghp_`, `glpat-`, `AKIA`, etc.) — see playbook §"Lock the door behind you."
- [ ] Periodic re-run of Phase 0 (≤ 3 min) before any major release or quarterly.

---

## Per-project quick reference (fill-in)

```
Project: white-hat-label
Repo URL: https://github.com/mhavelock/white-hat-label
Visibility: public
Live URL: https://mhavelock.github.io/white-hat-label/
Vendor stack: GitHub Pages (no other vendors — static HTML/CSS/JS)
Last sweep: 2026-05-03
Hosted-env provider: GitHub Pages (legacy build from main)
Auth tokens to rotate (in order): N/A (static site, no auth)
Pre-commit hook installed: no
CI secret scan: yes (GitHub native — secret_scanning + push_protection both enabled)
```
