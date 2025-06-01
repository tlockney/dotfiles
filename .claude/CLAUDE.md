**BEFORE STARTING ANY WORK: Read the CRITICAL RULES section below and refer back to this document throughout our session.**

# Working with Thomas

- Any time you interact with me, refer to me as Thomas.

## CRITICAL RULES - NO EXCEPTIONS

These rules MUST be followed without exception:

1. **TypeScript Types**: NEVER use `any` type. Use `unknown` for truly unknown types, then narrow with type guards.
2. **Commit Messages**: NEVER mention Claude, AI, or automated assistance in commit messages.
3. **Code Preservation**: NEVER rewrite existing implementations without explicit permission.

## When in Doubt - STOP

If you find yourself about to:
- Use the `any` type
- Mention AI/Claude in a commit message
- Rewrite existing code instead of modifying it
- Skip any type of testing

STOP immediately and ask for guidance.

## Project Context

- I work on a variety of projects including web applications, automation scripts, data processing tools, and serverless applications
- I value pragmatic solutions that balance technical excellence with business needs
- Most projects are for production use, so reliability and maintainability are critical
- I prefer modern, well-supported technologies over bleeding-edge experimental ones

## Communication Style

- Provide concise explanations for code changes, focusing on the "why" behind decisions
- When making significant architectural decisions, briefly explain the reasoning
- Ask clarifying questions early rather than making assumptions
- If you encounter ambiguity, present 2-3 specific options rather than asking open-ended questions
- For complex changes, break them into logical steps and confirm the approach before proceeding
- When debugging, walk me through your thought process and what you're investigating
- Share any external documentation references that might be helpful for learning more about proposed solutions.
- Use code comments close to the implementation where it makes sense, but include more general context in the broader scope (e.g., towards the top of the file or in a local README.md in the same folder).

## General Code Style & Standards

- We prefer simple, clean, maintainable solutions over clever or complex ones, even if the latter are more concise or performant. Readability and maintainability are primary concerns.
- Make the smallest reasonable changes to get to the desired outcome. You MUST ask permission before reimplementing features or systems from scratch instead of updating the existing implementation.
- When modifying code, match the style and formatting of surrounding code, even if it differs from standard style guides. Consistency within a file is more important than strict adherence to external standards.
- NEVER make code changes that aren't directly related to the task you're currently assigned. If you notice something that should be fixed but is unrelated to your current task, document it in a new issue instead of fixing it immediately.
- NEVER remove code comments unless you can prove that they are actively false. Comments are important documentation and should be preserved even if they seem redundant or unnecessary to you.
- When writing comments, avoid referring to temporal context about refactors or recent changes. Comments should be evergreen and describe the code as it is, not how it evolved or was recently changed.
- When you are trying to fix a bug or compilation error or any other issue, YOU MUST NEVER throw away the old implementation and rewrite without explicit permission from me. If you are going to do this, YOU MUST STOP and get explicit permission.
- NEVER name things as 'improved' or 'new' or 'enhanced', etc. Code naming should be evergreen. What is new today will be "old" someday.
- Use descriptive variable and function names that clearly indicate purpose and scope
- Prefer explicit imports over wildcard imports
- Include error handling for external dependencies and user inputs

## Testing Requirements

- Tests MUST cover the functionality being implemented.
- NEVER ignore the output of the system or the tests - Logs and messages often contain CRITICAL information.
- TEST OUTPUT MUST BE PRISTINE TO PASS
- If the logs are supposed to contain errors, capture and test it.
- NO EXCEPTIONS POLICY: Under no circumstances should you mark any test type as "not applicable". Every project, regardless of size or complexity, MUST have unit tests, integration tests, AND end-to-end tests. If you believe a test type doesn't apply, you need me to say exactly "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME"
- Even if the code does not currently have tests, you should ALWAYS practice TDD: write tests before writing the implementation code
- What TDD specifically means here: write failing test → implement minimal code → refactor → repeat
- Only write enough code to make the failing test pass
- Refactor code continuously while ensuring tests still pass
- Aim for 90%+ code coverage on new code
- Test edge cases, error conditions, and boundary values
- For legacy code without tests, add tests for any functionality you modify

### Testing Frameworks and Code Quality

- **JavaScript/TypeScript**: Prefer Vitest for unit/integration tests, Playwright for E2E, and Biome for linting/formatting, Vite for builds, NPM for general project structure
- **Deno**: use Deno's built in tools as much as possible: testing, linting, formatting, builds, and project/dependency management
- **Python**: Use pytest for unit/integration tests, pytest-asyncio for async code, and uv for general build/project management needs
- **Go**: Use built-in testing package with testify for assertions

## CI/CD

- Use GitHub Actions whenever possible. Set up any projects with a build that will run tests as well as checking formatting/linting on any commit or PR. For PRs, it should post status of the build to the PR comments.
- For AWS projects leveraging CDK, include both development and production deployment workflows (these can leverage the same workflow, if it makes sense to do so).
- Deployments will generally be done as rolling deployments, though in some cases I may ask to use a blue/green strategy.

## Error Handling & Debugging

- When encountering compilation errors, read the full error message carefully and address the root cause
- For runtime errors, use logging and debugging tools before making assumptions about the fix
- If you're unsure about an error's cause, explain what you're observing and ask for guidance
- Document any workarounds or non-obvious solutions with comments explaining why they're necessary
- When debugging complex issues, show me your debugging steps and findings

## Security & Best Practices

- Never commit secrets, API keys, or sensitive data to version control
- Use environment variables or secure secret management for configuration
- Validate and sanitize all user inputs
- Use parameterized queries for database operations
- Keep dependencies updated and regularly audit for vulnerabilities
- Follow principle of least privilege for access controls

## Observability

- Prefer OpenTelemetry where possible
- Use wide/structured logs
- When building on AWS, also leverage CloudWatch for at least basic monitoring and alerting needs. OpenTelemetry is a value-add on top of this.

## Documentation Standards

### README Requirements

- Clear project description and purpose
- Installation and setup instructions
- Usage examples
- Environment variable documentation
- Contribution guidelines for shared projects

### Code Documentation

- Document complex business logic and non-obvious decisions
- Include examples in function/method documentation
- Keep API documentation in sync with code changes
- Document known limitations or gotchas

## Version Control

### Commit Messages

- Use conventional commit format: `type(scope): description`
- Types: feat, fix, docs, style, refactor, test, chore
- Keep messages concise but descriptive
- Reference issue numbers when applicable
- Do not reference Claude in the commits unless the change itself is about Claude. There is no need to attribute Claude as it is generally obvious when it's being used.

### Change Management

- For large refactors, create a plan and get approval before starting
- Break changes into logical, reviewable commits
- Be sure that all changes are getting committed on a regular basis. Don't hesitate to suggest making a commit at meaningful points in development process.
- Make sure any test pass, linting is clean, and formatting is applied before making any commits. If there are not already pre-commit hooks in place to help enforce this, suggest adding them.
- Update relevant documentation with code changes

## Dependency Management

- Be parsimonious about adding dependencies, but don't add overly complex solutions when well tested, well supported libraries may provide more effective solutions.
- When possible, lock dependencies to ensure consistent builds. But be sure to regularly check for major updates that might fix address problems with the code. If a major update is available for a library or framework and it has been out for more than a year, it's probably a better choice.

## Environments

- I prefer to use a minimum number of environments: typically only a development and production environment or, in some cases, a single production environment with feature flags to make for safe deployments.
- Environment specific configuration should be minimized and generally leverage a minimal version of service discovery: naming conventions where possible, secrets management tools where needed, and DNS where suitable.
- For local development, minimize the number of necessary dependencies.
- Use containers if needed to set up local environments. Allow for enabling individual service dependencies so that existing shared services can be reused between multiple services/projects when needed.

## Technology-Specific Guidelines

### JavaScript / TypeScript

- FORBIDDEN: Never use `any` type under any circumstances. If you catch yourself typing `any`, use `unknown` instead and add proper type guards.
- If external libraries force `any`, wrap them immediately with properly typed interfaces.
- Before making any commit, search the entire codebase for `any` and replace with proper types.
- If the project is meant to run locally, and doesn't otherwise require a specific runtime, use Deno and stick with the most recent version unless instructed otherwise
- For serverless projects, prefer Hono as the framework of choice
- Use TypeScript strict mode and proper type definitions
- Prefer async/await over promise chains
- Use modern ES features appropriately (destructuring, optional chaining, etc.)
- Always use types
- For any dependencies added, be sure to look for any type definitions and use them. If there are separate dependencies to add typing for libraries, those are reasonable dependencies to add.

### Python

- Use `uv` as the package manager and project management tool for anything related to python
- Do NOT use `pip install`, use `uv add`
- Make sure the project has a `pyproject.toml` in the root directory
- If there isn't a `pyproject.toml` file, create one using uv by running `uv init`
- Follow PEP 8 for code style
- Use type hints for function parameters and return values
- Prefer pathlib over os.path for file operations

### Go

- Follow standard Go formatting with gofmt
- Use go modules for dependency management
- Implement proper error handling (don't ignore errors)
- Use context for cancellation and timeouts

### AWS

- Use CDK for defining all infrastructure
- Assume there may be common infrastructure in place already. If necessary, ask to make necessary calls to review shared infrastructure to leverage it for new projects.
- AWS Services to prefer: Lambda, SNS/SQS for asynchronous processing, S3, Secrets Manager, Route53, API Gateway, Cognito, ElasticCache for Redis, Fargate for running containers, DynamoDB for minimal non-relational data (e.g., where basic indexing is useful), RDS Postgres for relational data
- Be sure to any services needed for testing or other intermittent usage are shutdown when not needed
- Use CloudWatch for basic monitoring and alerting by default.

### CloudFlare

- When explicitly told to do so, we may use CloudFlare for certain projects. These will generally be minimal/streamlined systems that do not require AWS-specific capabilities. They generally will not be actual products provided so much as servicing business functions.

### SQL

- Prefer standardized, but modern SQL.
- If a decision about what database to use is being made, prefer PostgreSQL unless the application will be entirely local and relatively small in scope, in which case SQLite is a good choice.
- Use CTEs where it makes sense and makes for more clear code vs nested subqueries.

## Getting Help

- ALWAYS ask for clarification rather than making assumptions
- If you're having trouble, stop and ask for help, especially for tasks where human input would be valuable
- When stuck on a technical problem for more than 15 minutes, explain what you've tried and ask for direction
- If requirements seem unclear or conflicting, ask specific questions to clarify

## Project Lifecycle

### Starting New Projects

- Set up proper project structure and tooling from the beginning
- Initialize version control and set up .gitignore appropriately
- Create basic documentation and README
- Set up testing framework and CI/CD pipeline basics

### Maintaining Existing Projects

- Understand the existing architecture before making changes
- Respect established patterns and conventions
- Update tests and documentation when modifying functionality
- Consider backward compatibility and migration paths for breaking changes

## Pre-Commit Checklist

Before suggesting any commit, verify:
- [ ] No `any` types in TypeScript code
- [ ] Commit message follows conventional format without AI attribution
- [ ] All tests pass
- [ ] Linting/formatting is clean
- [ ] No unrelated changes included

## Common Mistakes to Avoid

These are frequent issues that MUST be caught:
- Using `any` instead of proper TypeScript types
- Mentioning Claude/AI in commit messages
- Making unrelated changes in the same commit
- Skipping tests without explicit authorization
- Rewriting instead of modifying existing code
