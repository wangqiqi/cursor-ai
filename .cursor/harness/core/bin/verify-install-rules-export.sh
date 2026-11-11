#!/usr/bin/env bash
# Smoke: kiro + trae core_rules_export installs.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
CURSOR_DIR="$ROOT/.cursor"
# shellcheck source=../lib/temp-cleanup.sh
source "$CURSOR_DIR/lib/temp-cleanup.sh"
sc_temp_trap_cleanup
INSTALL="$CURSOR_DIR/bin/install-adaptor-rules-export.sh"
[[ -f "$INSTALL" ]] || INSTALL="$CURSOR_DIR/harness/core/bin/install-adaptor-rules-export.sh"

sc_mktemp_dir sc-verify-rules-export
TMP="$SC_MKTEMP_LAST"

# kiro → steering/ · trae → rules/
for id in kiro trae; do
  if ! bash "$INSTALL" --adaptor "$id" "$TMP" >/dev/null 2>&1; then
    echo "FAIL: install-adaptor-rules-export --adaptor $id" >&2
    exit 1
  fi
  dir=".$id"
  subdir="rules"
  [[ "$id" == "kiro" ]] && subdir="steering"
  for f in "$dir/$subdir/core.md" "$dir/RULES.md" "$dir/README.md"; do
    [[ -f "$TMP/$f" ]] || { echo "FAIL: missing $TMP/$f" >&2; exit 1; }
  done
  [[ ! -d "$TMP/$dir/skills" ]] || { echo "FAIL: $dir must not contain skills/" >&2; exit 1; }
  grep -q 'core.md' "$TMP/$dir/RULES.md" || {
    echo "FAIL: $dir/RULES.md missing core.md entry" >&2
    exit 1
  }
  # 不应残留 .mdc（已重命名 .md）
  if find "$TMP/$dir" -name '*.mdc' | grep -q .; then
    echo "FAIL: $dir still contains .mdc files" >&2
    exit 1
  fi
done

echo "OK: verify-install-rules-export (kiro=steering · trae=rules · .md)"
