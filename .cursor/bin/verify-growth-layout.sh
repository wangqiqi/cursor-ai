#!/usr/bin/env bash
# Growth layout SOP checks (archive domain subdirs · scripts tree) — mother repo.
set -euo pipefail

CUR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(cd "$CUR/.." && pwd)"
FAIL=0

fail() { echo "FAIL $*"; FAIL=$((FAIL + 1)); }
ok() { echo "OK  $*"; }

echo "=== verify-growth-layout ==="

SSOT="$CUR/skills/plan/reference/growth-layout.md"
[[ -f "$SSOT" ]] && ok "growth-layout.md exists" || fail "missing $SSOT"

need_ref=(
  "$CUR/rules/execution/doc-hygiene.mdc"
  "$CUR/rules/feedback/verify.mdc"
  "$CUR/skills/run/SKILL.md"
  "$CUR/skills/scaffold/SKILL.md"
  "$CUR/templates/cursorGrowth/learn/plan-conventions.md"
)

for f in "${need_ref[@]}"; do
  if [[ -f "$f" ]] && grep -q 'growth-layout' "$f"; then
    ok "$(basename "$f") references growth-layout"
  else
    fail "$(basename "$f") missing growth-layout reference"
  fi
done

if [[ -f "$CUR/templates/cursorGrowth/learn/plan-conventions.md" ]] \
  && grep -q 'archive/{domain}/' "$CUR/templates/cursorGrowth/learn/plan-conventions.md"; then
  ok "plan-conventions template uses archive/{domain}/"
else
  fail "plan-conventions template missing archive/{domain}/"
fi

if [[ -f "$SSOT" ]] \
  && grep -q 'verify/domain/' "$SSOT" \
  && grep -q 'verify/tier/' "$SSOT"; then
  ok "growth-layout documents scripts verify/ tree"
else
  fail "growth-layout missing scripts verify/ tree"
fi

if [[ -f "$SSOT" ]] \
  && grep -qE '\| `sprint`' "$SSOT" \
  && grep -qE '\| `spike`' "$SSOT"; then
  ok "growth-layout lists default archive domains"
else
  fail "growth-layout missing default archive domain table"
fi

if grep -q 'verify-growth-layout.sh' "$CUR/verify-super-cursor.sh" 2>/dev/null; then
  ok "verify-super-cursor aggregates verify-growth-layout"
else
  fail "verify-super-cursor.sh must call verify-growth-layout.sh"
fi

[[ "$FAIL" -eq 0 ]] && echo "verify-growth-layout passed." && exit 0
echo "$FAIL check(s) failed." && exit 1
