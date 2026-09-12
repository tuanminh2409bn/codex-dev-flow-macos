# Python

Use only for the affected Python workspace.

## Discover narrowly

Read `pyproject.toml` first when present, then only the relevant package, tests, and configuration. Detect the supported Python version, `src/` versus flat layout, environment/package manager (`uv`, Poetry, PDM, pip-tools, pip), formatter, linter, type checker, test runner, web framework, and existing scripts. Ignore virtual environments, caches, build output, coverage, generated clients, large datasets, notebooks, and lockfile bodies unless directly relevant.

Use the repository's existing environment and commands. Do not create another environment, replace its package manager, or add dependencies without explicit authority.

## Preserve architecture and contracts

- Follow established domain, service, repository, API, CLI, and dependency-injection boundaries.
- Preserve sync/async boundaries; do not block an event loop or make a call async without tracing callers.
- Maintain public type hints and the repository's typing strictness. Avoid new untyped escape hatches without a boundary reason.
- Validate data at HTTP, CLI, file, database, queue, and external-service boundaries.
- Catch the narrowest useful exceptions. Do not swallow errors, use bare `except`, or broaden handling merely to pass tests.
- Preserve exception semantics, serialized formats, CLI exit behavior, API shapes, database transactions, and compatibility promises.
- Keep secrets and personal data out of source, logs, exceptions, fixtures, and snapshots.
- For concurrency, retries, timeouts, file writes, and transactions, consider cancellation, idempotency, atomicity, and partial failure.

## Maintainability

- Prefer clear functions and existing abstractions over new generic layers.
- Keep side effects at boundaries when the codebase supports it.
- Use deterministic tests; freeze time or isolate randomness through existing helpers rather than global hacks.
- Do not change migrations, persisted schemas, packaging metadata, or supported Python versions incidentally.

## Verification ladder

Derive exact commands from project configuration. Run only applicable stages:

1. Formatter/linter for changed files or the affected package.
2. A focused pytest/unit test covering the changed behavior or reproduced bug.
3. Typecheck for the affected package.
4. Relevant package or integration tests for shared code, I/O, databases, queues, or external APIs.
5. Import, CLI, server, worker, or packaging smoke test when entry points or distribution behavior changed.
6. Full suite only when a shared contract, fixture, plugin, or core utility has broad consumers.

Do not weaken assertions, delete tests, hide warnings, or add blanket ignores to make verification green.
