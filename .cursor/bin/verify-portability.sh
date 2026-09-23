#!/usr/bin/env bash
# 可移植性静态门禁 —— 让「支持 Linux · macOS · Git Bash」是可被守护的断言
#
# 检查发布脚本中的：
#   1. GNU-only 构造（BSD/macOS 缺失）：sed -i 无后缀 · find -printf · stat -c ·
#      sort -h · du --max-depth · date -d / -Iseconds · grep -P · xargs -r · tac
#   2. 非 POSIX 正则：grep/sed 模式里的 `\s`
#   3. `readlink -f` 无同层回退
#   4. 硬编码 `python3` 调用（Git Bash 可能只有 `python`）→ 应经 $PYTHON_BIN / sc_python
#   5. shebang 必须 `#!/usr/bin/env bash`
#
# 自检脚本本身把模式当**数据**用，故排除；`lib/platform.sh` 是解析器，允许 `command -v python3`。
set -euo pipefail

CUR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(cd "$CUR/.." && pwd)"
FAIL=0

# shellcheck source=../lib/platform.sh
source "$CUR/lib/platform.sh"

echo "=== verify-portability ==="

PY="$(sc_python 2>/dev/null || true)"
if [[ -z "$PY" ]]; then
  echo "FAIL python required for portability scan"
  FAIL=$((FAIL+1))
else
  if "$PY" - "$ROOT" "$CUR" <<'PY'
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
cur = Path(sys.argv[2])

# 检查器把模式当数据用，排除自身
SELF = {"verify-portability.sh", "verify-super-cursor.sh"}

files = []
files += sorted(p for p in cur.rglob("*.sh") if p.name not in SELF)
installer = root / "install-super-cursor.sh"
if installer.is_file():
    files.append(installer)

GNU_ONLY = [
    (r"(?<![.\w-])sed\b[^|]*\s-i(?![.\w])", "sed -i without backup suffix (BSD needs -i '')"),
    (r"find\b[^|]*-printf\b", "find -printf (GNU only)"),
    (r"stat\s+(-c|--format)\b", "stat -c/--format (GNU only)"),
    (r"sort\b[^|]*\s-h\b", "sort -h (GNU only)"),
    (r"du\b[^|]*--max-depth\b", "du --max-depth (BSD uses -d)"),
    (r"date\s+(-d\s|--date|-Iseconds)", "date -d/--date/-Iseconds (GNU only)"),
    (r"grep\b[^|]*\s-P\b", "grep -P (GNU only)"),
    (r"xargs\b[^|]*\s-r\b", "xargs -r (GNU only)"),
    (r"(?<![.\w-])tac\s", "tac (GNU only)"),
]
NON_POSIX_RE = re.compile(r"(grep\s+(-\w+\s+)*'[^']*\\s|sed\s+(-\w+\s+)*'[^']*\\s)")
READLINK_RE = re.compile(r"readlink\s+-f\b")
PYTHON3_RE = re.compile(r"(^|[|(]\s*|\$\(\s*|\beval\s+\"\$\(\s*)python3\s")

fails = []
for path in files:
    rel = path.relative_to(root)
    text = path.read_text(encoding="utf-8", errors="replace")
    lines = text.splitlines()

    if not lines or not lines[0].startswith("#!/usr/bin/env bash"):
        fails.append(f"{rel}:1 shebang must be '#!/usr/bin/env bash'")

    for i, line in enumerate(lines, 1):
        stripped = line.lstrip()
        if stripped.startswith("#"):
            continue
        # 显式豁免：只用于「本就是平台探测」的行，须在同一行写理由
        if "portability-allow" in line:
            continue
        # 去掉行尾注释里可能出现的示例（保守：只在 '#' 前是空白时截断）
        code = re.split(r"\s#\s", line)[0]

        for pat, why in GNU_ONLY:
            if re.search(pat, code):
                fails.append(f"{rel}:{i} {why} :: {stripped[:80]}")
        if NON_POSIX_RE.search(code):
            fails.append(f"{rel}:{i} non-POSIX \\s in grep/sed pattern")
        if READLINK_RE.search(code) and "||" not in code:
            fails.append(f"{rel}:{i} readlink -f without same-line fallback")
        if PYTHON3_RE.search(code):
            fails.append(f"{rel}:{i} hardcoded python3 call (use $PYTHON_BIN / sc_python)")

# --- 技能平台作用域：文档声明 ⇔ 代码实际 ---
platforms = cur / "docs/platforms.md"
if not platforms.is_file():
    fails.append("docs/platforms.md missing (platform scope undocumented)")
else:
    pt = platforms.read_text(encoding="utf-8", errors="replace")
    m = re.search(r"^## 技能平台作用域\n(.*?)(?=^## )", pt, re.S | re.M)
    section = m.group(1) if m else ""
    if not section:
        fails.append("docs/platforms.md: missing '## 技能平台作用域' section")
    else:
        linux_only = set()
        for sh in (cur / "skills").glob("*/scripts/*.sh"):
            if "require_linux" in sh.read_text(encoding="utf-8", errors="replace"):
                linux_only.add(sh.parent.parent.name)
        for sk in sorted(linux_only):
            if not re.search(r"\*\*" + re.escape(sk) + r"\*\*", section):
                fails.append(
                    f"docs/platforms.md: skill '{sk}' enforces require_linux but is not documented as Linux-only"
                )
        for row in re.finditer(r"^\|\s*\*\*([a-z0-9-]+)\*\*\s*\|([^|]*)\|", section, re.M):
            sk, scope = row.group(1), row.group(2)
            if "仅 Linux" in scope and sk not in linux_only:
                fails.append(
                    f"docs/platforms.md: '{sk}' declared Linux-only but no require_linux in its scripts"
                )

if fails:
    for f in fails:
        print("FAIL portability:", f)
    sys.exit(1)
print(f"OK  portability scan clean ({len(files)} scripts) + platform scope consistent")
PY
  then
    :
  else
    FAIL=$((FAIL+1))
  fi
fi

echo "---"
[[ "$FAIL" -eq 0 ]] && echo "verify-portability passed." && exit 0
echo "$FAIL check(s) failed." && exit 1
