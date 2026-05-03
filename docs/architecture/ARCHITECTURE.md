# Architecture — [PROJECT_NAME]

> L1 — Load for every session alongside `CLAUDE_MAINDOCS_INDEX.md`. This is what the project is, how it is structured, and what it never does. The MAINDOCS_INDEX is *current state* (changes session-to-session); this file is *rules and structure* (changes rarely).

---

## Summary

[One paragraph: what this system is, what it does, and who it's for. Written so a developer who has never seen it can orient in 30 seconds.]

---

## Stack

| Layer | Technology | Notes |
|-------|-----------|-------|
| Markup | [e.g. HTML5] | [any constraints] |
| Presentation | [e.g. CSS3 / Tailwind] | [any constraints] |
| Behaviour | [e.g. Vanilla JS / React / Next.js] | [any constraints] |
| State | [e.g. Zustand / Redux / Context] | [any constraints] |
| Data / API | [e.g. REST / GraphQL / Supabase] | [any constraints] |
| Hosting | [e.g. Vercel / GitHub Pages] | [any constraints] |

---

## Core Structural Decisions

[The 3–5 decisions that define how this codebase is shaped — not preferences, but choices with real consequences if violated.]

1. **[Decision name]** — [What was decided and why. What problem it solves. What would break if reversed.]
2. **[Decision name]** — [...]
3. **[Decision name]** — [...]

For the full ADR register (why each decision was made, alternatives considered), see `DECISIONS.md`.

---

## File Structure

```
[Define once the project is scaffolded — list key directories and their responsibilities]
```

---

## Data Flow

[Describe how data moves through the system — from user input to render output. Use a simple diagram or numbered steps.]

```
[User action] → [State / Store] → [API call] → [Response] → [Render]
```

---

## What We Never Do

These are absolute constraints. Violations require a new ADR, not just a comment.

- [Example: Never commit API keys or secrets to git]
- [Example: Never use inline styles — CSS classes and custom properties only]
- [Example: Never use `innerHTML` with dynamic content — XSS risk]
- [Add project-specific constraints as they are established]

The compact checklist form of these rules is in `CORE_PATTERNS.md` (G1–G15 table).

---

## Key Integrations

| Service | Purpose | Notes |
|---------|---------|-------|
| [e.g. Supabase] | [e.g. Auth + DB] | [any constraints or gotchas] |
| [e.g. Cloudinary] | [e.g. Image CDN] | [any constraints or gotchas] |

---

## Performance Targets

- **PageSpeed:** ≥ 95 mobile and desktop
- **[Add project-specific targets — e.g. LCP < 2.5s, no layout shift on load]**
