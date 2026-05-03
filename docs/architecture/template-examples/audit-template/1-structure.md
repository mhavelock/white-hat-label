# Audit YYYY-MM-DD — 1. Structure

> **Sample chunk — project structure, file organisation, naming. Replace `YYYY-MM-DD` with your audit date and copy into `docs/architecture/audit-YYYY-MM-DD/1-structure.md`.**

---

## Scope

In scope:

- Top-level directory layout.
- File organisation within `styles/`, `js/`, `assets/`, `docs/`.
- File naming patterns (kebab-case, casing consistency).
- Tracked vs untracked files (`.gitignore` correctness).
- Empty directories, orphaned files, dead code.

Out of scope:

- Code conventions inside files (covered by `2-conventions.md`).
- Build artefacts and dependencies (`node_modules/`, `dist/`).
- Framework-specific structure rules (covered by stack-specific chunks).

---

## Questions

1. Does the top-level layout match the structure documented in `CLAUDE.md`?
2. Are there files at the root that should live in subdirectories (or vice versa)?
3. Does every subdirectory have a clear single purpose? (No "misc/" or "stuff/" anti-patterns.)
4. Are filenames consistent — kebab-case for assets, kebab-case or PascalCase for source per stack convention?
5. Are there orphaned files — unreferenced from any HTML/JS/CSS, never imported, never linked?
6. Are there empty directories left over from refactors?
7. Are tracked files actually intended to be tracked? (Common offenders: `.DS_Store`, editor swap files, build outputs, plan workspaces.)
8. Are gitignored paths actually getting excluded? (`git check-ignore -v <path>` to verify.)
9. Does the file structure scale? (Adding a 50th component shouldn't require restructuring.)
10. Are protected files documented? (CLAUDE.md "Do not modify" list current?)

---

## How to gather evidence

```bash
# Top-level inventory
ls -la

# All tracked files grouped by directory
git ls-files | awk -F/ '{print $1}' | sort -u

# Files at root (should be small, well-known set)
git ls-files | grep -v '/'

# Find empty directories
find . -type d -empty -not -path '*/node_modules/*' -not -path '*/.git/*'

# Find files matching common cruft patterns
git ls-files | grep -E '\.(DS_Store|swp|swo|bak)$|~$'

# Verify .gitignore is doing its job
git check-ignore -v docs/plan/some-handoff.md
git check-ignore -v .claude/logs/edits.log

# Look for orphaned CSS — classes defined but never used in HTML
# (rough heuristic; manual review still required)
grep -rh 'class="' --include='*.html' | grep -oE 'class="[^"]*"' | sort -u
```

---

## Findings

### ✅ Wins

- [Document patterns that work — e.g. "Top-level layout exactly matches `CLAUDE.md` § File Structure"]
- [Document patterns that work — e.g. "All asset filenames are kebab-case, no exceptions"]

### ⚠️ Limits

- [Document accepted constraints — e.g. "`docs/architecture/` has 14 files, near the readability ceiling for a dir listing"]

### ❌ Issues

- [Document violations — e.g. "`utils-old.js` referenced in no HTML, candidate for deletion"]
- [Document violations — e.g. "Two empty directories: `assets/icons-old/`, `js/legacy/`"]

---

## Actions

- [ ] (H) [Action] — [owner], [due]
- [ ] (M) [Action]
- [ ] (L) [Action]

---

## See also

- `CLAUDE.md` § File Structure — the documented layout.
- `SYSTEM.md` — naming conventions reference.
- `FEEDBACK-LOOPS.md` — durable home for confirmed wins/limits.
