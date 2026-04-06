---
name: fe-visualisation
description: Capture the current UI state — defaults to Python snap (OS-level, low token cost), falls back to Playwright only when browser-specific inspection is needed
---

## Default: Python snap (always try this first)

Python snap is the default. It's fast, low-token, and captures exactly what's on screen.

1. Run: `python3 ~/.claude/scripts/snap.py`
2. Read the file path printed in output
3. Load the resulting image

## Fallback: Playwright MCP (browser-specific only)

Only use Playwright when Python snap is insufficient — e.g. you need a specific viewport width, need to inspect a headless state not visible on screen, or need to interact with the page before screenshotting.

1. Identify the dev server URL (check package.json scripts, or ask — default: http://localhost:3000)
2. Navigate to the URL via Playwright MCP
3. Take screenshot at 75% scale, PNG format — keep it small to conserve context tokens

## After capturing (both tools)

- Describe exactly what you see: layout, colours, spacing, overflow, alignment issues
- If a problem is visible, propose a specific fix before asking for feedback
