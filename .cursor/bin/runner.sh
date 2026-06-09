#!/usr/bin/env bash
# plan / run CLI
set -euo pipefail

CURSOR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(cd "$CURSOR_DIR/.." && pwd)"
CONFIG="$CURSOR_DIR/config/workflow.json"
# shellcheck source=../lib/platform.sh
source "$CURSOR_DIR/lib/platform.sh"

jw_config() {
  local key="$1"
  local default="${2:-}"
  local dotted="${key#.}"
  local val=""

  if [[ -f "$CONFIG" ]]; then
    val="$(jw_json_cfg "$CONFIG" "$dotted" "")"
    [[ -n "$val" && "$val" != "null" ]] && { echo "$val"; return 0; }
  fi
  echo "$default"
}

jw_config_join() {
  local key="$1"
  local default="${2:-}"
  local dotted="${key#.}"
  local joined=""

  if [[ -f "$CONFIG" ]]; then
    joined="$(jw_json_cfg_join "$CONFIG" "$dotted" "")"
    [[ -n "$joined" && "$joined" != "null" ]] && { echo "$joined"; return 0; }
  fi
  echo "$default"
}

PLAN_REL="$(jw_config '.plan_file' 'plan.md')"
PLAN="$ROOT/$PLAN_REL"
FRONTEND_DIR="$(jw_config '.task_verify_heuristics.frontend_test_dir' '')"
BACKEND_DIR="$(jw_config '.task_verify_heuristics.backend_test_dir' '')"
FRONTEND_TEST_CMD="$(jw_config '.task_verify_heuristics.frontend_test_cmd' '')"
BACKEND_TEST_CMD="$(jw_config '.task_verify_heuristics.backend_test_cmd' '')"
HEURISTICS_ENABLED="$(jw_config '.task_verify_heuristics.enabled' 'false')"
FALLBACK_TEST="$(jw_config '.task_verify_heuristics.fallback_test_script' './scripts/test.sh')"
FALLBACK_VERIFY="$(jw_config '.task_verify_heuristics.fallback_verify_script' './scripts/verify.sh')"
JW_SKIP_PREFIXES="$(jw_config_join '.task_id.prefixes_skip' 'REV- SPIKE- DOC-')"
export JW_SKIP_PREFIXES
# shellcheck source=../hooks/lib/plan-parse.sh
source "$CURSOR_DIR/hooks/lib/plan-parse.sh" "$PLAN"

cmd="${1:-status}"

next_version() {
  local latest ver major minor patch tag_glob default_ver version_line
  version_line="$(plan_meta "VERSION_LINE")"
  version_line="${version_line:-1.0}"
  tag_glob="${JW_VERSION_TAG_GLOB:-v${version_line}.*}"
  default_ver="${JW_VERSION_DEFAULT:-${version_line}.0}"
  latest="$(git -C "$ROOT" tag -l "$tag_glob" --sort=-v:refname 2>/dev/null | head -1 || true)"
  if [[ -z "$latest" ]]; then
    echo "$default_ver"
    return 0
  fi
  ver="${latest#v}"
  IFS='.' read -r major minor patch <<< "$ver"
  patch="${patch:-0}"
  echo "${major}.${minor}.$((patch + 1))"
}

release_check() {
  local p0_open
  p0_open="$(grep -E '\| P0 \|' "$PLAN" 2>/dev/null | grep -cv '| ✅ |' || true)"
  if [[ "$p0_open" -eq 0 ]]; then
    echo "ready"
    echo "next_version=$(next_version)"
    echo "tag=v$(next_version)"
    return 0
  fi
  echo "pending_p0=$p0_open"
  return 1
}

gate_check() {
  local reason
  reason="$(plan_gate_ok || true)"
  echo "=== run gate-check ==="
  case "$reason" in
    OK)
      echo "OK: PLAN_APPROVED=$(plan_plan_approved) · SPRINT=$(plan_sprint) · ACTIVE=$(plan_active)"
      return 0
      ;;
    PLANNING)
      echo "BLOCK: PLANNING=true — 请先 /plan 完成规划并设 PLANNING:false"
      return 1
      ;;
    NO_APPROVAL)
      echo "BLOCK: 无 PLAN_APPROVED — 请先 /plan 确认规划并写入日期"
      return 1
      ;;
    *)
      echo "BLOCK: 未知闸门状态"
      return 1
      ;;
  esac
}

plan_check() {
  local issues=0
  echo "=== plan / run plan-check ==="
  if [[ ! -f "$PLAN" ]]; then
    echo "FAIL: plan.md 不存在"
    return 1
  fi
  if ! grep -q '| ⬜ |' "$PLAN" 2>/dev/null && ! grep -q '| 🔧 |' "$PLAN" 2>/dev/null; then
    echo "WARN: 无活跃 ⬜/🔧 任务"
    issues=$((issues + 1))
  fi
  if [[ -z "$(plan_active)" ]]; then
    echo "WARN: <!-- ACTIVE --> 未设置"
    issues=$((issues + 1))
  fi
  if [[ -z "$(plan_sprint)" ]]; then
    echo "WARN: <!-- SPRINT --> 未设置"
    issues=$((issues + 1))
  fi
  if plan_planning; then
    echo "INFO: PLANNING=true — 仅 plan"
  elif [[ -z "$(plan_plan_approved)" ]]; then
    echo "FAIL: <!-- PLAN_APPROVED --> 未设置（run 硬闸门）"
    issues=$((issues + 1))
  fi
  if ! grep -qE '^\*\*(执行顺序|Order)\*\*' "$PLAN" 2>/dev/null; then
    echo "WARN: 缺 **执行顺序** 行（兼容 **Order**；NEXT 回退靠表序）"
    issues=$((issues + 1))
  fi
  local line cols bad=0
  while IFS= read -r line; do
    [[ "$line" =~ \|[[:space:]]*(⬜|🔧)[[:space:]]*\| ]] || continue
    cols="$(echo "$line" | awk -F'|' '{print NF}')"
    if [[ "$cols" -lt 8 ]]; then
      bad=$((bad + 1))
    fi
  done < <(grep -E '\| (⬜|🔧) \|' "$PLAN" 2>/dev/null || true)
  if [[ "$bad" -gt 0 ]]; then
    echo "WARN: ${bad} 行活跃任务可能缺「验收」或「落点」"
    issues=$((issues + 1))
  fi
  if [[ "$issues" -eq 0 ]]; then
    echo "OK: handoff 就绪"
    return 0
  fi
  echo "CHECK: ${issues} 项待补齐"
  return 0
}

task_verify() {
  local id="${1:-$(plan_active)}"
  local acc loc pattern test_py
  if [[ -z "$id" ]]; then
    echo "FAIL: 无 ACTIVE 任务 ID" >&2
    return 1
  fi
  acc="$(plan_task_acceptance "$id")"
  loc="$(plan_task_landing "$id")"
  echo "=== task-verify: ${id} ==="
  echo "验收: ${acc}"
  echo "落点: ${loc}"

  if [[ "$acc" =~ ^(\./|cd |npm |pnpm |npx |pytest |grep |cargo |go test|make |bash ) ]]; then
    echo "==> Running acceptance command"
    cd "$ROOT"
    # shellcheck disable=SC2086
    eval "$acc"
    return $?
  fi

  if [[ "$HEURISTICS_ENABLED" != "true" ]]; then
    echo "SKIP: heuristics disabled — run acceptance command in plan or verify manually"
    return 0
  fi

  if [[ "$acc" == *vitest* || "$loc" == *vitest* || "$loc" == *.test.ts* || "$loc" == *.test.tsx* ]]; then
    pattern="$(basename "$loc" .test.ts)"
    pattern="${pattern%.test.tsx}"
    if [[ -z "$pattern" || "$pattern" == "$loc" ]]; then
      pattern="$(echo "$acc $loc" | grep -oE '[A-Za-z0-9_-]+' | head -1)"
    fi
    if [[ -n "$FRONTEND_DIR" && -d "$ROOT/$FRONTEND_DIR" && -n "$FRONTEND_TEST_CMD" ]]; then
      echo "==> cd $FRONTEND_DIR && $FRONTEND_TEST_CMD -- ${pattern}"
      cd "$ROOT/$FRONTEND_DIR"
      # shellcheck disable=SC2086
      $FRONTEND_TEST_CMD -- "$pattern"
      return $?
    fi
  fi

  if [[ "$acc" == *contract* || "$acc" == *integration* || "$acc" == *test_* ]]; then
    test_py="$(echo "$acc $loc" | grep -oE 'test_[a-z_]+' | head -1)"
    if [[ -n "$test_py" && -n "$BACKEND_DIR" && -d "$ROOT/$BACKEND_DIR" && -n "$BACKEND_TEST_CMD" ]]; then
      echo "==> cd $BACKEND_DIR && $BACKEND_TEST_CMD ${test_py}"
      cd "$ROOT/$BACKEND_DIR"
      # shellcheck disable=SC2086
      $BACKEND_TEST_CMD -q --tb=short -k "${test_py#test_}" 2>/dev/null || $BACKEND_TEST_CMD -q --tb=short "$(find tests -name "${test_py}.py" 2>/dev/null | head -1)"
      return $?
    fi
  fi

  if [[ "$acc" == grep* ]]; then
    cd "$ROOT"
    # shellcheck disable=SC2086
    eval "$acc"
    return $?
  fi

  # Scaffold-aligned fallback (when acceptance is descriptive or empty)
  local test_script="${FALLBACK_TEST#./}"
  local verify_script="${FALLBACK_VERIFY#./}"
  if [[ -f "$ROOT/$test_script" ]]; then
    echo "==> heuristics fallback: $FALLBACK_TEST"
    cd "$ROOT"
    bash "$test_script"
    return $?
  fi
  if [[ -f "$ROOT/$verify_script" && "$acc" == *verify* ]]; then
    echo "==> heuristics fallback: $FALLBACK_VERIFY"
    cd "$ROOT"
    bash "$verify_script"
    return $?
  fi

  echo "SKIP: 验收列为描述性文字，请 Agent 按列手动执行；打版前须跑全量 VERIFY"
  echo "TIP: plan 验收列优先写 $FALLBACK_TEST 或 npm test / pytest 等可执行命令"
  return 0
}

print_status() {
  echo "=== run status ==="
  echo "PLANNING:   $(plan_meta PLANNING || echo false)"
  echo "SPRINT:     $(plan_sprint || echo '(none)')"
  echo "APPROVED:   $(plan_plan_approved || echo '(none)')"
  echo "AUTONOMOUS: $(plan_meta AUTONOMOUS || echo false)"
  echo "ACTIVE:     $(plan_active || echo '(none)')"
  local active
  active="$(plan_active)"
  if [[ -n "$active" ]]; then
    echo "STATUS:     $(plan_task_status "$active")"
    echo "ACCEPTANCE: $(plan_task_acceptance "$active")"
    echo "NEXT_TASK:  $(plan_next_task)"
  fi
  echo "VERIFY:     $(plan_verify)  (打版前全量)"
  echo "PENDING:    $(plan_pending_count) tasks"
  echo "MAX_LOOPS:  $(plan_max_loops)"
  echo "NEXT_VER:   v$(next_version)"
  if release_check >/dev/null 2>&1; then
    echo "RELEASE:    ready (P0 全部 ✅)"
  else
    echo "RELEASE:    pending"
  fi
  local gate
  gate="$(plan_gate_ok || true)"
  echo "GATE:       ${gate}"
}

run_verify() {
  local verify_cmd
  verify_cmd="$(plan_verify)"
  echo "==> Full VERIFY: $verify_cmd"
  cd "$ROOT"
  # shellcheck disable=SC2086
  eval "$verify_cmd"
}

case "$cmd" in
  status)
    print_status
    ;;
  verify)
    run_verify
    ;;
  task-verify)
    task_verify "${2:-}"
    ;;
  gate-check)
    gate_check
    ;;
  next-task)
    plan_next_task
    ;;
  active)
    plan_active
    ;;
  pending)
    plan_pending_count
    ;;
  next_version)
    next_version
    ;;
  release-check)
    release_check
    ;;
  plan-check)
    plan_check
    ;;
  help|-h|--help)
    cat <<EOF
用法: $0 [status|gate-check|task-verify|verify|plan-check|next-task|...]

  status        run Sprint 状态（默认）
  gate-check    run 硬闸门（PLANNING / PLAN_APPROVED）
  task-verify   任务级验收（优先验收列；可传 TASK_ID）
  verify        全量 VERIFY（打版前 / P0 闭合）
  plan-check    plan handoff 结构检查
  next-task     按执行顺序解析下一 ⬜ ID
  release-check P0 是否全部 ✅
  next_version  下一 patch 版本号

环境变量（跨项目）:
  JW_VERSION_TAG_GLOB   git tag 匹配（默认读 plan VERSION_LINE，如 v1.0.*）
  JW_VERSION_DEFAULT    无 tag 时起始版本（默认 {VERSION_LINE}.0）

配置: .cursor/config/workflow.json
EOF
    ;;
  *)
    echo "Unknown command: $cmd" >&2
    exit 1
    ;;
esac
