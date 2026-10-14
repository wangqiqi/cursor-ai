#!/usr/bin/env bash
# Install --skills-bundle full|core smoke (temp dir only).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
INSTALL="$ROOT/install-super-cursor.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

count_skills() {
  find "$1/.cursor/skills" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' '
}

[[ -x "$INSTALL" ]] || { echo "FAIL: install not executable" >&2; exit 1; }

FULL_DIR="$TMP/full"
CORE_DIR="$TMP/core"
"$INSTALL" "$FULL_DIR" --profile lite --skills-bundle full >/dev/null
"$INSTALL" "$CORE_DIR" --profile lite --skills-bundle core >/dev/null

full_n="$(count_skills "$FULL_DIR")"
core_n="$(count_skills "$CORE_DIR")"

if [[ "$full_n" != "28" ]]; then
  echo "FAIL: full bundle skills=$full_n (expected 28)" >&2
  exit 1
fi
if [[ "$core_n" != "23" ]]; then
  echo "FAIL: core bundle skills=$core_n (expected 23)" >&2
  exit 1
fi
for s in week disk maintain ops-deploy code-stats-viz; do
  [[ -d "$CORE_DIR/.cursor/skills/$s" ]] && {
    echo "FAIL: core install still has skills/$s" >&2
    exit 1
  }
done
echo "OK: install skills-bundle full=$full_n core=$core_n"
