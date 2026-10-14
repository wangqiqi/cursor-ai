#!/usr/bin/env bash
# SPIKE-001 / SPRINT-CURSOR-ALIGN: archive meta spike exists and contains gap matrix markers.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
ARCHIVE_DIR="$ROOT/.cursorGrowth/archive/meta"
shopt -s nullglob
files=("$ARCHIVE_DIR"/*_SPIKE_cursor_official_align.md)
if [[ ${#files[@]} -eq 0 ]]; then
  echo "FAIL: no archive meta/*_SPIKE_cursor_official_align.md" >&2
  exit 1
fi
latest="$(printf '%s\n' "${files[@]}" | sort | tail -1)"
for needle in "In · Doc · Skip" "官方文档锚点" "TASK-004"; do
  if ! grep -q "$needle" "$latest"; then
    echo "FAIL: missing '$needle' in $latest" >&2
    exit 1
  fi
done
LIB="$ROOT/.cursor/docs/library-index.md"
if ! grep -q "Cursor 官方平台" "$LIB"; then
  echo "FAIL: library-index.md missing Cursor 官方平台 section" >&2
  exit 1
fi
echo "OK: spike archive $latest"
echo "OK: library-index Cursor platform section"
