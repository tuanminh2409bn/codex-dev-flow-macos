# Next.js and TypeScript

Use only for the affected Next.js workspace.

## Discover narrowly

Read the relevant `package.json`, lockfile name, `tsconfig.json`, `next.config.*`, active instructions, and the affected route or feature directory. Detect the Next.js version, App Router versus Pages Router, package manager, workspace tool, test runner, and configured scripts. Ignore `node_modules/`, `.next/`, `dist/`, coverage, generated clients, minified assets, and lockfile bodies.

Use the package manager selected by the existing lockfile. Prefer repository scripts over ad-hoc commands and respect workspace filters in monorepos.

## Preserve architecture and boundaries

- Do not mix App Router and Pages Router patterns without an explicit migration requirement.
- Keep Server Components as the default in App Router code; add `"use client"` only for client state, effects, events, or browser-only APIs.
- Preserve established data-access, validation, authentication, error, styling, state, and component patterns.
- Validate untrusted input at route handlers, server actions, API boundaries, webhooks, and external-service boundaries.
- Never expose secrets through client bundles, logs, error payloads, or `NEXT_PUBLIC_*` variables.
- Treat URLs, response shapes, server-action inputs, cookies, cache behavior, and shared TypeScript types as contracts.
- For version-sensitive caching, rendering, middleware, runtime, or routing behavior, consult official documentation for the repository's installed version.

## TypeScript and UI quality

- Maintain the project's strictness. Avoid new `any`, unsafe assertions, blanket lint disables, and duplicated server/client types.
- Model loading, empty, error, unauthorized, not-found, and retry states where relevant.
- Preserve semantic HTML, labels, focus behavior, keyboard use, responsive layout, reduced motion, and accessible status/error announcements.
- Avoid unnecessary client JavaScript, request waterfalls, hydration mismatches, unstable render values, and duplicated fetching.
- Use the repository's image, font, metadata, link, and localization conventions.

## Verification ladder

Derive exact commands from `package.json`. Run only applicable stages:

1. Formatter or lint for changed files/workspace.
2. Focused unit or component test covering changed behavior.
3. Typecheck for the affected workspace.
4. Relevant integration or route tests.
5. Headless Interactive Browser/E2E verification (Chrome CDP `--headless`, Playwright `headless: true`, or DevTools in background mode without opening a visible window) for any UI, routing, hydration, or user-journey change: exercise real interactions (login, forms, clicks, state/tenant/locale/theme switches, error banners) on both Desktop (`1280px+`) and Mobile (`320px`–`390px`) viewports; verify live DOM integrity, `scrollWidth <= innerWidth`, zero `console.error`/`pageerror`, and inspect fresh screenshots.
6. Production build for routing, server/client boundaries, configuration, middleware, bundling, or runtime changes.

Expand to the monorepo-wide suite only when a shared package or contract can affect multiple consumers. Do not update snapshots blindly; inspect behavioral changes first. Always clean up disposable databases, test accounts, and background server processes after verification.
