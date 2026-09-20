#!/usr/bin/env bash
# PreToolUse (Bash) — Conventional Commits, checked before the commit exists rather than after.
#
# The release changelog is generated from these messages, so a malformed subject is not a style
# nit: it is a change that silently vanishes from the release notes.
#
# Policy from .groundwork.yaml:
#   off      - do nothing
#   warn     - allow, and explain what is wrong (default)
#   enforce  - block (exit 2) with the reason on stderr
#
# Only inspects `git commit -m` / `-am`. Anything it cannot parse confidently, it lets through:
# a false block is far more expensive than a missed lint.

set -uo pipefail
# shellcheck source=lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh" 2>/dev/null || exit 0

PAYLOAD="$(cat 2>/dev/null || true)"
CMD="$(gw_field '.tool_input.command' "$PAYLOAD")"
[ -n "$CMD" ] || exit 0

case "$CMD" in
  *"git commit"*) ;;
  *) exit 0 ;;
esac

CWD="$(gw_field '.cwd' "$PAYLOAD")"
[ -n "$CWD" ] || CWD="$PWD"
cd "$CWD" 2>/dev/null || exit 0

GW_CONFIG_FILE="$(gw_find_config "$CWD" 2>/dev/null || true)"
export GW_CONFIG_FILE
[ -f "$GW_CONFIG_FILE" ] || exit 0

POLICY="$(gw_config 'conventional_commits' 'warn')"
[ "$POLICY" = "off" ] && exit 0

# Extract the -m subject. Handles -m "…", -m '…', and -am "…".
SUBJECT="$(printf '%s' "$CMD" | sed -n \
  -e 's/.*-[a-zA-Z]*m[[:space:]]*"\([^"]*\)".*/\1/p' \
  -e "s/.*-[a-zA-Z]*m[[:space:]]*'\([^']*\)'.*/\1/p" | head -n1)"

# No quoted -m (heredoc, -F file, editor, amend without message): nothing to check.
[ -n "$SUBJECT" ] || exit 0

# Only the first line is the subject.
SUBJECT="${SUBJECT%%$'\n'*}"

TYPES="$(gw_config 'commit_types' '')"
if [ -n "$TYPES" ]; then
  TYPES="$(printf '%s' "$TYPES" | tr -d '[]' | tr ',' '|' | tr -d ' ')"
else
  TYPES="feat|fix|docs|style|refactor|perf|test|build|ci|chore|revert"
fi

PATTERN="^(${TYPES})(\([a-zA-Z0-9_./-]+\))?!?: .+"
PROBLEM=""

if ! printf '%s' "$SUBJECT" | grep -Eq "$PATTERN"; then
  if printf '%s' "$SUBJECT" | grep -Eq '^[a-zA-Z]+(\([^)]*\))?!?:'; then
    GIVEN="$(printf '%s' "$SUBJECT" | sed -E 's/^([a-zA-Z]+).*/\1/')"
    PROBLEM="type '$GIVEN' is not one of: ${TYPES//|/, }"
  else
    PROBLEM="missing the 'type(scope): ' prefix"
  fi
fi

# Planning ids belong in the branch name and the PR, never in the commit message.
if [ -z "$PROBLEM" ] && printf '%s' "$SUBJECT" | grep -Eq '\b[A-Z]{2,}-[0-9]+\b'; then
  PROBLEM="carries a ticket id — planning ids live in the branch name and the PR, not in commit messages"
fi

# Generated-by / AI attribution.
if [ -z "$PROBLEM" ] && printf '%s' "$SUBJECT" | grep -Eqi 'co-authored-by: *(claude|ai|gpt)|generated (with|by) '; then
  PROBLEM="contains AI attribution"
fi

[ -n "$PROBLEM" ] || exit 0

REASON="Commit subject: \"$SUBJECT\"
Problem: $PROBLEM.
Expected: type(scope): description  — e.g. feat(auth): reject expired refresh tokens
The release changelog is generated from these subjects, so a malformed one disappears from the release notes.
Allowed types: ${TYPES//|/, }"

if [ "$POLICY" = "enforce" ]; then
  printf 'Groundwork commit-lint (policy: enforce) blocked this commit.\n\n%s\n' "$REASON" >&2
  exit 2
fi

gw_context "PreToolUse" "Groundwork commit-lint (policy: warn) — the commit was allowed, but: $REASON"
