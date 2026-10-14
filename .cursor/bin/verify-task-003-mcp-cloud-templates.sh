#!/usr/bin/env bash
# TASK-003 SPRINT-CURSOR-ALIGN: MCP + Cloud environment templates and docs.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TPL="$ROOT/.cursor/templates/cursorGrowth"
DOC="$ROOT/.cursor/docs/cursor-cloud.md"
for f in mcp.json.example environment.json.example; do
  [[ -f "$TPL/$f" ]] || { echo "FAIL: missing $TPL/$f" >&2; exit 1; }
done
grep -q 'mcpServers' "$TPL/mcp.json.example" || { echo "FAIL: mcp.json.example" >&2; exit 1; }
grep -q '"install"' "$TPL/environment.json.example" || { echo "FAIL: environment.json.example install" >&2; exit 1; }
[[ -f "$DOC" ]] || { echo "FAIL: missing cursor-cloud.md" >&2; exit 1; }
grep -q 'ops-deploy' "$DOC" || { echo "FAIL: cursor-cloud.md missing ops-deploy link" >&2; exit 1; }
grep -q 'cursor-cloud.md' "$ROOT/.cursor/docs/platforms.md" || { echo "FAIL: platforms.md missing link" >&2; exit 1; }
grep -q '.cursor/mcp.json' "$TPL/README.md" || { echo "FAIL: README mcp copy path" >&2; exit 1; }
echo "OK: mcp/cloud templates"
echo "OK: cursor-cloud.md + platforms link"
