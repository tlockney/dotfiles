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

## Getting Help

- Ask for clarification rather than making assumptions
- If stuck for more than 15 minutes, explain what you've tried and ask for direction
