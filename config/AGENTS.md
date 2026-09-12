# Global working agreements

- Communicate in the user's language and lead with outcomes. Keep progress and final reports concise unless detail is requested.
- Treat the request as authority to inspect, edit, and verify the current workspace only. Ask before adding production dependencies, changing persistent schemas or public contracts, using credentials, pushing, deploying, or performing destructive/irreversible actions.
- Before editing, read the active repository instructions, inspect current status, and identify the smallest affected workspace. Preserve user changes and unrelated files.
- Prefer the repository's existing architecture, scripts, package manager, libraries, naming, error model, and test patterns. Do not introduce a parallel convention for convenience.
- Make the smallest coherent change that achieves the requested outcome. Do not perform adjacent cleanup or speculative features.

## Context and token discipline

- Start with manifests, instructions, status, and targeted filename/symbol searches. Do not inventory or read the whole repository by default.
- Search first and open only relevant sections. Stop discovery once evidence is sufficient for the next decision.
- Exclude dependencies, caches, build output, coverage, generated/vendored/minified code, large datasets, and lockfile bodies unless directly relevant.
- Do not reread unchanged files; inspect the diff. Avoid repeating large code, instructions, plans, or logs in chat.
- Run the narrowest useful check first, then expand according to impact. Prefer concise output and retain only actionable error context.
- For long tasks, maintain a compact checkpoint of decisions, changed files, verification results, and remaining work rather than raw history.

## Quality and completion

- Scale planning and verification to risk. Local mechanical edits need a local check; behavioral, shared, security-sensitive, data, API, and release changes need progressively stronger evidence.
- Never weaken tests, assertions, type checking, lint rules, or error handling merely to obtain a green result.
- A task is complete only when the requested behavior is implemented and proportionate checks pass, or when the exact verification constraint is reported.
- Report meaningful changes, checks and results, and unresolved risks. Do not narrate every command.

## Skill routing

- For Flutter, Next.js, or Python implementation work, prefer `dev-flow` as the primary router.
- When `dev-flow` is active, do not also load `using-agent-skills` or `context-engineering`. Load only the minimum specialist skill justified by task type or risk.
- Use git, deployment, security, performance, documentation, browser, or release skills only when the requested outcome or concrete risk calls for them.
