# Codex Dev Flow for macOS

Personal Codex setup for software development across languages and platforms, with a macOS installer. The repository restores:

- global working agreements at `~/.codex/AGENTS.md`;
- the `dev-flow` skill at `~/.agents/skills/dev-flow` (available across all your Codex projects);
- focused references for Flutter, Next.js, and Python, plus manifest-driven guidance for other stacks and target platforms.

Authentication, sessions, logs, plugin caches, API keys, and project source code are intentionally excluded.

## Fresh macOS installation

Run each section in Terminal in order.

### 1. Install Apple command-line tools

```bash
xcode-select --install
```

Finish the installer prompt before continuing.

### 2. Install Codex CLI

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

### 3. Install Homebrew and GitHub CLI

Skip the Homebrew command if `brew --version` already works.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
brew install gh
gh auth login -h github.com -p https -w
```

Follow the browser prompt and sign in to the GitHub account that can access this private repository.

### 4. Clone and install this configuration

```bash
mkdir -p "$HOME/Developer"
cd "$HOME/Developer"
gh repo clone tuanminh2409bn/codex-dev-flow-macos
cd codex-dev-flow-macos
chmod +x install.sh
./install.sh
```

The installer backs up existing guidance and the skill under `~/.codex/backups/`. It installs global `AGENTS.md` on a fresh setup. If an existing file differs, it preserves it and writes a uniquely named `AGENTS.md.proposed-*` for review and merging. The skill is replaced after staging; its previous contents remain in the backup.

### 5. Install Addy Osmani's Agent Skills plugin

`dev-flow` can work by itself, but this plugin provides the specialist skills it routes to for testing, debugging, security, UI, and other higher-risk work.

```bash
codex plugin marketplace add addyosmani/agent-skills --ref 0.6.12
codex plugin add agent-skills@agent-skills
```

### 6. Restart and verify

Quit the Codex desktop app completely, reopen it, and run:

```bash
codex doctor
codex plugin list
```

Then ask Codex:

```text
Confirm that the global AGENTS.md and dev-flow skill are available. Summarize their roles briefly.
```

## Updating an existing Mac

```bash
cd "$HOME/Developer/codex-dev-flow-macos"
git pull --ff-only
./install.sh
```

If Agent Skills is still pinned to `0.6.9`, update that marketplace separately (the installer does not manage plugins):

```bash
codex plugin marketplace remove agent-skills
codex plugin marketplace add addyosmani/agent-skills --ref 0.6.12
codex plugin add agent-skills@agent-skills
```

Review any `AGENTS.md.proposed-*` reported by the installer and merge the desired changes while preserving machine-specific rules. A proposal is not active guidance. Restart Codex and open a new chat after an update.

## Project-specific configuration

Keep each project's own `AGENTS.md` inside that project's Git repository. It will be restored when the project is cloned and will be layered on top of this global configuration.

## Workflow assessment

See [the upstream comparison and validation plan](docs/dev-flow-assessment-2026-10-12.md) for the workflow upgrade, scope, and evidence. The installer remains macOS-oriented; language and target-platform coverage does not imply a Windows installer.

## Installer verification

Run `python3 -m unittest discover -s tests -v` and `bash -n install.sh`. Tests use explicit `--config-dir` and `--skill-dir` destinations inside temporary directories; they do not alter the live Codex configuration.
