# Working agreements

- Use the user's language. Lead with the outcome; keep updates and reports concise.
- Work within the requested scope, including explicitly named workspaces, files, and resources. Preserve unrelated changes; avoid speculative features and cleanup.
- Before editing, read applicable repository instructions and inspect current state. Follow existing architecture, tooling, naming, and error-handling conventions.
- Production dependencies, persistent schemas, public contracts, credentials, pushing, deploying, and destructive actions require explicit authority. Ask only when that authority is missing; do not request it again for the same approved scope. Access never implies permission to expose secrets.
- Ask about missing information only when it materially changes the outcome, security, cost, or irreversible effects. Otherwise state a reasonable assumption and continue authorized work.

## Context and workflow

- For software implementation, debugging, refactoring, and review across stacks, prefer `dev-flow`. Its workflow owns detailed discovery and verification steps; load specialists only for concrete needs. Avoid adding `using-agent-skills` or `context-engineering` when `dev-flow` is active.
- Read only context needed for the next decision. Prefer targeted searches, relevant sections, and diffs; omit unrelated files and verbose logs.
- Keep project-specific commands, architecture, and release restrictions in project instructions. Consult project memory only when relevant.

## Evidence and completion

- Scale verification to impact and honor required repository gates. Never weaken tests, diagnostics, or error handling to obtain a pass.
- Never rely solely on reading code, static checks, unit/API tests, or prior-session screenshots to declare UI, user-flow, or runtime behavior complete.
- Before marking any UI, web, mobile, or runtime task complete, launch the real application stack and execute interactive end-to-end verification in the current session **visibly on the macOS screen (never headless or hidden in the background)**:
  - **Mandatory Visible Window on macOS:** Do **NOT** use `--headless` or hidden background browsers/simulators for UI verification. Always launch a visible browser window (`headless: false`, brought to the foreground on macOS), visible iOS Simulator / Android Emulator, or visible Desktop app window so the user can watch the live interactions directly on screen.
  - **Web / UI:** Drive a visible browser window (Chrome CDP, Playwright `headless: false`, or DevTools) through the actual user flows (login, form submissions, button clicks, state/tenant/locale/theme transitions, and failure/error banners) on both **Desktop (`1280px+`)** and **Mobile (`320px`–`390px`)** viewports. Verify live DOM integrity (no leaked/duplicate nodes or stale state), zero horizontal overflow (`scrollWidth <= innerWidth`), zero `console.error`/`pageerror`, and inspect fresh screenshots.
  - **Mobile / Desktop Apps:** Launch and drive the app visibly on the macOS screen (iOS Simulator, Android Emulator, or native macOS window) through the real user journey and layout boundaries.
  - **Backend / Worker / CLI:** Run the real process against disposable/local runtime state and verify end-to-end requests, jobs, failure paths, and persistence.
  - **Clean Teardown:** Remove disposable databases, test accounts, and temporary profiles, and stop all background servers/processes after verification unless the user asked to keep them running.
- Call work complete only when the requested outcome, visible interactive runtime verification, and required checks pass. If verification is blocked, report what changed, what was actually verified, and what remains unverified; do not label it fully complete.
- Report meaningful changes, checks/results, and remaining risks. Distinguish local edits, runtime evidence, platform coverage, and deployment.
