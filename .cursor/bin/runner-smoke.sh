#!/usr/bin/env bash
# Smoke-test runner.sh against template plan (no side effects on repo plan.md)
set -euo pipefail

CURSOR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(cd "$CURSOR_DIR/.." && pwd)"
TMP_PLAN="$(mktemp)"
trap 'rm -f "$TMP_PLAN"' EXIT

cp "$CURSOR_DIR/templates/plan.md" "$TMP_PLAN"

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

echo "runner smoke passed."
