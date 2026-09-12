---
name: dev-flow
description: Execute software changes end to end in Flutter, Next.js, or Python repositories with risk-scaled planning, minimal context loading, implementation, verification, and concise reporting. Use for feature work, bug fixes, refactors, reviews, and other coding tasks that should be carried through rather than merely explained.
---

# Dev Flow

Complete the requested software outcome with the smallest sufficient context and the smallest coherent change. Preserve user intent, repository conventions, and unrelated work.

## 1. Establish the local contract

Before editing:

1. Read the active `AGENTS.md` chain.
2. Inspect repository status without modifying it.
3. Identify the affected workspace or package from nearby manifests and paths.
4. Prefer existing scripts, architecture, libraries, and naming conventions.
5. Treat adding production dependencies, changing public contracts or schemas, rotating secrets, pushing, deploying, and destructive operations as separate decisions requiring explicit authority.

Do not inventory the whole repository unless the task genuinely spans it.

## 2. Detect the affected stack

Use manifests, not guesses:

- `pubspec.yaml`: read [references/flutter.md](references/flutter.md).
- `next.config.*` or a `package.json` with `next`: read [references/nextjs.md](references/nextjs.md).
- `pyproject.toml`, `setup.cfg`, `setup.py`, or Python package files: read [references/python.md](references/python.md).

For a monorepo, read only the references for components affected by the request. When a repository-specific `AGENTS.md` conflicts with a stack reference, the repository rule wins.

## 3. Scale the process to risk

Classify before loading more guidance:

- **Small:** localized text, style, documentation, or mechanical change with no contract or behavior risk. Inspect narrowly, edit directly, and run the nearest cheap check.
- **Standard:** behavior change, bug fix, or work across multiple files. State a short plan, implement in a thin slice, and run targeted then affected checks.
- **High:** authentication, authorization, payments, secrets, untrusted input, public API, persistent data, migrations, concurrency, production configuration, deployment, irreversible action, or unfamiliar critical code. Surface material assumptions, use explicit acceptance criteria, validate authoritative documentation where version-sensitive, and apply broader verification.

Ask only when missing information would materially change behavior, architecture, cost, security, or an irreversible outcome. Otherwise state the assumption briefly and proceed.

## 4. Route supporting Agent Skills sparingly

This skill is the primary router. Do not load `using-agent-skills` or `context-engineering`; their routing and context roles are handled here.

Load no supporting skill for a trivial mechanical change. Normally load at most one relevant Addy Osmani skill; use up to three only for high-risk or genuinely multi-phase work:

- unclear product requirement: `interview-me` or `spec-driven-development`
- large, clear change: `planning-and-task-breakdown`
- multi-file implementation: `incremental-implementation`
- logic or behavior change: `test-driven-development`
- unexpected failure: `debugging-and-error-recovery`
- public API or module boundary: `api-and-interface-design`
- user-facing UI: `frontend-ui-engineering`
- authentication, untrusted data, secrets, or privacy: `security-and-hardening`
- measured performance problem: `performance-optimization`
- version-sensitive framework decision: `source-driven-development`
- requested pre-merge review: `code-review-and-quality`
- requested simplification with unchanged behavior: `code-simplification`
- requested CI, migration, documentation, observability, commit, release, or deployment work: use only the matching specialist skill

Do not invoke review, security, performance, documentation, git, or shipping workflows merely because code was edited. Trigger them from task risk or the user's requested outcome.

## 5. Control context and tool output

- Start with the nearest manifest, active instructions, status, and a targeted filename or symbol search.
- Search first; open only relevant sections. Stop discovery once evidence is sufficient to make the next decision.
- Exclude dependencies, build artifacts, caches, coverage, generated code, vendored code, minified files, and lockfile bodies unless they are the subject of the task.
- Do not reread unchanged content. Review the diff instead.
- Run the narrowest useful check first. Expand to package or full-suite checks only when impact or failure propagation justifies it.
- Prefer quiet or concise command output. On failure, retain the actionable error and minimal surrounding context rather than full logs.
- For long work, maintain a compact checkpoint of decisions, changed files, verified results, and remaining work. Do not preserve raw logs in the checkpoint.
- Keep commentary and the final report concise unless the user requests detail.

## 6. Implement and verify

1. Define the observable acceptance condition.
2. Make the smallest coherent change that satisfies it.
3. Add or update tests when behavior or logic changes and a viable test boundary exists.
4. Run formatting and static checks for changed code.
5. Run targeted tests, then affected package checks when warranted.
6. Build or run a real smoke check when compilation, routing, platform behavior, packaging, or runtime integration is affected.
7. Inspect the final diff for scope drift, leaked secrets, debug artifacts, accidental generated files, and weakened tests or lint rules.

Never delete or weaken tests, suppress diagnostics, or broaden exception handling merely to obtain a green result. If verification cannot run, report the exact constraint and the strongest evidence still obtained.

## 7. Report the outcome

Lead with whether the requested result is complete. Then report only:

- meaningful changes
- checks run and their results
- unresolved risk or required user action

Do not repeat the plan, narrate every command, or paste routine logs.
