# Serverside — [PROJECT_NAME]

> **Template skeleton.** Fill in the project-specific values. Delete sections that don't apply. Add sections for serverside components this project uses.
>
> The live values (current env vars, current build status, current secrets-rotation state) live in `CLAUDE_MAINDOCS_INDEX.md` § Environment Variables and § Settings — Current State of Play. This file is the reference *shape*; the MAINDOCS_INDEX is the current values. Don't duplicate.

---

## Overview

| Type | Value |
|------|-------|
| Architecture | [Static site / SPA / Full-stack / Headless CMS / etc.] |
| Backend | [None / Node.js / PHP / Python / etc.] |
| Database | [None / PostgreSQL / MySQL / Supabase / etc.] |
| Auth | [None / NextAuth / Auth0 / Clerk / etc.] |

---

## Hosting

| Component | Details |
|-----------|---------|
| Host | [GitHub Pages / Vercel / Cloudflare Pages / Netlify / Fly.io / etc.] |
| Source branch | `main` |
| Build step | [None — files served as-is / `npm run build` / `next build` / etc.] |
| HTTPS | [Enforced automatically / manual SSL config] |
| CDN | [Provider CDN / Cloudflare / None] |
| Preview deploys | [Yes — automatic per-PR / Yes — per-branch / No] |

### Vercel-specific (if hosting on Vercel)

| Component | Details |
|-----------|---------|
| Project ID | [from Vercel dashboard → Project Settings] |
| Production branch | `main` (deploys on push) |
| Preview branches | `dev` + feature branches (deploys on push) |
| Env var scopes | Production / Preview / Development — set in Vercel dashboard, sync with `vercel env pull .env.local` |
| Build command | [auto-detected / `next build` / custom] |
| Output directory | [auto-detected / `.next/` / `dist/`] |
| Cron jobs | [Yes — defined in `vercel.json` / No] |
| Speed Insights | [Enabled / Disabled] |

---

## Domain

| Component | Details |
|-----------|---------|
| Domain | [domain.com] |
| DNS provider | [Cloudflare / Namecheap / Google / etc.] |
| CNAME / A record target | [hosting-provider.io] |
| CNAME file | [`CNAME` in repo root] — required for GitHub Pages custom domains |

---

## Environment Variables

| Variable | Purpose | Required in production |
|----------|---------|----------------------|
| `[VAR_NAME]` | [What it does] | Yes / No |

> Store secrets in [GitHub Actions Secrets / Vercel env / .env (never committed)].

---

## What This Project Does NOT Have

Any suggestion to add the following requires a new ADR:

- [List things that are intentionally absent for this project]
- Example: No server-side database (settings stored in `localStorage`)
- Example: No authentication
- Example: No analytics on the main page

---

## Security Posture

| Concern | Approach |
|---------|----------|
| User data | [What data is collected, where it's stored] |
| External links | All `target="_blank"` use `rel="noopener noreferrer"` |
| Dynamic content | No `innerHTML` with untrusted input — `textContent` or DOM methods only |
| Dependencies | [Zero / Minimal / Regularly audited — `npm audit`] |
| Secrets | Never committed to git — stored in environment variables |

---

## CI/CD Pipeline

| Step | Tool | Trigger |
|------|------|---------|
| [Test / Build / Deploy / etc.] | [GitHub Actions / Vercel / etc.] | [push to main / PR / etc.] |

---

## Monitoring

| What | How |
|------|-----|
| Uptime | [Check [domain.com] directly / StatusPage / UptimeRobot] |
| Errors | [Browser console / Sentry / CloudWatch / None] |
| Deploy status | [GitHub Pages / Vercel dashboard / GitHub Actions tab] |
