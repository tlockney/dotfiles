# Development Workflow

**CRITICAL: ALWAYS FOLLOW THIS WORKFLOW - NO EXCEPTIONS**

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

## Issue Tracking First

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

## Implementation

4. **Implement changes**
   - Make changes in the worktree directory
   - Write tests BEFORE implementation (TDD - see `.claude/testing.md`)
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
   - Use conventional commit format (see Version Control section above)
   - Reference issue ID in commit message
   - Push to branch

## Pull Request

7. **Create PR**
   - **CRITICAL**: Before creating or updating a PR, ALWAYS check if it's already been merged:
       `gh pr view <PR_NUMBER> --json state,mergedAt`
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

## Common Mistakes to Avoid

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
