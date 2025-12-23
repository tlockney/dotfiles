# Working with Thomas

**BEFORE STARTING ANY WORK: Read the CRITICAL RULES section below and refer back to this document throughout our session.**

## Context

- Most projects are for production use - reliability and maintainability are critical
- I prefer modern, well-supported technologies over bleeding-edge experimental ones

## CRITICAL RULES - NO EXCEPTIONS

These rules MUST be followed without exception:

1. **TypeScript Types**: NEVER use `any` type. Use `unknown` for truly unknown types, then narrow with type guards. If external libraries force `any`, wrap them immediately with properly typed interfaces.
2. **Commit Messages**: NEVER mention Claude, AI, or automated assistance in commit messages unless the change itself is about Claude tooling.
3. **Code Preservation**: NEVER rewrite existing implementations without explicit permission. Make the smallest reasonable changes to achieve the desired outcome.
4. **Testing**: All application/business logic code MUST have tests. Configuration files and simple scripts may not require tests, but when in doubt, ask.

### When in Doubt - STOP

If you're about to use `any`, skip tests, rewrite code, or mention AI in commits: **STOP and ask for guidance.**

## Communication Style

- Ask clarifying questions early rather than making assumptions
- For ambiguity, present 2-3 specific options rather than open-ended questions
- For complex changes, break into logical steps and confirm the approach before proceeding
- When debugging, walk me through your thought process

## Code Standards

### Core Philosophy

Prefer simple, clean, maintainable solutions over clever or complex ones. Readability and maintainability trump cleverness and performance.

### Key Rules

- Match the style and formatting of surrounding code. Consistency within a file is more important than external standards.
- NEVER make code changes unrelated to your current task
- NEVER remove code comments unless you can prove they are actively false
- NEVER name things 'improved', 'new', 'enhanced', etc. Code naming should be evergreen

### Markdown Formatting

When creating or editing markdown files:

- **Line breaks:** Consecutive lines render as a single line. Use one of:
  - Blank line between paragraphs
  - Unordered/ordered list for multi-item metadata
  - `<br/>` tag when semantic list doesn't fit
  - Two trailing spaces (less visible, avoid)
- **Metadata blocks:** Use lists for key-value pairs at document top (e.g., Date, Status, Author)
- **Code blocks:** Always specify language hint (` ```typescript `, ` ```bash `, ` ```json `, etc.)
- **Diagrams:** Prefer Mermaid over ASCII art for flowcharts and architecture diagrams
- **Tables:** Use for structured comparisons; avoid for simple key-value pairs (use lists instead)
- **Headers:** Don't skip levels (h1 → h3); maintain consistent hierarchy

## Additional Context Files

Read these files when the situation applies:

- **`.claude/testing.md`** - Read when writing tests or discussing test strategy (TDD process, coverage requirements, preferred tools by language)
- **`.claude/technology.md`** - Read when working with JS/TS, Python, Deno, or AWS (language-specific preferences and tooling)
- **`.claude/workflow.md`** - Read before commits, PRs, or starting issue-linked work (git workflow, issue tracking, worktree process)

## Getting Help

- Ask for clarification rather than making assumptions
- If stuck for more than 15 minutes, explain what you've tried and ask for direction
