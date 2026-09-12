#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
codex_dir="${CODEX_HOME:-$HOME/.codex}"
skill_dir="$codex_dir/skills/dev-flow"
timestamp="$(date +%Y%m%d-%H%M%S)"
backup_dir="$codex_dir/backups/codex-dev-flow-$timestamp"

if [[ ! -f "$repo_dir/config/AGENTS.md" ]]; then
  echo "Missing config/AGENTS.md" >&2
  exit 1
fi

if [[ ! -f "$repo_dir/skills/dev-flow/SKILL.md" ]]; then
  echo "Missing skills/dev-flow/SKILL.md" >&2
  exit 1
fi

mkdir -p "$codex_dir" "$codex_dir/skills"

if [[ -f "$codex_dir/AGENTS.md" || -d "$skill_dir" ]]; then
  mkdir -p "$backup_dir"

  if [[ -f "$codex_dir/AGENTS.md" ]]; then
    cp "$codex_dir/AGENTS.md" "$backup_dir/AGENTS.md"
  fi

  if [[ -d "$skill_dir" ]]; then
    mv "$skill_dir" "$backup_dir/dev-flow"
  fi

  echo "Existing configuration backed up to: $backup_dir"
fi

install -m 0644 "$repo_dir/config/AGENTS.md" "$codex_dir/AGENTS.md"
cp -R "$repo_dir/skills/dev-flow" "$skill_dir"

test -f "$codex_dir/AGENTS.md"
test -f "$skill_dir/SKILL.md"

echo "Installed global guidance: $codex_dir/AGENTS.md"
echo "Installed Dev Flow skill: $skill_dir"
echo "Restart Codex to load the restored configuration."
