**BEFORE STARTING ANY WORK: Read the CRITICAL RULES section below and refer back to this document throughout our session.**

# Working with Thomas

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

## Testing Requirements

**Scope**: Application and business logic code only. Configuration files, simple shell scripts, and infrastructure code may not require tests - when in doubt, ask.

### TDD Process

Practice TDD for all new code:
1. Write a failing test
2. Implement minimal code to make it pass
3. Refactor while keeping tests green
4. Repeat

**Requirements**:
- Aim for 90%+ code coverage on new code
- Every application project needs unit tests, integration tests, AND end-to-end tests

**Exception**: If you believe tests don't apply, ask explicitly. I need to say "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME"

### Preferred Testing Tools

- **JavaScript/TypeScript**: Vitest, Playwright, Biome, Vite, NPM
- **Deno**: Built-in tools for everything
- **Python**: pytest, pytest-asyncio, uv
- **Go**: Built-in testing with testify

## Technology Preferences

### JavaScript / TypeScript

- **Local/utility projects**: Use Deno (latest version) with built-in tooling
- **Serverless projects**: Use Hono framework
- Use TypeScript strict mode
- Before committing, verify no `any` types exist in the codebase

### Deno

- Use built-in tools for all development needs
- For shell operations, use the `dax` library
- Prefer Deno standard library: https://jsr.io/@std

### Python

- **Package management**: Use `uv` exclusively (NOT `pip install`, use `uv add`)
- Ensure `pyproject.toml` exists (create with `uv init` if missing)
- Use type hints for all function parameters and return values
- Prefer pathlib over os.path

### AWS

- Define all infrastructure with CDK
- Check if shared infrastructure exists before creating new resources
- **Preferred services**: Lambda, SNS/SQS, S3, Secrets Manager, Route53, API Gateway, Cognito, ElastiCache, Fargate, DynamoDB, RDS Postgres
- Shut down test/intermittent services when not in use

## Version Control

### Commit Messages

- Use conventional commit format: `type(scope): description`
- Types: feat, fix, docs, style, refactor, test, chore

### Pre-Commit Checklist

Before suggesting any commit, verify:
- [ ] No `any` types in TypeScript code (if applicable)
- [ ] Commit message follows conventional format (see Critical Rule #2)
- [ ] All tests pass
- [ ] Linting/formatting is clean
- [ ] No unrelated changes included (see Critical Rule #3)

## Development Workflow

**CRITICAL: ALWAYS FOLLOW THIS WORKFLOW - NO EXCEPTIONS**

### Issue Tracking First

1. **STOP AND CREATE/GET ISSUE FIRST**
   - Before ANY code changes, ask user for issue ID
   - If user hasn't created one, ask them to create it or provide details so you can create it
   - **Check for MCP server**: Use available MCP tools for the issue tracker if installed (e.g., Linear MCP, GitHub MCP)
   - NEVER proceed without an issue tracker entry
   - Supported systems: Linear, GitHub Issues, Jira, or other project-specific trackers
   - Check project CLAUDE.md for default project/tracker configuration

2. **Create git worktree linked to issue**
   - Format: `worktrees/ISSUE-ID-description`
   - Example: `worktrees/PROJ-123-fix-authentication-bug`
   - Create branch with same name
   - Use project-specific issue ID format (e.g., LINEAR-123, GH-456, JIRA-789)

3. **Update issue to In Progress**
   - Use MCP tools if available, otherwise use API/CLI tools
   - This signals to the team that work has started

### Implementation

4. **Implement changes**
   - Make changes in the worktree directory
   - Write tests BEFORE implementation (TDD - see Testing Requirements above)
   - Update documentation as needed

5. **Quality checks**
   - Run project-specific formatting, linting, and testing commands
   - Common patterns:
     - **Deno projects**: `deno fmt`, `deno lint`, `deno test`
     - **Node/npm projects**: `npm run format`, `npm run lint`, `npm test`
     - **Python projects**: `uv run ruff format`, `uv run ruff check`, `uv run pytest`
     - **Go projects**: `go fmt`, `go vet`, `go test`
   - Check project CLAUDE.md or README for exact commands
   - Fix any issues before committing

6. **Commit and push**
   - Use conventional commit format (see Version Control section)
   - Reference issue ID in commit message
   - Push to branch

### Pull Request

7. **Create PR**
   - **CRITICAL**: Before creating or updating a PR, ALWAYS check if it's already been merged:
     ```bash
     gh pr view <PR_NUMBER> --json state,mergedAt
     ```
   - If PR is already merged, DO NOT try to push more commits to that branch
   - If you need to add more changes after a PR is merged:
     - **ALWAYS create a NEW issue and NEW branch/PR**
     - **NEVER push directly to main/master** - all changes must go through PR workflow
   - Reference issue ID in PR title and body
   - Link PR to issue (use MCP tools or issue tracker integration if available)
   - Ensure all CI checks pass

8. **Clean up**
   - After merge, remove worktree: `git worktree remove worktrees/ISSUE-ID-description`
   - Update issue status to Done/Completed (use MCP tools if available)

**REMINDER: If user asks you to fix something, your FIRST response should be:**

"I need to create an issue for this work. Can you either:

1. Provide the issue ID if you've already created one
2. Create an issue and give me the ID
3. Give me details so I can create the issue (I'll check for MCP tools first)"

### Common Mistakes to Avoid

**NEVER push directly to main/master:**

- ALL changes must go through the PR workflow
- Even small fixes require an issue, branch, and PR
- This ensures proper code review and CI checks

**DO NOT push to branches with merged PRs:**

- User may merge PRs quickly to test deployments
- Always check PR status before pushing changes
- If PR is merged, create a new branch for additional fixes

**Example of checking PR status:**

```bash
# Good - check before pushing
gh pr view 88 --json state,mergedAt
# If state is "MERGED", create a new branch instead
```

**Correct workflow for post-merge changes:**

```bash
# BAD - Don't do this!
git checkout main
git add .
git commit -m "fix: some fix"
git push  # ❌ Never push directly to main

# GOOD - Always use PR workflow
# 1. Create issue (or get issue ID from user)
# 2. Create worktree and branch
git worktree add worktrees/ISSUE-123-description -b ISSUE-123-description
# 3. Make changes in worktree
# 4. Commit and push branch
# 5. Create PR
gh pr create --title "..." --body "..." --base main
```

## Getting Help

- Ask for clarification rather than making assumptions
- If stuck for more than 15 minutes, explain what you've tried and ask for direction
