# Go

Use only for the affected Go module or workspace.

## Discover narrowly

Read `go.mod`, `go.work` when present, `Makefile`/Taskfile/CI scripts, `.golangci.yml`, and the affected package directory. Detect the Go version, module boundaries (`cmd/`, `internal/`, `pkg/`), code generators, and test flags. Ignore `vendor/`, compiled binaries, coverage profiles, and `go.sum` bodies unless dependency resolution is directly relevant.

Do not manually edit `go.sum` or generated files such as `*.pb.go`, `*_gen.go`, `mock_*.go`, `sqlc` output, or `wire_gen.go`. Run the repository's generator only when source definitions change.

## Preserve architecture and contracts

- Keep interfaces small and consumer-defined where established; respect `internal/` encapsulation and package dependency direction.
- Pass `context.Context` as the first parameter across I/O, RPC, database, and worker boundaries; never store `context.Context` in structs.
- Preserve error semantics and wrapping (`fmt.Errorf("...: %w", err)`) so callers using `errors.Is` and `errors.As` continue to work.
- Validate untrusted input at HTTP, gRPC, CLI, queue, and config boundaries; preserve JSON/Protobuf struct tags, wire compatibility, and status codes.

## Concurrency and resource safety

- Ensure every spawned goroutine has a bounded lifetime, cancellation path (`ctx.Done()`), and wait mechanism (`errgroup.Group`, `sync.WaitGroup`); never leak channels or goroutines on early return.
- Guard shared mutable state with synchronization or channel ownership; do not copy `sync.Mutex`, `sync.WaitGroup`, or structs containing them by value.
- Avoid returning a typed `nil` pointer inside a non-nil `error` or interface value.
- Close `http.Response.Body`, files, and database rows deterministically; avoid `defer` inside unbounded loops and always check `rows.Err()` after iteration.
- Set explicit timeouts on HTTP clients, servers, and external I/O operations.

## Verification ladder

Use repository scripts when available. Otherwise run the smallest applicable progression:

1. `gofmt` (or `goimports` if configured) on changed `.go` files.
2. `go vet` and configured linters (`golangci-lint`, `staticcheck`) on affected packages.
3. Focused unit test (`go test -run <Pattern> ./path/to/pkg`) reproducing the bug or proving the change.
4. Race detector (`go test -race ./path/to/pkg`) whenever goroutines, channels, timers, caches, or shared state are touched.
5. Dependent package and integration tests across the module/workspace when exported symbols or contracts change.
6. Binary build (`go build ./cmd/...`) or CLI/service smoke check when wiring, flags, or entry points change.
