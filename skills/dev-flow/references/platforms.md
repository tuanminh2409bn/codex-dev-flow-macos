# Stack and platform discovery

Use for stacks without a dedicated reference or changes crossing runtime/OS boundaries. This is a discovery guide, not a command recipe.

## Resolve the execution contract

Identify the affected workspace, supported language/runtime versions, package manager or wrapper, build/test scripts, and CI target matrix. Inspect only relevant manifest sections. Lockfiles and toolchain pins take precedence over globally installed tools. A Dockerfile describes a runtime/container target, not necessarily the application's language.

| Evidence | Resolve before choosing checks |
| --- | --- |
| `package.json`, workspace config | Framework, package manager pin, scripts, workspace filter, browser versus server runtime; do not assume Next.js |
| `go.mod`, `go.work` | Go version, module/workspace boundaries, affected package tests; race checks when concurrency changes |
| `Cargo.toml`, `rust-toolchain.toml` | Rust toolchain, workspace members, features and target triples |
| `pom.xml`, `build.gradle*`, wrappers | Java/Kotlin version, modules, wrapper tasks; distinguish JVM backend from Android |
| `*.sln`, `*.csproj`, `global.json` | .NET SDK, target frameworks, affected projects and OS requirements |
| `Package.swift`, `*.xcodeproj`, `*.xcworkspace` | Swift/Xcode versions, scheme, destination, simulator/device and signing boundaries |
| `CMakeLists.txt`, presets, `Makefile`, `meson.build` | Compiler, build directory, options, target ABI, existing test runner |
| `Gemfile`, `*.gemspec`, `composer.json`, `mix.exs` | Runtime pin, dependency tooling, existing test and lint scripts |
| Other manifests or build files | Follow local docs, scripts, and CI; do not invent universal commands |

Read build scripts before running unfamiliar tasks: a task named `test` or `build` may publish, mutate data, download tools, or require credentials. Missing tooling is a verification constraint, not permission to install or upgrade it.

## Trace impact, not every package

For shared libraries, follow changed exports and their consumers. For full-stack work, trace input → validation → service/domain → persistence/provider → response/UI, reading only affected boundaries. Preserve serialization, error mapping, timeouts, retries, cancellation, ownership, and transaction behavior relevant to the change.

## Verify affected targets

Select checks from actual supported targets and changed behavior. A platform-neutral unit test cannot prove an OS integration works.

- Filesystem/process work: relevant path separators, case sensitivity, permissions, line endings, executable discovery, shell quoting, and exit codes.
- Native/mobile/desktop: relevant lifecycle, threading, resource ownership, permissions, entitlements, architecture, and minimum OS version.
- Web: relevant browser runtime, accessibility, navigation, hydration, and responsive behavior; use available browser tooling for user journeys that need it.
- Services/CLI/libraries: entry points, signal/exit behavior, packaging/import/linking, and affected external contracts.

Report each required target as verified, failed, or unavailable with the command and reason. Use available local checks when a target requires another host or SDK; do not infer Windows/Linux/device success from a macOS build. Cross-platform software guidance does not make this repository's macOS installer portable to Windows.
