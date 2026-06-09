#!/usr/bin/env bash
# Bootstrap .cursorGrowth from template — see config growth.enabled
set -euo pipefail

INPUT=$(cat)

HOOKS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CURSOR_DIR="$(cd "$HOOKS_DIR/.." && pwd)"
# shellcheck source=lib/config-load.sh
source "$HOOKS_DIR/lib/config-load.sh"
# shellcheck source=lib/json-utils.sh
source "$HOOKS_DIR/lib/json-utils.sh"

jw_resolve_project_root "$HOOKS_DIR"
jw_init_config "$CURSOR_DIR"

if [[ "$JW_GROWTH_ENABLED" != "true" ]]; then
  echo "$INPUT"
  exit 0
fi

PROJECT_ROOT="$(json_workspace_root "$INPUT")"
if [[ -z "$PROJECT_ROOT" ]]; then
  PROJECT_ROOT="$JW_PROJECT_ROOT"
fi

if [[ "$PROJECT_ROOT" == *"/.cursor" || "$(basename "$PROJECT_ROOT")" == ".cursor" ]]; then
  PROJECT_ROOT="$(cd "$PROJECT_ROOT/.." && pwd)"
fi

GROWTH_DIR="$PROJECT_ROOT/.cursorGrowth"
TEMPLATE_DIR="$CURSOR_DIR/templates/cursorGrowth"

if [[ ! -d "$GROWTH_DIR" ]]; then
  mkdir -p "$GROWTH_DIR"
  if [[ -d "$TEMPLATE_DIR" ]]; then
    jw_copy_tree "$TEMPLATE_DIR" "$GROWTH_DIR"
  else
    mkdir -p "$GROWTH_DIR/learn" "$GROWTH_DIR/logs" "$GROWTH_DIR/perception"
  fi
fi

# Ensure learn/ exists even if growth dir predates template
mkdir -p "$GROWTH_DIR/learn" "$GROWTH_DIR/logs" "$GROWTH_DIR/perception"
if [[ ! -f "$GROWTH_DIR/README.md" && -f "$TEMPLATE_DIR/README.md" ]]; then
  cp "$TEMPLATE_DIR/README.md" "$GROWTH_DIR/README.md"
fi

echo "$INPUT"
