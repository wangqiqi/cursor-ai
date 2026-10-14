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
# shellcheck source=../lib/onekey-bootstrap.sh
source "$HOOKS_DIR/../lib/onekey-bootstrap.sh"

sc_resolve_project_root "$HOOKS_DIR"
sc_init_config "$CURSOR_DIR"

if [[ "$SC_GROWTH_ENABLED" != "true" ]]; then
  echo "$INPUT"
  exit 0
fi

PROJECT_ROOT="$(json_workspace_root "$INPUT")"
if [[ -z "$PROJECT_ROOT" ]]; then
  PROJECT_ROOT="$SC_PROJECT_ROOT"
fi

if [[ "$PROJECT_ROOT" == *"/.cursor" || "$(basename "$PROJECT_ROOT")" == ".cursor" ]]; then
  PROJECT_ROOT="$(cd "$PROJECT_ROOT/.." && pwd)"
fi

GROWTH_DIR="$PROJECT_ROOT/.cursorGrowth"
# 插件轨不含 templates/ → 回退到已安装项目的母版模板（否则 Growth 只是空目录）
TEMPLATE_DIR="${SC_CURSOR_DIR:-$CURSOR_DIR}/templates/cursorGrowth"

if [[ ! -d "$GROWTH_DIR" ]]; then
  mkdir -p "$GROWTH_DIR"
  if [[ -d "$TEMPLATE_DIR" ]]; then
    sc_copy_tree "$TEMPLATE_DIR" "$GROWTH_DIR"
  else
    mkdir -p "$GROWTH_DIR/learn" "$GROWTH_DIR/archive" "$GROWTH_DIR/rules/local" \
      "$GROWTH_DIR/logs" "$GROWTH_DIR/perception" "$GROWTH_DIR/session"
  fi
fi

mkdir -p "$GROWTH_DIR/learn" "$GROWTH_DIR/archive" "$GROWTH_DIR/rules/local" \
  "$GROWTH_DIR/logs" "$GROWTH_DIR/perception" "$GROWTH_DIR/session"

if [[ ! -f "$GROWTH_DIR/README.md" && -f "$TEMPLATE_DIR/README.md" ]]; then
  cp "$TEMPLATE_DIR/README.md" "$GROWTH_DIR/README.md"
fi

# Seed learn/*.md from template (idempotent — never overwrite existing)
if [[ -d "$TEMPLATE_DIR/learn" ]]; then
  for stub in "$TEMPLATE_DIR/learn"/*.md; do
    [[ -f "$stub" ]] || continue
    dest="$GROWTH_DIR/learn/$(basename "$stub")"
    if [[ ! -f "$dest" ]]; then
      cp "$stub" "$dest"
    fi
  done
fi

# Seed session/persona.json + aliases.json (idempotent)
if [[ -f "$TEMPLATE_DIR/session/persona.json" && ! -f "$GROWTH_DIR/session/persona.json" ]]; then
  mkdir -p "$GROWTH_DIR/session"
  cp "$TEMPLATE_DIR/session/persona.json" "$GROWTH_DIR/session/persona.json"
fi
if [[ -f "$TEMPLATE_DIR/session/aliases.json" && ! -f "$GROWTH_DIR/session/aliases.json" ]]; then
  mkdir -p "$GROWTH_DIR/session"
  cp "$TEMPLATE_DIR/session/aliases.json" "$GROWTH_DIR/session/aliases.json"
fi

if [[ -f "$TEMPLATE_DIR/rules/local/README.md" && ! -f "$GROWTH_DIR/rules/local/README.md" ]]; then
  cp "$TEMPLATE_DIR/rules/local/README.md" "$GROWTH_DIR/rules/local/README.md"
fi

# Legacy migration: root plan.md / archive/
if [[ -f "$PROJECT_ROOT/plan.md" && ! -f "$GROWTH_DIR/plan.md" ]]; then
  mv "$PROJECT_ROOT/plan.md" "$GROWTH_DIR/plan.md"
fi
if [[ -d "$PROJECT_ROOT/archive" && ! -d "$GROWTH_DIR/archive" ]] || \
   { [[ -d "$PROJECT_ROOT/archive" ]] && [[ -z "$(ls -A "$GROWTH_DIR/archive" 2>/dev/null || true)" ]]; }; then
  if [[ -d "$PROJECT_ROOT/archive" ]] && [[ "$(ls -A "$PROJECT_ROOT/archive" 2>/dev/null || true)" != "" ]]; then
    mkdir -p "$GROWTH_DIR/archive"
    mv "$PROJECT_ROOT/archive"/* "$GROWTH_DIR/archive/" 2>/dev/null || true
    rmdir "$PROJECT_ROOT/archive" 2>/dev/null || true
  fi
fi

# Symlink rules/local for Cursor globs
CURSOR_LOCAL="$PROJECT_ROOT/.cursor/rules/local"
if [[ -d "$GROWTH_DIR/rules/local" && ! -L "$CURSOR_LOCAL" ]]; then
  if [[ ! -e "$CURSOR_LOCAL" ]] || { [[ -d "$CURSOR_LOCAL" ]] && \
    [[ "$(find "$CURSOR_LOCAL" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')" -le 1 ]]; }; then
    rm -rf "$CURSOR_LOCAL"
    mkdir -p "$(dirname "$CURSOR_LOCAL")"
    # Windows / Git Bash 可能无符号链接权限：失败必须降级为目录副本，不能让 hook 中断（set -e）
    if ! ln -sf "../../.cursorGrowth/rules/local" "$CURSOR_LOCAL" 2>/dev/null; then
      mkdir -p "$CURSOR_LOCAL"
      cp "$GROWTH_DIR/rules/local/README.md" "$CURSOR_LOCAL/README.md" 2>/dev/null \
        || cp "$TEMPLATE_DIR/rules/local/README.md" "$CURSOR_LOCAL/README.md" 2>/dev/null \
        || true
    fi
  fi
fi

sc_bootstrap_onekey_start "$PROJECT_ROOT" "${SC_CURSOR_DIR:-$CURSOR_DIR}" "$SC_ONEKEY_BOOTSTRAP"

echo "$INPUT"
