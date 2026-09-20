#!/usr/bin/env bash
# PostToolUse (Write|Edit|MultiEdit) — the docs-in-same-PR rule, enforced at the moment the
# habit forms rather than at review time.
#
# When product code has been edited in this session and no design page has, remind once. Once.
# A reminder that fires on every edit gets tuned out, which is worse than no reminder.
#
# Always exits 0 — this hook informs, it never blocks. Even under `enforce` it only raises the
# volume, because blocking an edit cannot tell the difference between "forgot the doc" and
# "the doc update is the next edit".

set -uo pipefail
# shellcheck source=lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh" 2>/dev/null || exit 0

PAYLOAD="$(cat 2>/dev/null || true)"
FILE="$(gw_field '.tool_input.file_path' "$PAYLOAD")"
[ -n "$FILE" ] || exit 0

CWD="$(gw_field '.cwd' "$PAYLOAD")"
[ -n "$CWD" ] || CWD="$PWD"
cd "$CWD" 2>/dev/null || exit 0

ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -n "$ROOT" ] || exit 0

GW_CONFIG_FILE="$(gw_find_config "$CWD" 2>/dev/null || true)"
export GW_CONFIG_FILE
[ -f "$GW_CONFIG_FILE" ] || exit 0

POLICY="$(gw_config 'docs_in_same_pr' 'warn')"
[ "$POLICY" = "off" ] && exit 0

DESIGN_DIR="$(gw_config 'paths.design' 'design/')"
DESIGN_DIR="${DESIGN_DIR%/}"
[ -d "$ROOT/$DESIGN_DIR" ] || exit 0

# Normalise to a repo-relative path.
REL="${FILE#"$ROOT"/}"

# A design edit clears the flag: the rule has been satisfied for this stretch of work.
STATE_DIR="${CLAUDE_PLUGIN_DATA:-${TMPDIR:-/tmp}}/groundwork"
SESSION="$(gw_field '.session_id' "$PAYLOAD")"
[ -n "$SESSION" ] || SESSION="nosession"
FLAG="$STATE_DIR/drift-$SESSION"
mkdir -p "$STATE_DIR" 2>/dev/null || exit 0

case "$REL" in
  "$DESIGN_DIR"/*)
    rm -f "$FLAG" 2>/dev/null
    exit 0
    ;;
esac

# Only product code counts. Docs, tests, config and generated files do not.
case "$REL" in
  *.md|*.txt|*.rst|*.lock|*.snap) exit 0 ;;
  test/*|tests/*|spec/*|__tests__/*|docs/*|.github/*) exit 0 ;;
  *_test.*|*.test.*|*.spec.*|*_spec.*) exit 0 ;;
esac

case "$REL" in
  *.py|*.js|*.jsx|*.ts|*.tsx|*.go|*.rs|*.java|*.kt|*.rb|*.php|*.cs|*.swift|*.scala|*.c|*.cc|*.cpp|*.h|*.hpp|*.ex|*.exs|*.sql|*.tf|*.proto) ;;
  *) exit 0 ;;
esac

# Already reminded in this session — stay quiet.
[ -f "$FLAG" ] && exit 0
: > "$FLAG" 2>/dev/null || exit 0

if [ "$POLICY" = "enforce" ]; then
  LEAD="Groundwork (docs_in_same_pr: enforce) — this change does not merge without it."
else
  LEAD="Groundwork reminder."
fi

gw_context "PostToolUse" "$LEAD You have edited product code ($REL) but no page under $DESIGN_DIR/ in this session. If this change alters behavior that a design page describes, that page is updated in the SAME change — not as a follow-up ticket. If it does not, no action is needed. This fires once per session."
