# FE Visualisation & Visual Debugging — Approach Reference

Documented approach models, wins, and hard rules for visual debugging on web projects. Covers when to use each tool, how to avoid over-capturing, and patterns for effective visual QA.

---

## Tool Decision Tree

Start here before reaching for any tool. Pick the **lowest-friction option that answers the question**.

```text
Is there already a screenshot in the conversation?
  └─ YES → Use it. Don't re-capture.
  └─ NO ↓

Is this a "what does it look like right now?" question?
  └─ YES → Python snap (python3 ~/.claude/scripts/snap.py) — default, always first
  └─ NO ↓

Do you need a specific viewport width, or interaction before screenshotting?
  └─ YES → Playwright MCP
  └─ NO ↓

Is the user reporting a bug they can see (not reproducible locally)?
  └─ YES → Ask user to provide screenshot — their view is ground truth
  └─ NO ↓

Is the page deployed/live and you need to inspect it remotely?
  └─ YES → Playwright MCP (navigate to live URL)
  └─ NO ↓

Is the user describing something verbally?
  └─ Use verbal to triage the problem TYPE. Then immediately capture before proposing a fix.
```

**Token rule:** Screenshots are single-use. Capture → describe → fix → release. Never hold an image in context longer than needed.

---

## Viewport Testing Matrix

Standard viewports to test at for any layout change:

| Viewport | Context |
|----------|---------|
| 320px | Minimum supported width |
| 480px | Small phones, landscape minimum |
| 768px | Tablet portrait |
| 1024px | Laptop |
| 1440px | Wide desktop |
| Phone landscape | Critical — small phones in landscape mode are the hardest layout case |

---

## Tool Reference

### 1. Python Snap — `python3 ~/.claude/scripts/snap.py`

**What it is:** OS-level full-screen capture via `pyautogui`. Low token cost. Captures whatever is visible on screen.

**Requires:** `pip install pyautogui pillow`

**Invoke as:** `/run-python-screenshot` (skill)

**Best for:**
- "What does this look like right now?" checks on a local dev server
- Before/after comparisons when iterating on a layout or style fix
- Quick state verification — "is this rendering correctly?"

**Pitfalls:**
- The browser window must be the active/visible window.
- No viewport control — captures the browser at its current window size. For specific breakpoint testing, resize the browser first or use Playwright.

---

### 2. Playwright MCP

**What it is:** Headless browser automation via MCP. Navigate, interact, screenshot, inspect network and console.

**Invoke as:** `/run-playwright` (skill) or directly via `mcp__playwright__*` tools

**Scale:** Always 75%, PNG.

**Best for:**
- Specific viewport testing (e.g. 320px minimum, phone landscape)
- Testing interactions (click, hover, form submit)
- Console error inspection
- Deployed/live site screenshots without a local server

**Pitfalls:**
- Headless rendering of CSS animations can differ from live browser. For animation correctness, prefer the live browser via Python snap.
- 75% scale rule is non-negotiable — full scale wastes context tokens.

---

### 3. Human-Provided Screenshot

**Best for:**
- Production bugs visible on the user's device
- Real device rendering (actual phone, real browser zoom)
- Bugs that are environment-specific

**When to ask for it:**
> "Can you drop a screenshot? That'll be faster than me trying to reproduce it."

---

### 4. Verbal Description

**Best for:**
- Initial triage only — understand the problem type before deciding which tool to use

**Hard rule:** Never propose a visual fix based on verbal description alone. Always capture first.

---

## Category 1: Wins That Became Rules

### FV-01: Look before you fix — Python snap as default first move

**What happened:** Visual bugs described verbally; fixes proposed without capturing first. Fixes missed because the actual rendered state differed from what the code suggested.

**Win locked in:** Default to `/fe-visualisation` before any visual analysis. Describe → capture → fix — in that order.

**Rule extracted:** Never propose a visual or layout fix based on code-reading alone when a screenshot is obtainable.

**How to apply:** Any time a message contains "it looks", "spacing", "aligned", "colour seems", or any visual description — snap before responding.

---

### FV-02: Screenshot single-use — release after describing

**What happened:** Screenshots held across many tool calls. Token cost ballooned; context pressure dropped earlier content.

**Win locked in:** Single-use rule. Capture → describe in text → propose fix → release. Text description is the durable artefact.

**Rule extracted:** Once you've described an image in text, the image is no longer needed. Describing it converts the visual information into a durable form.

---

### FV-03: Viewport matrix before any layout change

**What happened:** Layout fixes tested at one viewport looked correct but broke at a smaller or landscape breakpoint.

**Win locked in:** Always verify at the minimum supported width (320px) and phone landscape for any layout change.

**Rule extracted:** Small-phone landscape is typically the hardest layout case. Changes that look fine at 375px portrait can break landscape.

**How to apply:** Add 320px and phone-landscape to the Playwright test matrix for any responsive layout change.

---

## Category 2: Limits Set Deliberately

### FV-04: Playwright at 75% scale — non-negotiable

**Limit:** Playwright screenshots always at 75% scale, PNG. Full-scale is wasteful for the detail gain.

---

### FV-05: No verbose Playwright for simple local checks

**Limit:** Python snap is the default for local dev server screenshots. Playwright only when viewport control, interaction, or live URL navigation is needed.

---

### FV-06: Human screenshot beats headless for device-specific bugs

**When:** User reports something wrong on their actual phone. Playwright headless won't show device-font rendering, actual hardware pixel density, or OS-level colour management.

**Rule:** For device-specific bugs, ask for the user's screenshot first.

---

## Hard Rules Summary

```text
FE VISUALISATION HARD RULES

1. Never fix a visual bug without looking first — snap or screenshot before proposing
2. Screenshots are single-use — describe in text, then release from context
3. Python snap is the default — Playwright only when viewport/interaction/live URL needed
4. Human screenshot beats headless for device-specific bugs — ask the user
5. Verbal description → triage only — never a diagnosis on its own
6. Playwright: always 75% scale, PNG — full-scale is wasteful
7. Always test at minimum width (320px) and phone landscape for any layout change
```

---

## Quick-Reference: When to Use What

| Situation | Best Tool | Why |
|-----------|-----------|-----|
| Local dev — "what does this look like?" | Python snap | Fast, low-token, OS-rendered |
| Mobile breakpoint check | Playwright | Viewport control |
| User reports device bug | Ask for human screenshot | Ground truth |
| Deployed page inspection | Playwright → live URL | No local window needed |
| Before/after fix comparison | Python snap × 2 | Before fix → after fix → compare |
| Initial triage | Verbal → then snap | Verbal narrows; snap confirms |
| WCAG contrast check | Python snap + token value from CSS | Rendered colour + token math |
