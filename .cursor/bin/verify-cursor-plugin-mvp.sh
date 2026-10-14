#!/usr/bin/env bash
# TASK-002 SPRINT-PLUGIN-MVP: .cursor-plugin subset matches SPIKE-002 scope.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
PLUGIN="$ROOT/.cursor-plugin"

fail() { echo "FAIL: $*" >&2; exit 1; }

[[ -d "$PLUGIN" ]] || fail "missing $PLUGIN"

if [[ -d "$PLUGIN/commands" ]]; then
  fail ".cursor-plugin/commands must not exist"
fi

for rel in rules/core.mdc rules/workflow.mdc; do
  [[ -f "$PLUGIN/$rel" ]] || fail "missing $rel"
done

for skill in master plan run learn scaffold; do
  [[ -f "$PLUGIN/skills/$skill/SKILL.md" ]] || fail "missing skills/$skill/SKILL.md"
done

[[ -f "$PLUGIN/skills/master/routes.md" ]] || fail "missing skills/master/routes.md"

for skill in git release debug test; do
  [[ ! -d "$PLUGIN/skills/$skill" ]] || fail "skills/$skill should not be in MVP plugin"
done

[[ ! -d "$PLUGIN/rules/tech" ]] || fail "rules/tech must not be in MVP plugin"

for hook in hooks/hooks.json hooks/growth-init.sh hooks/run-start.sh hooks/run-stop.sh; do
  [[ -e "$PLUGIN/$hook" ]] || fail "missing $hook"
done

[[ -f "$PLUGIN/hooks/lib/config-load.sh" ]] || fail "missing hooks/lib/config-load.sh"

grep -q '"command": "hooks/run-start.sh"' "$PLUGIN/hooks/hooks.json" \
  || fail "hooks.json must use plugin-local hooks/ paths"

bash "$ROOT/.cursor/bin/verify-cursor-plugin-manifest.sh" || exit 1

echo "OK: cursor-plugin MVP subset (lifecycle skills · core rules · hooks · no commands)"
