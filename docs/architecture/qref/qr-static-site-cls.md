# qr-static-site-cls: Cumulative Layout Shift on a static site — the killer trio

> **Three cheap fixes prevent ~95% of CLS on a static HTML/CSS/JS site: explicit image dimensions, font loading discipline, and `defer` on every `<script>`. Skip any one and Lighthouse will tell you so. This qref is the recipe.**

---

## Symptom

- Lighthouse mobile score < 95 with **Cumulative Layout Shift** flagged red.
- Visible "jump" on first paint when an image, web font, or async-loaded script lands.
- A button or link moves under the user's pointer between hover and click.
- Text reflows after fonts swap in (FOUT — flash of unstyled text — but with layout shift).

CLS is measured in unitless "layout shift score" — the size of the shifted area as a fraction of the viewport, multiplied by the distance moved. **Target: ≤ 0.1.** Mobile is harder than desktop because the viewport is smaller, so any shift counts proportionally more.

---

## Root cause

Browser layout works in passes. If the browser commits to a layout before knowing the final size of an element, then the element loads and is bigger/smaller than the placeholder, everything around it shifts. The three usual culprits:

1. **Images without intrinsic dimensions.** The browser can't reserve space, so it lays out around `0×0`, then reflows when the bytes arrive.
2. **Web fonts swapping in.** System font is shorter/taller/wider than the web font; when the swap happens, every line wraps differently.
3. **Synchronously parsed `<script>` tags.** The browser pauses parsing the HTML, fetches and runs the script, then resumes — but if the script injects DOM, it shifts everything below it.

---

## Worked example — a hero image without dimensions

Bad markup (causes ~0.15 CLS on a 393px-wide mobile viewport):

```html
<img src="hero.jpg" alt="Hero">
```

What happens on first paint:

1. Browser lays out the page assuming `<img>` is `0×0`.
2. Hero image loads (say 1600×900, scaled to 393×221 in CSS).
3. Browser reflows; everything below the image jumps down 221px.
4. CLS spikes.

Good markup:

```html
<img
  src="hero.jpg"
  alt="Hero"
  width="1600"
  height="900"
  fetchpriority="high">
```

`width` and `height` give the browser an aspect ratio to reserve. The image still scales via CSS (`width: 100%; height: auto`); the attributes are just dimension hints, not pixel commitments.

Even better, use `aspect-ratio` on the container so the slot is reserved even before the `<img>` exists in the DOM (e.g., for a lazy-mounted carousel slide):

```html
<div class="hero" style="aspect-ratio: 16/9">
  <img src="hero.jpg" alt="Hero" width="1600" height="900">
</div>
```

---

## Remedy — the trio

### 1. Every `<img>` has `width`, `height`, and `alt`

```html
<img
  src="photo.jpg"
  alt="A descriptive caption — never empty for content images"
  width="800"
  height="600"
  loading="lazy">       <!-- below-fold only -->
```

- `width` and `height` are HTML attributes (not CSS). They set the intrinsic ratio.
- CSS still controls actual rendered size: `img { max-width: 100%; height: auto; }`.
- Above-the-fold images (LCP candidates) get `fetchpriority="high"` and **no** `loading="lazy"`.
- Below-fold images get `loading="lazy"` to defer download until near-viewport.
- `srcset` for retina:

  ```html
  <img
    src="photo-500.jpg"
    srcset="photo-250.jpg 250w, photo-500.jpg 500w"
    sizes="(min-width: 768px) 50vw, 100vw"
    alt="..."
    width="500"
    height="375">
  ```

### 2. Font loading without layout shift

Default web font behaviour swaps fonts when they load — that *is* the shift. Three ways to prevent it:

**Option A — system font stack only (no web fonts).** Zero CLS from fonts. Trade-off: less brand control.

```css
:root {
  --font-body: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
}
```

**Option B — `font-display: optional`.** Browser uses the system fallback for the entire pageview if the web font isn't ready in ~100ms. No swap, no shift, but the user might never see your web font on a slow connection.

```css
@font-face {
  font-family: "Inter";
  src: url("/fonts/Inter.woff2") format("woff2");
  font-display: optional;
}
```

**Option C — `font-display: swap` + `size-adjust` matching.** Browser uses fallback immediately, then swaps. Use `size-adjust`, `ascent-override`, `descent-override` on a CSS `@font-face` declaration of the *fallback* to make the fallback metrics match the web font, so the swap is invisible.

```css
@font-face {
  font-family: "Inter Fallback";
  src: local("Arial");
  size-adjust: 107%;
  ascent-override: 90%;
  descent-override: 22%;
  line-gap-override: 0%;
}
```

Then `font-family: "Inter", "Inter Fallback", sans-serif`. Tools like [Fontaine](https://github.com/danielroe/fontaine) automate the metric calculation.

**Pre-load critical fonts** so they're ready before first paint:

```html
<link
  rel="preload"
  href="/fonts/Inter.woff2"
  as="font"
  type="font/woff2"
  crossorigin>
```

### 3. `defer` on every `<script>` tag

```html
<script src="js/main.js" defer></script>
```

`defer` does three useful things:

1. **Async download** — browser fetches the script in parallel with HTML parsing.
2. **Parse-after-parse** — script executes only after HTML is fully parsed, i.e. after the DOM exists.
3. **Order preserved** — multiple `defer` scripts execute in source order. Use this for dependency chains.

Compare:

| Attribute | Download | Execute | DOM ready? | Order? |
|---|---|---|---|---|
| `<script>` (no attr) | blocking | blocking | no — pauses parsing | source |
| `<script async>` | parallel | as soon as downloaded | maybe | unpredictable |
| `<script defer>` | parallel | after HTML parsed | yes | source |

For a static site, **defer is almost always right**. `async` only when the script is genuinely independent (an analytics ping that doesn't read or write DOM).

`type="module"` is implicitly `defer`. So:

```html
<script type="module" src="js/main.js"></script>
```

…is equivalent to `defer` and you don't need to write the attribute.

---

## Verification

After applying the trio, verify:

```bash
# Lighthouse from CLI
npx lighthouse https://your-site.example/ --view --preset=mobile

# Or from Chrome DevTools — Performance Insights → CLS
```

Target: CLS ≤ 0.1, ideally ≤ 0.05.

Programmatic measurement (paste into DevTools console while loading):

```js
new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    if (!entry.hadRecentInput) {
      console.log("CLS shift:", entry.value, "sources:", entry.sources);
    }
  }
}).observe({ type: "layout-shift", buffered: true });
```

Each `value` is one shift; sum them across the page lifetime to get total CLS.

---

## Common gotchas

- **Embedded YouTube / iframe widgets** without explicit dimensions reflow when the iframe loads. Wrap in an `aspect-ratio` container.
- **Animated banners or accordions** that change height after JS hydrates count as shifts unless the user explicitly interacts (`hadRecentInput: true` exempts those). For first-paint banners, reserve space in CSS.
- **Web ads** are CLS poison. If you must include them, reserve a fixed-size slot.
- **Cookie banners** that push content down on appearance shift everything. Position them as `fixed` overlays, not in document flow.

---

## See also

- `CORE_PATTERNS.md` — performance-related G constraints.
- [web.dev: Cumulative Layout Shift](https://web.dev/articles/cls)
- [web.dev: Optimize CLS](https://web.dev/articles/optimize-cls)
- [Fontaine](https://github.com/danielroe/fontaine) — automatic font metric matching.
