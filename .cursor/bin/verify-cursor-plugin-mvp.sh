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

for agent in ship review spike; do
  [[ -f "$PLUGIN/agents/$agent.md" ]] || fail "missing agents/$agent.md"
done

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

verify_mdc="$PLUGIN/rules/feedback/verify.mdc"
mother_verify="$ROOT/.cursor/rules/feedback/verify.mdc"
[[ -f "$verify_mdc" ]] || fail "missing rules/feedback/verify.mdc"
[[ -f "$mother_verify" ]] || fail "missing mother rules/feedback/verify.mdc"
if ! diff -q "$mother_verify" "$verify_mdc" >/dev/null 2>&1; then
  fail "plugin verify.mdc must match mother (run sync-plugin-subset.sh)"
fi
grep -q "## 母版门禁清单（分组聚合" "$verify_mdc" \
  || fail "plugin verify.mdc must document grouped gate list"
if grep -qE '11 道(门禁| · 全部接线)' "$verify_mdc"; then
  fail "plugin verify.mdc still mentions obsolete 11 道 gate count"
fi

bash "$ROOT/.cursor/bin/verify-cursor-plugin-manifest.sh" || exit 1

echo "OK: cursor-plugin MVP subset (lifecycle skills · agents · core rules · hooks · no commands)"
