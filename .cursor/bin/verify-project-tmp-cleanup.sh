#!/usr/bin/env bash
# 项目 /tmp 契约清理 — 负向/正向 fixture
set -euo pipefail

CUR="$(cd "$(dirname "$0")/.." && pwd)"
ROOT="$(cd "$CUR/.." && pwd)"
# shellcheck source=../lib/temp-cleanup.sh
source "$CUR/lib/temp-cleanup.sh"
sc_temp_trap_cleanup

PY="$(command -v python3 || command -v python)"
[[ -n "$PY" ]] || { echo "FAIL: python required"; exit 1; }

sc_mktemp_dir sc-verify-ptc
FIX="$SC_MKTEMP_LAST"
CFG="$FIX/temp-cleanup.json"
TMP_ROOT="${TMPDIR:-/tmp}"
PREFIX="${TMP_ROOT%/}/sc-verify-ptc-$$"
mkdir -p "$PREFIX-ephemeral" "$PREFIX-persist"
echo old > "$PREFIX-ephemeral/data"
echo keep > "$PREFIX-persist/data"

cat > "$CFG" <<EOF
{
  "version": 1,
  "enabled": true,
  "rules": [
    {
      "id": "ephemeral",
      "glob": "${PREFIX}-ephemeral",
      "tier": "ephemeral",
      "after": ["test"]
    },
    {
      "id": "persist",
      "glob": "${PREFIX}-persist",
      "tier": "persistent",
      "max_age_hours": 9999,
      "after": ["sweep"]
    }
  ]
}
EOF

"$PY" "$CUR/lib/project-tmp-cleanup.py" --config "$CFG" --phase test --root "$ROOT"
[[ ! -d "${PREFIX}-ephemeral" ]] || { echo "FAIL: ephemeral not removed"; exit 1; }
[[ -d "${PREFIX}-persist" ]] || { echo "FAIL: persistent removed too early"; exit 1; }

"$PY" "$CUR/lib/project-tmp-cleanup.py" --config "$CFG" --phase sweep --root "$ROOT"
[[ -d "${PREFIX}-persist" ]] || { echo "FAIL: persistent removed by sweep (young file)"; exit 1; }

# 非法 glob 不得删除 /etc
BAD="$FIX/bad.json"
echo '{"enabled":true,"rules":[{"id":"x","glob":"/etc/passwd*","tier":"ephemeral","after":["test"]}]}' > "$BAD"
out="$("$PY" "$CUR/lib/project-tmp-cleanup.py" --config "$BAD" --phase test --root "$ROOT" 2>&1)" || true
echo "$out" | grep -q 'SKIP rule' || { echo "FAIL: unsafe glob must SKIP: $out"; exit 1; }
[[ -f /etc/passwd ]] || { echo "FAIL: /etc/passwd missing"; exit 1; }

rm -rf "$PREFIX-persist"
echo "OK verify-project-tmp-cleanup"
