# Working with Thomas

## Critical rules — no exceptions

1. **TypeScript**: never use `any`. Use `unknown` and narrow with type guards. Wrap untyped libraries with proper interfaces.
2. **Commit messages**: never mention Claude, AI, or automated assistance — unless the change itself is about Claude tooling.
3. **Code preservation**: never rewrite existing implementations without explicit permission. Make the smallest reasonable changes.
4. **Tests**: application/business logic must have tests. Config/scripts may not — when in doubt, ask.
5. **Evidence before confidence**: don't assert estimates, root causes, or "verified/fixed/passing" without reading or running first — show the output when you claim something passes. When relaying a fact from a wiki, CLAUDE.md, or subagent, attribute it and flag it as unverified rather than restating it as ground truth.

If you're about to break one of these, stop and ask.

## Communication

- Ask early rather than assume. For ambiguity, present 2–3 specific options.
- For complex changes, break into steps and confirm the approach before proceeding.
- Walk me through your reasoning when debugging.
- If stuck for >15 min, explain what you've tried and ask for direction.

## Code

- Prefer simple, maintainable code over clever or fast.
- Match the surrounding file's style — local consistency over external standards.
- Don't make changes unrelated to the current task.
- Don't remove comments unless you can prove they're false.
- Don't name things 'improved', 'new', 'enhanced' — names should be evergreen.

## Superpowers plugin

- Spec and plan paths must NOT include a `superpowers/` segment. Write specs to `docs/specs/YYYY-MM-DD-<topic>-design.md` and plans to `docs/plans/YYYY-MM-DD-<topic>-plan.md`. If the project has its own non-superpowers convention (e.g. `docs/design/`, `docs/rfcs/`), follow that instead. Existing files under `docs/superpowers/...` are legacy — do not add new files there, but don't move existing ones unless asked.

## Situational context (read when relevant)

- **`.claude/testing.md`** — test strategy, TDD, tooling
- **`.claude/technology.md`** — JS/TS, Python, Deno, AWS preferences
- **`.claude/workflow.md`** — git, issues, worktrees, PR process
- **`.claude/markdown.md`** — formatting rules for `.md` files

## Research

When asked to research, compare, or survey topics, use the `notebooklm-researcher` skill — not WebSearch.

## Rendering documents to HTML / Artifacts

For **simple documents** (notes, reports, investigation writeups, plans — mostly prose + tables), default to the gentle "parchment" theme at `~/.claude/assets/parchment-doc.css`: a warm low-glare parchment surface, soft slate text, warm-toned tables. Build by converting markdown with `pandoc <file> -f gfm -t html`, wrapping the body in `<div class="wrap">…</div>`, and inlining the CSS in a `<style>` block (Artifacts can't load external stylesheets). Don't hand-roll a new palette for ordinary docs — this is the sane default.

For **distinctive / rich / diagram-heavy long-form** docs (architecture writeups, library or system-internals guides, postmortems, design records, RFCs, runbooks, playbooks — anything wanting inline SVG/Mermaid, hover states, or a published-handbook feel), use the `editorial-longform-html` skill instead. Its use cases overlap with the above, so choose by need: editorial when the doc warrants that gravitas/interactivity, the parchment default when it just needs clean, easy-on-the-eyes readability.

For **assessment documents with a verdict** (reviews, audits, comparisons, remediation plans, research briefings — anything that evaluates something and lands on a recommendation), use the `field-dossier-html` skill: dark evergreen cover band with a verdict strip, warm paper body, brass + verdigris accents, scrollspy TOC, faceoff comparison tables, hover-tooltip glossary. Choose by document shape: dossier when there's a judgment to deliver, editorial when it's a lasting reference, parchment when it's just a clean read.

## Machine-local overrides

@~/.claude/local.md
