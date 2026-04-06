# Gemini MCP — Consultancy Protocol

How to use the Gemini MCP for architectural audit, decision validation, root cause analysis, and research within a Claude Code session.

---

## Why a Second Model

Claude accumulates recency bias in a working session. After 10+ iterations on a problem, it optimises for the constraints it has learned, not for the ideal solution. Gemini — called fresh with only the context you explicitly pass — has no prior history with the problem. It audits from the outside.

This is the **"Gemini Reads, Claude Writes" protocol:** Claude authors and implements; Gemini validates and challenges.

**When a second-model review is most valuable:**
- Claude has been iterating on the same problem for many steps — Gemini's unbiased read can break the deadlock.
- Before committing to a hard-to-reverse decision (dependency, architecture pattern, data model).
- After a significant refactor — to confirm nothing regressed.

---

## Tool Reference

| Tool | Model | Max Response | Use For |
|------|-------|-------------|---------|
| `mcp__gemini__ask_gemini` | Gemini Flash | 8,192 tokens | Analysis, synthesis, architecture audit, second opinion. Fast. |
| `mcp__gemini__ask_gemini_pro` | Gemini Pro | 16,384 tokens | Complex architectural reasoning, multi-constraint decisions, deep code review. |
| `mcp__gemini__web_search` | Gemini + Google | — | Research — libraries, API behaviour, browser compatibility, patterns. |
| `mcp__gemini__web_reader` | Gemini | — | Read a specific URL — docs, specs, release notes. |
| `mcp__gemini__parse_document` | Gemini multimodal | — | Parse PDFs, images, scanned docs (up to 20MB public URL). |

**Flash vs Pro:**
- Flash first — fast and sufficient for most audits and second opinions.
- Pro when: the problem is genuinely complex, Flash's response lacks depth, or you're making a hard-to-reverse architectural decision.

---

## Consultancy Patterns

### Pattern 1 — Architecture Audit (most common)

Use after significant changes, before committing a major refactor, or when `FEEDBACK-LOOPS.md` rules may have been under pressure.

```
system_prompt: "You are performing a cross-session architectural audit of [PROJECT_NAME]. You are the AUDITOR, not the author. Claude Code wrote this code. Your job is to find drift, regressions, and constraint violations — not to suggest new features."

prompt: """
ARCHITECTURE CONSTRAINTS (do not violate these):
[Paste docs/ARCHITECTURE.md §Core Structural Decisions + §What We Never Do]

SYSTEM RULES:
[Paste docs/SYSTEM.md §Rules of Engagement]

HARD RULES (derived from feedback loops):
[Paste docs/architecture/FEEDBACK-LOOPS.md §Hard Rules]

CHANGED CODE:
[Paste the relevant file(s) or diff]

AUDIT QUESTION:
Does the changed code above introduce any:
1. Violations of the "What We Never Do" constraints?
2. Drift from the documented architecture patterns?
3. Regressions of issues documented in the Hard Rules?
4. New race conditions or sequencing risks?

Output:
- Confirmed solid: [list]
- Potential drift: [specific file + pattern violated]
- Regressions to check: [list]
- Recommended action: [1-2 sentences max]
"""
```

**Which tool:** `ask_gemini` (Flash) unless the diff is large and multi-file → use `ask_gemini_pro`.

---

### Pattern 2 — Stuck in a Loop (break deadlock)

Use when the same bug has been fixed 3+ times without finding root cause.

```
system_prompt: "You are a senior web developer reviewing a problem cold, with no prior history. You have not seen this code before."

prompt: """
PROJECT CONTEXT:
[Paste docs/ARCHITECTURE.md §Core Structural Decisions — minimum needed to understand the system]

THE PROBLEM:
[Describe the symptom exactly — what is observed, what is expected]

WHAT HAS BEEN TRIED:
[List the approaches attempted and why each didn't work]

THE RELEVANT CODE:
[Paste the specific function or module, not the whole file]

QUESTION:
What is the most likely root cause? What would you check first that hasn't been checked yet?
Do not suggest patching the symptoms. Identify the source.
"""
```

**Which tool:** `ask_gemini_pro` — root cause analysis is complex reasoning.

**Trigger condition:** Same bug attempted 3+ times.

---

### Pattern 3 — Decision Validation (Black Hat)

Use before committing to a dependency, architecture choice, or constraint that is hard to reverse.

```
system_prompt: "You are a devil's advocate auditor. Your job is to find what can go wrong with this decision."

prompt: """
CURRENT ARCHITECTURE:
[Relevant constraint from ARCHITECTURE.md or DECISIONS.md]

PROPOSED DECISION:
[The change being considered]

QUESTION:
Play Black Hat. What are the top 3 ways this decision could fail or introduce problems?
What documented constraint does it most stress?
Is there a simpler alternative that covers the same use case?
"""
```

**Which tool:** `ask_gemini` (Flash).

---

### Pattern 4 — Research

Use when evaluating a library, investigating an API behaviour, or checking how others have solved a class of problem.

**Web search:**
```
search_query: "[library name] [specific question or issue]"
search_recency_filter: "oneYear"  // or "oneMonth" for fast-moving areas
count: 10
```

**Read a specific page:**
```
url: "https://[library-docs-url]"
return_format: "markdown"
```

**Parse a PDF** (spec, API reference, report):
```
file_url: "https://[publicly accessible PDF URL]"
parse_mode: "auto"
```

---

### Pattern 5 — Recursive Architecture Test

Use when you want to verify that your architecture docs accurately reflect the code — before relying on them as source of truth.

```
system_prompt: "You are a new developer joining this project. You have read only the two documents provided. You have not seen the codebase."

prompt: """
ARCHITECTURE DOCUMENT:
[Paste ARCHITECTURE.md §Core Structural Decisions + §What We Never Do]

SYSTEM RULES:
[Paste SYSTEM.md §Rules of Engagement]

QUESTION:
Based only on these two documents, describe how you would implement [key feature or flow].
Walk through the key decisions you would make and why.
"""
```

Compare the response against the actual code. Where it diverges: update the doc or flag the code as drifted.

**Which tool:** `ask_gemini` (Flash).

---

### Pattern 6 — Delete Code / Quality Advocate

Use when the codebase has grown and you want a cold assessment of what should be removed.

```
system_prompt: "You are a senior architect reviewing a codebase for removal candidates and value drift. You are not looking for bugs. You are asking: what should not exist, and has recent work made this project less coherent?"

prompt: """
PROJECT ARCHITECTURE:
[Paste ARCHITECTURE.md §Core Structural Decisions + §What We Never Do]

[For Mode A — add the relevant code files or file tree]

RECENT CHANGES (if Mode B):
[Describe what was built in the recent session or paste the diff]

QUESTIONS:
Mode A: Identify up to 5 removal candidates — dead code, redundant abstractions, stale documentation, unnecessary dependencies. For each: name it, explain why it's a candidate, and state the risk of removing it.
Mode B: Has the recent work prioritised near-term delivery over long-term coherence? Where has complexity been added that doesn't pull its weight?

Output format:
- Removal candidates: [name, reason, removal risk]
- Value drift findings: [finding, specific constraint stressed, recommended action]
- Overall verdict: net positive / neutral / net negative for project health
"""
```

**Which tool:** `ask_gemini_pro`.

---

### Pattern 7 — Model-Tiering (Flash as Router)

Use when the question is complex but you're not sure which parts of the context are relevant.

**Step 1 — Flash as router:**
```
tool: ask_gemini (Flash)
system_prompt: "You are a context triage assistant. Identify the minimum information needed to answer the question. Do not answer it yourself."

prompt: """
FULL CONTEXT:
[Paste everything — ARCHITECTURE.md, SYSTEM.md, relevant code files]

QUESTION:
[The actual question you want answered]

OUTPUT:
List the specific sections and code snippets directly relevant to this question.
"""
```

**Step 2 — Pro with filtered payload:**
```
tool: ask_gemini_pro
system_prompt: [persona for the actual question]

prompt: """
[Only the sections Flash identified as relevant]

QUESTION:
[Same question]
"""
```

---

## Payload Assembly Guide

| What to include | Why |
|----------------|-----|
| `ARCHITECTURE.md §Core Structural Decisions` + `§What We Never Do` | The never-break constraints |
| `SYSTEM.md §Rules of Engagement` | The coding rules |
| `FEEDBACK-LOOPS.md §Hard Rules` | The distilled guardrail list |
| Only the changed file(s) or diff | Not the whole codebase |
| A specific, focused question | One question per call |

**Information order rule:** LLMs attend most heavily to tokens immediately before generation. The question goes last. Structure: role/persona → constraints → code → question.

**No-hypothesis rule:** When asking for root cause or contradictions, do not tell Gemini your theory. State the symptom and the code. Let it form its own hypothesis independently.

---

## When to Call (Trigger Table)

| Trigger | Pattern | Tool |
|---------|---------|------|
| Same bug fixed 3+ times | Stuck in a Loop | `ask_gemini_pro` |
| About to add a new dependency | Decision Validation | `ask_gemini` |
| Just completed a major refactor | Architecture Audit | `ask_gemini` |
| "This feels fragile" | Architecture Audit | `ask_gemini` |
| Evaluating a library or API | Research | `web_search` → `web_reader` |
| Hard-to-reverse architectural choice | Decision Validation | `ask_gemini_pro` |
| Post-sprint: what should be removed? | Quality Advocate | `ask_gemini_pro` |
| Do the architecture docs match the code? | Recursive Architecture Test | `ask_gemini` |
| Complex question, unclear which context matters | Model-Tiering | Flash → `ask_gemini_pro` |

**Hard rule:** Call Gemini when stuck after the 2nd failed attempt, not the 5th.
