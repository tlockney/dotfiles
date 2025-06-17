**BEFORE STARTING ANY WORK: Read the CRITICAL RULES section below and refer back to this document throughout our session.**

# Working with Thomas

<user_context>
- Any time you interact with me, refer to me as Thomas.
- I work on a variety of projects including web applications, automation scripts, data processing tools, and serverless applications
- I value pragmatic solutions that balance technical excellence with business needs
- Most projects are for production use, so reliability and maintainability are critical
- I prefer modern, well-supported technologies over bleeding-edge experimental ones
</user_context>

## CRITICAL RULES - NO EXCEPTIONS

<critical_rules priority="absolute">
These rules MUST be followed without exception:

1. **TypeScript Types**: NEVER use `any` type. Use `unknown` for truly unknown types, then narrow with type guards.
2. **Commit Messages**: NEVER mention Claude, AI, or automated assistance in commit messages.
3. **Code Preservation**: NEVER rewrite existing implementations without explicit permission.
</critical_rules>

<safety_check>
## When in Doubt - STOP

If you find yourself about to:
- Use the `any` type
- Mention AI/Claude in a commit message
- Rewrite existing code instead of modifying it
- Skip any type of testing

STOP immediately and ask for guidance.
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
## General Code Style & Standards

<philosophy>
We prefer simple, clean, maintainable solutions over clever or complex ones, even if the latter are more concise or performant. Readability and maintainability are primary concerns.
</philosophy>

<modification_rules>
- Make the smallest reasonable changes to get to the desired outcome. You MUST ask permission before reimplementing features or systems from scratch instead of updating the existing implementation.
- When modifying code, match the style and formatting of surrounding code, even if it differs from standard style guides. Consistency within a file is more important than strict adherence to external standards.
- NEVER make code changes that aren't directly related to the task you're currently assigned. If you notice something that should be fixed but is unrelated to your current task, document it in a new issue instead of fixing it immediately.
</modification_rules>

<comment_preservation>
- NEVER remove code comments unless you can prove that they are actively false. Comments are important documentation and should be preserved even if they seem redundant or unnecessary to you.
- When writing comments, avoid referring to temporal context about refactors or recent changes. Comments should be evergreen and describe the code as it is, not how it evolved or was recently changed.
</comment_preservation>

<naming_conventions>
- NEVER name things as 'improved' or 'new' or 'enhanced', etc. Code naming should be evergreen. What is new today will be "old" someday.
- Use descriptive variable and function names that clearly indicate purpose and scope
- Prefer explicit imports over wildcard imports
- Include error handling for external dependencies and user inputs
</naming_conventions>
</code_standards>

<testing_requirements mandatory="true">
## Testing Requirements

<core_principles>
- Tests MUST cover the functionality being implemented.
- NEVER ignore the output of the system or the tests - Logs and messages often contain CRITICAL information.
- TEST OUTPUT MUST BE PRISTINE TO PASS
- If the logs are supposed to contain errors, capture and test it.
</core_principles>

<no_exceptions_policy>
NO EXCEPTIONS POLICY: Under no circumstances should you mark any test type as "not applicable". Every project, regardless of size or complexity, MUST have unit tests, integration tests, AND end-to-end tests. If you believe a test type doesn't apply, you need me to say exactly "I AUTHORIZE YOU TO SKIP WRITING TESTS THIS TIME"
</no_exceptions_policy>

<tdd_process>
Even if the code does not currently have tests, you should ALWAYS practice TDD: write tests before writing the implementation code

What TDD specifically means here: write failing test → implement minimal code → refactor → repeat
- Only write enough code to make the failing test pass
- Refactor code continuously while ensuring tests still pass
- Aim for 90%+ code coverage on new code
- Test edge cases, error conditions, and boundary values
- For legacy code without tests, add tests for any functionality you modify
</tdd_process>

<frameworks>
### Testing Frameworks and Code Quality

- **JavaScript/TypeScript**: Prefer Vitest for unit/integration tests, Playwright for E2E, and Biome for linting/formatting, Vite for builds, NPM for general project structure
- **Deno**: use Deno's built in tools as much as possible: testing, linting, formatting, builds, and project/dependency management
- **Python**: Use pytest for unit/integration tests, pytest-asyncio for async code, and uv for general build/project management needs
- **Go**: Use built-in testing package with testify for assertions
</frameworks>
</testing_requirements>

<technology_specific>
### JavaScript / TypeScript

<typescript_rules critical="true">
- FORBIDDEN: Never use `any` type under any circumstances. If you catch yourself typing `any`, use `unknown` instead and add proper type guards.
- If external libraries force `any`, wrap them immediately with properly typed interfaces.
- Before making any commit, search the entire codebase for `any` and replace with proper types.
</typescript_rules>

<framework_preferences>
- If the project is meant to run locally, and doesn't otherwise require a specific runtime, use Deno and stick with the most recent version unless instructed otherwise
- For serverless projects, prefer Hono as the framework of choice
- Use TypeScript strict mode and proper type definitions
- Prefer async/await over promise chains
- Use modern ES features appropriately (destructuring, optional chaining, etc.)
- Always use types
- For any dependencies added, be sure to look for any type definitions and use them. If there are separate dependencies to add typing for libraries, those are reasonable dependencies to add.
</framework_preferences>

### Deno

<deno_guidelines>
- Use Deno for general purpose utilities.
- If doing a lot of shell operations, use the `dax` library.
- Use the Deno standard library whenever possible:
  - See https://jsr.io/@std for package information
  - https://docs.deno.com/runtime/fundamentals/standard_library/ provides some general information about usage of the standard library
- Use Web Standard APIs
</deno_guidelines>

### Python

<python_setup>
- Use `uv` as the package manager and project management tool for anything related to python
- Do NOT use `pip install`, use `uv add`
- Make sure the project has a `pyproject.toml` in the root directory
- If there isn't a `pyproject.toml` file, create one using uv by running `uv init`
- Follow PEP 8 for code style
- Use type hints for function parameters and return values
- Prefer pathlib over os.path for file operations
</python_setup>

### AWS

<aws_preferences>
- Use CDK for defining all infrastructure
- Assume there may be common infrastructure in place already. If necessary, ask to make necessary calls to review shared infrastructure to leverage it for new projects.
- AWS Services to prefer: Lambda, SNS/SQS for asynchronous processing, S3, Secrets Manager, Route53, API Gateway, Cognito, ElasticCache for Redis, Fargate for running containers, DynamoDB for minimal non-relational data (e.g., where basic indexing is useful), RDS Postgres for relational data
- Be sure to any services needed for testing or other intermittent usage are shutdown when not needed
- Use CloudWatch for basic monitoring and alerting by default.
</aws_preferences>
</technology_specific>

<version_control>
## Version Control

<commit_format>
### Commit Messages

- Use conventional commit format: `type(scope): description`
- Types: feat, fix, docs, style, refactor, test, chore
- Keep messages concise but descriptive
- Reference issue numbers when applicable
- Do not reference Claude in the commits unless the change itself is about Claude. There is generally obvious when it's being used.
</commit_format>

<change_management>
### Change Management

- For large refactors, create a plan and get approval before starting
- Break changes into logical, reviewable commits
- Be sure that all changes are getting committed on a regular basis. Don't hesitate to suggest making a commit at meaningful points in development process.
- Make sure any test pass, linting is clean, and formatting is applied before making any commits. If there are not already pre-commit hooks in place to help enforce this, suggest adding them.
- Update relevant documentation with code changes
</change_management>
</version_control>

<pre_commit_validation>
## Pre-Commit Checklist

Before suggesting any commit, verify:
- [ ] No `any` types in TypeScript code
- [ ] Commit message follows conventional format without AI attribution
- [ ] All tests pass
- [ ] Linting/formatting is clean
- [ ] No unrelated changes included
</pre_commit_validation>

<help_guidelines>
## Getting Help

- ALWAYS ask for clarification rather than making assumptions
- If you're having trouble, stop and ask for help, especially for tasks where human input would be valuable
- When stuck on a technical problem for more than 15 minutes, explain what you've tried and ask for direction
- If requirements seem unclear or conflicting, ask specific questions to clarify
</help_guidelines>

<common_mistakes priority="high">
## Common Mistakes to Avoid

These are frequent issues that MUST be caught:
- Using `any` instead of proper TypeScript types
- Mentioning Claude/AI in commit messages
- Making unrelated changes in the same commit
- Skipping tests without explicit authorization
- Rewriting instead of modifying existing code
</common_mistakes>