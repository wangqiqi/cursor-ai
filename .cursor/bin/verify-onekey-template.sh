#!/usr/bin/env bash
# Mother template: .cursor/templates/project-onekey/onekey_start.sh
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CUR="$ROOT/.cursor"
tpl="$CUR/templates/project-onekey/onekey_start.sh"

[[ -f "$tpl" ]] || { echo "FAIL: missing $tpl" >&2; exit 1; }
bash -n "$tpl" || { echo "FAIL: bash -n onekey template" >&2; exit 1; }

for needle in \
  "scripts/test.sh" \
  "scripts/verify.sh" \
  "onekey_start.sh" \
  "set -euo pipefail"; do
  grep -qF "$needle" "$tpl" || { echo "FAIL: template missing '$needle'" >&2; exit 1; }
done

# 模板须可执行（install 复制后 chmod +x；母版文件本身也应 +x）
if [[ ! -x "$tpl" ]]; then
  chmod +x "$tpl"
fi
[[ -x "$tpl" ]] || { echo "FAIL: template not executable" >&2; exit 1; }

echo "OK: project-onekey template $tpl"
