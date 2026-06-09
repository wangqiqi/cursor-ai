#!/usr/bin/env bash
# Load .cursor/config/workflow.json
set -euo pipefail

_LIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../lib/platform.sh
source "$_LIB_DIR/../lib/platform.sh"

JW_CONFIG="${JW_CONFIG:-}"
JW_PROJECT_ROOT="${JW_PROJECT_ROOT:-}"
JW_PLAN_REL="${JW_PLAN_REL:-plan.md}"
JW_WORKFLOW_ENABLED="${JW_WORKFLOW_ENABLED:-true}"
JW_HOOKS_ENABLED="${JW_HOOKS_ENABLED:-true}"
JW_GROWTH_ENABLED="${JW_GROWTH_ENABLED:-false}"
JW_SKIP_PREFIXES="${JW_SKIP_PREFIXES:-REV- SPIKE- DOC-}"
JW_TASK_PREFIX="${JW_TASK_PREFIX:-TASK-}"
JW_HEURISTICS_ENABLED="${JW_HEURISTICS_ENABLED:-false}"

jw_resolve_project_root() {
  local hooks_dir="${1:-}"
  local root
  root="$(cd "${hooks_dir}/../.." && pwd)"
  if [[ -f "${root}/.cursor/config/workflow.json" ]]; then
    JW_PROJECT_ROOT="$root"
    return 0
  fi
  JW_PROJECT_ROOT="$(cd "${hooks_dir}/../../.." && pwd)"
}

jw_init_config() {
  local cursor_dir="$1"
  JW_CONFIG="${cursor_dir}/config/workflow.json"
  JW_PLAN_REL="$(jw_cfg '.plan_file' 'plan.md')"
  JW_WORKFLOW_ENABLED="$(jw_cfg '.workflow.enabled' 'true')"
  JW_HOOKS_ENABLED="$(jw_cfg '.workflow.hooks_enabled' 'true')"
  JW_GROWTH_ENABLED="$(jw_cfg '.growth.enabled' 'false')"
  JW_SKIP_PREFIXES="$(jw_cfg_join '.task_id.prefixes_skip' 'REV- SPIKE- DOC-')"
  JW_TASK_PREFIX="$(jw_cfg_first '.task_id.prefixes_autonomous' 'TASK-')"
  JW_HEURISTICS_ENABLED="$(jw_cfg '.task_verify_heuristics.enabled' 'false')"
}

jw_plan_path() {
  echo "${JW_PROJECT_ROOT}/${JW_PLAN_REL}"
}

jw_cfg() {
  local jqpath="$1"
  local default="$2"
  jw_json_cfg "$JW_CONFIG" "${jqpath#.}" "$default"
}

jw_cfg_join() {
  local jqpath="$1"
  local default="$2"
  jw_json_cfg_join "$JW_CONFIG" "${jqpath#.}" "$default"
}

jw_cfg_first() {
  local jqpath="$1"
  local default="$2"
  local val
  val="$(jw_cfg_join "$jqpath" "$default")"
  echo "${val%% *}"
}
