After completing code changes, sync the architecture documentation:

1. List all files changed in this session.
2. For each change, check whether it:
   - Introduces a new architectural pattern not documented in `ARCHITECTURE.md`
   - Violates or changes a constraint listed in `SYSTEM.md`
   - Changes a structural decision (e.g. new state shape, new service, new component pattern)
   - Affects the pipeline data flow diagram
   - Changes package versions
   - Introduces a new pitfall or resolves an existing one
3. For any match, propose the specific update to `ARCHITECTURE.md` or `SYSTEM.md`.
4. Update `docs/architecture/.ai/memory/active_sprint.md` change log with today's date and a one-line summary.
5. Prompt to write a session handoff to `docs/plan/handoff_YYYY-MM-DD.md` if not already done.

Report: "Arch sync complete — N docs updated" OR list proposed changes for confirmation.
