---
name: frontend-standards
description: Applies professional front-end coding standards to HTML, CSS, and JavaScript work. Use this skill whenever writing, reviewing, or refactoring front-end code — HTML markup, CSS stylesheets, JavaScript, or any combination. Trigger for requests like "write a component", 'build a page', 'style this' 'add interactivity', 'review my HTML/CSS/JS', 'fix this layout', 'create a form', 'make this responsive', or any task that produces or modifies front-end files. Also trigger when the user asks about best practices, accessibility, performance, CLS, or responsive design. This skill should be used proactively any time front-end code is being produced — don't wait to be asked.
---

# Front-End Coding Standards

Professional front-end code. Follow these standards. They exist for consistency, maintainability, and quality.

## Core Principles

- **Separation of concerns**: HTML for structure, CSS for presentation, JS for behaviour.
- **Progressive enhancement**: Build for the lowest capable device first, layer up.
- **Readability over cleverness**: Code is read more than written. Optimise for the next developer.
- **Mobile-first CSS**: Write base styles for the smallest screen. Add complexity upward via `min-width` or `width >=` media queries. Never use `max-width` media queries for responsive breakpoints.
- **Just enough JS**: Only add JavaScript when HTML/CSS cannot achieve the goal.

---

## HTML

### Doctype and encoding
Every page starts with:
```html
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
```

### Semantic markup
Use meaningful elements: `<header>`, `<nav>`, `<main>`, `<article>`, `<section>`, `<footer>`,
`<figure>`, `<figcaption>`, `<time>`. Avoid wrapping everything in `<div>` when a semantic element exists.

### Attribute conventions
- Always **double quotes** on attribute values
- Attribute order: `class`, `id`/`name`, `data-*`, `src`/`for`/`type`/`href`/`value`, `title`/`alt`, `role`/`aria-*`
- Don't self-close void elements (`<img>` not `<img />`)
- Always include closing tags for non-void elements

### IDs vs classes
- **Classes** for styling — reusable, composable
- **IDs** for JS hooks, in-page anchors, and `<label for>` associations
- Names: lowercase, hyphen-separated (`primary-button` not `primaryButton`)
- Semantic names (`secondary-nav`) not presentational (`left-nav`, `blue-button`)

### Forms
- Wrap controls in `<form>` with a meaningful `action`
- Every `<input>`, `<select>`, and `<textarea>` gets an associated `<label>` with matching `for`/`id`
- Use HTML5 input types: `type="email"`, `type="tel"`, `type="number"`, `type="date"` — these give built-in validation and mobile-native keyboards
- Don't use placeholder text as a substitute for labels
- Use inline validation (validate as the user types, not only on submit)
- Use a descriptive action label on submit buttons — "Send Message", "Create Account", "Request Quote" — not generic "Submit"

### Tables
Use `<table>` only for tabular data. Include `<thead>`, `<tbody>`, `<caption>`, and `scope` on `<th>`.

### Links
`href` must point to a real URL. Never `javascript:void(0)`.

### Images — CLS prevention
Every `<img>` element requires three attributes to prevent cumulative layout shift:
```html
<img src="photo.jpg" alt="Description of the image" width="600" height="400">
```
All three (`alt`, `width`, `height`) are mandatory on every image. Use `<picture>` / `srcset` for responsive images.

### Indentation
4 spaces per level (soft tabs).

---

## CSS

### Methodology: OOCSS + component naming
Use a component-element naming pattern with hyphen separation. The base component name (e.g. `.card`) is the root, and child elements extend it with hyphens:

```css
/* Base component */
.card { ... }

/* Component elements — always prefixed with component name */
.card-image { ... }
.card-title { ... }
.card-price { ... }
.card-body { ... }

/* Modifiers — prefixed mod- */
.mod-featured { ... }

/* State — prefixed is- */
.is-expanded { ... }

/* JS hooks — prefixed js-, never styled in CSS */
.js-toggle { }

/* Utilities — prefixed u- */
.u-visually-hidden { ... }
```

This naming pattern is important because it makes the relationship between parent and child elements obvious at a glance. Always follow it.

### Box model — set this first
At the top of every stylesheet, before any other rules:
```css
*, *::before, *::after {
    box-sizing: border-box;
}
```
This prevents width calculation surprises and is expected by other developers reading your code.

### Formatting rules
- One selector per line when multiple selectors share a rule
- One declaration per line
- Space before `{`: `.selector {`
- Space after `:`: `color: red;`
- Always terminate with `;`, including the last declaration
- **Alphabetise properties** within each rule
- Blank line between rule sets

### Specificity
- Keep specificity low. Prefer class selectors over element or ID selectors.
- Never use `!important`. There are almost no legitimate use cases in component code.
- `.card-title` beats `.card .card-header h2` — use the simplest selector that works.

### Colours
- Hex for opaque: always 6 digits (`#aabbcc` not `#abc`)
- `rgb()` modern syntax for opacity: `rgb(31 41 59 / 0.26)`
- CSS custom properties for any colour used more than once

### Typography / lengths
- Relative units by default: `rem`, `em`, `%`, viewport units
- Root `font-size: 16px`; use `rem` for sizing
- Keyword font weights (`normal`, `bold`) over numbers

### No inline styles
Never use the `style` attribute in HTML.

### Media queries — mobile-first (critical)

This is one of the most important patterns in responsive CSS. Your base styles (outside any media query) must target the smallest screen. Then use `min-width` or the range syntax `width >=` to layer on styles for larger screens:

```css
/* Base styles — mobile, no media query needed */
.card-grid {
    display: grid;
    gap: 1rem;
    grid-template-columns: 1fr;
}

/* Tablet and up */
@media (min-width: 600px) {
    .card-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

/* Desktop */
@media (min-width: 1024px) {
    .card-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}
```

The modern range syntax `@media (width >= 600px)` is also acceptable and equivalent.

Never use `@media (max-width: ...)` for responsive breakpoints. max-width is a desktop-first pattern that contradicts the mobile-first principle.

Place media queries immediately below their related component rules.

### Dark mode
Include `@media (prefers-color-scheme: dark)` alternatives.

### Stylesheet section order
1. CSS custom properties / design tokens
2. Reset / normalise
3. Base HTML element defaults
4. Layout / grid
5. Reusable components
6. Page-specific styles
7. Utilities

---

## JavaScript

### Inclusion
Place `<script>` just before `</body>`, or use `defer` in `<head>`.
Never use inline event handlers (`onclick=`, `onchange=`, etc.) in HTML.

### Formatting
- 4 spaces indentation
- Semicolons always
- Single quotes for strings
- `===` not `==`
- `const`/`let` only (no `var`), each on its own line
- camelCase for variables/functions; TitleCase for classes; UPPER_SNAKE_CASE for constants
- Prefix booleans with `is` where natural: `isOpen`, `isValid`

### No global pollution
Wrap code in IIFEs, modules, or `DOMContentLoaded` callbacks.

### Event handling
Use event delegation — bind to a stable parent:
```js
document.querySelector('.list').addEventListener('click', (e) => {
    if (e.target.matches('.list-item')) { ... }
});
```

### Performance
- Use `transform` and `opacity` for animations, never `top`/`left`/`width`/`height`
- Debounce `scroll` and `resize` handlers
- Batch DOM reads and writes

---

## Accessibility

Every interactive component must be keyboard-accessible and screen-reader friendly:

- One `<h1>` per page; heading levels sequential
- All interactive elements reachable via Tab / arrow keys / Enter / Space
- Visible focus indicators — never remove outline without replacement
- `alt` on all images (empty `alt=""` for decorative)
- **ARIA on interactive controls**: Buttons that toggle something need `aria-expanded` and `aria-controls`. Navigation landmarks need `aria-label` when there are multiple `<nav>` elements. Custom controls need appropriate `role`, `aria-*` attributes.
- Colour contrast: WCAG AA minimum (4.5:1 text, 3:1 UI)
- Keyboard dismiss: overlay/modal/panel components must close on Escape key

---

## Performance & CLS Prevention

- `width` and `height` on all `<img>`, `<video>`, `<iframe>` elements
- `aspect-ratio` in CSS for fluid media containers
- Never dynamically inject content above existing content
- `font-display: swap` on web fonts
- `loading="lazy"` on below-fold images
- `<link rel="preconnect">` for external domains
- Concatenate, minify, gzip for production

---

## Responsive Design

- Code mobile-first: base styles for smallest screen, `min-width` queries upward
- Let content dictate breakpoints, not device dimensions
- Never target specific devices ("iPad landscape")
- Navigation: provide off-canvas or overlay pattern for mobile when horizontal nav doesn't fit
- Data tables: wrap in a scrollable container at minimum

---

## Code Quality Checklist

Before delivering front-end code, verify:
- [ ] `<!doctype html>` and `<meta charset="UTF-8">`
- [ ] Every `<img>` has `alt`, `width`, `height`
- [ ] Every form input has a `<label>` with matching `for`/`id`
- [ ] Heading hierarchy starts at `<h1>`, levels are sequential
- [ ] No inline styles, no inline event handlers
- [ ] No `!important`
- [ ] All responsive media queries use `min-width` or `width >=` (mobile-first)
- [ ] `box-sizing: border-box` set globally
- [ ] CSS class names follow component-element pattern (`.card`, `.card-title`)
- [ ] Dark mode `prefers-color-scheme` rules included
- [ ] Interactive components have ARIA attributes (`aria-expanded`, `aria-controls`)
- [ ] Keyboard navigation works (Tab, Escape for dismissals)
- [ ] Animations use `transform`/`opacity`, not layout properties
