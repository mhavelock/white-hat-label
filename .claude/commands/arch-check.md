Before making any code changes, perform an architecture check:

1. Read `docs/architecture/ARCHITECTURE.md` — focus on §"What We Never Do" and the section most relevant to the planned change.
2. Read `docs/architecture/SYSTEM.md` — focus on naming conventions, component patterns, and the section most relevant to the planned change.
3. Read `docs/architecture/CORE_PATTERNS.md` — extract every rule listed under "Never Do", "Hard Rules", or equivalent constraint sections.
4. Identify which of those project-specific rules apply to this change.
5. Confirm the change does not violate any extracted constraint.
6. Report: "Architecture check complete — no violations" OR list any conflicts found with the relevant rule and file reference.
