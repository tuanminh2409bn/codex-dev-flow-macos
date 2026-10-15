# Polyglot, Shell/CI, and Cross-Platform Discovery

Use for unlisted languages, polyglot repositories crossing stack boundaries, Shell/Docker/CI changes, or OS-sensitive target verification.

## Resolve the execution contract

Identify the affected workspace, runtime/compiler version pins, wrapper scripts, and CI matrix before choosing commands. Lockfiles, version managers (`.nvmrc`, `.node-version`, `.python-version`, `.tool-versions`, `mise.toml`, `rust-toolchain.toml`, `global.json`, `.fvmrc`), and repository wrappers (`./gradlew`, `./mvnw`, `bundle exec`, `uv run`) take precedence over globally installed binaries.

Read build scripts, `Makefile` targets, and task definitions before executing unfamiliar commands: a target named `test`, `check`, or `build` may mutate data, build containers, download toolchains, or publish artifacts. Missing tooling or SDKs are verification constraints, not permission to install or upgrade system packages.

## Shell scripts, containers, and CI workflows

- **Shell (`*.sh`, `zsh`, `bash`):** Preserve target shell compatibility (`#!/usr/bin/env bash` versus POSIX `sh`). Use `set -euo pipefail` where appropriate, quote variable expansions (`"$var"`), guard against empty paths before `rm`/`mv`, prefer temporary staging + atomic `mv`, and test against paths containing spaces. Verify syntax with `bash -n` / `sh -n` and `shellcheck` when available.
- **Containers (`Dockerfile`, `compose*.yaml`):** Keep base image tags explicit, preserve multi-stage build boundaries and non-root runtime users, never bake secrets or `.env` files into layers, and keep `.dockerignore` aligned with build context needs.
- **CI/CD (`.github/workflows/`, GitLab CI, etc.):** Preserve pinned action/image versions, minimal token permissions, matrix coverage, and required quality gates; never weaken or skip failing CI steps to force a green pipeline.

## Trace cross-stack boundaries narrowly

In monorepos or polyglot systems (e.g., Flutter + Swift/Kotlin/Rust FFI, React/Next.js + Go/Python/.NET API, or microservice meshes), read only the changed producer, the contract boundary (REST/OpenAPI, GraphQL, Protobuf/gRPC, IPC/MethodChannel, FFI header), and direct consumers. Preserve serialization formats, field nullability, error codes, timeouts, retries, cancellation, and idempotency across the boundary.

## Verify affected targets honestly

Select checks from actual supported targets and changed behavior. A platform-neutral unit test cannot prove an OS or device integration works.

- **Filesystem and processes:** Verify path separators, case sensitivity (macOS APFS is often case-insensitive while Linux is case-sensitive), file permissions, line endings, executable lookup, signal handling, and exit codes.
- **Native, mobile, and desktop:** Verify lifecycle, main-thread vs. background execution, resource cleanup, permissions, entitlements, CPU architecture (`arm64` vs. `x86_64`), and minimum OS version.
- **Web and browser:** Verify SSR vs. client runtime APIs, accessibility, navigation, hydration, and responsive behavior.
- **Services, CLI, and libraries:** Verify entry points, configuration parsing, packaging/linking, and public exports.

Report each required target as **verified**, **failed**, or **unavailable** with the exact command and reason. Use available local checks when a target requires another OS or SDK; never infer Windows, Linux, or physical-device success from a macOS host or simulator check.
