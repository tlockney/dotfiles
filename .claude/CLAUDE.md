# Working with Thomas

## Critical rules — no exceptions

1. **TypeScript**: never use `any`. Use `unknown` and narrow with type guards. Wrap untyped libraries with proper interfaces.
2. **Commit messages**: never mention Claude, AI, or automated assistance — unless the change itself is about Claude tooling.
3. **Code preservation**: never rewrite existing implementations without explicit permission. Make the smallest reasonable changes.
4. **Tests**: application/business logic must have tests. Config/scripts may not — when in doubt, ask.

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

## Situational context (read when relevant)

- **`.claude/testing.md`** — test strategy, TDD, tooling
- **`.claude/technology.md`** — JS/TS, Python, Deno, AWS preferences
- **`.claude/workflow.md`** — git, issues, worktrees, PR process
- **`.claude/markdown.md`** — formatting rules for `.md` files

## Research

When asked to research, compare, or survey topics, use the `notebooklm-researcher` skill — not WebSearch.

## Machine-local overrides

@~/.claude/local.md
