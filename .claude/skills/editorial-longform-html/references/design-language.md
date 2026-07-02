# Design language — engineering reference docs

Visual style guide for long-form engineering reference HTML at Metron.
Use it when a document needs the gravitas of a published handbook —
architecture writeups, library guides, system internals, postmortems.

Reference implementations:

- `docs/tiger-cloud-per-service-roles-guide.html` — the canonical example
- `common-infra/docs/cognito-s3-cloudfront/architecture.html`
- `common-infra/docs/cognito-s3-cloudfront/how-to-create-a-protected-site.html`

For the drop-in template, see [`templates/engineering-reference.html`](templates/engineering-reference.html).

## When to use this style

- **Yes:** internal architecture docs, library / framework guides, how-tos, postmortems, design records, anything with a "reference" feel.
- **No:** customer-facing marketing pages, status dashboards, quick READMEs, anything where the editorial tone is wrong. Pick a different language for those.

## Design tokens

```css
:root {
  /* Paper background, soft ecru tints */
  --bg:           #f3ecdd;   /* base */
  --bg-soft:      #ece4d2;   /* TOC, notes, hover */
  --bg-code:      #e6dcc4;   /* inline-code background */

  /* Ink */
  --ink:          #000;      /* body text — pure black for contrast */
  --ink-soft:     #3a3a36;   /* italics, captions, mini-map links */
  --ink-mute:     #6b6357;   /* footer, meta, eyebrow tags, mini-map numerals */

  /* Forest — primary structural color */
  --forest:       #1f3a32;
  --forest-deep:  #142822;   /* h1 / h2 / code-block bg */

  /* Copper — single accent */
  --copper:       #a85a1a;
  --copper-soft:  #c87a2f;

  /* Rules */
  --rule:         #c9bfa3;
  --rule-strong:  #8a7e5e;
}
```

Use copper sparingly. It's the only saturated color on the page; if everything is copper, nothing is. Reserve it for eyebrows, links, accents on callouts, and the drop cap.

**On `--ink: #000`.** Pure black for body text reads cleanly on the cream paper background and avoids the "slightly faint" feel that softer dark-gray inks have on warm-toned backgrounds. The body color used to be `#1a1d1c` (a warm near-black) but was lifted to pure `#000` after readability feedback. `--ink-soft` and `--ink-mute` retain their tonal warmth — the visual hierarchy is "true black for body, warm subdued grays for secondary content."

## Typography

Three families, loaded from Google Fonts:

| Family | Role | Notes |
|---|---|---|
| **Fraunces** | Display + lede + h2/h3 | Variable axes: `opsz` 9–144, `wght` 300–900, `SOFT` 0–100. Use `opsz` 144 + `SOFT` 50 for h1, italic at `SOFT` 100 for accents. |
| **Source Serif 4** | Body | Variable `opsz` 8–60. 17px / 1.65 line-height for body. |
| **JetBrains Mono** | Eyebrows, code, labels, table headers | 11px @ 0.28em letter-spacing for uppercase eyebrows. |

```html
<link href="https://fonts.googleapis.com/css2?family=Fraunces:opsz,wght,SOFT@9..144,300..900,0..100&family=Source+Serif+4:opsz,wght@8..60,300..700&family=JetBrains+Mono:wght@400;600&display=swap" rel="stylesheet">
```

## Patterns

### Eyebrow

Small uppercase mono caption sitting above section heads or as the masthead category line.

```html
<div class="eyebrow">Engineering Reference · Metron Common Infrastructure</div>
```

```css
.eyebrow {
  font-family: "JetBrains Mono", monospace;
  font-size: 11px;
  letter-spacing: 0.28em;
  text-transform: uppercase;
  color: var(--copper);
  margin-bottom: 24px;
}
```

### Section numbers

Each top-level section gets a numbered eyebrow as `§ 01`, `§ 02`, etc. Built into the h2:

```html
<h2><span class="num">§ 04</span>Request flow</h2>
```

For how-to documents, swap the section number for `Step / 01` (or whatever kind label fits — "Before you start", "Clean up", "Reference"):

```html
<h2><span class="kind">Step / 03</span>Write your site stack</h2>
```

### H1 with italic accent

The display heading gets one italicized word in copper, set in Fraunces at maximum optical size and softness.

```html
<h1>Cognito-Protected <em>Static Sites</em></h1>
```

```css
h1 {
  font-family: "Fraunces", serif;
  font-variation-settings: "opsz" 144, "SOFT" 50;
  font-weight: 400;
  font-size: 60px;
  line-height: 1.02;
  letter-spacing: -0.02em;
  color: var(--forest-deep);
}
h1 em {
  font-style: italic;
  font-variation-settings: "opsz" 144, "SOFT" 100;
  color: var(--copper);
}
```

### Lede

A single italicized Fraunces paragraph directly under the h1, capped at ~640px so it sets in a comfortable measure:

```css
.lede {
  font-family: "Fraunces", serif;
  font-variation-settings: "opsz" 72;
  font-weight: 300;
  font-style: italic;
  font-size: 22px;
  line-height: 1.45;
  color: var(--ink-soft);
  max-width: 660px;
}
```

### Drop cap

Apply `.lead-para` to the first paragraph of the document's opening section. The drop cap is floated, italic, copper, four lines tall.

```css
.lead-para::first-letter {
  font-family: "Fraunces", serif;
  font-variation-settings: "opsz" 144, "SOFT" 100;
  font-weight: 400;
  font-style: italic;
  float: left;
  font-size: 68px;
  line-height: 0.85;
  margin: 8px 10px 0 0;
  color: var(--copper);
}
```

One drop cap per document. Don't repeat it on subsequent sections.

### Code blocks

Dark on cream — the only place dark backgrounds appear in the design. 3px copper left border anchors them visually.

```css
pre {
  font-family: "JetBrains Mono", monospace;
  background: var(--forest-deep);
  color: #e6dcc4;
  padding: 22px 26px;
  border-radius: 4px;
  font-size: 13px;
  line-height: 1.6;
  border-left: 3px solid var(--copper);
}
```

Inline `code` uses the cream `--bg-code` with a `--rule` border and forest-deep text. Keep them visually distinct from prose without screaming.

#### Syntax highlighting

Block code is highlighted by an inlined, curated Prism build (see "Syntax highlighting" in SKILL.md). Tag the inner `<code class="language-ts">`; untagged blocks stay plain. The token theme stays inside the warm editorial ramp — this is the one sanctioned place a color beyond copper appears, and even here the palette is deliberately warm and desaturated, never cool:

| Token role | Color | Notes |
|---|---|---|
| keyword, tag, selector, control, docker instruction | `#d98a44` copper | bold; the "look here" color |
| operator, entity, url | `#c9a06a` amber-tan | |
| number, boolean, constant, function name, macro | `#e3b25e` gold | |
| string, char, attr-value, regex, template-string | `#a9b87f` olive | |
| class-name, type, key, property, attr-name, builtin | `#cdb58a` sand | |
| variable, parameter | `#d9c9a8` light tan | |
| comment | `#968b6c` khaki | italic; recedes |
| punctuation | `#b8ac8a` | |
| diff inserted / deleted | olive / `#cf8a5a` terracotta | warm background bands, scoped to `language-diff` |

The `<pre>` surface is dark in both light and espresso-dark themes, so one token palette reads in both — there's no separate dark-mode token set. Never substitute a stock Prism/highlight.js theme; the rainbow defaults fight the register.

### Notes / callouts

Three variants, all anchored by a left border and a mono label.

```html
<div class="note caveat">
  <span class="note-label">Caveat · MET-2425</span>
  <p>CloudFormation exports are region-scoped…</p>
</div>
```

| Variant | Border | Use for |
|---|---|---|
| `.note` (default) | `--rule-strong` | Operational notes, asides, "by the way" |
| `.note.warn` | `--copper-soft` | "This step is manual today" / process gaps |
| `.note.caveat` | `--copper` | Hard constraints, region limits, known-broken cases |
| `.note.good` | `--forest` (+ faint forest tint background) | Success states, "if you see this it worked" |

The label is always JetBrains Mono 10px, uppercase, letterspaced 0.20em, in the matching accent color.

### TL;DR / pull quote

Italic Fraunces with a 3px copper left border, no background:

```css
.tldr {
  border-left: 3px solid var(--copper);
  padding: 4px 0 4px 24px;
  font-family: "Fraunces", serif;
  font-variation-settings: "opsz" 32;
  font-style: italic;
  font-size: 19px;
  line-height: 1.5;
  color: var(--ink-soft);
}
```

### Tables

Mono uppercase letterspaced headers in copper; rule borders; soft hover. Numeric columns can use a right-aligned mono variant.

```css
thead th {
  font-family: "JetBrains Mono", monospace;
  font-size: 10px;
  font-weight: 600;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--copper);
  border-bottom: 1.5px solid var(--rule-strong);
}
tbody tr:hover { background: var(--bg-soft); }
```

### Lists

Replace the default bullet with a copper `§`:

```css
ul li::marker {
  color: var(--copper);
  content: "§  ";
  font-family: "JetBrains Mono", monospace;
  font-size: 0.85em;
}
```

### Table of contents

Boxed, cream background, copper left border, JetBrains Mono "Contents" eyebrow header. Two-column layout via CSS `columns: 2`. Items numbered with `decimal-leading-zero` counters.

```css
nav.toc ol.toc-list > li::before {
  content: counter(toc, decimal-leading-zero);
  font-family: "JetBrains Mono", monospace;
  font-size: 10px;
  color: var(--copper);
  margin-right: 12px;
  letter-spacing: 0.1em;
}
```

For how-to docs, use `content: "STEP / " counter(toc, decimal-leading-zero)` in a single column.

### Clickable document title

The `<h1>` wraps its content in `<a href="#" class="title-link">`. Clicking the title sets the URL hash to empty, which clears any section-level hash the reader may have set by navigating to a `<h2>` or per-entry heading. The address bar then shows the canonical document URL (with a trailing `#`, which is benign and copy-pasteable).

```html
<h1>
  <a href="#" class="title-link">Cognito-Protected <em>Static Sites</em></a>
</h1>
```

```css
a.title-link {
  color: inherit;
  text-decoration: none;
  transition: color 0.18s;
}
a.title-link:hover { color: var(--copper); }
a.title-link:hover em { color: var(--copper-soft); }
```

At rest the title-link is visually identical to a plain `<h1>` — the existing italic-accent `<em>` keeps its copper color. On hover the surrounding title turns copper and the `<em>` shifts to copper-soft so the accent is still visibly distinct from the rest.

### Self-anchoring section headings

Every section `<h2>` wraps its content in an `<a href="#section-id" class="heading-link">` so the heading itself is clickable. Clicking it sets the URL hash and the section URL can be copied from the address bar without using the TOC.

```html
<section id="problem">
  <h2><a href="#problem" class="heading-link"><span class="num">§ 02</span>The problem</a></h2>
  …
</section>
```

```css
a.heading-link {
  color: inherit;
  text-decoration: none;
  transition: color 0.18s;
}
a.heading-link:hover { color: var(--copper); }
a.heading-link:hover .num,
a.heading-link:hover .kind { color: var(--copper-soft); }
```

Styling at rest is identical to a plain `<h2>` — the link is invisible unless the reader hovers, at which point the heading text turns copper. The `§ NN` prefix also responds to hover. No JavaScript.

This pattern extends to any sharable subheading. For per-entry reference content (catalog of items, list of named entries with type tags), give each entry's heading an id and wrap it the same way:

```html
<h4 class="entry" id="entry-outbound-notifications">
  <a href="#entry-outbound-notifications" class="heading-link">
    <span class="entry-name">Outbound Notifications</span>
    <span class="entry-tag">Type A · active strategic</span>
  </a>
</h4>
```

### Floating mini-map TOC

A fixed-position companion TOC in the left gutter, shown only at viewport widths ≥ 1180px (where there's enough gutter space outside the 880px container). Entries mirror the main TOC.

```html
<nav class="minimap" aria-label="On this page">
  <div class="minimap-label">§ On this page</div>
  <ol>
    <li><a href="#problem">The problem</a></li>
    <li><a href="#model">The model</a></li>
    <!-- match the main TOC -->
  </ol>
</nav>
```

Key positioning trick: `left: max(20px, calc(50vw - 580px))` so the mini-map's right edge sits exactly at the left edge of the 880px content column for any viewport ≥ 1180px. Below that, the gutter is too narrow and the nav is hidden via `display: none`.

```css
.minimap { display: none; }
@media (min-width: 1180px) {
  .minimap {
    display: block;
    position: fixed;
    top: 96px;
    left: max(20px, calc(50vw - 580px));
    width: 140px;
    z-index: 5;
    font-family: "JetBrains Mono", monospace;
    font-size: 9px;
    letter-spacing: 0.1em;
    line-height: 1.5;
    color: var(--ink-soft);
  }
  .minimap a {
    display: block;
    padding: 4px 8px 4px 12px;
    color: var(--ink-soft);
    text-decoration: none;
    border-left: 2px solid var(--rule);
    text-transform: uppercase;
  }
  .minimap a::before {
    content: counter(mm, decimal-leading-zero) "  ";
    color: var(--ink-mute);
  }
  .minimap a:hover { color: var(--copper); border-left-color: var(--copper); }
}
```

**Progressive enhancement.** On browsers that support scroll-driven animations, the mini-map fades in once the reader has scrolled past the masthead (≈500–750px). Browsers without support get the always-visible version, so there's no JS fallback to maintain.

```css
@supports (animation-timeline: scroll()) {
  @media (min-width: 1180px) {
    .minimap {
      opacity: 0;
      animation: minimap-fade-in linear both;
      animation-timeline: scroll();
      animation-range: 500px 750px;
    }
    @keyframes minimap-fade-in { to { opacity: 1; } }
  }
}
```

This is the **only** sanctioned animation in the design language — see the anti-patterns at the bottom.

### Series navigation

For multi-part document sets, a small forest-bordered nav block between the masthead and the main TOC. The current part is marked with `class="current"`; the others link out.

```html
<nav class="series-nav" aria-label="In this series">
  <span class="series-label">In this series</span>
  <ol>
    <li><a href="../part-1/">Part 1 — Overview and Rationale</a></li>
    <li class="current">Part 2 — Linear Structure Guide</li>
    <li><a href="../part-3/">Part 3 — Migration Plan</a></li>
  </ol>
</nav>
```

```css
.series-nav {
  margin: 0 0 56px;
  padding: 18px 24px;
  background: var(--bg-soft);
  border-left: 3px solid var(--forest);
  font-family: "JetBrains Mono", monospace;
  font-size: 11px;
  letter-spacing: 0.14em;
  text-transform: uppercase;
}
.series-nav .series-label { color: var(--forest); font-weight: 600; letter-spacing: 0.22em; }
.series-nav li.current::before { content: "▸ "; color: var(--copper); }
```

The forest border (rather than copper) keeps the series block visually distinct from the TOC and other copper-anchored navigation. Useful when a doc set has standalone members — the standalone doc drops the series-nav, the series members carry it.

### Restricted / internal-only banner

A small chip sitting above the masthead that makes it immediately obvious if the doc shows up in a place it shouldn't. Use for personal-reference docs, internal analyses with candid stakeholder commentary, or anything that would be uncomfortable circulated more broadly.

```html
<div class="restricted-banner">Internal · Personal Reference · Not for Distribution</div>
```

```css
.restricted-banner {
  margin: 0 0 20px;
  padding: 10px 16px;
  background: rgba(168, 90, 26, 0.08);
  border: 1px solid var(--copper);
  border-radius: 2px;
  font-family: "JetBrains Mono", monospace;
  font-size: 10px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  color: var(--copper);
  text-align: center;
}
```

Faint copper tint behind a copper outline — calm in context but unmistakable when the doc opens. Don't make it red or louder; the editorial register doesn't shout.

### Figure with caption

For inline diagrams (hand-rolled SVG, Mermaid, static images). The figure provides spacing and the caption gets centered italic styling matching the lede tone.

```html
<figure class="diagram">
  <svg viewBox="0 0 880 200" role="img" aria-labelledby="d-title d-desc">
    <title id="d-title">Diagram title</title>
    <desc id="d-desc">Prose description for screen readers.</desc>
    <!-- SVG markup using --forest, --copper, --ink-soft for marks -->
  </svg>
  <figcaption>Caption — italic Source Serif, ~14px, centered, max 680px.</figcaption>
</figure>
```

```css
figure.diagram { margin: 40px 0 44px; }
figure.diagram svg { width: 100%; height: auto; display: block; }
figure.diagram figcaption {
  margin: 16px auto 0;
  max-width: 680px;
  text-align: center;
  font-family: "Source Serif 4", Georgia, serif;
  font-style: italic;
  font-size: 14px;
  line-height: 1.55;
  color: var(--ink-soft);
}
```

Always include `role="img"` plus a `<title>` and `<desc>` inside the SVG for screen-reader users. The visible `<figcaption>` is a complement, not a substitute.

### Figure zoom

The template bundles a click-to-zoom lightbox so dense diagrams (small
Mermaid labels, fine SVG detail) can be opened large. It is the single
scripted feature in the language — treat it as a built-in, not something
to reinvent per document.

- **Trigger.** Any `<figure>`, `.mermaid` block, or standalone `<img>`
  becomes zoomable automatically (a `MutationObserver` also catches
  Mermaid diagrams once they render). A mono "Click to zoom" hint
  (JetBrains Mono, 9px, `--copper` on a faint `--bg` chip) fades in on
  hover; the cursor becomes `zoom-in`.
- **Lightbox.** `--bg` backdrop at ~0.97 opacity with a 4px blur —
  light, never a dark Material scrim. The figure fits to ~92vw × 90vh
  and SVG scales crisply. The stage fills the viewport so a zoomed-in
  wide diagram pans without clipping.
- **Controls.** A mono `--bg-soft` chip bar with `--copper` labels
  (`− / 100% / + / Reset / Close`), no icons. Scroll or the buttons
  zoom (wheel step is proportional to scroll distance), drag pans,
  double-click toggles, `Esc` / backdrop click closes.
- **Don't** restyle it louder (drop shadow, dark overlay, iconography)
  or extend the script to other interactive behaviors — either breaks
  the register.

### Ornament divider

Used to break up very long sections — never adjacent to a section heading, only between content blocks. Three centered section marks letterspaced 1em:

```html
<div class="ornament">§ § §</div>
```

### Footer

Mono uppercase letterspaced row at the bottom. Repeat the doc identifier, the publishing context, and the date. Three-up flex with a top rule.

## Surface details

- **Paper background.** Solid `--bg` plus two faint radial gradients (copper top-left, forest bottom-right at 5–6% opacity). Optional SVG noise grain overlay at 4% opacity with `mix-blend-mode: multiply` adds tactile depth without distracting.
- **No drop shadows.** This is print, not Material.
- **No animations.** Static editorial layouts only.
- **Light mode only.** Skip `prefers-color-scheme: dark` — pick a different language for dark.

## Diagrams

### Mermaid

Theme via `theme: 'base'` + `themeVariables` mapping the design tokens to Mermaid's actor / signal / note variables. Use JetBrains Mono for diagram text so it harmonizes with the page's mono labels.

Minimum config:

```js
mermaid.initialize({
  startOnLoad: true,
  theme: 'base',
  themeVariables: {
    fontFamily: '"JetBrains Mono", monospace',
    fontSize: '13px',
    primaryColor: '#ece4d2',
    primaryBorderColor: '#1f3a32',
    primaryTextColor: '#142822',
    lineColor: '#3a3a36',
    secondaryColor: '#e6dcc4',
    tertiaryColor: '#f3ecdd',
    actorBkg: '#ece4d2',
    actorBorder: '#1f3a32',
    actorTextColor: '#142822',
    signalColor: '#3a3a36',
    signalTextColor: '#142822',
    noteBkgColor: '#f3ecdd',
    noteBorderColor: '#a85a1a',
  },
});
```

### Hand-drawn SVG

For topology / architecture diagrams that Mermaid can't express well, hand-author SVG using the design tokens directly. Italic-Fraunces labels, JetBrains Mono sub-labels and eyebrows, ink-soft solid arrows, rule-strong dashed arrows. Wrap in `<figure class="topology">` with `--bg-soft` background and a `--rule` border for inset framing.

## Responsive + print

Standard breakpoint at `720px`:

- Container padding shrinks (56px → 28px horizontal).
- H1 drops to 42px, h2 to 26px.
- TOC collapses to single column.
- Meta row stacks vertically.
- Code blocks shrink to 12px.

Print stylesheet strips the grain and TOC, swaps code blocks to a light background, and adds `page-break-inside: avoid` to sections so printed copies break sensibly.

## Layout

```css
.container {
  max-width: 880px;       /* architecture / reference docs */
  max-width: 820px;       /* how-tos and shorter docs */
  margin: 0 auto;
  padding: 80px 56px 120px;
}
```

The 880px / 820px ceiling keeps text in a comfortable reading measure (~70–80 characters) and matches the editorial feel.

## Anti-patterns

- **Don't mix dark and light surfaces** beyond the documented exception (code blocks). Notes are cream, not white.
- **Don't use Inter, Roboto, or system-ui.** The whole point of this aesthetic is that it's not generic.
- **Don't introduce a second accent color.** Copper carries every accent role; adding teal or red dilutes it.
- **Don't add icons.** The mono section numbers and `§` marks are the iconography.
- **Don't auto-link Linear / GitHub issues.** Manual `<a href="…">MET-2425</a>` with the linear.app URL is fine; don't write a JS rewriter.
- **Don't use the drop cap on every section.** One per document.
- **Don't extrapolate from the mini-map fade-in to other animation.** The scroll-driven fade is the *only* sanctioned animation in the language. It's allowed because (1) it's a navigation aid, not content; (2) it's progressive enhancement behind `@supports` — browsers without support get the same nav always-visible; (3) it's tied to scroll position, not time. Don't extend this to hover transitions on content elements, decorative motion, or anything that fades in over time.
- **The figure-zoom lightbox is the one sanctioned script.** It's a readability aid for dense diagrams, fully self-contained, and inert when the doc has no figures. Its presence does not license other JavaScript, client-side state, or decorative motion — the rest of the language stays static HTML/CSS. If you want interactivity beyond opening a figure, this is the wrong style.
- **Don't drop the heading-link wrap to "clean up" the markup.** The self-anchoring section pattern is part of the design. Without it, getting a section URL requires fishing through the TOC; with it, the address bar is the canonical share point.
