# Database Schemas, Migrations, and API Contracts

Use when changes touch SQL migrations, ORM schemas (`schema.prisma`, Drizzle, Alembic, Flyway, Liquibase, ActiveRecord, Eloquent, Ecto, EF Core), or cross-service IDL contracts (OpenAPI, Protobuf `*.proto`, GraphQL `*.graphql`).

## Discover narrowly

Read the schema source of truth, the latest migration files, codegen configuration, and direct producer/consumer boundaries. Ignore historical migration snapshots and generated client bodies except to confirm diff expectations.

Never hand-edit generated ORM clients, OpenAPI SDKs, Protobuf stubs (`*.pb.*`), or GraphQL codegen output; edit the source schema and run the repository's generator.

## Migration and database safety

- Treat committed/applied migrations as append-only history. Create a new migration instead of rewriting existing ones unless explicitly editing an unmerged local draft.
- Design backward-compatible (expand-and-contract) migrations for shared or production databases:
  - Avoid dropping or renaming live columns/tables in the same release that application code still reads them.
  - Avoid adding `NOT NULL` columns without a safe default or two-step backfill on populated tables.
  - Consider index creation locks (`CONCURRENTLY` in PostgreSQL where transactional rules allow) and foreign-key indexing.
- Preserve transaction boundaries, isolation assumptions, idempotency keys, and explicit `down`/rollback safety where the framework expects reversible migrations.
- Parameterize every query; never interpolate untrusted strings into raw SQL.

## API and wire contract compatibility

- **OpenAPI / REST / Webhooks:** Preserve existing route paths, HTTP methods, status codes, required request fields, response field types/nullability, pagination envelopes, and error codes unless a versioned or approved breaking change is requested.
- **Protobuf / gRPC:** Never reuse or renumber field tags, change wire types, or delete active fields without reserving the tag and field name (`reserved`).
- **GraphQL:** Prefer additive schema evolution (`@deprecated` before removal); guard resolver N+1 queries (DataLoader/batching) and authorization checks per field/mutation.

## Verification ladder

1. Validate schema or IDL syntax (`prisma validate`, `buf lint`, `buf breaking`, OpenAPI/GraphQL schema linter).
2. Run code generation and verify that generated types/clients compile cleanly with no unintended drift.
3. Apply the migration against an isolated local or test database (verify `up`, schema state, and `down`/re-apply when supported).
4. Run repository/DAO queries, serialization tests, and affected producer/consumer contract tests.
