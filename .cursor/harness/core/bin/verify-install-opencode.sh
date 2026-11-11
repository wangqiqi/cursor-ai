#!/usr/bin/env bash
# Smoke: install OpenCode adaptor (generate AGENTS.md + opencode.json in temp dir).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CURSOR_DIR="$ROOT/.cursor"
# shellcheck source=../lib/temp-cleanup.sh
source "$CURSOR_DIR/lib/temp-cleanup.sh"
sc_temp_trap_cleanup
INSTALL_OC="$CURSOR_DIR/bin/install-adaptor-opencode.sh"
[[ -f "$INSTALL_OC" ]] || INSTALL_OC="$CURSOR_DIR/harness/core/bin/install-adaptor-opencode.sh"

sc_mktemp_dir sc-verify-install-opencode
TMP="$SC_MKTEMP_LAST"

if ! bash "$INSTALL_OC" "$TMP" >/dev/null 2>&1; then
  echo "FAIL: install-adaptor-opencode exited non-zero" >&2
  exit 1
fi

[[ -f "$TMP/AGENTS.md" ]] || { echo "FAIL: missing AGENTS.md" >&2; exit 1; }
[[ -f "$TMP/opencode.json" ]] || { echo "FAIL: missing opencode.json" >&2; exit 1; }

# opencode.json 必须含 instructions 数组且引用 .cursor/rules
grep -q '"instructions"' "$TMP/opencode.json" || { echo "FAIL: opencode.json missing instructions" >&2; exit 1; }
grep -q '\.cursor/rules' "$TMP/opencode.json" || { echo "FAIL: opencode.json must reference .cursor/rules" >&2; exit 1; }

# 不应再生成 .opencode/ 目录（官方无此约定）
[[ ! -d "$TMP/.opencode" ]] || { echo "FAIL: must NOT create .opencode/ dir (not an official convention)" >&2; exit 1; }

# JSON 有效性（有 python/jq 时校验）
if command -v python3 >/dev/null 2>&1; then
  python3 -c "import json;json.load(open('$TMP/opencode.json'))" || { echo "FAIL: invalid opencode.json" >&2; exit 1; }
elif command -v jq >/dev/null 2>&1; then
  jq empty "$TMP/opencode.json" || { echo "FAIL: invalid opencode.json" >&2; exit 1; }
fi

echo "OK: verify-install-opencode (AGENTS.md + opencode.json)"
