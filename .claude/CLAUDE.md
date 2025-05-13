# Working with Thomas

- Any time you interact with me, refer to me as Thomas.

## Code Style

- We prefer simple, clean, maintainable solutions over clever or complex ones, even if the latter are more concise or performant. Readability and maintainability are primary concerns.
- Make the smallest reasonable changes to get to the desired outcome. You MUST ask permission before reimplementing features or systems from scratch instead of updating the existing implementation.
- When modifying code, match the style and formatting of surrounding code, even if it differs from standard style guides. Consistency within a file is more important than strict adherence to external standards.
- NEVER make code changes that aren't directly related to the task you're currently assigned. If you notice something that should be fixed but is unrelated to your current task, document it in a new issue instead of fixing it immediately.
- NEVER remove code comments unless you can prove that they are actively false. Comments are important documentation and should be preserved even if they seem redundant or unnecessary to you.
- When writing comments, avoid referring to temporal context about refactors or recent changes. Comments should be evergreen and describe the code as it is, not how it evolved or was recently changed.
- When you are trying to fix a bug or compilation error or any other issue, YOU MUST NEVER throw away the old implementation and rewrite without expliict permission from the user. If you are going to do this, YOU MUST STOP and get explicit permission from the user.
- NEVER name things as 'improved' or 'new' or 'enhanced', etc. Code naming should be evergreen. What is new today will be "old" someday.

## Getting Help

- ALWAYS ask for clarification rather than making assumptions.
- If you're having trouble, stop and ask for help, especially for tasks where human input would be valuable.

## Testing

- Tests MUST cover the functionality being implemented.
- NEVER ignore the output of the system or the tests - Logs and messages often contain CRITICAL information.
- TEST OUTPUT MUST BE PRISTINE TO PASS
- If the logs are supposed to contain errors, capture and test it.
- NO EXCEPTIONS POLICY: Under no circumstances should you mark any test type as "not applicable". Every project, regardless of size or complexity, MUST have unit tests, integration tests, AND end-to-end tests. If you believe a test type doesn't apply, you need the human to say exactly "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME"
- Even if the code does not currently have tests, you should ALWAYS practice TDD: write tests before writing the implementation code
- Only write enough code to make the failing test pass
- Refactor code continuously while ensuring tests still pass

## Specific Technologies

### JavaScript / TypeScript

- If the project is meant to run locally, and doesn't otherwise require a specific runtime, use Deno and stick with the most recent version unless instructed otherwise
- For serverless projects, prefer Hono as the framework of choice

### Python

- Use `uv` as the package manager and project management tool for anything related to python
- Do NOT use `pip install`, use `uv add`
- Make sure the project has a `pyproject.toml` in the root directory
- If there isn't a `pyproject.toml` file, create one using uv by running `uv init`
