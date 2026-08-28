#!/usr/bin/env bash
# Doc-coherence checks for Super Cursor mother repo (aggregated by verify-super-cursor.sh).
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CUR="$ROOT/.cursor"
FAIL=0

fail() { echo "FAIL $*"; FAIL=$((FAIL+1)); }
ok() { echo "OK  $*"; }

echo "=== verify-doc-super-cursor ==="

# --- README skills count vs disk ---
disk_skills="$(find "$CUR/skills" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
readme_line="$(grep -E 'skills/.*[0-9]+ 个' "$ROOT/README.md" 2>/dev/null | head -1 || true)"
if [[ -z "$readme_line" ]]; then
  fail "README.md missing skills count line (N 个)"
else
  readme_skills="$(echo "$readme_line" | grep -oE '[0-9]+ 个' | head -1 | grep -oE '[0-9]+' || true)"
  if [[ "$readme_skills" == "$disk_skills" ]]; then
    ok "README skills count=$disk_skills matches disk"
  else
    fail "README skills count=$readme_skills disk=$disk_skills"
  fi
fi

# --- migration-catalog skills/rules counts (optional line) ---
mc="$CUR/docs/migration-catalog.md"
if [[ -f "$mc" ]]; then
  disk_rules="$(find "$CUR/rules" -name '*.mdc' | wc -l | tr -d ' ')"
  if grep -qE "${disk_skills} skills" "$mc" && grep -qE "${disk_rules} rules" "$mc"; then
    ok "migration-catalog counts skills=$disk_skills rules=$disk_rules"
  else
    fail "migration-catalog counts mismatch (expect ${disk_skills} skills · ${disk_rules} rules)"
  fi
else
  fail "missing $mc"
fi

# --- doc-hygiene rule registered ---
check_rule() {
  [[ -f "$1" ]] && ok "exists $1" || fail "missing $1"
}
check_rule "$CUR/rules/execution/doc-hygiene.mdc"

# --- relative markdown links under .cursor/docs ---
py="$(command -v python3 2>/dev/null || command -v python 2>/dev/null || true)"
if [[ -z "$py" ]]; then
  fail "python required for doc link check"
else
  if "$py" - "$CUR/docs" <<'PY'
import re, sys
from pathlib import Path

docs_root = Path(sys.argv[1])
link_re = re.compile(r'\]\(([^)]+)\)')
skip_prefix = ("http://", "https://", "mailto:", "#")
broken = []

for md in sorted(docs_root.rglob("*.md")):
    text = md.read_text(encoding="utf-8", errors="replace")
    for raw in link_re.findall(text):
        target = raw.split()[0].strip()
        if not target or target.startswith(skip_prefix):
            continue
        # strip anchor
        path_part = target.split("#", 1)[0]
        if not path_part:
            continue
        resolved = (md.parent / path_part).resolve()
        if not resolved.exists():
            broken.append(f"{md.relative_to(docs_root)} -> {target}")

if broken:
    for b in broken[:20]:
        print("FAIL broken link:", b)
    if len(broken) > 20:
        print("FAIL ... and", len(broken) - 20, "more")
    sys.exit(1)
print("OK  relative links in .cursor/docs (%d files)" % len(list(docs_root.rglob('*.md'))))
sys.exit(0)
PY
  then
    :
  else
    FAIL=$((FAIL+1))
  fi
fi

echo "---"
[[ "$FAIL" -eq 0 ]] && echo "verify-doc-super-cursor passed." && exit 0
echo "$FAIL check(s) failed." && exit 1
