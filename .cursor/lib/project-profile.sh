#!/usr/bin/env bash
# project-profile.sh — read .cursorGrowth/project-profile.json (按需启用元数据)
set -euo pipefail

_SC_PP_LIB="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=platform.sh
source "$_SC_PP_LIB/platform.sh"

sc_project_profile_path() {
  local root="${1:-}"
  [[ -n "$root" ]] || return 1
  echo "$root/.cursorGrowth/project-profile.json"
}

sc_profile_ignore() {
  [[ "${VERIFY_IGNORE_PROFILE:-}" == "1" ]]
}

# 0 = apply profile filters · 1 = no profile or ignore
sc_profile_filter_enabled() {
  local root="${1:-}"
  sc_profile_ignore && return 1
  local path
  path="$(sc_project_profile_path "$root" 2>/dev/null || true)"
  [[ -n "$path" && -f "$path" ]]
}

sc_profile_normalize_manifest_tier() {
  local tier="${1:-}"
  case "$tier" in
    l2-standard) echo "l2-domain" ;;
    l2-core | l2-domain | l3 | l0 | l1 | changed) echo "$tier" ;;
    *) echo "$tier" ;;
  esac
}

sc_profile_tier_rank() {
  case "$(sc_profile_normalize_manifest_tier "$1")" in
    l0) echo 0 ;;
    l1) echo 1 ;;
    l2-core) echo 2 ;;
    l2-domain) echo 3 ;;
    l3) echo 4 ;;
    changed) echo 5 ;;
    *) echo -1 ;;
  esac
}

# Exit 0 if tier may run (manifest runner / verify layer)
sc_profile_tier_allowed() {
  local root="${1:-}"
  local tier="${2:-}"
  if ! sc_profile_filter_enabled "$root"; then
    return 0
  fi
  local path rank want max=0
  path="$(sc_project_profile_path "$root")"
  want="$(sc_profile_tier_rank "$tier")"
  [[ "$want" -ge 0 ]] || return 0

  if command -v jq >/dev/null 2>&1; then
    while IFS= read -r en; do
      [[ -n "$en" ]] || continue
      local r
      r="$(sc_profile_tier_rank "$en")"
      [[ "$r" -ge "$max" ]] && max="$r"
    done < <(jq -r '.verify.enabled_tiers[]? // empty' "$path" 2>/dev/null || true)
  else
    local py
    py="$(sc_python 2>/dev/null || true)"
    [[ -n "$py" ]] || return 0
    max="$("$py" - "$path" <<'PY'
import json, sys
path = sys.argv[1]
ranks = {"l0":0,"l1":1,"l2-core":2,"l2-domain":3,"l2-standard":3,"l3":4,"changed":5}
try:
    d = json.load(open(path, encoding="utf-8"))
except (OSError, json.JSONDecodeError):
    print(-1); sys.exit(0)
tiers = (d.get("verify") or {}).get("enabled_tiers") or []
mx = -1
for t in tiers:
    mx = max(mx, ranks.get(t, ranks.get("l2-domain" if t == "l2-standard" else "", -1)))
print(mx)
PY
)"
  fi

  [[ "$max" -lt 0 ]] && return 0
  [[ "$want" -le "$max" ]]
}

# Exit 0 if manifest row stacks column matches profile primary (or stacks is * / empty)
sc_profile_stacks_allow_row() {
  local root="${1:-}"
  local stacks_col="${2:-*}"
  stacks_col="${stacks_col//$'\r'/}"
  if ! sc_profile_filter_enabled "$root"; then
    return 0
  fi
  if [[ -z "$stacks_col" || "$stacks_col" == "*" ]]; then
    return 0
  fi

  local path
  path="$(sc_project_profile_path "$root")"
  local primary_csv
  if command -v jq >/dev/null 2>&1; then
    primary_csv="$(jq -r '[.stacks.primary[]?] | join(" ")' "$path" 2>/dev/null || true)"
  else
    local py
    py="$(sc_python 2>/dev/null || true)"
    [[ -n "$py" ]] || return 0
    primary_csv="$("$py" - "$path" <<'PY'
import json, sys
try:
    d = json.load(open(sys.argv[1], encoding="utf-8"))
    print(" ".join((d.get("stacks") or {}).get("primary") or []))
except (OSError, json.JSONDecodeError):
    pass
PY
)"
  fi

  [[ -n "${primary_csv// }" ]] || return 0

  local s p
  stacks_col="${stacks_col//,/ }"
  for s in $stacks_col; do
    for p in $primary_csv; do
      [[ "$s" == "$p" ]] && return 0
    done
  done
  return 1
}

# One-line hint for run-start (empty if missing / invalid)
sc_project_profile_hint() {
  local root="${1:-}"
  local path py
  path="$(sc_project_profile_path "$root" 2>/dev/null || true)"
  [[ -n "$path" && -f "$path" ]] || return 0

  if command -v jq >/dev/null 2>&1; then
    local primary detected
    primary="$(jq -r '[.stacks.primary[]?] | join(",")' "$path" 2>/dev/null || true)"
    detected="$(jq -r '[.stacks.detected[]?] | join(",")' "$path" 2>/dev/null || true)"
    if [[ -z "$primary" && -z "$detected" ]]; then
      return 0
    fi
    echo "Project profile: primary=${primary:-?} · detected=${detected:-?} · SSOT=.cursorGrowth/project-profile.json"
    return 0
  fi

  py="$(sc_python 2>/dev/null || true)"
  [[ -n "$py" ]] || return 0
  "$py" - "$path" <<'PY'
import json, sys
path = sys.argv[1]
try:
    d = json.load(open(path, encoding="utf-8"))
except (OSError, json.JSONDecodeError):
    sys.exit(0)
st = d.get("stacks") or {}
primary = ",".join(st.get("primary") or [])
detected = ",".join(st.get("detected") or [])
if not primary and not detected:
    sys.exit(0)
print(f"Project profile: primary={primary or '?'} · detected={detected or '?'} · SSOT=.cursorGrowth/project-profile.json")
PY
}

# Default verify tiers when adapt creates a new profile
sc_project_profile_default_verify_tiers() {
  echo "l0 l1 l2-core"
}
