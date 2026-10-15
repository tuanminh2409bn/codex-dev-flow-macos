#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
target_host="codex"
config_dir=""
skill_dir=""
guidance_name=""

# Explicit destinations also allow verification without touching live configuration.
while [[ $# -gt 0 ]]; do
  case "$1" in
    --antigravity)
      target_host="antigravity"
      shift
      ;;
    --target)
      if [[ $# -lt 2 || -z "$2" || "$2" == --* ]]; then
        echo "Missing value for $1" >&2
        exit 1
      fi
      case "$2" in
        codex|antigravity) target_host="$2" ;;
        *) echo "Unsupported target: $2 (expected codex or antigravity)" >&2; exit 1 ;;
      esac
      shift 2
      ;;
    --config-dir|--skill-dir|--guidance-name)
      if [[ $# -lt 2 || -z "$2" || "$2" == --* ]]; then
        echo "Missing destination for $1" >&2
        exit 1
      fi
      case "$1" in
        --config-dir) config_dir="$2" ;;
        --skill-dir) skill_dir="$2" ;;
        --guidance-name) guidance_name="$2" ;;
      esac
      shift 2
      ;;
    *) echo "Unknown option: $1" >&2; exit 1 ;;
  esac
done

if [[ "$target_host" == "antigravity" ]]; then
  config_dir="${config_dir:-${GEMINI_CONFIG_DIR:-$HOME/.gemini/config}}"
  skill_dir="${skill_dir:-$config_dir/skills/dev-flow}"
  guidance_name="${guidance_name:-GEMINI.md}"
  host_label="Google Antigravity"
else
  config_dir="${config_dir:-${CODEX_HOME:-$HOME/.codex}}"
  skill_dir="${skill_dir:-$HOME/.agents/skills/dev-flow}"
  guidance_name="${guidance_name:-AGENTS.md}"
  host_label="Codex"
fi

case "$guidance_name" in
  */*|..|.)
    echo "Guidance name must be a filename, not a path: $guidance_name" >&2
    exit 1
    ;;
esac

for required in config/AGENTS.md skills/dev-flow/SKILL.md; do
  if [[ ! -f "$repo_dir/$required" ]]; then
    echo "Missing $required" >&2
    exit 1
  fi
done

mkdir -p "$config_dir" "$(dirname "$skill_dir")"
# Do not replace a symlink or a non-directory with a skill tree.
if [[ -L "$skill_dir" || ( -e "$skill_dir" && ! -d "$skill_dir" ) ]]; then
  echo "Skill destination must be a regular directory: $skill_dir" >&2
  exit 1
fi

guidance_path="$config_dir/$guidance_name"
backup_dir=""
if [[ -e "$guidance_path" || -d "$skill_dir" ]]; then
  mkdir -p "$config_dir/backups"
  backup_dir="$(mktemp -d "$config_dir/backups/dev-flow-$(date +%Y%m%d-%H%M%S)-XXXXXX")"
  if [[ -f "$guidance_path" ]]; then
    cp "$guidance_path" "$backup_dir/$guidance_name"
  fi
  if [[ -d "$skill_dir" ]]; then
    cp -R "$skill_dir" "$backup_dir/dev-flow"
  fi
  echo "Existing configuration backed up to: $backup_dir"
fi

# Never overwrite machine-specific guidance. A differing template is a proposal.
if [[ ! -e "$guidance_path" && ! -L "$guidance_path" ]]; then
  install -m 0644 "$repo_dir/config/AGENTS.md" "$guidance_path"
  echo "Installed global guidance: $guidance_path"
elif cmp -s "$repo_dir/config/AGENTS.md" "$guidance_path"; then
  echo "Global guidance already matches the template."
else
  proposal="$(mktemp "$config_dir/${guidance_name}.proposed-XXXXXX")"
  install -m 0644 "$repo_dir/config/AGENTS.md" "$proposal"
  echo "Preserved existing global guidance. Review and merge: $proposal"
fi

if [[ "$target_host" == "antigravity" ]] && cmp -s "$repo_dir/config/AGENTS.md" "$guidance_path"; then
  mkdir -p "$config_dir/rules"
  if [[ ! -e "$config_dir/rules/AGENTS.md" && ! -L "$config_dir/rules/AGENTS.md" ]] || cmp -s "$repo_dir/config/AGENTS.md" "$config_dir/rules/AGENTS.md"; then
    install -m 0644 "$repo_dir/config/AGENTS.md" "$config_dir/rules/AGENTS.md"
  fi
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
echo "Restart $host_label and open a new chat to load the configuration."
