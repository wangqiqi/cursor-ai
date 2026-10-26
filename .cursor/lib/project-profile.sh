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
