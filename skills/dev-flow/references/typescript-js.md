# TypeScript and JavaScript (Web, Node, Bun, Deno)

Use for TypeScript or JavaScript workspaces outside Next.js (React/Vite/Remix, Vue/Nuxt, Svelte/SvelteKit, Angular, Astro, Express/Fastify/NestJS/Hono, Electron/Tauri UI, or Node/Bun/Deno libraries and CLIs).

## Discover narrowly

Read the relevant `package.json` or `deno.json`, lockfile name (`pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`, `bun.lock*`, `deno.lock`), `tsconfig*.json`, and framework/bundler config (`vite.config.*`, `nuxt.config.*`, `svelte.config.*`, `angular.json`, `astro.config.*`, `nest-cli.json`). Detect the runtime, module format (`ESM` versus `CJS`), package manager, workspace filter, and test runner. Ignore `node_modules/`, `dist/`, `build/`, `.output/`, `.nuxt/`, `.svelte-kit/`, `.astro/`, coverage, minified bundles, and lockfile bodies.

Use the package manager and runtime pinned by the repository. Do not apply Next.js App Router conventions to non-Next.js projects.

## Preserve architecture and boundaries

- Keep browser, SSR, worker/edge, and Node/Bun/Deno server boundaries distinct; never import server-only modules, filesystem APIs, or secrets into client bundles.
- Follow the framework's established reactivity and state model (React hooks, Vue Composition API/Pinia, Svelte runes/stores, Angular signals/RxJS, or NestJS DI modules).
- Validate untrusted input at HTTP, WebSocket, RPC, IPC, CLI, and webhook boundaries using the project's schema library.
- Preserve package `exports`, public TypeScript declarations, module resolution (`bundler`, `node16`, `nodenext`), and serialization contracts.
- Never leak secrets through `VITE_*`, `PUBLIC_*`, `NUXT_PUBLIC_*`, client configs, or error payloads.

## Correctness and runtime quality

- Maintain strict TypeScript checking; avoid new `any`, unsafe `as` casts, `@ts-ignore`, and duplicated DTO/domain types.
- Handle async rejections and cancellation (`AbortController`/`AbortSignal`); avoid floating promises, unhandled rejections, and event-loop blocking in server handlers.
- Clean up timers, event listeners, WebSocket/SSE connections, `IntersectionObserver`s, and RxJS/store subscriptions on unmount or teardown.
- For UI work, model loading, empty, error, offline, and retry states; preserve semantic HTML, keyboard focus, ARIA labels, and responsive behavior.

## Verification ladder

Derive exact commands from `package.json` or `deno.json`. Run only applicable stages:

1. Formatter or linter (`eslint`, `biome`, `oxlint`, `prettier`, `deno lint`) on changed files.
2. Focused unit or component test (`vitest`, `jest`, `node --test`, `bun test`, `deno test`) covering changed behavior.
3. Typecheck (`tsc --noEmit`, `vue-tsc`, `svelte-check`, `ng build`, `deno check`) for the affected workspace.
4. Relevant API, service, or integration tests.
5. Browser/E2E test (`playwright`, `cypress`) when user journeys, routing, hydration, or DOM behavior changed.
6. Build or bundle check when exports, bundler config, SSR boundaries, or packaging changed.
