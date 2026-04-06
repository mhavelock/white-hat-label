---
name: penpot-html-to-design
description: >
  Recreates HTML/CSS from a project into the connected Penpot file using the Penpot MCP plugin.
  Trigger when the user wants to: mirror a coded component or page into Penpot, create a design
  file from existing frontend code, or document a Next.js / React / HTML page as a Penpot frame.
  Trigger phrases: "recreate in Penpot", "add to Penpot", "design file from code",
  "put this in Penpot", "Penpot mock from HTML/CSS".
  Do NOT trigger for: Figma work, general design tasks with no code source, or Penpot-to-code direction.
---

# Penpot HTML-to-Design Skill

Recreate HTML/CSS from a coded project into the active Penpot file using the `mcp__penpot__execute_code` tool. The Penpot MCP plugin runs JavaScript directly inside the Penpot desktop app plugin bridge.

---

## Prerequisites

Before starting, confirm:

1. **Penpot desktop app is open** with the MCP plugin active.
2. **The correct file/page is open** in Penpot (`Mocks` page or equivalent).
3. **The MCP server is connected** — verify by running a smoke-test call:

```js
return penpotUtils.getPages();
```

If this fails, the plugin is not connected. Ask the user to open Penpot and activate the MCP plugin.

---

## Job Breakdown Methodology

Break the work into **discrete, sequenced jobs**. Never attempt to build everything in one `execute_code` call — the plugin bridge has a ~30-second execution timeout per task. Large operations will silently fail or time out.

### Standard Job Sequence

| Job | What |
|-----|------|
| **Job 1 — Audit** | Read source code, extract layout structure, components, brand tokens |
| **Job 2 — Components** | Build reusable Penpot components (buttons, chips, cards, panels) |
| **Job 3 — Frame setup** | Create the target frame, set dimensions, add flex layout |
| **Job 4 — Compose** | Place component instances into the frame in correct layout |
| **Job 5 — Verify** | Export snapshot, check structure with `shapeStructure()` |

Each job is a separate session or a separate cluster of `execute_code` calls. Use `storage` to persist object references between calls within the same session.

---

## Step 1 — Audit the Source

Read the source HTML/CSS/TSX files before touching Penpot.

Extract and record:

- **Page layout**: wrapper max-width, padding, flex/grid structure
- **Section breakdown**: header, sidebar, content area, footer
- **Component list**: what repeating elements exist (cards, chips, buttons)
- **Brand tokens**: colors, font sizes, gaps, radii (from `globals.css`, Tailwind config, or design tokens)
- **Responsive breakpoints**: mobile vs desktop layout differences

Document this as a quick table before proceeding. Do not guess — read the actual files.

---

## Step 2 — Orient in Penpot

```js
// Check pages
const pages = penpotUtils.getPages();
return pages;
```

```js
// Check existing frames on target page
const page = penpotUtils.getPageByName("Mocks");
const structure = penpotUtils.shapeStructure(page.root, 1);
return structure;
```

```js
// Check library components already available
const lib = penpot.library.local;
storage.components = {};
lib.components.forEach(c => { storage.components[c.name] = c; });
return lib.components.map(c => ({ id: c.id, name: c.name }));
```

Store references in `storage` immediately. Do not re-fetch on every call.

---

## Step 3 — Build Components (Job 2)

Build each UI primitive as a **Penpot library component** before composing the page. One component per `execute_code` call for safety.

### Component creation pattern

```js
// 1. Create the board
const btn = penpot.createBoard();
btn.name = "MyButton";
btn.resize(140, 36);
btn.fills = [{ fillColor: "#310101", fillOpacity: 1 }];

// 2. Add flex layout
btn.addFlexLayout();
btn.flex.dir = "row";
btn.flex.columnGap = 8;
btn.flex.horizontalPadding = 12;
btn.flex.verticalPadding = 6;

// 3. Add children in visual order using appendChild
//    (for dir="row"/"column", appendChild inserts at the front of children array,
//     which is the VISUAL END — so call in top-to-bottom / left-to-right order)
const icon = penpot.createRectangle();
icon.name = "icon";
icon.resize(16, 16);
icon.fills = [{ fillColor: "#ffffff", fillOpacity: 1 }];
btn.appendChild(icon);

const label = penpot.createText("Button label");
label.name = "label";
label.fills = [{ fillColor: "#ffffff", fillOpacity: 1 }];
label.fontSize = 14;
label.growType = "auto-width"; // ALWAYS set after resize or text creation
btn.appendChild(label);

// 4. Register as library component
const component = penpot.library.local.createComponent([btn]);
component.name = "MyButton";

// 5. Store reference
storage.components["MyButton"] = penpot.library.local.components.find(c => c.name === "MyButton");
return { w: btn.width, h: btn.height };
```

### Component checklist

- [ ] Icon/placeholder rect at correct size
- [ ] Text with `growType = "auto-width"` or `"auto-height"`
- [ ] Flex layout with correct `dir`, `gap`, `padding`
- [ ] Fill colors from brand tokens (not guessed)
- [ ] Registered in local library via `createComponent()`
- [ ] Reference stored in `storage.components`

---

## Step 4 — Build the Frame (Job 3)

```js
const page = penpotUtils.getPageByName("Mocks");

// Find or create the target frame
let frame = penpotUtils.findShape(s => s.name === "Walks Page — Desktop", page.root);

// Check dimensions
return { w: frame.width, h: frame.height, hasChildren: frame.children.length };
```

If the frame doesn't exist, create it:

```js
const frame = penpot.createBoard();
frame.name = "Page Name — Desktop";
frame.resize(1440, 960);
frame.x = 3200; // position on canvas away from other frames
frame.y = 0;
```

Add flex col layout to the frame:

```js
frame.addFlexLayout();
frame.flex.dir = "column";
frame.flex.rowGap = 0;
frame.flex.verticalPadding = 0;
frame.flex.horizontalPadding = 0;
storage.frame = frame;
```

---

## Step 5 — Compose the Page (Job 4)

Add sections in **visual top-to-bottom order** using `frame.appendChild()`.

### Banner

```js
const banner = penpot.createBoard();
banner.name = "banner";
banner.resize(1440, 220);
banner.fills = [{ fillColor: "#310101", fillOpacity: 1 }];
storage.frame.appendChild(banner);
banner.layoutChild.verticalSizing = "fix";
banner.layoutChild.horizontalSizing = "fill";

// Optional: heading text
const heading = penpot.createText("Page Title");
heading.name = "banner-heading";
heading.fontSize = 32;
heading.fontWeight = "700";
heading.fills = [{ fillColor: "#ffffff", fillOpacity: 1 }];
heading.growType = "auto-width";
banner.insertChild(0, heading);
penpotUtils.setParentXY(heading, 48, 88);
```

### Two-column content area

```js
const contentArea = penpot.createBoard();
contentArea.name = "content-area";
contentArea.resize(1440, 740);
contentArea.fills = [{ fillColor: "#ffffff", fillOpacity: 1 }];
contentArea.addFlexLayout();
contentArea.flex.dir = "row";
contentArea.flex.columnGap = 32;
contentArea.flex.horizontalPadding = 48;
contentArea.flex.verticalPadding = 32;
contentArea.flex.alignItems = "start";
storage.frame.appendChild(contentArea);
contentArea.layoutChild.verticalSizing = "fill";
contentArea.layoutChild.horizontalSizing = "fill";
storage.contentArea = contentArea;
```

### Place component instances

```js
// Instantiate a component from the library
const filterPanel = storage.components["FilterPanel"].instance();
filterPanel.name = "FilterPanel";

// Append to parent in visual order
storage.contentArea.appendChild(filterPanel);
filterPanel.layoutChild.horizontalSizing = "fill";
```

---

## Step 6 — Verify (Job 5)

```js
// Check structure
return penpotUtils.shapeStructure(storage.frame, 3);
```

```js
// Export a snapshot (PNG)
// Use mcp__penpot__export_shape tool with the frame's ID
```

Check:
- All sections present in correct order
- Flex layouts applied (visible in `layout` key of shapeStructure output)
- Component instances linked (visible in `componentInstance` key)
- No orphaned shapes outside the frame

---

## Critical API Rules

These are confirmed gotchas from live sessions. Violating them causes silent failures.

### Shape creation and insertion

| Rule | Detail |
|------|--------|
| `parent.appendChild(shape)` for **flex boards** | Inserts at the FRONT of the children array. For `dir="row"` or `dir="column"`, children array is REVERSED vs visual order. Call `appendChild` in visual top-to-bottom / left-to-right order. |
| `parent.insertChild(index, shape)` | Use when precise index control is needed. Index 0 = visually LAST for flex col/row. |
| NEVER use `flex.appendChild` | `board.flex.appendChild` is BROKEN. Always use `board.appendChild(shape)`. |
| `shape.width` / `shape.height` | READ-ONLY. Use `shape.resize(w, h)` to set dimensions. |
| `shape.parentX` / `shape.parentY` | READ-ONLY. Use `penpotUtils.setParentXY(shape, x, y)` to position relative to parent. |
| Text `growType` | Resets to `"fixed"` whenever `resize()` is called. Always re-set: `text.growType = "auto-width"` after any resize. |
| `shape.fills` | Entire array is replaced at once: `shape.fills = [{ fillColor: "#ff0000", fillOpacity: 1 }]`. Cannot mutate individual items. |
| `shape.strokes` | Same pattern as fills — replace whole array. |

### Flex layout child direction reversal

For any board with `flex.dir = "column"` or `flex.dir = "row"`:

- **children[0]** = visually LAST (bottom / right)
- **children[last]** = visually FIRST (top / left)
- Use `board.appendChild(shape)` — it inserts at the front of the array, placing shape visually at the END
- So: call `appendChild` in the order you want things to appear visually (top-to-bottom)

Example — building a three-row column that should display A, B, C top-to-bottom:

```js
board.appendChild(shapeA); // children = [A] → A appears at top
board.appendChild(shapeB); // children = [B, A] → B appears second
board.appendChild(shapeC); // children = [C, B, A] → C appears at bottom
```

---

## Timeout Management

The Penpot plugin bridge has a **~30-second execution timeout per task**. The terminal will log:

```
(PluginBridge): Task <uuid> completed: success=true
```

on success, or time out silently on complex operations.

### Rules to avoid timeouts

1. **One component per `execute_code` call** when building components.
2. **Store all object references in `storage`** immediately after creation — they survive between calls.
3. **Never build a full page in one call** — split into: frame setup → section by section → children.
4. **Avoid loops with large iterations** — if you need 10 card instances, do 3–4 per call.
5. **If a call seems to hang**, check the terminal. If you see `success=true`, the call completed. If no log appears, the call timed out and you need to split it further.

### Storage pattern

```js
// Call 1 — create and store
const frame = penpot.createBoard();
frame.name = "My Frame";
frame.resize(1440, 960);
storage.frame = frame;
return frame.id;

// Call 2 — retrieve and continue
const frame = storage.frame; // still available
frame.addFlexLayout();
return "Layout added";
```

---

## Penpot Data Model Reference

From the Penpot technical docs (`/docs/technical-guide/developer/data-model/`):

- A **File** contains Pages and library assets (Components, Colors, Typographies).
- A **Page** contains a tree of **Shapes** — the root shape is `page.root`.
- **Frames** (`Board` type) are the top-level containers. Pages are structured into boards.
- **Groups** organise low-level shapes logically.
- Low-level types: `Rectangle`, `Path`, `Text`, `Ellipse`, `Image`, `Boolean`, `SvgRaw`.
- Each shape has: position (`x`, `y`), dimensions (read-only), fills, strokes, shadow, blur, font (for text), content (for text).
- The `ShapeTree` is hierarchical: parent → children. Parent does not imply visual containment.

---

## Worked Example — This Session (2026-03-07)

**Source**: `app/walks/WalksList.tsx` (Next.js 15, Tailwind v4)

**Target**: `Walks Page — Desktop` frame (1440×960) on `Mocks` page

**Jobs completed**:

| Job | Result |
|-----|--------|
| Job 1 — Audit | Extracted layout, brand tokens, component list from source TSX |
| Job 2 — Components | Built 6 library components: Chip, ViewOnMapButton, OpenInGoogleMapsButton, FilterToggleButton, WalkCard, FilterPanel |
| Job 3 — Frame setup | Frame already existed at 1440×960; added flex col layout |
| Job 4 — Compose | Banner (dark red, 220px) + content-area (flex row: sidebar 312px + walks-list with 3 WalkCard instances) |
| Job 5 — Verify | Confirmed via `shapeStructure()` — all layers present, flex layouts applied, component instances linked |

**Brand tokens used**:

| Token | Value |
|-------|-------|
| Primary / banner bg | `#310101` |
| Accent | `#04115c` |
| Border | `#e5e7eb` |
| Surface | `#ffffff` |
| Chip bg | `#f0fdfa` |
| Chip text | `#0f766e` |
| Muted text | `#6b7280` |
| Foreground | `#1a1a1a` |

**Issues encountered**:

| Issue | Solution |
|-------|----------|
| `board.flex.appendChild` broken | Use `board.appendChild(shape)` instead |
| Children visual order reversed in flex col/row | Call `appendChild` in visual order (top-to-bottom) — each call prepends to children array |
| `shape.width` read-only | Always use `shape.resize(w, h)` |
| `parentX/parentY` read-only | Use `penpotUtils.setParentXY(shape, x, y)` |
| Text overflows bounding box after resize | Set `text.growType = "auto-width"` or `"auto-height"` after every resize |
| Large operations risk timeout | Split into one-component-per-call; use `storage` for state persistence |
| Plugin bridge timeout ~30s | Terminal log `success=true` confirms completion; split further if timing out |
