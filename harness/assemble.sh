#!/usr/bin/env bash
# Assemble harness/core + adaptors/cursor → destination .cursor tree (default: repo root .cursor/)
set -euo pipefail

HARNESS="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT="$(cd "$HARNESS/.." && pwd)"
DEST="${1:-$ROOT/.cursor}"
CORE="$HARNESS/core"
ADAPTOR="$ROOT/adaptors/cursor"

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
