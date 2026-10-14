#!/usr/bin/env bash
# SPIKE-002 SPRINT-PLUGIN-MVP: scope matrix archived.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ARCHIVE_DIR="$ROOT/.cursorGrowth/archive/meta"
shopt -s nullglob
files=("$ARCHIVE_DIR"/*_SPIKE_plugin_mvp_scope.md)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "FAIL: no archive meta/*_SPIKE_plugin_mvp_scope.md" >&2
  exit 1
fi
latest="$(printf '%s\n' "${files[@]}" | sort | tail -1)"
for needle in "**In**" "**Out**" "rules" "skills" "hooks" "agents" "install"; do
  grep -q "$needle" "$latest" || { echo "FAIL: missing '$needle' in $latest" >&2; exit 1; }
done
grep -qE 'master.*plan.*run|plan.*run.*master' "$latest" || {
  echo "FAIL: missing lifecycle skills in scope matrix" >&2
  exit 1
}
echo "OK: plugin MVP scope spike archive $latest"
