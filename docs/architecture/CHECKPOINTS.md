# Checkpoints as External Memory

Automatic checkpoint writing at defined trigger points — not requiring the user to ask. The goal is a GitHub-workflow cadence: each significant step produces a written record, so context loss never destroys progress.

---

## The Problem

Without explicit checkpoints, the session handoff is the only durability mechanism. If context compacts mid-session or a session ends abruptly, the in-progress state is lost.

**The GitHub analogy:**
```
Issue opened → branch created → commit pushed → CI runs → PR merged → deploy → monitoring
   ↕               ↕              ↕              ↕          ↕           ↕          ↕
 ticket          state         diff saved     test log   merged     live log   alert log
```

Every stage produces an artifact. For this project:
```
Task starts → work done → checkpoint written → session ends → handoff → next session
   ↕              ↕              ↕                  ↕             ↕          ↕
tasklist.md   CORE_PATTERNS   mini-checkpoint    handoff.md    MEMORY.md  /session-start
```

---

## Trigger Table — When to Auto-Write a Checkpoint

Claude should self-trigger a write at each of these events without being asked.

| Trigger | What fires it | Written to | Format |
|---------|--------------|-----------|--------|
| **Significant code change complete** | Any Write/Edit to `js/`, `styles/`, or HTML files | `context/summaries/handoff_[date].md` (append) | "Changed: [file] — [what + why]. Regression check: [result]." |
| **Bug root-caused** | Root cause identified after investigation | `context/summaries/handoff_[date].md` | Root cause + fix in 2 sentences. Reference BREAKTHROUGHS.md if it's a meaningful pattern. |
| **Second-model consultation complete** | Gemini or fresh-context audit call resolved | `context/summaries/handoff_[date].md` | "Audit finding: [confirmed / flagged drift / recommended change]." |
| **Browser test result** | User confirms test pass or fail in browser | `context/summaries/tasklist.md` | Update task status. Log result one line. |
| **Architecture decision made** | New pattern, constraint change, ADR-level choice | `docs/architecture/DECISIONS.md` | New ADR entry (see DECISIONS.md format). |
| **New breakthrough** | Novel approach, correct decision under pressure, avoided a wrong path | `docs/architecture/BREAKTHROUGHS.md` | New B-XX entry. |
| **New feedback loop** | Win locked in, limit set, explicit "no" | `docs/architecture/FEEDBACK-LOOPS.md` | New FL-XX entry. |
| **Context ~70% full** | Estimated from session length / output density | `context/summaries/recovery_[date].md` | Current open tasks + critical in-progress state. Notify user. |
| **Session end** | User signals end or context compaction imminent | `context/summaries/handoff_[date].md` | Full handoff (see `context/summaries/plan-rules.md` Rule 1 format). |

---

## Mini-Checkpoint Format

For mid-session writes (not the full end-of-session handoff), use this compact format. Append to the active handoff file.

```markdown
### Checkpoint [HH:MM]

**Changed:** `[filename]`
**What:** [One sentence — what was changed]
**Why:** [One sentence — the reason / problem solved]
**Regression check:** [Pass / OPEN items / concern flagged]
**Next:** [What comes next, or BLOCKED: reason]
```

Example:
```markdown
### Checkpoint 14:32

**Changed:** `styles/components.css`
**What:** Replaced hardcoded `#555e64` with `--color-text-muted` CSS custom property
**Why:** G1 violation fix — value was hardcoded instead of using the design token
**Regression check:** Pass — dark mode checked, layout unchanged
**Next:** Run W3C validator — USER task H1
```

---

## Log Awareness

Claude should proactively check these log sources at the appropriate moment — not wait for the user to paste them.

### Git Log

Always check at session start and before any diff review.

```bash
git log --oneline -10            # What changed recently
git diff HEAD~1 -- [file]        # Specific file diff
git log --oneline -- [file]      # History of a specific file
git blame [file] -L [from],[to]  # Who/what changed specific lines
```

**When to run unprompted:**
- At session start — to understand what's changed since last session
- When a user reports "something broke" — before touching any code
- Before writing any handoff — to ensure all commits are accounted for

### Browser Console Output

For runtime JS errors on the page.

**When to ask the user to paste console output:**
- "It's not working" — check for JS errors before reading code
- Feature not responding to interaction — check for event listener errors
- Data not persisting — check for `localStorage` errors or quota issues
- Visual glitches that could be JS-related

**Common patterns to look for:**
```
Uncaught TypeError: ...              → JS error — check the file and line
Failed to read 'localStorage'        → Private browsing mode or storage quota
ReferenceError: X is not defined     → Module not loaded or wrong script load order
Uncaught SyntaxError: ...            → Parse error in a JS file
```

### Log Triage Flow

When the user reports a runtime problem, run this sequence before touching code:

```
1. git log --oneline -5            → Did something recent change?
2. fe-visualisation snap           → What does the UI actually look like right now?
3. Ask for browser console output  → Any JS errors?
4. Check the relevant JS module    → Is the init running? Event listeners attached?
5. Check localStorage directly     → F12 → Application → Local Storage
```

---

## Implementation — How Auto-Checkpoints Work

Claude Code does not have a PostToolUse hook that writes structured content automatically. The checkpoint system works via explicit rules that Claude follows as part of its operating mode.

**Rules in `context/summaries/plan-rules.md` (Rule 6)** make checkpoint writing part of the session protocol — not optional, not prompted.

**The discipline is:**
- After any Write or Edit to a source file, append a mini-checkpoint to the active handoff
- After any second-model audit, note the finding
- After a root cause is identified, write it before proposing the fix
- Before context is estimated to be >70% full, write a recovery checkpoint

This mirrors GitHub Actions' approach: trigger conditions are defined upfront; actions are automatic when conditions are met.
