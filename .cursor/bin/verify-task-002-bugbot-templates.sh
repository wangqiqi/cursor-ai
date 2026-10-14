#!/usr/bin/env bash
# TASK-002 SPRINT-CURSOR-ALIGN: Bugbot optional templates + install doc paths.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TPL="$ROOT/.cursor/templates/cursorGrowth"
for f in BUGBOT.md config/bugbot.yaml.example; do
  if [[ ! -f "$TPL/$f" ]]; then
    echo "FAIL: missing $TPL/$f" >&2
    exit 1
  fi
done
if ! grep -q "version: 1" "$TPL/config/bugbot.yaml.example"; then
  echo "FAIL: bugbot.yaml.example missing version: 1" >&2
  exit 1
fi
README="$TPL/README.md"
for needle in ".cursor/BUGBOT.md" ".cursor/config/bugbot.yaml" "review"; do
  if ! grep -q "$needle" "$README"; then
    echo "FAIL: README missing '$needle'" >&2
    exit 1
  fi
done
if ! grep -q "review" "$TPL/BUGBOT.md"; then
  echo "FAIL: BUGBOT.md missing review skill split" >&2
  exit 1
fi
echo "OK: bugbot templates"
echo "OK: README copy paths"
