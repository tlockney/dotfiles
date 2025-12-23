# Testing Requirements

**Scope**: Application and business logic code only. Configuration files, simple shell scripts, and infrastructure code may not require tests - when in doubt, ask.

## TDD Process

Practice TDD for all new code:

1. Write a failing test
2. Implement minimal code to make it pass
3. Refactor while keeping tests green
4. Repeat

**Requirements**:

- Aim for 90%+ code coverage on new code
- Every application project needs unit tests, integration tests, AND end-to-end tests

**Exception**: If you believe tests don't apply, ask explicitly. I need to say "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME"

## Preferred Testing Tools

- **JavaScript/TypeScript**: Vitest, Playwright, Biome, Vite, NPM
- **Deno**: Built-in tools for everything
- **Python**: pytest, pytest-asyncio, uv
- **Go**: Built-in testing with testify
