#!/usr/bin/env bash
# TASK-001 SPRINT-CURSOR-ALIGN: learn template + migration-catalog 2026 section.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
LEARN_TPL="$ROOT/.cursor/templates/cursorGrowth/learn/cursor-platform.md"
MIG="$ROOT/.cursor/docs/migration-catalog.md"
if [[ ! -f "$LEARN_TPL" ]]; then
  echo "FAIL: missing $LEARN_TPL" >&2
  exit 1
fi
if ! grep -q "disable-model-invocation" "$LEARN_TPL"; then
  echo "FAIL: cursor-platform.md missing skill policy" >&2
  exit 1
fi
if ! grep -q "## 2026 官方面" "$MIG"; then
  echo "FAIL: migration-catalog missing 2026 section" >&2
  exit 1
fi
# Section body: lines after heading until next ## or EOF, max 30 lines
start="$(grep -n "## 2026 官方面" "$MIG" | head -1 | cut -d: -f1)"
next="$(tail -n "+$((start + 1))" "$MIG" | grep -n '^## ' | head -1 | cut -d: -f1 || true)"
if [[ -n "$next" ]]; then
  end=$((start + next - 1))
  lines=$((end - start))
else
  lines="$(tail -n "+$start" "$MIG" | wc -l | tr -d ' ')"
fi
if [[ "$lines" -gt 30 ]]; then
  echo "FAIL: 2026 section has $lines lines (max 30)" >&2
  exit 1
fi
echo "OK: cursor-platform template"
echo "OK: migration-catalog 2026 section ($lines lines)"
