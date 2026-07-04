---
name: field-dossier-html
description: Use when rendering a review, assessment, comparison, remediation plan, or research briefing as a standalone HTML page in the "field dossier" style — dark evergreen cover band over warm paper body, brass + verdigris accents, sticky scrollspy TOC, BLUF panel, faceoff comparison tables, hand-drawn SVG diagrams, hover-tooltip glossary terms. Extracted from the Hermes Agent field-dossier artifact (2026-07-02).
---

# Field-dossier HTML

A house style for **assessment documents**: reviews, audits, comparisons,
remediation plans, research briefings — anything with a verdict. The
register is "intelligence dossier": a dark cover band that states the
subject and verdict up front, then a calm paper body that walks the
evidence. Distinct from the parchment default (light, gentle, for plain
notes) and from `editorial-longform-html` (print handbook, for reference
docs that live a year). Reach for this one when the document **evaluates
something and lands on a recommendation**.

## The one file you need

**`assets/dossier-template.html`** — drop-in template. Copy it to the
target path and fill in the `TODO` markers. The CSS *is* the design;
don't re-derive it. Canonical reference implementation: the Hermes Agent
dossier artifact (`claude.ai/code/artifact/85cb967b-…`).

## Structure (in order)

1. **Cover band** (`.cover`) — dark evergreen, engraved-grid texture,
   brass bottom rule. Contains: mono classification strip (`.cover-top`),
   giant Archivo-Expanded title + grotesk subtitle with one bold
   verdigris phrase, an optional animated signature SVG mark
   (`.loopmark` — replace with a doc-specific line drawing or delete),
   and a 5-cell metadata strip (`.meta`) whose last cell is the
   **Verdict** in brass.
2. **Shell** (`.shell`) — two-column grid: sticky mono TOC left
   (scrollspy highlights the active section; hidden < 920px), 760px
   reading column right.
3. **BLUF panel** (`.bluf`) — verdigris-topped summary card, first thing
   in main. The whole document in 1–3 paragraphs, findings first.
4. **Numbered sections** (`.sec` + `.sec-head` with mono brass
   `.sec-num`). Add `class="reveal"` for the scroll-in fade
   (reduced-motion safe).
5. **Glossary** — auto-built by the bundled script from every inline
   `.term` tooltip; just leave the empty `<dl id="glossary-list">`.
6. **Footer** (`.foot`) — mono strip: dossier name left, compile date +
   sources right.

## Component cheat sheet

| Need | Reach for |
|---|---|
| Verdict-style metadata | `.meta` cell with `.v.accent` |
| Front-loaded summary | `.bluf` (never use the literal word "BLUF" beyond the eyebrow — Thomas dislikes the acronym; "Bottom line up front" spelled out is the shipped eyebrow) |
| Caveat / honest weakness / manual step | `.note` with mono `.nlabel` (include a `MET-XXX` ref when relevant) |
| Two-thing comparison | `.faceoff` — `th.h` = favored/home column (verdigris), `th.o` = other (brass); mono `.faceoff-cap` header strip; `.faceoff-wrap` scrolls |
| Architecture / flow diagram | `<figure class="figure">` + hand-authored SVG using the `.dg` vocabulary (`.box`, `.box-core` brass, `.box-verd` verdigris, `.flow`, `.flow-accent`, `.lbl`, `.lbl-sm`, `.ey` eyebrow, arrowhead markers). Add `.wide` + `min-width` on the svg for scrollable diagrams |
| Jargon with definition | `<span class="term" tabindex="0" data-term="Name" data-def="Plain definition">term</span>` — renders a hover/focus tooltip AND auto-collects into the glossary (single source of truth) |
| Inline emphasis code | `code` (verdigris tint) |
| Bullets | plain `ul` — brass dash bullets are automatic; nested get verdigris |

## Design rules

- **Two accents only: brass (#9A6620) and verdigris (#2E6E64).** Brass
  = attention/other/warning; verdigris = favored/good/definition. No
  third color, no red/blue/purple.
- **Typography**: Archivo Expanded (display) / Archivo (grotesk UI) /
  Source Serif 4 (body) / JetBrains Mono (labels, eyebrows, captions,
  TOC). Mono is always uppercase + letterspaced for labels.
- **Dark is for the cover only.** The body is warm paper; don't extend
  the cover palette into sections.
- **Motion budget**: the cover mark's draw/spin, the `.reveal` fade-ins,
  and tooltip transitions — nothing else. All gated on
  `prefers-reduced-motion`.
- **Diagrams are hand-authored SVG** in the `.dg` vocabulary — no chart
  libraries, no raster images. Label marks directly; mono figcaption
  under a hairline rule. Mark illustrative (non-measured) charts as
  such in the caption.
- Tables and wide figures scroll inside their own wrapper; the page
  never scrolls horizontally.

## Fonts under the artifact CSP

The template loads webfonts via a Google Fonts `<link>`. **Claude
artifacts block external requests**, so when publishing via the
Artifact tool the fallback stacks take over — they are deliberately
chosen to keep the register on macOS (Avenir Next Condensed for
display, Charter for body, SF Mono for mono). This is acceptable; don't
strip the `<link>` (it upgrades the page everywhere else). If exact
typography ever matters for an artifact, embed WOFF2 data URIs the way
`editorial-longform-html/assets/fonts-embedded.css` does — but for a
different font set, so it must be regenerated, not copied.

## The three scripts (all bundled, all CSP-safe inline)

1. **Scroll reveal** — IntersectionObserver adds `.in` to `.reveal`.
2. **TOC scrollspy** — highlights the active section link.
3. **Glossary builder** — collects every `[data-def]` into the glossary
   `<dl>`, deduped and alphabetized.

They are no-ops when their targets are absent. Don't add other scripts;
if the document needs real interactivity, this is the wrong style.

## When NOT to use

- Plain notes/reports without a verdict → parchment default
  (`~/.claude/assets/parchment-doc.css`).
- Reference docs, runbooks, system guides meant to live long →
  `editorial-longform-html`.
- Dashboards, anything dynamic, marketing.
