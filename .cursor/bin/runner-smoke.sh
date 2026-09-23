#!/usr/bin/env bash
# Smoke-test runner.sh against template plan (no side effects on repo plan.md)
set -euo pipefail

CURSOR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(cd "$CURSOR_DIR/.." && pwd)"
TMP_PLAN="$(mktemp)"
trap 'rm -f "$TMP_PLAN"' EXIT

cp "$CURSOR_DIR/templates/plan.md" "$TMP_PLAN"

# Template default is closed/empty; smoke needs an active sprint fixture.
# 不用 `sed -i`（BSD/macOS 需要 -i ''），改走临时文件。
sed \
  -e 's/<!-- ACTIVE: (none) -->/<!-- ACTIVE: TASK-001 -->/' \
  -e 's/<!-- PLAN_APPROVED: (none) -->/<!-- PLAN_APPROVED: 2099-01-01 -->/' \
  -e 's/<!-- SPRINT_STATUS: closed -->/<!-- SPRINT_STATUS: active -->/' \
  -e 's/<!-- SPRINT: (none) -->/<!-- SPRINT: SPRINT-01 -->/' \
  "$TMP_PLAN" > "$TMP_PLAN.new"
mv "$TMP_PLAN.new" "$TMP_PLAN"

# shellcheck source=../hooks/lib/plan-parse.sh
source "$CURSOR_DIR/hooks/lib/plan-parse.sh" "$TMP_PLAN"

echo "=== runner smoke ==="

active="$(plan_active)"
[[ "$active" == "TASK-001" ]] || { echo "FAIL: expected TASK-001, got $active"; exit 1; }
echo "OK  plan_active=$active"

approved="$(plan_plan_approved)"
[[ -n "$approved" ]] || { echo "FAIL: PLAN_APPROVED empty"; exit 1; }
echo "OK  PLAN_APPROVED set"

gate="$(plan_gate_ok)"
[[ "$gate" == "OK" ]] || { echo "FAIL: gate=$gate"; exit 1; }
echo "OK  gate-check would pass"

next="$(plan_next_task)"
echo "OK  next-task=$next"

bash "$CURSOR_DIR/bin/runner.sh" help 2>/dev/null | grep -q 'release-tag' \
  && echo "OK  runner help lists release-tag" \
  || { echo "FAIL: runner help missing release-tag"; exit 1; }

# help 不得有命令替换噪音（回归：未转义反引号）
help_err="$(bash "$CURSOR_DIR/bin/runner.sh" help 2>&1 >/dev/null)"
[[ -z "$help_err" ]] || { echo "FAIL: runner help wrote to stderr: $help_err"; exit 1; }
echo "OK  runner help is clean"

# 闸门 fail-closed：未批准的模板 plan 必须 BLOCK（P0-3 回归）
(
  # shellcheck source=../hooks/lib/plan-parse.sh
  source "$CURSOR_DIR/hooks/lib/plan-parse.sh" "$CURSOR_DIR/templates/plan.md"
  g="$(plan_gate_ok)" || true
  [[ "$g" == "NO_APPROVAL" ]] || { echo "FAIL: template gate=$g (expect NO_APPROVAL)"; exit 1; }
  echo "OK  unapproved template blocks"
) || exit 1

echo "runner smoke passed."
