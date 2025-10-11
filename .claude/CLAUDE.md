**BEFORE STARTING ANY WORK: Read the CRITICAL RULES section below and refer back to this document throughout our session.**

# Working with Thomas

<user_context>
- I work on a variety of projects including web applications, automation scripts, data processing tools, and serverless applications
- I value pragmatic solutions that balance technical excellence with business needs
- Most projects are for production use, so reliability and maintainability are critical
- I prefer modern, well-supported technologies over bleeding-edge experimental ones
</user_context>

## CRITICAL RULES - NO EXCEPTIONS

<critical_rules priority="absolute">
These rules MUST be followed without exception:

1. **TypeScript Types**: NEVER use `any` type. Use `unknown` for truly unknown types, then narrow with type guards. If external libraries force `any`, wrap them immediately with properly typed interfaces.
2. **Commit Messages**: NEVER mention Claude, AI, or automated assistance in commit messages unless the change itself is about Claude tooling.
3. **Code Preservation**: NEVER rewrite existing implementations without explicit permission. Make the smallest reasonable changes to achieve the desired outcome.
4. **Testing**: All application/business logic code MUST have tests. Configuration files and simple scripts may not require tests, but when in doubt, ask.
</critical_rules>

<safety_check>
## When in Doubt - STOP

If you're about to use `any`, skip tests, rewrite code, or mention AI in commits: **STOP and ask for guidance.**
</safety_check>

<communication_guidelines>
## Communication Style

- Provide concise explanations for code changes, focusing on the "why" behind decisions
- When making significant architectural decisions, briefly explain the reasoning
- Ask clarifying questions early rather than making assumptions
- If you encounter ambiguity, present 2-3 specific options rather than asking open-ended questions
- For complex changes, break them into logical steps and confirm the approach before proceeding
- When debugging, walk me through your thought process and what you're investigating
- Share any external documentation references that might be helpful for learning more about proposed solutions.
- Use code comments close to the implementation where it makes sense, but include more general context in the broader scope (e.g., towards the top of the file or in a local README.md in the same folder).
</communication_guidelines>

<code_standards>
## Code Style & Standards

<philosophy>
Prefer simple, clean, maintainable solutions over clever or complex ones. Readability and maintainability trump cleverness and performance in most cases.
</philosophy>

<modification_approach>
- Match the style and formatting of surrounding code. Consistency within a file is more important than strict adherence to external standards.
- NEVER make code changes unrelated to your current task. If you notice something that should be fixed, document it instead of fixing it immediately.
- Use descriptive variable and function names that clearly indicate purpose and scope
- Prefer explicit imports over wildcard imports
- Include error handling for external dependencies and user inputs
</modification_approach>

<comments_and_naming>
- NEVER remove code comments unless you can prove they are actively false. Preserve comments even if they seem redundant.
- When writing comments, avoid temporal context about refactors or recent changes. Comments should be evergreen and describe the code as it is.
- NEVER name things 'improved', 'new', 'enhanced', etc. Code naming should be evergreen - what is new today will be old tomorrow.
</comments_and_naming>
</code_standards>

<testing_requirements mandatory="true">
## Testing Requirements

**Scope**: These requirements apply to application and business logic code. Configuration files, simple shell scripts, and infrastructure code may not require tests - when in doubt, ask.

<core_principles>
- Tests MUST cover the functionality being implemented
- NEVER ignore test output - logs and messages often contain CRITICAL information
- Test output must be pristine to pass
- If errors are expected, capture and assert them in tests
</core_principles>

<tdd_process>
Practice TDD for all new code and modified functionality:
1. Write a failing test
2. Implement minimal code to make it pass
3. Refactor while keeping tests green
4. Repeat

Requirements:
- Aim for 90%+ code coverage on new code
- Test edge cases, error conditions, and boundary values
- For legacy code without tests, add tests for any functionality you modify
- Every application project needs unit tests, integration tests, AND end-to-end tests

**Exception**: If you believe tests don't apply, ask explicitly. I need to say "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME"
</tdd_process>

<frameworks>
### Preferred Testing Tools

- **JavaScript/TypeScript**: Vitest (unit/integration), Playwright (E2E), Biome (lint/format), Vite (builds), NPM (project structure)
- **Deno**: Use Deno's built-in tools for testing, linting, formatting, builds, and project/dependency management
- **Python**: pytest (unit/integration), pytest-asyncio (async), uv (project management)
- **Go**: Built-in testing package with testify for assertions
</frameworks>
</testing_requirements>

<technology_specific>
## Technology-Specific Guidance

*Note: These sections provide preferred tools and patterns when you're working with these technologies. Not all projects will use all of these.*

### JavaScript / TypeScript

**Type Safety** (See Critical Rule #1):
- Use TypeScript strict mode and proper type definitions
- Before committing, verify no `any` types exist in the codebase
- For dependencies without types, look for `@types/*` packages and add them

**Framework & Runtime Preferences**:
- **Local/utility projects**: Use Deno (latest version) with its built-in tooling
- **Serverless projects**: Use Hono as the framework
- Prefer async/await over promise chains
- Use modern ES features (destructuring, optional chaining, etc.)

### Deno

*Use for general purpose utilities and scripts.*

- Use Deno's built-in tools for all development needs (testing, linting, formatting, builds, dependency management)
- For shell operations, use the `dax` library
- Prefer Deno standard library: https://jsr.io/@std
- Use Web Standard APIs when available

### Python

*Use for data processing, automation, and backend services.*

- **Package management**: Use `uv` exclusively (NOT `pip install`, use `uv add`)
- Ensure `pyproject.toml` exists in root (create with `uv init` if missing)
- Follow PEP 8 for code style
- Use type hints for all function parameters and return values
- Prefer pathlib over os.path for file operations

### AWS

*Use for cloud infrastructure and serverless applications.*

- Define all infrastructure with CDK
- Check if shared infrastructure exists before creating new resources
- **Preferred services**: Lambda, SNS/SQS, S3, Secrets Manager, Route53, API Gateway, Cognito, ElastiCache (Redis), Fargate, DynamoDB (simple key-value), RDS Postgres (relational)
- Shut down test/intermittent services when not in use
- Use CloudWatch for monitoring and alerting by default

### Go

*Use for performance-critical services and CLI tools.*

- Use built-in testing package with testify for assertions
- Follow standard Go conventions and idioms
</technology_specific>

<version_control>
## Version Control

### Commit Messages

- Use conventional commit format: `type(scope): description`
- Types: feat, fix, docs, style, refactor, test, chore
- Keep messages concise but descriptive
- Reference issue numbers when applicable

### Change Management

- For large refactors, create a plan and get approval before starting
- Break changes into logical, reviewable commits
- Commit regularly at meaningful points in the development process
- Before committing: ensure all tests pass, linting is clean, and formatting is applied
- If pre-commit hooks don't exist, suggest adding them
- Update relevant documentation with code changes

### Pre-Commit Checklist

Before suggesting any commit, verify:
- [ ] No `any` types in TypeScript code (if applicable)
- [ ] Commit message follows conventional format (see Critical Rule #2)
- [ ] All tests pass
- [ ] Linting/formatting is clean
- [ ] No unrelated changes included (see Critical Rule #3)
</version_control>

<help_guidelines>
## Getting Help

- Ask for clarification rather than making assumptions
- If stuck on a technical problem for more than 15 minutes, explain what you've tried and ask for direction
- For unclear or conflicting requirements, ask specific questions to clarify
- Stop and ask for help when human input would be valuable
</help_guidelines>