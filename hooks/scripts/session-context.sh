#!/usr/bin/env bash
# SessionStart — tell Claude where this repository stands, so Groundwork skills do not have to
# re-detect it and do not silently assume a maturity level the repo has not reached.
#
# Always exits 0. A session must never fail because this hook did.

set -uo pipefail
# shellcheck source=lib.sh
. "$(dirname "${BASH_SOURCE[0]}")/lib.sh" 2>/dev/null || exit 0

PAYLOAD="$(cat 2>/dev/null || true)"
CWD="$(gw_field '.cwd' "$PAYLOAD")"
[ -n "$CWD" ] || CWD="$PWD"
cd "$CWD" 2>/dev/null || exit 0

GW_CONFIG_FILE="$(gw_find_config "$CWD" 2>/dev/null || true)"
export GW_CONFIG_FILE

# Only speak up inside a repository that has adopted Groundwork, or that plainly looks like a
# software project with design docs. Staying quiet everywhere else is the whole point.
ROOT="$(git rev-parse --show-toplevel 2>/dev/null || true)"
[ -n "$ROOT" ] || exit 0

HAS_CONFIG=0
[ -f "$GW_CONFIG_FILE" ] && HAS_CONFIG=1
DESIGN_DIR="$(gw_config 'paths.design' 'design/')"
DESIGN_DIR="${DESIGN_DIR%/}"
HAS_DESIGN=0
[ -d "$ROOT/$DESIGN_DIR" ] && HAS_DESIGN=1

if [ "$HAS_CONFIG" -eq 0 ] && [ "$HAS_DESIGN" -eq 0 ]; then
  exit 0
fi

LAYER="$(gw_config 'layer' '')"
SPRINT="$(gw_config 'paths.sprint' 'SPRINT.md')"
SPEC="$(gw_config 'paths.spec' '')"
CC_POLICY="$(gw_config 'conventional_commits' 'warn')"
DOCS_POLICY="$(gw_config 'docs_in_same_pr' 'warn')"

MSG="Groundwork is active in this repository."

if [ "$HAS_CONFIG" -eq 1 ]; then
  MSG="$MSG Config: ${GW_CONFIG_FILE#"$ROOT"/}."
  [ -n "$LAYER" ] && MSG="$MSG Detected maturity layer: $LAYER."
else
  MSG="$MSG No .groundwork.yaml yet — run the init skill before relying on layer-gated steps."
fi

# Which canon pages exist. Missing pages are stated, not silently tolerated.
if [ "$HAS_DESIGN" -eq 1 ]; then
  PRESENT=""
  MISSING=""
  for page in architecture.md tech-rationale.md infrastructure.md communications.md security.md go-live-readiness.md; do
    if [ -f "$ROOT/$DESIGN_DIR/$page" ]; then
      PRESENT="$PRESENT ${page%.md}"
    else
      MISSING="$MISSING ${page%.md}"
    fi
  done
  [ -n "$PRESENT" ] && MSG="$MSG Design pages present:$PRESENT."
  [ -n "$MISSING" ] && MSG="$MSG Design pages MISSING:$MISSING — do not assume their content exists; say so if a step needs one."

  # An as-built banner means the page is a hypothesis, not canon.
  if grep -rlq 'as-built, unverified' "$ROOT/$DESIGN_DIR" 2>/dev/null; then
    MSG="$MSG Some design pages still carry the 'as-built, unverified' banner — treat their claims as unverified hypotheses."
  fi
else
  MSG="$MSG No $DESIGN_DIR/ directory — this repository is at review-discipline level only; design-dependent steps must degrade loudly rather than invent a design."
fi

[ -f "$ROOT/$SPRINT" ] && MSG="$MSG Sprint plan: $SPRINT (canon for design intent; the tracker is canon for live status)."
[ -n "$SPEC" ] && MSG="$MSG Spec: $SPEC."

MSG="$MSG Policies — conventional_commits: $CC_POLICY, docs_in_same_pr: $DOCS_POLICY."
MSG="$MSG Standing rule: a design page that describes changed behavior is updated in the same change as the code, never as a follow-up."

gw_context "SessionStart" "$MSG"
