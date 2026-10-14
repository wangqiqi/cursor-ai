#!/usr/bin/env bash
# SPIKE-003 SPRINT-LITE-SKILLS: skills bundle scope archived.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ARCHIVE_DIR="$ROOT/.cursorGrowth/archive/meta"
shopt -s nullglob
files=("$ARCHIVE_DIR"/*_SPIKE_skills_bundle_scope.md)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "FAIL: no archive meta/*_SPIKE_skills_bundle_scope.md" >&2
  exit 1
fi
latest="$(printf '%s\n' "${files[@]}" | sort | tail -1)"
for needle in "skills-bundle" "full" "core" "skill-bundles.json" "week" "ops-deploy"; do
  grep -qF "$needle" "$latest" || { echo "FAIL: missing '$needle' in $latest" >&2; exit 1; }
done
echo "OK: skills bundle scope spike archive $latest"
