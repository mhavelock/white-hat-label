# DECISIONS.md — Architecture Decision Records

Key technical decisions made during development. Each entry captures the choice, the alternatives considered, and the actual reason — so future sessions don't relitigate them or regress them by accident.

---

## How to use this file

When a significant technical decision is made — a choice that would be expensive to reverse, or one where the reason isn't obvious from the code — add an ADR here. This is the institutional memory that keeps decisions visible.

**Format:**
- **Decision:** What was decided (one sentence).
- **Context:** Why this decision was needed.
- **Alternatives:** What else was considered.
- **Why [chosen option]:** The actual reason.

---

## ADR-001: [Decision name]

**Decision:** [One sentence — what was decided.]

**Context:** [Why this decision came up. What constraint, requirement, or problem triggered it.]

**Alternatives:**
- [Option A] — [why it was rejected]
- [Option B] — [why it was rejected]

**Why [chosen option]:** [The actual reason this option was selected. Be specific — vague reasons like "it's better" don't survive context loss.]

---

## ADR-002: CSS custom properties as single source of truth

**Decision:** All colours, spacing, font sizes, and timing values are defined as `--custom-properties` in `styles/theme.css`. Never hardcoded at usage sites.

**Context:** The project has light and dark modes and may have page- or feature-specific themes. All need to stay consistent.

**Alternatives:**
- Hardcoded values — silently diverge across files as the codebase grows
- SASS variables — adds a build step; custom properties work in plain CSS and cascade at runtime

**Why custom properties:** One change to a token propagates everywhere automatically. Dark mode overrides are applied at `:root` level and cascade. Feature-specific namespaces (e.g. `--[feature]-*`) allow isolated tokens without collision. Custom properties are live — they can be updated at runtime by JS, which enables dynamic theming.

---

## ADR-003: Mobile-first, min-width breakpoints only

**Decision:** All media queries use `@media (min-width: ...)`. No `max-width` layout breakpoints anywhere.

**Context:** Responsive CSS needs to support a range of screen sizes cleanly without specificity conflicts.

**Alternatives:**
- `max-width` breakpoints — common approach, but creates overrides that compound and conflict

**Why min-width:** Base styles are the simplest case (mobile). Additional styles for larger screens layer on top. This creates a clean additive cascade — no overrides, no conflicts. Reversing `max-width` patterns later is expensive.

---

## ADR-004: [Add decisions here as the project grows]

**Decision:** [...]

**Context:** [...]

**Alternatives:**
- [...]

**Why [...]:** [...]
