# /project-init — New Project Initialisation

Run this command at the very start of a new project, before any code work. It collects the project definition from you, then generates the core architecture documents.

**Run once. Takes ~5 minutes. Do not run on an existing project.**

---

## Step 1 — Check for prior initialisation

Read `docs/architecture/ARCHITECTURE.md`. If it does NOT contain `[PENDING INITIALIZATION]` or `[PROJECT_NAME]`, this project has already been initialised — stop and run `/session-start` instead.

---

## Step 2 — Ask the user these questions

Ask them one at a time. Wait for each answer before continuing. Do not proceed until you have answers for all mandatory questions.

**Mandatory:**
1. What is the project name?
2. What does this project do? (One paragraph — what it is, who uses it, what problem it solves.)
3. What is the tech stack? (Framework, styling approach, state management, hosting, CI/CD, domain.)
4. What is the repository URL and live site URL?
5. What are the top 3 UX or product goals? (Not features — principles that all decisions should serve.)
6. Are there any hard constraints already known? (e.g. "no npm", "must work without JS", "must hit PageSpeed 100".)

**Optional (ask if not obvious from the stack):**
7. What is the local dev command?
8. Any specific integrations? (Auth, database, CDN, analytics, third-party APIs.)

---

## Step 3 — Generate the core documents

Using the answers above, populate these files. Replace all `[PENDING INITIALIZATION]`, `[PROJECT_NAME]`, and `[...]` placeholders with real content.

Generate in this order:

1. **`docs/architecture/ARCHITECTURE.md`** — Fill in: Summary, Stack table, first Core Structural Decisions (based on tech stack choices), initial "What We Never Do" list (draw from `CORE_PATTERNS.md` G1–G13 as the baseline, plus any constraints stated in Q6).

2. **`docs/architecture/SYSTEM.md`** — Fill in: Rules of Engagement (keep generic rules, add project-specific ones), update Naming Conventions table to reflect the actual framework in use, update Test Programme with project-specific checks.

3. **`docs/architecture/CORE_PATTERNS.md`** — Replace `[PROJECT_NAME]`. Add any project-specific constraints as G14+ rows to the Global Constraints table. Keep G1–G13 — they apply to all web projects.

4. **`docs/plan/tasklist.md`** — Replace `[PROJECT_NAME]` and the date. Remove the example rows. Add the first real tasks: project scaffold, CLAUDE.md from `docs/init/CLAUDE.txt`, and whatever the user says comes next.

5. **`docs/init/CLAUDE.txt`** → Copy to `CLAUDE.md` in the project root and fill it in: Summary, Stack, File Structure (create the initial structure based on the tech stack), UX Goals (from Q5), Common Commands (from Q7), Git Workflow.

6. **`docs/architecture/.ai/memory/active_sprint.md`** — Fill in the current sprint goal (first sprint = "project scaffold and architecture setup").

---

## Step 4 — Report

After generating all documents, report:

- **Project initialised:** [project name]
- **Documents updated:** [list]
- **First task:** [T001 from tasklist]
- **Recommended first action:** [what to do next — e.g. "scaffold the project structure, then run /session-start"]

Do not start any code work during this step. Initialisation is documentation only.
