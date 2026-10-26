#!/usr/bin/env bash
# Assemble .cursor/harness/core + .cursor/adaptors/cursor → flat .cursor/ runtime tree.
set -euo pipefail

HARNESS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_ROOT="$(cd "$HARNESS_DIR/.." && pwd)"
DEST="${1:-$CURSOR_ROOT}"
CORE="$HARNESS_DIR/core"
ADAPTOR="$CURSOR_ROOT/adaptors/cursor"

if [[ ! -d "$CORE" ]]; then
  echo "错误: 缺少 $CORE（先完成 harness 分区搬迁）" >&2
  exit 1
fi

# shellcheck source=core/lib/platform.sh
source "$CORE/lib/platform.sh"

mkdir -p "$DEST"
sc_copy_tree "$CORE" "$DEST" "hooks/state/*"
if [[ -d "$ADAPTOR" ]]; then
  sc_copy_tree "$ADAPTOR" "$DEST" "hooks/state/*"
fi
sc_chmod_scripts "$DEST"
echo "OK: assembled harness → $DEST"
