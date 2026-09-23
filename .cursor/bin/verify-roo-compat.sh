#!/usr/bin/env bash
# 协议字段白名单 —— 「协议无关 / Roo 兼容」的可验证版本
#
# README 承诺 `.cursor/` 整体复制到 `.roo/` 也能被加载。该承诺的可验证部分是：
# 母版**只使用开放协议字段**，不引入任何单一编辑器的私有键 —— 否则复制过去会被静默忽略。
#
# 本脚本按文件类型断言 frontmatter 键集 ⊆ 白名单，并检查 `.mdc`/`.md` 扩展名约定。
set -euo pipefail

CUR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=../lib/verify-common.sh
source "$CUR/lib/verify-common.sh" "verify-roo-compat"

echo "=== verify-roo-compat（协议字段白名单）==="

vc_py "$CUR" <<'PY'
import re
import sys
from pathlib import Path

cur = Path(sys.argv[1])
fails = []

# 各协议面允许的 frontmatter 键（只列开放协议字段；不含编辑器私有键）
ALLOW = {
    "rule": {"description", "globs", "alwaysApply"},
    "skill": {"name", "description", "disable-model-invocation", "paths", "icon", "color"},
    "agent": {"name", "description", "model", "readonly", "is_background"},
    "command": {"description"},
}


def frontmatter_keys(path):
    text = path.read_text(encoding="utf-8", errors="replace")
    if not text.startswith("---\n"):
        return None
    end = text.find("\n---", 4)
    if end < 0:
        return None
    keys = set()
    for raw in text[4:end].splitlines():
        m = re.match(r"^([A-Za-z_][A-Za-z0-9_-]*):", raw)
        if m:
            keys.add(m.group(1))
    return keys


def check(kind, path, rel):
    keys = frontmatter_keys(path)
    if keys is None:
        fails.append(f"{rel}: missing frontmatter (kind={kind})")
        return
    extra = keys - ALLOW[kind]
    if extra:
        fails.append(f"{rel}: editor-private frontmatter key(s) {sorted(extra)} — not portable")


for p in sorted((cur / "rules").rglob("*.mdc")):
    check("rule", p, str(p.relative_to(cur)))
for p in sorted((cur / "skills").glob("*/SKILL.md")):
    check("skill", p, str(p.relative_to(cur)))
for p in sorted((cur / "agents").glob("*.md")):
    check("agent", p, str(p.relative_to(cur)))
for p in sorted((cur / "commands").glob("*.md")):
    check("command", p, str(p.relative_to(cur)))

# rules 必须是 .mdc（Cursor/协议约定）；.cursor/rules 里的 .md 会被忽略
for p in sorted((cur / "rules").rglob("*.md")):
    if p.suffix == ".md":
        fails.append(f"{p.relative_to(cur)}: rules must use .mdc (plain .md is ignored)")

if fails:
    for f in fails:
        print("FAIL protocol:", f)
    sys.exit(1)
print("OK  protocol field whitelist clean (rules .mdc · skills · agents · commands)")
PY

vc_summary "verify-roo-compat passed."
