# Rust

Use only for the affected Rust crate or workspace.

## Discover narrowly

Read the workspace and crate `Cargo.toml`, `rust-toolchain.toml`, `.cargo/config.toml`, `build.rs`, feature flags, and target configurations. Identify the Rust edition/MSRV, async runtime (`tokio`, `async-std`, `smol`), error crates (`thiserror`, `anyhow`), and FFI/Wasm bridges (`flutter_rust_bridge`, `pyo3`, `napi-rs`, `wasm-bindgen`, `tauri`). Ignore `target/`, generated bindings, and `Cargo.lock` bodies.

Do not add crate dependencies, enable heavy default features, or edit `Cargo.lock` manually without explicit authority.

## Preserve architecture and contracts

- Respect crate boundaries, module visibility (`pub`, `pub(crate)`), trait coherence, SemVer-sensitive public signatures, and additive Cargo features.
- Keep `unsafe` blocks minimal, encapsulated behind safe abstractions, and documented with explicit `// SAFETY:` invariants.
- For FFI, C ABI, or cross-language bridges, preserve `#[repr(C)]` layout, pointer alignment, ownership/drop responsibility, and panic boundaries (never unwind across FFI without `catch_unwind`).
- Propagate errors via `Result` and `?` using the crate's established error types; do not erase structured library errors into opaque strings.

## Correctness, memory, and async discipline

- Avoid new `.unwrap()`, `.expect()`, `panic!()`, or unchecked slice indexing in library and production request paths unless an invariant is proven locally.
- In async code, never hold a non-async `std::sync::MutexGuard` across `.await` points or block the executor thread with synchronous file/network I/O or CPU-bound work (`spawn_blocking`).
- Prefer borrowing (`&str`, `&[T]`, `Cow`) over unnecessary `.clone()` allocations on hot paths while keeping lifetimes readable.
- Guard integer casts (`try_into()`), checked arithmetic where overflow matters, and cancellation safety in `tokio::select!` branches.

## Verification ladder

Use repository scripts when available. Otherwise run the smallest applicable progression:

1. `cargo fmt --check` on the affected crate.
2. `cargo check` and `cargo clippy -p <crate> --all-targets` without hiding diagnostics behind blanket `#[allow(...)]`.
3. Focused unit test (`cargo test -p <crate> <test_filter>`) covering the changed behavior or bug.
4. Integration tests (`tests/`) and doctests (`cargo test --doc -p <crate>`) when public APIs or examples change.
5. Feature and target checks (`--no-default-features`, `--all-features`, or specific `--target`) when `#[cfg(...)]` or feature flags change.
6. Bridge codegen, Wasm, or binary smoke check when FFI bindings, `build.rs`, or CLI entry points change.
