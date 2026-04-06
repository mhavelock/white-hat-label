# Codebase Audit — Reference

Practical guidance for running effective audits. Covers what to exclude from context, how to chunk the codebase, and the audit criteria. Prompts and thinking modes live in `six-hats.md`.

---

## 1. Selective Context — The Exclusion List

These paths should not be loaded into AI context for audits. They are either binary, auto-generated, or irrelevant to code quality.

### Hard exclusions (never load)

```
.git/                           # version history — use git log/diff instead
assets/photos/                  # binary files
assets/graphics/                # visual assets
assets/bgs/                     # background images
*.ico, *.png, *.jpg, *.webp     # binary image files
site.webmanifest                # JSON manifest — rarely relevant
CNAME                           # single-line domain file
```

### Soft exclusions (load only if specifically relevant)

```
context/summaries/              # historical session summaries
js/logger.js                    # dev utility, not application logic
```

---

## 2. Audit Chunks

Break the codebase into chunks that fit within a single context load. Each chunk should be auditable in isolation.

| Chunk | Files | Focus |
|-------|-------|-------|
| **A1 — HTML** | `index.html`, `[other].html` | Semantics, accessibility, SEO, meta tags, script loading |
| **A2 — Core CSS** | `theme.css`, `global.css`, `grid.css`, `utilities.css` | Token system, base styles, breakpoints, utility classes |
| **A3 — Component CSS** | `components.css`, `badges.css`, `custom.css` | Component patterns, namespace isolation |
| **A4 — JS** | `main.js`, `[feature].js` | Module patterns, localStorage handling, event listeners |
| **A5 — Docs** | `docs/ARCHITECTURE.md`, `docs/SYSTEM.md`, `docs/architecture/CORE_PATTERNS.md` | Accuracy of docs vs actual code |

---

## 3. Audit Guidelines (G1–G13)

Check each chunk against the global constraints from `CORE_PATTERNS.md`. For each constraint, verdict: ✅ Pass / ⚠️ Warning / ❌ Fail.

| Constraint | Check |
|-----------|-------|
| G1 — No hardcoded CSS values | All colour/spacing references use `--custom-properties` |
| G2 — Mobile-first breakpoints | All `@media` use `min-width`; no `max-width` for layout |
| G3 — rAF not setInterval | Any animation loop uses `requestAnimationFrame` |
| G4 — visibilitychange pause | Any rAF loop pauses when `document.hidden` |
| G5 — Transform/opacity only | Animated properties never trigger layout |
| G6 — No `!important` | Specificity solved without `!important` |
| G7 — No inline styles | No `style` attribute in HTML |
| G8 — localStorage sanitised | All reads validated before use |
| G9 — No `var` | Only `const` and `let` in JS |
| G10 — Safe external links | All `target="_blank"` have `rel="noopener noreferrer"` |
| G11 — Image attributes | Every `<img>` has `alt`, `width`, `height` |
| G12 — No `innerHTML` with dynamic content | Dynamic content uses `textContent` or DOM methods |
| G13 — No font-size override | `html`/`body` font-size not set |

---

## 4. Standard Audit Prompt

Use this prompt to run a full audit chunk:

```
Read [list of files].
Then read docs/ARCHITECTURE.md §"What We Never Do" and docs/architecture/CORE_PATTERNS.md.

Audit the files against G1–G13. For each constraint, verdict: ✅ Pass / ⚠️ Warning / ❌ Fail.
List all failures and warnings with line numbers and specific fixes.
Also check for: code organisation improvements, unused CSS/JS, accessibility issues, and security concerns.
```

---

## 5. Post-Audit Checklist

After any audit session:

- [ ] All G1–G13 failures fixed
- [ ] `npx html-validate` passes — no errors or warnings
- [ ] `docs/ARCHITECTURE.md` updated if any structural decisions changed
- [ ] New constraints added to `CORE_PATTERNS.md` if any new patterns were established
- [ ] Tasks updated in `context/summaries/tasklist.md`
- [ ] Handoff written to `context/summaries/handoff_YYYY-MM-DD.md`
- [ ] Changes committed with `git-commit-messaging` skill
