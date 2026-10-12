#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
codex_dir="${CODEX_HOME:-$HOME/.codex}"
skill_dir="$HOME/.agents/skills/dev-flow"

# Explicit destinations also allow verification without touching live configuration.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --config-dir|--skill-dir)
      if [[ $# -lt 2 || -z "$2" || "$2" == --* ]]; then
        echo "Missing destination for $1" >&2
        exit 1
      fi
      case "$1" in
        --config-dir) codex_dir="$2" ;;
        --skill-dir) skill_dir="$2" ;;
      esac
      shift 2
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

for required in config/AGENTS.md skills/dev-flow/SKILL.md; do
  if [[ ! -f "$repo_dir/$required" ]]; then
    echo "Missing $required" >&2
    exit 1
  fi
done

mkdir -p "$codex_dir" "$(dirname "$skill_dir")"
# Do not replace a symlink or a non-directory with a skill tree.
if [[ -L "$skill_dir" || ( -e "$skill_dir" && ! -d "$skill_dir" ) ]]; then
  echo "Skill destination must be a regular directory: $skill_dir" >&2
  exit 1
fi

backup_dir=""
if [[ -e "$codex_dir/AGENTS.md" || -d "$skill_dir" ]]; then
  mkdir -p "$codex_dir/backups"
  backup_dir="$(mktemp -d "$codex_dir/backups/codex-dev-flow-$(date +%Y%m%d-%H%M%S)-XXXXXX")"
  if [[ -f "$codex_dir/AGENTS.md" ]]; then
    cp "$codex_dir/AGENTS.md" "$backup_dir/AGENTS.md"
  fi
  if [[ -d "$skill_dir" ]]; then
    cp -R "$skill_dir" "$backup_dir/dev-flow"
  fi
  echo "Existing configuration backed up to: $backup_dir"
fi

# Never overwrite machine-specific guidance. A differing template is a proposal.
if [[ ! -e "$codex_dir/AGENTS.md" && ! -L "$codex_dir/AGENTS.md" ]]; then
  install -m 0644 "$repo_dir/config/AGENTS.md" "$codex_dir/AGENTS.md"
  echo "Installed global guidance: $codex_dir/AGENTS.md"
elif cmp -s "$repo_dir/config/AGENTS.md" "$codex_dir/AGENTS.md"; then
  echo "Global guidance already matches the template."
else
  proposal="$(mktemp "$codex_dir/AGENTS.md.proposed-XXXXXX")"
  install -m 0644 "$repo_dir/config/AGENTS.md" "$proposal"
  echo "Preserved existing global guidance. Review and merge: $proposal"
fi

stage="$(mktemp -d "$(dirname "$skill_dir")/.dev-flow-stage-XXXXXX")"
trap 'rm -rf "$stage"' EXIT
cp -R "$repo_dir/skills/dev-flow/." "$stage/"
if [[ -d "$skill_dir" ]]; then
  mv "$skill_dir" "$backup_dir/dev-flow-original"
fi
if ! mv "$stage" "$skill_dir"; then
  if [[ -d "$backup_dir/dev-flow-original" ]]; then
    mv "$backup_dir/dev-flow-original" "$skill_dir"
  fi
  exit 1
fi
trap - EXIT

test -f "$skill_dir/SKILL.md"
echo "Installed Dev Flow skill: $skill_dir"
echo "Restart Codex and open a new chat to load the configuration."
