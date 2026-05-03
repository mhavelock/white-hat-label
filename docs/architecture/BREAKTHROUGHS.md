# Project Breakthroughs — Reflective Record

Process, approach, and decision breakthroughs from development. These are not feature releases — they are moments where a better way to think about a problem was found, a correct decision was made under pressure, or a root cause was identified instead of a symptom.

**Format:** what the situation was → what we were tempted to do → what we actually did → what we learned.

---

## How to use this file

When you solve a problem in a way that was non-obvious — or when you find that an initial approach was wrong and a better one was found — record it here. These entries are reference material for future sessions. They should help Claude (and you) avoid repeating the same diagnostic detours.

---

## B-01: entire.io session-tracker leak diagnosis

**Date:** 2026-05-03
**Session type:** Security / public-repo posture

**Situation:** Routine `git branch -r` on the white-hat-label public repo showed an unexpected `origin/entire/checkpoints/v1` branch with 9 commits. Each commit was an entire.io session checkpoint pushed automatically by the tool's default behaviour. `git show` on any commit revealed full conversation transcripts — code, prompts, internal reasoning, vendor names, process notes. **No credentials**, but high-context IP and process leakage, world-readable on a public repo.

**Temptation:** Delete the branch (`git push origin --delete entire/checkpoints/v1`), assume the leak was contained, move on. The checkpoints would still exist in any clone made during the leak window, but the immediate source would be gone.

**What we actually did:** Multi-step remediation in the right order:
1. **Stop future leakage first** — `entire enable --skip-push-sessions` (must precede history rewrite, otherwise the next session pushes a fresh checkpoint).
2. **Strip from history** — `git filter-repo --invert-paths --path .entire/`.
3. **Delete remote shadow branches** — `git push origin --delete entire/checkpoints/v1`.
4. **Delete local shadows** — `git branch | grep entire/ | xargs git branch -D`.
5. **Force-push cleaned main** — `git push --force-with-lease origin main`.
6. **Add to `.gitignore`** — `.entire/` plus matching patterns for `.aider/`, `.cursor/`-style trackers.
7. **Add branch protection** — prevent future accidental force-push (see ADR-006).
8. **Add `docs/security-sweep-playbook.md`** — formalise the audit so the next sweep is repeatable, not improvisational.

**Lesson:** Any tool with default-on push to origin is a leak vector until proven otherwise. The remediation cost (an afternoon of filter-repo + force-push + branch-protection setup) is permanent and incomplete — anything cloned during the leak window is already out. The prevention cost (one flag, set once before first use) is trivial. Generalises beyond entire.io: assume hostile defaults on any third-party tool that touches version control or pushes artefacts. Also: order matters in remediation — opt out *before* rewriting history, not after.

**ADR reference:** ADR-005 (two-phase security playbook), ADR-006 (branch protection), ADR-007 (opt-out for session-trackers).

---

## B-02: Update all references when a fact changes — not just the most recent handoff

**Date:** 2026-05-03
**Session type:** Documentation discipline (cross-project lesson)

**Situation:** Originated on the sister `hardy-succulents` project. An AI image-generation model was swapped (FLUX Pro v1.1 Redux → FLUX Kontext Pro) after the first iteration produced "lovely AI rendering but no text" (Redux is image-variation, ignores prompts). A thorough handoff was written capturing execution data, version IDs, and the iteration narrative. The doc work was considered complete. The model name was also referenced in three other places: the project README (stack table), the tasklist (active task description with stale endpoint and parameters), and the relevant phase plan. None of those were touched.

**Temptation:** Treat the handoff as the canonical record of changes. New facts go in the handoff; if anyone needs to know later, they read the handoff. Move on.

**What we actually did:** Only after the user prompted ("ensure the correct model we are using is correct in docs") a project-wide grep surfaced the stale references. Each was updated — current-state docs in place, research/discovery docs annotated with a top-of-doc "Status update" callout pointing at the new canonical source rather than retconned (the original reasoning is part of their value).

**Lesson:** When a fact changes — model name, env var, endpoint, version, file path, vendor, threshold value — the handoff is one place to record it, but **not the only place to update**. README, tasklist, qref files, plan documents, and `CLAUDE.md` often duplicate the same fact for different audiences. Leaving the old fact in those files creates conflicting "memories" that future sessions and humans pick up at random — exactly the kind of drift that erodes trust in the doc system.

**Rule extracted:** After changing a fact, `grep -rln "OLD_VALUE" --include="*.md" .` across the project and either update each reference or explicitly annotate it as historical. Writing the handoff is the *start* of the doc work, not the end. Discovery / research docs are the exception — they get a top-of-doc correction note rather than a retcon.

**Cross-project relevance for white-hat-label:** Particularly applicable when standards or boilerplate decisions change (e.g. a renamed protected file, a new gitignore pattern after a security incident, a swapped OAuth provider, a moved env var). The boilerplate is consumed by other projects — a stale reference in this repo's docs propagates downstream.

**ADR reference:** none

---

## Example — Diagnosing a Root Cause Instead of a Symptom

**Situation:** A form was submitting despite client-side validation showing errors. The initial assumption was that the validation function wasn't running.

**Temptation:** Add `console.log` statements and re-run the validation function manually.

**What we actually did:** Read the event listener setup. Found that `submit` was being listened on the button (`click`) rather than the form (`submit`). The form was also being submitted by Enter key, which bypassed the button listener.

**Lesson:** When a validation appears to be not running, always check *where* the listener is attached, not just whether the function is correct. The symptom (validation ignored) pointed to the wrong file. The root cause was the event binding, not the validation logic.

**ADR reference:** none
