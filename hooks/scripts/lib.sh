#!/usr/bin/env bash
# Shared helpers for Groundwork hooks.
#
# Design rules for every hook in this plugin:
#   - Never block on anything but an explicit `enforce` policy.
#   - Never fail the session because the hook itself broke. Exit 0 on any internal error.
#   - Never read or emit repository content beyond what the check needs.

set -uo pipefail

# Read a scalar from .groundwork.yaml without requiring a YAML parser.
# Usage: gw_config <dotted.key> [default]
# Supports the nested keys this plugin actually uses, by matching the leaf under its parent.
gw_config() {
  local key="$1" default="${2:-}" file="$GW_CONFIG_FILE"
  [ -f "$file" ] || { printf '%s' "$default"; return 0; }

  local parent leaf
  if [[ "$key" == *.* ]]; then
    parent="${key%%.*}"
    leaf="${key##*.}"
  else
    parent=""
    leaf="$key"
  fi

  local value
  if [ -n "$parent" ]; then
    value=$(awk -v parent="$parent" -v leaf="$leaf" '
      /^[[:space:]]*#/ { next }
      /^[^[:space:]#]/ { in_parent = ($0 ~ "^" parent ":") ? 1 : 0; next }
      in_parent && $1 == leaf":" {
        sub(/^[[:space:]]*[^:]+:[[:space:]]*/, "")
        sub(/[[:space:]]*#.*$/, "")
        gsub(/^["'"'"']|["'"'"']$/, "")
        print; exit
      }
    ' "$file" 2>/dev/null)
  else
    value=$(awk -v leaf="$leaf" '
      /^[[:space:]]*#/ { next }
      $1 == leaf":" {
        sub(/^[^:]+:[[:space:]]*/, "")
        sub(/[[:space:]]*#.*$/, "")
        gsub(/^["'"'"']|["'"'"']$/, "")
        print; exit
      }
    ' "$file" 2>/dev/null)
  fi

  if [ -n "${value:-}" ]; then printf '%s' "$value"; else printf '%s' "$default"; fi
}

# Locate .groundwork.yaml by walking up from the session cwd.
gw_find_config() {
  local dir="${1:-$PWD}"
  while [ -n "$dir" ] && [ "$dir" != "/" ]; do
    if [ -f "$dir/.groundwork.yaml" ]; then printf '%s' "$dir/.groundwork.yaml"; return 0; fi
    dir="$(dirname "$dir")"
  done
  printf '%s' "/nonexistent"
  return 1
}

# Emit additionalContext for the given hook event and exit 0.
# Usage: gw_context <HookEventName> <message>
gw_context() {
  local event="$1" msg="$2"
  if command -v jq >/dev/null 2>&1; then
    jq -nc --arg e "$event" --arg m "$msg" \
      '{hookSpecificOutput: {hookEventName: $e, additionalContext: $m}}'
  else
    # Minimal escaping fallback when jq is unavailable.
    local esc
    esc=$(printf '%s' "$msg" | sed 's/\\/\\\\/g; s/"/\\"/g' \
      | awk 'NR>1 { printf "\\n" } { printf "%s", $0 }')
    printf '{"hookSpecificOutput":{"hookEventName":"%s","additionalContext":"%s"}}' "$event" "$esc"
  fi
  exit 0
}

# Read a field out of the hook's stdin JSON payload.
# Usage: gw_field <jq-path> <payload>
gw_field() {
  local path="$1" payload="$2"
  if command -v jq >/dev/null 2>&1; then
    printf '%s' "$payload" | jq -r "$path // empty" 2>/dev/null
  else
    printf ''
  fi
}
