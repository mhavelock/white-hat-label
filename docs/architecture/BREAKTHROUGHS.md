# Project Breakthroughs — Reflective Record

Process, approach, and decision breakthroughs from development. These are not feature releases — they are moments where a better way to think about a problem was found, a correct decision was made under pressure, or a root cause was identified instead of a symptom.

**Format:** what the situation was → what we were tempted to do → what we actually did → what we learned.

---

## How to use this file

When you solve a problem in a way that was non-obvious — or when you find that an initial approach was wrong and a better one was found — record it here. These entries are reference material for future sessions. They should help Claude (and you) avoid repeating the same diagnostic detours.

---

## B-01: [Breakthrough name]

**Date:** YYYY-MM-DD
**Session type:** [Performance / Bug fix / Architecture / Refactor / Feature]

**Situation:** [Describe what the problem or situation was. What was observed? What was the symptom?]

**Temptation:** [What was the easy or obvious response that would have been wrong — or at least suboptimal?]

**What we actually did:** [The actual solution chosen. Be specific — name files, functions, or patterns involved.]

**Lesson:** [The generalised principle extracted from this. What does this mean for future decisions?]

**ADR reference:** [ADR-00X if a formal decision was recorded, or "none"]

---

## B-02: [Breakthrough name]

**Date:** YYYY-MM-DD
**Session type:** [...]

**Situation:** [...]

**Temptation:** [...]

**What we actually did:** [...]

**Lesson:** [...]

**ADR reference:** [...]

---

## Example — Diagnosing a Root Cause Instead of a Symptom

**Situation:** A form was submitting despite client-side validation showing errors. The initial assumption was that the validation function wasn't running.

**Temptation:** Add `console.log` statements and re-run the validation function manually.

**What we actually did:** Read the event listener setup. Found that `submit` was being listened on the button (`click`) rather than the form (`submit`). The form was also being submitted by Enter key, which bypassed the button listener.

**Lesson:** When a validation appears to be not running, always check *where* the listener is attached, not just whether the function is correct. The symptom (validation ignored) pointed to the wrong file. The root cause was the event binding, not the validation logic.

**ADR reference:** none
