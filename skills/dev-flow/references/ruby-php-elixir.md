# Ruby, PHP, and Elixir

Use only for the affected Ruby (`Gemfile`), PHP (`composer.json`), or Elixir (`mix.exs`) workspace.

## Discover narrowly

Read the primary manifest (`Gemfile`/`*.gemspec`, `composer.json`, or `mix.exs`), lockfile name, framework config, and test helper. Always run commands through the project's wrapper (`bundle exec`, `bin/rails`, `./vendor/bin/...`, `php artisan`, `mix`). Ignore `vendor/`, `_build/`, `deps/`, `tmp/`, `log/`, `storage/`, `bootstrap/cache/`, and compiled public assets.

Do not edit lockfiles or committed database schema dumps (`db/schema.rb`, `structure.sql`) manually without running the framework's migration workflow.

## Preserve architecture and framework contracts

- **Ruby / Rails:** Enforce strong parameters at controller boundaries, keep domain logic in models/service objects as established, wrap multi-record mutations in `ActiveRecord::Base.transaction`, use `includes`/`preload` to prevent N+1 queries, and pass only serializable primitives (IDs, not ActiveRecord objects) to Sidekiq/ActiveJob workers.
- **PHP / Laravel / Symfony:** Preserve `declare(strict_types=1)` where used, validate input via FormRequests/Symfony Validator, respect `$fillable`/`$guarded` mass-assignment rules, prevent Eloquent/Doctrine N+1 queries (`with()`), and maintain PSR autoloading and static-analysis contracts (`phpstan`/`psalm`).
- **Elixir / Phoenix:** Respect OTP supervision trees and GenServer responsibilities (avoid blocking `handle_call` with external I/O when a `Task` or caller process fits better), validate external data through Ecto changesets, handle `{:ok, _}` / `{:error, _}` tuples exhaustively, and never call `String.to_atom/1` on untrusted input.

## Security and runtime correctness

- Validate authentication, authorization policies/scopes, and CSRF/webhook signatures at every entry point.
- Ensure background jobs are idempotent and safe across retries and rolling deploys.
- Keep secrets, session keys, and PII out of logs, exception payloads, and test fixtures.

## Verification ladder

Select the progression matching the active ecosystem:

1. Formatter/linter (`bundle exec rubocop`, `./vendor/bin/pint` or `php-cs-fixer`, `mix format --check-formatted` / `mix credo`) on changed files.
2. Focused test (`bundle exec rspec <path:line>` or `bin/rails test <path:line>`, `php artisan test --filter=<Test>` or `./vendor/bin/phpunit`, `mix test <path:line>`).
3. Static/type check (`srb tc`/`steep`, `./vendor/bin/phpstan` or `psalm`, `mix compile --warnings-as-errors` / `mix dialyzer`) when configured.
4. Request, controller, LiveView, or background-job integration tests for affected flows.
