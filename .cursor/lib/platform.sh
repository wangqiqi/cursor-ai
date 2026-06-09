#!/usr/bin/env bash
# Cross-platform helpers — Linux · macOS · Git Bash (Windows)
# Source from hooks/, bin/, or install-super-cursor.sh at repo root.
[[ -n "${JW_PLATFORM_LOADED:-}" ]] && return 0
JW_PLATFORM_LOADED=1
set -euo pipefail

# Resolve python3 or python (Git Bash / Windows may only expose `python`)
jw_python() {
  if [[ -n "${JW_PYTHON_CMD:-}" ]]; then
    echo "$JW_PYTHON_CMD"
    return 0
  fi
  local c
  for c in python3 python; do
    if command -v "$c" >/dev/null 2>&1; then
      JW_PYTHON_CMD="$c"
      echo "$JW_PYTHON_CMD"
      return 0
    fi
  done
  return 1
}

# true when jq or python is available for JSON CLI
jw_has_json_tool() {
  command -v jq >/dev/null 2>&1 && return 0
  jw_python >/dev/null 2>&1
}

# Dotted config path → jq filter (plan_file → .plan_file)
jw_jq_path() {
  local dotted="${1#.}"
  echo ".${dotted}"
}

# ISO-8601 timestamp (BSD date on macOS lacks GNU -Iseconds flag)
jw_iso8601_now() {
  date +"%Y-%m-%dT%H:%M:%S%z" 2>/dev/null || date
}

# Read a dotted path from a JSON file (jq or python)
jw_json_cfg() {
  local file="$1" dotted="$2" default="${3:-}"
  local val="" jqpath py

  [[ -f "$file" ]] || { echo "$default"; return 0; }

  if command -v jq >/dev/null 2>&1; then
    jqpath="$(jw_jq_path "$dotted")"
    val="$(jq -r "${jqpath} // empty" "$file" 2>/dev/null || true)"
  elif py="$(jw_python)"; then
    val="$("$py" - "$file" "$dotted" <<'PY' 2>/dev/null || true
import json, sys
path, dotted = sys.argv[1], sys.argv[2].lstrip(".")
data = json.load(open(path))
cur = data
for part in dotted.split("."):
    if part not in cur:
        sys.exit(1)
    cur = cur[part]
if cur in ("", None):
    sys.exit(1)
if isinstance(cur, bool):
    print("true" if cur else "false")
elif isinstance(cur, (dict, list)):
    print(json.dumps(cur, ensure_ascii=False))
else:
    print(cur)
PY
)"
  fi

  [[ -n "$val" && "$val" != "null" ]] && echo "$val" || echo "$default"
}

# Join JSON array at dotted path with spaces (jq or python)
jw_json_cfg_join() {
  local file="$1" dotted="$2" default="${3:-}"
  local joined="" jqpath py

  [[ -f "$file" ]] || { echo "$default"; return 0; }

  if command -v jq >/dev/null 2>&1; then
    jqpath="$(jw_jq_path "$dotted")"
    joined="$(jq -r "${jqpath} // [] | join(\" \")" "$file" 2>/dev/null || true)"
  elif py="$(jw_python)"; then
    joined="$("$py" - "$file" "$dotted" <<'PY' 2>/dev/null || true
import json, sys
path, dotted = sys.argv[1], sys.argv[2].lstrip(".")
data = json.load(open(path))
cur = data
for part in dotted.split("."):
    cur = cur[part]
if not isinstance(cur, list):
    sys.exit(1)
print(" ".join(str(x) for x in cur))
PY
)"
  fi

  [[ -n "$joined" && "$joined" != "null" ]] && echo "$joined" || echo "$default"
}

# Deep-merge two JSON files to stdout (profile install)
jw_json_merge_files() {
  local base="$1" overlay="$2" py
  if command -v jq >/dev/null 2>&1; then
    jq -s '.[0] * .[1]' "$base" "$overlay"
    return 0
  fi
  if py="$(jw_python)"; then
    "$py" - "$base" "$overlay" <<'PY'
import json, sys

def deep_merge(a, b):
    for k, v in b.items():
        if k in a and isinstance(a[k], dict) and isinstance(v, dict):
            deep_merge(a[k], v)
        else:
            a[k] = v
    return a

base = json.load(open(sys.argv[1]))
overlay = json.load(open(sys.argv[2]))
print(json.dumps(deep_merge(base, overlay), indent=2, ensure_ascii=False))
PY
    return 0
  fi
  echo "FAIL: jq or python required for JSON merge" >&2
  return 1
}

# Copy directory tree; prefers rsync, falls back to cp -a (Git Bash / minimal macOS)
# Usage: jw_copy_tree <src_dir> <dest_dir> [exclude_glob ...]
jw_copy_tree() {
  local src="$1" dest="$2"
  shift 2
  local excludes=("$@")

  mkdir -p "$dest"

  if command -v rsync >/dev/null 2>&1; then
    local -a args=(-a)
    local ex
    for ex in "${excludes[@]}"; do
      args+=(--exclude "$ex")
    done
    rsync "${args[@]}" "${src}/" "${dest}/"
    return 0
  fi

  cp -a "${src}/." "${dest}/"
  local ex
  for ex in "${excludes[@]}"; do
    case "$ex" in
      hooks/state/*)
        rm -rf "${dest}/hooks/state/"* 2>/dev/null || true
        mkdir -p "${dest}/hooks/state"
        ;;
      *)
        rm -rf "${dest}/${ex}" 2>/dev/null || true
        ;;
    esac
  done
}

# chmod +x for shipped scripts (install)
jw_chmod_scripts() {
  local cursor_dir="$1"
  chmod +x "${cursor_dir}/bin/"*.sh 2>/dev/null || true
  find "${cursor_dir}/templates/scaffold" -name '*.sh' -exec chmod +x {} + 2>/dev/null || true
  chmod +x "${cursor_dir}/hooks/"*.sh 2>/dev/null || true
  [[ -f "${cursor_dir}/templates/scaffold/java-gradle/gradlew" ]] \
    && chmod +x "${cursor_dir}/templates/scaffold/java-gradle/gradlew" || true
}

# Tab-separated rows → aligned columns (column(1) optional)
jw_print_columns() {
  if command -v column >/dev/null 2>&1; then
    column -t -s $'\t'
  else
    awk -F'\t' '{ printf "%-18s %-10s %s\n", $1, $2, $3 }'
  fi
}

# Node stack hint from package.json (nextjs / react / vue / nodejs)
jw_detect_node_stack() {
  local pkg="$1"
  [[ -f "$pkg" ]] || return 1

  if command -v jq >/dev/null 2>&1; then
    if jq -e '.dependencies.next != null' "$pkg" >/dev/null 2>&1; then
      echo "nextjs"
    elif jq -e '(.dependencies.react // .devDependencies.react) != null' "$pkg" >/dev/null 2>&1; then
      echo "react"
    elif jq -e '.dependencies.vue != null' "$pkg" >/dev/null 2>&1; then
      echo "vue"
    else
      echo "nodejs"
    fi
    return 0
  fi

  local py
  py="$(jw_python)" || { echo "nodejs"; return 0; }
  "$py" - "$pkg" <<'PY'
import json, sys
p = json.load(open(sys.argv[1]))
deps = {**(p.get("dependencies") or {}), **(p.get("devDependencies") or {})}
if "next" in deps:
    print("nextjs")
elif "react" in deps:
    print("react")
elif "vue" in deps:
    print("vue")
else:
    print("nodejs")
PY
}

# --- manifest.json helpers (scaffold CLI) ---

_manifest_py() {
  local manifest="$1" py
  shift
  py="$(jw_python)" || return 1
  "$py" - "$manifest" "$@" <<'PY'
import json, sys

path = sys.argv[1]
cmd = sys.argv[2]
data = json.load(open(path))
scaffolds = data.get("scaffolds", [])

def by_id(sid):
    for s in scaffolds:
        if s.get("id") == sid:
            return s
    return None

if cmd == "list":
    for s in scaffolds:
        print(f"{s['id']}\t{s.get('category', '')}\t{s.get('name', '')}")
elif cmd == "exists":
    sys.exit(0 if by_id(sys.argv[3]) else 1)
elif cmd == "info":
    s = by_id(sys.argv[3])
    if not s:
        sys.exit(1)
    print(f"name: {s.get('name', '')}")
    print(f"description: {s.get('description', '')}")
    print(f"verify: {s.get('verify', '')}")
    print("post_apply:")
    for p in s.get("post_apply") or []:
        print(f"  - {p}")
elif cmd == "field":
    s = by_id(sys.argv[3])
    if not s:
        sys.exit(1)
    print(s.get(sys.argv[4], ""))
elif cmd == "post_apply":
    s = by_id(sys.argv[3])
    if not s:
        sys.exit(1)
    for p in s.get("post_apply") or []:
        print(p)
elif cmd == "ids":
    for s in scaffolds:
        print(s["id"])
PY
}

jw_require_json_tool() {
  if jw_has_json_tool; then
    return 0
  fi
  echo "FAIL: jq or python required" >&2
  return 1
}

jw_manifest_list() {
  local manifest="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -r '.scaffolds[] | "\(.id)\t\(.category)\t\(.name)"' "$manifest"
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    _manifest_py "$manifest" list
  else
    jw_require_json_tool
    return 1
  fi
}

jw_manifest_scaffold_exists() {
  local manifest="$1" id="$2"
  if command -v jq >/dev/null 2>&1; then
    jq -e --arg id "$id" '.scaffolds[] | select(.id == $id)' "$manifest" >/dev/null 2>&1
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    _manifest_py "$manifest" exists "$id"
  else
    return 1
  fi
}

jw_manifest_scaffold_info() {
  local manifest="$1" id="$2"
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg id "$id" '
      .scaffolds[] | select(.id == $id) |
      "name: \(.name)",
      "description: \(.description)",
      "verify: \(.verify)",
      "post_apply:",
      (.post_apply[]? | "  - \(.)")
    ' "$manifest"
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    _manifest_py "$manifest" info "$id"
  else
    jw_require_json_tool
    return 1
  fi
}

jw_manifest_scaffold_field() {
  local manifest="$1" id="$2" field="$3"
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg id "$id" --arg f "$field" '.scaffolds[] | select(.id == $id) | .[$f]' "$manifest"
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    _manifest_py "$manifest" field "$id" "$field"
  else
    jw_require_json_tool
    return 1
  fi
}

jw_manifest_scaffold_post_apply() {
  local manifest="$1" id="$2"
  if command -v jq >/dev/null 2>&1; then
    jq -r --arg id "$id" '.scaffolds[] | select(.id == $id) | .post_apply[]' "$manifest"
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    _manifest_py "$manifest" post_apply "$id"
  else
    jw_require_json_tool
    return 1
  fi
}

jw_manifest_ids() {
  local manifest="$1"
  if command -v jq >/dev/null 2>&1; then
    jq -r '.scaffolds[].id' "$manifest"
  elif command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1; then
    _manifest_py "$manifest" ids
  else
    jw_require_json_tool
    return 1
  fi
}
