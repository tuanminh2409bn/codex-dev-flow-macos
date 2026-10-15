# Dev Flow for macOS (Codex & Google Antigravity)

Personal agentic development setup across languages and platforms, with a safe macOS installer for both **Google Antigravity** and **Codex**. The repository provides:

- global working agreements (`~/.gemini/config/GEMINI.md` for Antigravity or `~/.codex/AGENTS.md` for Codex);
- the `dev-flow` primary router skill (`~/.gemini/config/skills/dev-flow` for Antigravity or `~/.agents/skills/dev-flow` for Codex);
- progressive-disclosure references loaded on-demand only for the active stack:
  - **Mobile & Cross-Platform:** [Flutter & Dart](skills/dev-flow/references/flutter.md), [Swift & Apple Platforms](skills/dev-flow/references/swift.md), [Java & Kotlin (JVM / Android)](skills/dev-flow/references/jvm.md)
  - **Web & Full-Stack JS/TS:** [Next.js](skills/dev-flow/references/nextjs.md), [TypeScript & JavaScript (React, Vue, Svelte, Angular, Node, Bun, Deno)](skills/dev-flow/references/typescript-js.md)
  - **Backend, Systems & Native:** [Python](skills/dev-flow/references/python.md), [Go](skills/dev-flow/references/go.md), [Rust](skills/dev-flow/references/rust.md), [C# & .NET](skills/dev-flow/references/dotnet.md), [C & C++](skills/dev-flow/references/cpp.md), [Ruby, PHP & Elixir](skills/dev-flow/references/ruby-php-elixir.md)
  - **Cross-Cutting & Contracts:** [Database Migrations & API Contracts](skills/dev-flow/references/data-and-contracts.md), [Polyglot, Shell/CI & Target Platforms](skills/dev-flow/references/platforms.md), [Specialist Routing](skills/dev-flow/references/specialists.md).

Authentication, sessions, logs, plugin caches, API keys, and project source code are intentionally excluded.

## Installation on macOS

### Option A: Install for Google Antigravity

```bash
chmod +x install.sh
./install.sh --antigravity
```

This installs global rules at `~/.gemini/config/GEMINI.md` and the skill at `~/.gemini/config/skills/dev-flow`, backing up any existing files under `~/.gemini/config/backups/` and preserving custom local guidance via `GEMINI.md.proposed-*`.

### Option B: Install for OpenAI Codex

Run each section in Terminal in order for a fresh Codex setup:

#### 1. Install Apple command-line tools

```bash
xcode-select --install
```

Finish the installer prompt before continuing.

#### 2. Install Codex CLI

Use the official OpenAI installer:

```bash
curl -fsSL https://chatgpt.com/codex/install.sh | sh
```

Open a new Terminal window, then verify:

```bash
codex --version
codex login
```

To install or open the desktop app:

```bash
codex app
```

#### 3. Install Homebrew and GitHub CLI

Skip the Homebrew command if `brew --version` already works.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gh
gh auth login -h github.com -p https -w
```

Follow the browser prompt and sign in to the GitHub account that can access this repository.

#### 4. Clone and install this configuration

```bash
mkdir -p "$HOME/Developer"
cd "$HOME/Developer"
gh repo clone tuanminh2409bn/codex-dev-flow-macos
cd codex-dev-flow-macos
chmod +x install.sh
./install.sh
```

The installer backs up existing guidance and the skill under `~/.codex/backups/`. It installs global `AGENTS.md` on a fresh setup. If an existing file differs, it preserves it and writes a uniquely named `AGENTS.md.proposed-*` for review and merging. The skill is replaced after staging; its previous contents remain in the backup.

#### 5. Install Addy Osmani's Agent Skills plugin

`dev-flow` can work by itself, but this plugin provides the specialist skills it routes to for testing, debugging, security, UI, and other higher-risk work.

```bash
codex plugin marketplace add addyosmani/agent-skills --ref 0.6.12
codex plugin add agent-skills@agent-skills
```

#### 6. Restart and verify

Quit the desktop app completely, reopen it, and ask the agent:

```text
Confirm that the global guidance and dev-flow skill are available. Summarize their roles briefly.
```

## Updating an existing Mac

```bash
cd "$HOME/Developer/codex-dev-flow-macos"
git pull --ff-only
./install.sh                 # For Codex
# or
./install.sh --antigravity   # For Google Antigravity
```

Review any `*.proposed-*` file reported by the installer and merge the desired changes while preserving machine-specific rules. A proposal is not active guidance. Restart the host app and open a new chat after an update.

## Project-specific configuration

Keep each project's own `AGENTS.md` or `GEMINI.md` inside that project's Git repository. It will be restored when the project is cloned and will be layered on top of this global configuration.

## Workflow assessment

See [the upstream comparison and validation plan](docs/dev-flow-assessment-2026-10-12.md) for the workflow upgrade, scope, and evidence. The installer remains macOS-oriented; language and target-platform coverage does not imply a Windows installer.

## Installer verification

Run `python3 -m unittest discover -s tests -v` and `bash -n install.sh`. Tests use explicit `--config-dir` and `--skill-dir` destinations inside temporary directories; they do not alter live configuration.
