#!/usr/bin/env bash
# TASK-006 SPRINT-CURSOR-ALIGN: plugin distribution decision archived.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ARCHIVE_DIR="$ROOT/.cursorGrowth/archive/meta"
shopt -s nullglob
files=("$ARCHIVE_DIR"/*_plugin_distribution_decision.md)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "FAIL: no archive meta/*_plugin_distribution_decision.md" >&2
  exit 1
fi
latest="$(printf '%s\n' "${files[@]}" | sort | tail -1)"
for needle in "install-super-cursor" "Cursor Plugin" "Agent Plugin" "Marketplace"; do
  grep -q "$needle" "$latest" || { echo "FAIL: missing '$needle' in $latest" >&2; exit 1; }
done
LEARN="$ROOT/.cursor/templates/cursorGrowth/learn/cursor-platform.md"
grep -q 'install-super-cursor' "$LEARN" || { echo "FAIL: cursor-platform.md install path" >&2; exit 1; }
grep -q 'cursor-plugin' "$LEARN" || { echo "FAIL: cursor-platform.md plugin MVP pointer" >&2; exit 1; }
echo "OK: plugin distribution archive $latest"
echo "OK: cursor-platform distribution summary"
