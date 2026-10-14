#!/usr/bin/env bash
# SPIKE-001 SPRINT-MOTHER-LEAN: tools skills optional bundle decision archived.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ARCHIVE_DIR="$ROOT/.cursorGrowth/archive/meta"
shopt -s nullglob
files=("$ARCHIVE_DIR"/*_SPIKE_tools_skills_bundle.md)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "FAIL: no archive meta/*_SPIKE_tools_skills_bundle.md" >&2
  exit 1
fi
latest="$(printf '%s\n' "${files[@]}" | sort | tail -1)"
for needle in "week" "disk" "maintain" "ops-deploy" "code-stats-viz" "In · Defer" "Defer" "install profile"; do
  grep -q "$needle" "$latest" || { echo "FAIL: missing '$needle' in $latest" >&2; exit 1; }
done
echo "OK: tools skills bundle spike archive $latest"
