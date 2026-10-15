# C# and .NET

Use only for the affected .NET project or solution.

## Discover narrowly

Read `global.json`, `Directory.Build.props`, `Directory.Packages.props`, solution files (`*.sln`, `*.slnx`), and the affected `.csproj`. Identify the SDK version, `TargetFramework`/`TargetFrameworks` (`net8.0`, `net9.0`), nullable context (`<Nullable>enable</Nullable>`), and project type (ASP.NET Core, Worker, MAUI/Desktop, Class Library, Unity). Ignore `bin/`, `obj/`, `.vs/`, `TestResults/`, and generated files (`*.g.cs`, `*.Designer.cs`).

Do not hand-edit generated source files or modify historical EF Core migrations that have already been committed.

## Preserve architecture and contracts

- Respect Dependency Injection lifetimes (`Transient`, `Scoped`, `Singleton`): never capture a `Scoped` or `Transient` dependency inside a `Singleton` service (captive dependency).
- Preserve middleware pipeline order, authentication/authorization policies, Minimal API or Controller route contracts, and JSON serialization options (`System.Text.Json`).
- Keep EF Core persistence models separate from public request/response DTOs; validate external input at API, message-bus, and CLI boundaries.
- Honor nullable reference type annotations; avoid new null-forgiving operators (`!`) or `#pragma warning disable` without a documented boundary invariant.

## Async, resource, and data access correctness

- Keep async all the way: pass `CancellationToken` through async APIs, HTTP calls, and EF Core queries; never block threads with `.Result`, `.Wait()`, or `.GetAwaiter().GetResult()`.
- Dispose `IDisposable` and `IAsyncDisposable` instances deterministically (`using` / `await using`).
- Use `IHttpClientFactory` or typed `HttpClient` registrations rather than instantiating short-lived `new HttpClient()` per request.
- In EF Core, use `AsNoTracking()` for read-only queries where established, avoid N+1 lazy-loading traps, and bound query page sizes.

## Verification ladder

Use repository scripts or `dotnet` CLI on the narrowest affected project:

1. `dotnet format --verify-no-changes --include <changed-files>` (or configured analyzer check).
2. Focused unit test (`dotnet test <TestProject.csproj> --filter <FullyQualifiedName>`).
3. Project compilation (`dotnet build <Project.csproj> --no-restore`) with nullable and Roslyn analyzer warnings clean.
4. Integration or `WebApplicationFactory` test suite for affected endpoints, database queries, or consumers.
5. Publish, AOT, or multi-target check when `.csproj` packaging, trimming, or runtime identifiers change.
