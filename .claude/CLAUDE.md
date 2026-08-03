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
- After ~3 failed approaches to the same problem, stop, explain what you've tried, and ask for direction.
- When running unattended (background agents, scheduled runs), don't block on questions — make the conservative choice and flag it in the summary.

## Code

- Prefer simple, maintainable code over clever or fast.
- Match the surrounding file's style — local consistency over external standards.
- Don't make changes unrelated to the current task.
- Don't remove comments unless you can prove they're false.
- Don't name things 'improved', 'new', 'enhanced' — names should be evergreen.

## Delegation

- Push bulk/mechanical work down to cheaper models (subagents); keep the
  main session's context for judgment and synthesis.
- Brief every subagent fully: the context, the why, and what done looks
  like. It starts blank and inherits nothing.
- Delegate when work is parallel, bulk, or would flood your context —
  not for single lookups you can answer directly.
- Subagents may run a *stronger* model than the parent when one call
  needs deeper judgment; a subagent given work above its capability
  should return it rather than burn tokens on it.

## Superpowers plugin

- Spec and plan paths must NOT include a `superpowers/` segment. Write specs to `docs/specs/YYYY-MM-DD-<topic>-design.md` and plans to `docs/plans/YYYY-MM-DD-<topic>-plan.md`. If the project has its own non-superpowers convention (e.g. `docs/design/`, `docs/rfcs/`), follow that instead. Existing files under `docs/superpowers/...` are legacy — do not add new files there, but don't move existing ones unless asked.

## Creating skills — where they belong

Before creating a new skill, decide its home by audience and stability:
`~/.claude/skills/` is a scratch **incubator** (not a permanent home); my
personal work skills live in the private `metron-skills` plugin repo
(`~/src/metron-private/agent-skills`); team-standard skills go in
`claude-resources`. The full decision path is in that repo's README under
"Where a skill belongs" — consult it, and nudge me to promote anything that's
lingered in `~/.claude/skills/` once it's proven.

## Work tracking

- **Editing an existing file**: just do it, no ceremony.
- **Creating a new substantive artifact** (new doc under `docs/`, new plan/audit, new source file in a product repo, start of a new investigation): ask once at creation — "Track this in Linear, or one-off?" — then proceed either way. One dismissible prompt, fired at birth only, never on later edits. Skip it for dotfiles, config, and vault notes.
- **Code changes to a product repo**: full issue → worktree → branch → PR workflow. Read `~/.claude/workflow.md` before starting.
- **Open PRs as ready for review, never drafts** unless I explicitly ask for a draft — drafts keep Weir (the `metron-code-review` bot) from starting its review. Use `gh pr create` without `--draft`; `gh pr ready <number>` fixes one already opened as a draft.

## Situational context (read when relevant)

- **`~/.claude/testing.md`** — test strategy, TDD, tooling
- **`~/.claude/technology.md`** — JS/TS, Python, Deno, AWS preferences
- **`~/.claude/workflow.md`** — git, issues, worktrees, PR process
- **`~/.claude/markdown.md`** — formatting rules for `.md` files

## Research

When asked to research, compare, or survey topics, use the `notebooklm-researcher` skill — not WebSearch — unless I explicitly invoke a different research skill.

## Rendering documents to HTML / Artifacts

**Default to the `field-dossier-html` skill** for rendered documents: dark evergreen cover band with a verdict strip, warm paper body, brass + verdigris accents, scrollspy TOC, faceoff comparison tables, hover-tooltip glossary. It was built for assessment documents (reviews, audits, comparisons, remediation plans, research briefings) but is the preferred style unless one of the exceptions below clearly fits better.

Exception — **distinctive / rich / diagram-heavy long-form reference** docs (architecture writeups, library or system-internals guides, postmortems, design records, RFCs, runbooks, playbooks — anything wanting inline SVG/Mermaid, hover states, or a published-handbook feel): use the `editorial-longform-html` skill.

Exception — **simple documents** (quick notes, plans — mostly prose + tables, no verdict, no handbook gravitas): the gentle "parchment" theme at `~/.claude/assets/parchment-doc.css` — a warm low-glare parchment surface, soft slate text, warm-toned tables. Build by converting markdown with `pandoc <file> -f gfm -t html`, wrapping the body in `<div class="wrap">…</div>`, and inlining the CSS in a `<style>` block (Artifacts can't load external stylesheets). Don't hand-roll a new palette.

When in doubt, use the dossier style.

## Machine-local overrides

@~/.claude/local.md
