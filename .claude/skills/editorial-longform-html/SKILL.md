---
name: editorial-longform-html
description: Author long-form reference documents as standalone HTML in the editorial-print aesthetic — ecru paper background, Fraunces display + Source Serif body + JetBrains Mono labels, forest/copper accents, numbered sections, mono eyebrows. The style leans technical but is not engineering-only — use it for any substantive long-form internal document that wants the gravitas of a published handbook: architecture writeups, library/framework guides, system internals, postmortems, design records, RFCs, runbooks, ADRs AND product strategy memos, product requirements / PRDs, roadmap rationale, process playbooks, operational handbooks, policy or governance documents, retrospectives, org-design proposals, vendor evaluations, and similar. Use both when converting from markdown AND when authoring HTML directly to take advantage of inline SVG diagrams, hand-drawn topology figures, interactive Mermaid, hover states, side-by-side code/diagram layouts, or any visual technique that markdown can't express. Trigger on phrases like "make an HTML version", "render this as a doc", "publish this writeup", "convert to HTML", "write this directly in HTML", "reference doc", "playbook", "handbook page", "a doc with diagrams", or whenever the user supplies substantive technical/product/process content and asks for a polished HTML output — assume this style is the default for that class of document unless the user names a different one. Do NOT use for customer-facing marketing pages, status dashboards, quick READMEs, ephemeral status updates, or anything where the editorial tone would feel wrong. ALSO trigger on any request to add, file, or register a document into the Reading Room library — "add this to the reading room", "file this in the library", "put this doc in the reading room", "register this in the reading room" — whether the document is already in the editorial style or still needs to be authored or converted from another source (markdown, notes, a plan, a writeup); the skill covers both paths.
---

# Editorial long-form HTML

A house style for substantive long-form internal documents.
Editorial-print feel: cream paper, forest + copper accents, three
typefaces, mono eyebrows, numbered sections. Originally captured for
engineering reference docs, but the register — calm, considered,
print-handbook — fits any document where a reader is expected to *sit
with* the content: technical references, but equally product strategy,
PRDs, process playbooks, policy docs, postmortems, retrospectives. The
canonical reference implementations are
`docs/tiger-cloud-per-service-roles-guide.html` and the
`tiger-cloud-secrets-management.html` companion in the Metron workspace
— don't reinvent the visual language, follow it.

## Scope — what kinds of docs

The style is medium-agnostic about subject matter as long as the
*shape* of the document matches: long-form, sectioned, intended to be
read carefully and referred back to. Some categories that fit
naturally:

- **Technical / engineering** — architecture writeups, library guides,
  system internals, postmortems, RFCs, ADRs, runbooks.
- **Product** — PRDs, strategy memos, roadmap rationale, market
  analyses, competitive landscapes, vendor evaluations.
- **Process / operational** — playbooks, operational handbooks,
  policy and governance docs, org-design proposals, hiring rubrics,
  on-call manuals.
- **Reflective** — retrospectives, decision logs, narrative
  postmortems for non-technical incidents.

When in doubt: if it could plausibly live in a printed company
handbook a year from now, this style fits. If it's ephemeral (status
updates, daily standups, customer-facing copy, marketing), pick
something else.

## The two files you need

- **`assets/engineering-reference.html`** — drop-in template. Start
  every new document by copying this file. It already has the Google
  Fonts link, the CSS variables, every component style, the optional
  Mermaid block, the inlined syntax-highlight pair, the responsive +
  print rules, and TODO markers showing where content goes.
- **`references/design-language.md`** — the full style guide. Read it
  when you need to decide *which* component to reach for or what a
  specific class is supposed to look like. Don't read it just to fill
  in TODOs — only when a design decision is in front of you.

A real example doc (`references/exemplar-tiger-roles.html`) is also
bundled if you want to see the components used in context.

- **`assets/fonts-embedded.css`** — the three typefaces as base64 WOFF2
  data URIs, for when the document must be fully self-contained (most
  importantly, publishing as a Claude Code artifact, whose CSP blocks
  the Google Fonts `<link>`). Not used by default — see "Publishing as
  a Claude Code artifact" below.
- **`assets/prism-bundle.min.js`** — the curated Prism build (core +
  ~18 languages, ~46 KB) that powers syntax highlighting. It is the
  source of truth for the copy already inlined in the template's
  `SYNTAX-HIGHLIGHT:js` block — you don't link or copy it per-doc;
  it's here so the inlined copy is regenerable. See "Syntax
  highlighting" below.

The zoom + theme + mobile bundle inside the template (the
`EDITORIAL-HEAD` / `EDITORIAL-BODY` blocks) is the **canonical copy
from the Reading Room engine's `assets/editorial/{head,body}.html`**
(the `@tlockney/reading-room` engine repo, `tlockney/reading-room` on
GitHub; locally cloned at `~/src/personal/reading-room-lib`), inlined
here so standalone docs are self-contained. A drift test in the engine
repo keeps the two in sync — when changing zoom/theme behavior, edit
the partials there and re-sync this template, don't fork it here.

## Two authoring modes

This skill supports two distinct workflows. Pick the one that matches
intent before you start — they share the same visual language but
imply different planning.

- **Markdown → HTML.** The source of truth is a `.md` file; the HTML
  is a published rendering. Keep the HTML structure close to what
  pandoc or a converter would produce so the two stay in sync.
- **HTML-native authoring.** HTML is the medium and the artifact. Use
  this when the document genuinely needs visual capabilities markdown
  can't express: hand-authored SVG topology diagrams, inline Mermaid,
  multi-column layouts, side-by-side code + diagram callouts, custom
  figures, hover-revealed detail, or sequence diagrams that should
  live next to the prose explaining them. Don't pretend a markdown
  source exists — write the HTML directly and let the visual
  affordances drive the structure.

If a document starts in markdown and outgrows it (you keep wanting to
reach for something the format can't do), promote it to HTML-native
rather than papering over with embedded `<div>`s in the `.md`.

## How to use it

1. **Copy `assets/engineering-reference.html` to the target path.** Don't
   write HTML from scratch — the template's CSS is the design, and
   re-deriving it loses fidelity. This applies to both modes.
2. **Search for `TODO` markers** and fill them in: title, eyebrow text,
   h1 (with one italicized word for the copper accent), lede paragraph,
   TOC entries, sections, footer.
3. **Replace numbered `§ 01 / § 02 / …`** for reference docs, or
   `Step / 01 / Step / 02 / …` for how-to docs. Don't mix the two
   modes in one doc.
4. **Keep section h2s wrapped in `<a href="#id" class="heading-link">`.**
   Self-anchoring headings let a reader click any heading and copy the
   section's URL from the address bar — they're a small interaction win
   and the template ships with them wired up. Don't strip the wrap.
5. **Sync the mini-map with the main TOC.** The floating `<nav class="minimap">`
   block is a persistent companion to the main TOC, shown only at viewport
   ≥ 1180px. Its entries must mirror the main TOC for the same document;
   if you add or remove a section, update both. Delete the block (not just
   the CSS) if you don't want a floating nav.
6. **One drop cap per document.** Apply `.lead-para` to the first
   paragraph of the opening section only.
7. **Delete optional blocks you aren't using.** The template ships with
   commented-out scaffolds for the restricted banner, series-nav, and
   figure.diagram. Uncomment what you need; delete the rest so the
   markup stays tidy.
8. **Delete the Mermaid `<script>` block if you're not using diagrams.**
   Don't ship an unused 80KB import.
9. **Tag every code block with its language — this is the default, not
   an option.** Write `<pre><code class="language-ts">…</code></pre>`
   (`ts`, `sql`, `json`, `bash`, `python`, … — full list under "Syntax
   highlighting" below). An untagged `<pre><code>` renders as flat,
   uncolored text: no error, no warning, just a silently plain block
   that reads as an oversight. Don't hand-write `<span>` tints to color
   code — that legacy approach needs per-doc CSS the template doesn't
   carry, so it produces *no* color; let Prism highlight the tagged
   block at load. `references/exemplar-tiger-roles.html` shows the
   tagged blocks in use. Only if the document has no code at all,
   delete *both* `SYNTAX-HIGHLIGHT` blocks (the CSS in `<head>` and the
   ~46 KB JS before `</body>`) so you don't ship an unused import —
   same rule as Mermaid.
10. **Keep the container max-width as shipped** (880px for reference,
   820px for how-tos) — the editorial measure is part of the feel.

## Component cheat sheet

| Need | Reach for |
|---|---|
| Document title (clickable) | `<h1><a href="#" class="title-link">Title with <em>accent</em></a></h1>` |
| Section opener (clickable) | `<h2><a href="#id" class="heading-link"><span class="num">§ 04</span>Title</a></h2>` |
| How-to step | `<h2><a href="#id" class="heading-link"><span class="kind">Step / 03</span>Title</a></h2>` |
| Aside / by-the-way | `<div class="note">` |
| Manual / TODO step | `<div class="note warn">` |
| Hard constraint | `<div class="note caveat">` |
| Success state | `<div class="note good">` |
| Pull quote / TL;DR | `<div class="tldr">` |
| Long-section break | `<div class="ornament">§ § §</div>` |
| Inline figure + caption | `<figure class="diagram"><svg…/><figcaption>…</figcaption></figure>` |
| Highlighted code block | `<pre><code class="language-ts">…</code></pre>` — warm-palette tokens via inlined Prism; drop the class for a plain block |
| Click-to-zoom figure | automatic — any `<figure>`, `.mermaid`, or `<img>` is made zoomable by the bundled `edzoom` script (click, scroll/±, drag, pinch) |
| Dark-mode toggle | automatic — the bundled theme toggle (bottom-right) flips light/espresso and persists |
| Floating mini-map nav | `<nav class="minimap"><div class="minimap-label">…</div><ol>…</ol></nav>` |
| Multi-part series nav | `<nav class="series-nav"><span class="series-label">…</span><ol>…</ol></nav>` |
| Internal-only banner | `<div class="restricted-banner">Internal · Scope · Not for Distribution</div>` |

Note labels are mono uppercase with a Linear / GitHub reference where
relevant: `<span class="note-label">Caveat · MET-2425</span>`. Don't
auto-link those — write the `<a href>` by hand.

## Navigation aids

Three patterns make a long-form doc browsable, all included in the
template by default:

- **Clickable document title** — the `<h1>` wraps its content in
  `<a href="#" class="title-link">`. Clicking the title resets the
  URL hash to empty, so the canonical document URL ends up in the
  address bar even if the reader had navigated to a section anchor.
  Hover turns copper; the italic accent shifts to copper-soft to stay
  visible. No JavaScript.
- **Self-anchoring section headings** — every section `<h2>` wraps its
  content in `<a href="#section-id" class="heading-link">`. Clicking
  the heading sets the URL hash to that section; copy the URL from
  the address bar. Hover state turns copper. No JavaScript.
- **Floating mini-map TOC** — a fixed-position `<nav class="minimap">`
  in the left gutter, shown only at viewport widths ≥ 1180px. Entries
  mirror the main TOC. On browsers that support `animation-timeline:
  scroll()` (Chrome 115+, Safari TP, Firefox via flag), the mini-map
  fades in after the user scrolls past the masthead; everywhere else
  it's always visible at wide widths. The progressive enhancement is
  wrapped in `@supports` so there's no JavaScript fallback to write.

If a document has a per-entry reference structure (catalog of items,
classification reference, list of named entries with type tags), give
each entry an id (e.g. `id="entry-name-slug"`) and wrap the entry
heading in the same `heading-link` pattern. The IRR (Initiative
Review Reference) in `sweng-team-process/` is the canonical example —
every `<h4 class="init-entry">` row is individually shareable.

## The editorial bundle (zoom + theme)

The template ships a small shared bundle — figure zoom, a light/dark
theme toggle, and mobile overflow fixes — inlined as two marked blocks:
`EDITORIAL-HEAD` (before `</head>`: CSS + a no-flash theme init) and
`EDITORIAL-BODY` (before `</body>`: the zoom + toggle scripts). It's
included by default and needs no per-figure or per-page markup.

**Figure zoom.**

- **What's zoomable.** Any `<figure>`, any `.mermaid` block, and any
  standalone `<img>` that contains an `svg`/`img`/`canvas`. A faint mono
  "Click to zoom" hint appears on hover; the cursor turns to `zoom-in`.
- **Interaction.** Click to open; scroll or the `+` / `−` buttons to
  zoom; drag to pan; **pinch and two-finger pan on touch devices**;
  double-click to toggle; `Esc`, `Close`, or a backdrop click to
  dismiss. The wheel step is proportional to scroll distance so
  trackpads don't zoom too fast.
- **Register.** In light mode the lightbox uses an ecru backdrop, a mono
  copper control bar, and no icons. The stage fills the viewport so
  zoomed-in wide diagrams pan freely without clipping. A
  `MutationObserver` re-scans the page, so asynchronously-rendered
  Mermaid diagrams become zoomable once drawn.

**Theme toggle.**

- A small mono toggle sits bottom-right. It flips between the light
  editorial palette and a warm **espresso dark** palette (not a generic
  inverted theme — same forest/copper language, and diagrams sit on an
  ecru "plate" so they read as intentional light figures). The choice
  persists in `localStorage`; first load honors `prefers-color-scheme`.
  A no-flash init in `<head>` sets the theme before paint.

**These are the only scripts.** Everything else in this style is static
HTML/CSS. Both pieces are no-ops when unused. To remove the bundle,
delete the `EDITORIAL-HEAD` and `EDITORIAL-BODY` blocks.

## Design rules worth restating

- **Copper is the only accent.** Don't introduce teal, red, blue. If
  you find yourself wanting a second accent color, the answer is to
  use copper more deliberately, not to add one. The **one carve-out**
  is *inside code blocks*: syntax highlighting uses a small warm token
  ramp (copper for keywords, plus gold, olive, sand, and khaki) so code
  is legible. That ramp is deliberately warm and desaturated — never
  cool (no blue/teal). Don't let it leak out of `<pre>` into the page
  chrome, and don't reach for a stock Prism/highlight.js theme; they're
  rainbow and will fight the register. The bundled editorial theme is
  the sanctioned one.
- **No icons.** The mono `§` markers and section numbers are the
  iconography. Adding emoji or icon fonts breaks the register.
- **No drop shadows; light by default with an optional dark toggle.**
  This is print, not Material — no shadows, no glow. The bundled theme
  toggle adds a warm espresso dark mode in the same forest/copper
  language (diagrams sit on an ecru plate in dark). The toggle is the
  sanctioned mechanism — don't hand-roll per-element dark hacks.
- **No animations, with one carved-out exception.** The mini-map's
  scroll-triggered fade-in (via `animation-timeline: scroll()`) is
  allowed because it's a navigation aid, progressive-enhancement only,
  and replaces nothing — browsers without support show the same nav
  always-visible. Don't extrapolate from this to decorative motion,
  hover animations, or transitions on content elements. Static
  editorial layouts everywhere else.
- **Three sanctioned scripts — the figure-zoom lightbox, the theme
  toggle, and syntax highlighting.** Aside from these (and the optional
  Mermaid import), the style is no-JS: navigation aids (title self-link,
  heading links, mini-map fade) are pure HTML/CSS. All three are allowed
  on the same terms — they're readability aids, fully self-contained
  (inlined, CSP-safe), and no-ops when unused. Highlighting only runs on
  code blocks you tag with `language-*`; it touches nothing else. Don't
  take them as license to add other scripts, client-side state, or
  motion — if you want interactivity beyond opening a figure, flipping
  the theme, or coloring code, this is the wrong style.
- **Don't use Inter, Roboto, or system-ui.** The whole point is that
  it isn't generic.
- **Dark mode comes from the toggle, not a raw media query.** The
  bundle's no-flash init reads `prefers-color-scheme` as the first-load
  default, then honors the user's saved choice. Don't add your own
  `@media (prefers-color-scheme: dark)` block — drive everything through
  the `:root[data-theme="dark"]` variables the bundle already defines.

If you find yourself wanting to deviate, read
`references/design-language.md` first — the existing tokens probably
already cover the case, and the anti-patterns section calls out the
common temptations.

## Targeting the Reading Room

Docs authored with this skill are standalone — they carry the full
editorial bundle and open correctly off-disk or over email. They can
*also* join the **Reading Room**, the per-machine internal doc-library.
Since engine 0.3.0 the library is a **content home** — a plain local
directory at `~/.local/share/reading-room` (the XDG default; override
with `$READING_ROOM_HOME` or a `--root` flag), served by the installed
`reading-room` CLI, not a git repo. The doc itself doesn't change: the
engine strips the baked-in `EDITORIAL-*` regions and re-injects the
library's current bundle on serve, so there's never a double zoom or
double toggle.
### Two entry paths

When the request is "add this to the Reading Room", decide which case
you're in before touching anything:

- **The document is already editorial.** It was authored with this
  skill (or carries the template's structure and the `EDITORIAL-*`
  blocks): skip straight to the `add-doc` helper below. Don't
  re-author, restyle, or "improve" it on the way in.
- **The document doesn't exist yet, or lives in another format** —
  markdown, a plan, meeting notes, a writeup: author the editorial
  HTML from that source first, following everything above (copy the
  template, fill the TODOs, pick components deliberately), then file
  the result in with `add-doc`. The conversion is a full authoring
  pass, not a wrapper — don't paste markdown into the template and
  call it done.


**If the `reading-room` CLI is installed** (check `reading-room
--version`; the binary may be at `~/.deno/bin/reading-room` if that dir
isn't on `PATH`), file the doc in with its `add-doc` helper rather than
hand-editing the registry. No `cd` needed — `add-doc` resolves the
content home itself (`--root` → `$READING_ROOM_HOME` → XDG default) and
lazily creates it if absent:

```
reading-room add-doc --src /path/to/your-doc.html --topic <topic-id> \
  --title "Title" --kind "Guide · Engineering Ref" --desc "One line." \
  --foot-left "2026·06·07" --foot-right "repo-or-source" \
  [--slug custom-slug] [--visibility private|shared] [--review] \
  [--new-topic "§ 0N|topic-id|Topic Name|Short"] \
  [--root /path/to/a/different/home]
```

It validates the slug is unique, copies the file into the home's
`_migrated/<slug>.html`, and inserts a registry entry (preserving the
file's comments). If a live `reading-room serve` agent is running
(e.g. the launchd agent on `127.0.0.1:8413`), just refresh — edits show
without a restart; otherwise `reading-room serve` shows it.

**To hand-edit instead**, add an object to the right topic's `docs`
array in `registry.jsonc`:

| Field | Meaning |
|---|---|
| `slug` | output filename stem → `/docs/<slug>` (unique) |
| `title` / `kind` / `desc` | card title, eyebrow label, one-line italic blurb |
| `footLeft` / `footRight` | card footer left/right (e.g. date · source repo) |
| `src` | source HTML relative to the metron workspace; overridden when `_migrated/<slug>.html` exists |
| `visibility` | `private` (local only) or `shared` (eligible for the deferred SSO remote) |
| `review` | `true` pins it to the "For Review" section with a copper chip |

## Publishing as a Claude Code artifact

A doc in this style can be published as a **Claude Code artifact** — a
live page at a private `claude.ai` URL, shareable within the org. Use
the `Artifact` tool (point it at the `.html` file). Per the Claude Code
docs (`code.claude.com/docs/en/artifacts.md`, treat as their word, not
independently verified): artifacts require a Team/Enterprise plan and a
`/login` session; the published file is wrapped in a doc shell and
served under a **strict CSP that blocks all external requests** —
scripts, stylesheets, fonts, images, `fetch`/XHR/WebSocket. Everything
must be inlined. The rendered page must be ≤ 16 MiB and is a single
page (in-page anchors only — which this style already uses).

This style is *almost* artifact-ready as shipped: the editorial bundle
(zoom + theme) is already inlined, syntax highlighting is already
inlined (the `SYNTAX-HIGHLIGHT:js` Prism bundle needs no swap — that's
why it's inlined rather than CDN-loaded), navigation is in-page anchors,
and the design already prefers hand-authored SVG over raster images. Two
things in the template reach out to the network and **break under the
CSP** — fix both before publishing:

1. **Fonts (the important one).** The template loads Fraunces + Source
   Serif 4 + JetBrains Mono from Google Fonts via `<link>` (the
   `FONTS-LINK` block). The CSP blocks it, so the page silently falls
   back to default serif/mono — which guts the entire editorial look,
   since the typefaces *are* the aesthetic. **Fix:** delete the three
   `<link>` tags and paste the full contents of
   **`assets/fonts-embedded.css`** into a `<style>` block in its place.
   That asset carries the same three typefaces as base64 WOFF2 data
   URIs (latin + latin-ext), so the page is self-contained. Fraunces
   and Source Serif 4 are the **multi-axis variable fonts** (Fraunces
   keeps `opsz`/`wght`/`SOFT`, Source Serif keeps `opsz`/`wght`), so the
   template's `font-variation-settings` keep working at full fidelity —
   this is not a static-instance downgrade.

2. **Mermaid (only if you used it).** The optional Mermaid block imports
   from a CDN (`cdn.jsdelivr.net`) — also blocked. If the doc has live
   Mermaid diagrams, either pre-render them to inline SVG before
   publishing, or drop them. The hand-authored `figure.diagram` SVGs are
   fine; they're already inline.

The embedded-fonts asset is ~700 KB — comfortably under the 16 MiB
limit, but it does add output-token cost and page weight. So **only do
the swap when actually publishing an artifact.** Keep the `<link>` for
normal viewing, off-disk/email use, and the Reading Room (the engine
re-injects its own bundle on serve). The `<link>` and the embed are
mutually exclusive — never ship both.

To regenerate `assets/fonts-embedded.css` (e.g. if the typeface set
changes): fetch the css2 URL from the `FONTS-LINK` block with a modern
browser User-Agent, keep the `latin` and `latin-ext` `@font-face`
slices, download each `woff2`, and rewrite its `src: url(...)` as a
`data:font/woff2;base64,…` URI. Request the variable axes
(`Fraunces:opsz,wght,SOFT@…`) so the served files stay multi-axis.

## Syntax highlighting

Code blocks are highlighted by an inlined, curated **Prism** build with
a bespoke warm-palette theme. Unlike fonts and Mermaid (large, CDN-by-
default, swapped-in for artifacts), the Prism bundle is small (~46 KB)
and **inlined by default** — same reasoning as the editorial bundle, so
highlighting just works off-disk, over email, in the Reading Room, and
as an artifact with no swap step.

- **Tagging.** Put `class="language-<lang>"` on the inner `<code>`:
  `<pre><code class="language-ts">…</code></pre>`. An untagged or
  unsupported block falls back to the plain forest/cream `<pre>` — no
  error, no styling change. Only tag block code; inline `<code>` stays
  plain (the theme is scoped to `<pre>`, so a stray class on inline code
  won't tint it).
- **Bundled languages.** `markup`/`html`, `css`, `javascript`, `jsx`,
  `typescript` (`ts`), `tsx`, `json`, `yaml`, `bash`/`shell`, `python`
  (`py`), `sql`, `go`, `rust`, `diff`, `markdown`, `toml`, and
  `docker`/`dockerfile`. This set covers Metron's stack (Deno/TS, React,
  Python, AWS CDK, TimescaleDB SQL, YAML/JSON config, Dockerfiles); add
  more only if a document needs them.
- **The theme.** Lives in the `SYNTAX-HIGHLIGHT:css` block in `<head>`.
  It maps Prism token classes to the warm ramp — copper (keywords/tags/
  control), gold (numbers, constants, function names), olive (strings),
  sand (types, keys, properties), khaki-italic (comments), with warm
  diff bands. The `<pre>` surface is dark in both light and dark themes,
  so one token palette reads in both. Edit colors here, not in the JS.
- **Removing it.** If a doc has no code, delete *both* `SYNTAX-HIGHLIGHT`
  blocks (CSS in `<head>`, JS before `</body>`). Leaving the CSS is
  harmless; the JS is the ~46 KB you don't want to ship unused.

To regenerate `assets/prism-bundle.min.js` (e.g. to add/remove
languages): fetch Prism 1.29.0 `prism-core.min.js` plus each
`prism-<lang>.min.js` from a CDN (e.g. cdnjs `…/prism/1.29.0/
components/`) and concatenate **in dependency order** (core first; then
`markup`, `css`, `clike`, `javascript`, then dependents like `jsx`,
`typescript`, `tsx`; standalone languages anywhere after core; `markdown`
after `markup`). **Do not** use Prism's autoloader plugin — it fetches
languages from the network on demand and breaks offline and under the
artifact CSP. After regenerating, paste the bundle back into the
template's `SYNTAX-HIGHLIGHT:js` `<script>` block (it must contain no
literal `</script>`).

## When NOT to use this skill

- Customer-facing marketing pages or landing copy
- Live dashboards, status pages, anything dynamic or stateful
- Short READMEs and quick notes (overkill)
- Slide decks
- Any context where the user has explicitly asked for a different
  visual language

## Visualizations — pair with `tufte-viz`

When the document includes charts, plots, or any quantitative
visualization, invoke the `tufte-viz` skill *before* drawing them.
Tufte's principles (high data-ink ratio, no chartjunk, graphical
integrity, small multiples) compose directly with this style — the
editorial-print palette already constrains you toward restraint, and
`tufte-viz` provides the principles for what to put inside the figure.
Practical defaults that follow from the combination:

- Hand-author SVG over chart libraries when the data is small enough
  (under ~50 marks) — you get full control of ink and labels.
- Use `--ink` / `--ink-soft` for data marks, `--copper` only for the
  one element you want the reader to look at first, `--rule` for
  axes. Avoid gridlines; if you need them, drop to `--rule` at low
  opacity.
- JetBrains Mono for axis tick labels and small annotations; italic
  Fraunces for figure titles when the figure is the centerpiece.
- Small multiples beat a single dense chart — the `figure.topology`
  framing already documented in the design language works for grids
  of small charts too.
- Captions go *under* the figure in `--ink-mute`, italic Fraunces,
  ~14px. No chart legend if you can label the marks directly.

Don't slot in a generic library chart (Chart.js default theme, etc.)
and call it done — it will fight the page's visual register.

## Companion markdown

When the document is markdown-first and HTML is the rendering, keep
the two in sync: the content shape (eyebrow → h1 → lede → TOC →
numbered sections → footer) translates cleanly, and pandoc-style
conversion is the path of least resistance.

When the document is HTML-native, there's no markdown source to
maintain — don't generate one as a "companion" unless the user
explicitly asks. A lossy markdown shadow of a richly-illustrated HTML
doc is worse than no markdown at all, because future edits will drift.
