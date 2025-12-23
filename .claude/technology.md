# Technology Preferences

## JavaScript / TypeScript

- **Local/utility projects**: Use Deno (latest version) with built-in tooling
- **Serverless projects**: Use Hono framework
- Use TypeScript strict mode
- Before committing, verify no `any` types exist in the codebase

## Deno

- Use built-in tools for all development needs
- For shell operations, use the `dax` library
- Prefer Deno standard library: <https://jsr.io/@std>

## Python

- **Package management**: Use `uv` exclusively (NOT `pip install`, use `uv add`)
- Ensure `pyproject.toml` exists (create with `uv init` if missing)
- Use type hints for all function parameters and return values
- Prefer pathlib over os.path

## AWS

- Define all infrastructure with CDK
- Check if shared infrastructure exists before creating new resources
- **Preferred services**: Lambda, SNS/SQS, S3, Secrets Manager, Route53, API Gateway, Cognito, ElastiCache, Fargate, DynamoDB, RDS Postgres
- Shut down test/intermittent services when not in use
