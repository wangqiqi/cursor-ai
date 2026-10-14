#!/usr/bin/env bash
# TASK-005 SPRINT-CURSOR-ALIGN: platforms.md documents Cloud + Tab hooks; default hooks.json unchanged.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PLAT="$ROOT/.cursor/docs/platforms.md"
HOOKS="$ROOT/.cursor/hooks.json"
for needle in "Cloud Agents parity" "beforeTabFileRead" "run-start.sh"; do
  grep -q "$needle" "$PLAT" || { echo "FAIL: platforms.md missing '$needle'" >&2; exit 1; }
done
grep -q 'platforms.md' "$ROOT/.cursor/docs/cursor-cloud.md" || {
  echo "FAIL: cursor-cloud.md missing platforms cross-link" >&2
  exit 1
}
if grep -q 'beforeTabFileRead\|afterTabFileEdit' "$HOOKS"; then
  echo "FAIL: hooks.json should not enable Tab hooks by default (TASK-005 doc-only)" >&2
  exit 1
fi
grep -q 'sessionStart' "$HOOKS" || { echo "FAIL: hooks.json sessionStart" >&2; exit 1; }
echo "OK: hooks cloud/tab documentation"
echo "OK: hooks.json mother wiring without Tab hooks"
