Log a project breakthrough to the reflective architecture system.

---

## Process

1. **Read `docs/architecture/BREAKTHROUGHS.md`** to get the current highest B-N number and confirm the format.

2. **Gather the breakthrough details** — ask the user if needed:
   - What was the situation?
   - What were we tempted to do?
   - What did we actually do?
   - What is the lesson / rule extracted?

3. **Write B-(N+1)** in `BREAKTHROUGHS.md` using this structure:
   ```
   ## B-N: [Title]
   **Date:** YYYY-MM-DD
   **Session type:** [brief label]
   **Situation:** ...
   **Temptation:** ...
   **What we actually did:** ...
   **Lesson:** ...
   [**Rule extracted:** optional — if a reusable principle can be named]
   [**ADR reference:** optional]
   ```

4. **Write FL-(N) in `docs/architecture/FEEDBACK-LOOPS.md`** under the appropriate category (Category 1: Wins That Became Rules / Category 2: Limits Set Deliberately / Category 3: Redirections). Use this structure:
   ```
   ### FL-N: [Short title] → [Rule in one line]
   **What happened:** ...
   **Win locked in / Limit set / Redirection:** ...
   **Rule extracted:** ...
   **How to apply:** ...
   ```

5. **Update the Reflective Patterns table** at the bottom of `BREAKTHROUGHS.md` — add a row for any new pattern, or note which existing pattern this instance extends.

6. **Update memory** — edit `MEMORY.md` in the auto-memory folder to reflect the new breakthrough if it changes how warmup, pipeline, or a key architecture decision should be understood in future sessions.

7. **Commit** with message: `docs(architecture): add B-N [title] breakthrough + FL-N`

Report: "B-N logged — [one-line summary of the lesson]"
