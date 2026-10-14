#!/usr/bin/env bash
# TASK-004 SPRINT-CURSOR-ALIGN: .cursor/commands/ retired; slash SSOT is skills/.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CMD="$ROOT/.cursor/commands"
shopt -s nullglob
if [[ -d "$CMD" ]]; then
  leftover=("$CMD"/*.md)
  if [[ ${#leftover[@]} -gt 0 ]]; then
    echo "FAIL: .cursor/commands/*.md still present (skill-only slash)" >&2
    printf '  %s\n' "${leftover[@]}" >&2
    exit 1
  fi
fi
NAMING="$ROOT/.cursor/docs/naming.md"
if grep -q '永远.*命中.*commands' "$NAMING"; then
  echo "FAIL: naming.md still documents commands-first slash" >&2
  exit 1
fi
for required in plan run master learn scaffold release long delivery user-manual test-report; do
  [[ -f "$ROOT/.cursor/skills/$required/SKILL.md" ]] || {
    echo "FAIL: missing skills/$required/SKILL.md" >&2
    exit 1
  }
done
echo "OK: no .cursor/commands slash stubs"
echo "OK: lifecycle slash skills present"
