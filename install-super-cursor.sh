#!/usr/bin/env bash
# install-super-cursor.sh — copy universal Super Cursor template to any project
set -euo pipefail

usage() {
  cat <<EOF
用法: $0 [目标项目路径] [选项]

  未指定路径时：从当前目录向上查找 Git 项目根（.git），安装到该根目录。
  也可显式使用 --here（同上）。

环境变量:
  SUPER_CURSOR_HOME   cursor-ai 母版仓库根（含 .cursor/）
  CURSOR_AI_HOME      同上（别名）

  配合 PATH: install-super-cursor · super-cursor-sync（依赖 SUPER_CURSOR_HOME）

选项:
  --setup-shell                    写入 ~/.bashrc / ~/.zshrc（母版目录执行一次）
  --here                           安装到当前目录所属的 Git 项目根
  --profile full|lite|rules-only   工作流配置（默认 full）
  --copy-plan                      复制 templates/plan.md → .cursorGrowth/plan.md
  --replace                        先删除目标 .cursor/ 再拷贝（无残留；推荐升级/迁移）
  -h, --help                       显示帮助

示例:
  $0 --setup-shell                 # 母版目录：只写 shell 环境变量（推荐首次）
  source ~/.bashrc && install-super-cursor --replace   # 任意项目子目录同步
  $0 --replace                     # 在仓库任意子目录执行（需已 setup-shell）
  $0 /path/to/my-app --profile lite --copy-plan
  super-cursor-sync --replace      # 若已将 \$SUPER_CURSOR_HOME/bin 加入 PATH

项目特化与产出 → .cursorGrowth/（plan · archive · learn · rules/local）
EOF
}

resolve_source_root() {
  local script_dir dir candidate
  for candidate in "${SUPER_CURSOR_HOME:-}" "${CURSOR_AI_HOME:-}"; do
    if [[ -n "$candidate" && -d "$candidate/.cursor" ]]; then
      echo "$candidate"
      return 0
    fi
  done
  script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
  if [[ -d "$script_dir/.cursor" ]]; then
    echo "$script_dir"
    return 0
  fi
  echo "错误: 未找到母版 .cursor/；设置 SUPER_CURSOR_HOME 为 cursor-ai 仓库根" >&2
  return 1
}

# 从 start 向上找含 .git 的目录（无 git 命令时的回退）
find_git_root_by_walk() {
  local dir
  dir="$(cd "${1:-$PWD}" && pwd)"
  while [[ "$dir" != "/" ]]; do
    if [[ -d "$dir/.git" ]]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

find_project_root() {
  local start="${1:-$PWD}"
  local root
  if root="$(git -C "$start" rev-parse --show-toplevel 2>/dev/null)"; then
    echo "$root"
    return 0
  fi
  find_git_root_by_walk "$start"
}

SC_SHELL_MARKER_BEGIN="# >>> super-cursor >>>"
SC_SHELL_MARKER_END="# <<< super-cursor <<<"

setup_super_cursor_shell() {
  local mother_root="$1"
  local rc_files=() rc block tmp updated=0

  [[ -f "$HOME/.bashrc" ]] && rc_files+=("$HOME/.bashrc")
  [[ -f "$HOME/.zshrc" ]] && rc_files+=("$HOME/.zshrc")
  if [[ ${#rc_files[@]} -eq 0 ]]; then
    rc_files+=("$HOME/.bashrc")
  fi

  block=$(
    cat <<EOF

$SC_SHELL_MARKER_BEGIN
# Super Cursor 母版 — 任意 Git 项目目录: install-super-cursor --replace
export SUPER_CURSOR_HOME="$mother_root"
export PATH="\$SUPER_CURSOR_HOME/bin:\$PATH"
alias install-super-cursor="\$SUPER_CURSOR_HOME/install-super-cursor.sh"
$SC_SHELL_MARKER_END
EOF
  )

  for rc in "${rc_files[@]}"; do
    if grep -qF "$SC_SHELL_MARKER_BEGIN" "$rc" 2>/dev/null; then
      tmp="$(mktemp)"
      awk -v begin="$SC_SHELL_MARKER_BEGIN" -v end="$SC_SHELL_MARKER_END" '
        BEGIN { skip=0 }
        index($0, begin) { skip=1; next }
        index($0, end) { skip=0; next }
        skip==0 { print }
      ' "$rc" > "$tmp"
      mv "$tmp" "$rc"
      echo "已更新 $rc 中的 super-cursor 块"
    else
      echo "已写入 $rc"
    fi
    printf '%s' "$block" >> "$rc"
    updated=1
  done

  if [[ "$updated" -eq 1 ]]; then
    echo ""
    echo "Shell 环境已配置（SUPER_CURSOR_HOME=$mother_root）"
    echo "  请执行: source ~/.bashrc   # 或 source ~/.zshrc · 重开终端"
    echo "  然后在任意项目目录: install-super-cursor --replace"
  fi
}

SOURCE="$(resolve_source_root)" || exit 1
TARGET=""
PROFILE="full"
COPY_PLAN="false"
REPLACE="false"
USE_HERE="false"
SETUP_SHELL="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --setup-shell)
      SETUP_SHELL="true"
      shift
      ;;
    --here)
      USE_HERE="true"
      shift
      ;;
    --profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    --copy-plan)
      COPY_PLAN="true"
      shift
      ;;
    --replace)
      REPLACE="true"
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "错误: 未知选项 $1" >&2
      usage
      exit 1
      ;;
    *)
      if [[ -z "$TARGET" ]]; then
        TARGET="$1"
      else
        echo "错误: 未知参数 $1" >&2
        usage
        exit 1
      fi
      shift
      ;;
  esac
done

if [[ "$SETUP_SHELL" == "true" ]]; then
  setup_super_cursor_shell "$SOURCE"
  if [[ -z "$TARGET" && "$REPLACE" != "true" && "$COPY_PLAN" != "true" ]]; then
    exit 0
  fi
fi

if [[ -z "$TARGET" ]]; then
  if ! TARGET="$(find_project_root "$PWD")"; then
    echo "错误: 未找到 Git 项目根（从 $(pwd) 向上无 .git）" >&2
    echo "提示: 指定路径，或先 cd 到 Git 仓库内" >&2
    usage
    exit 1
  fi
  echo "检测到 Git 项目根: $TARGET"
elif [[ "$USE_HERE" == "true" ]]; then
  if ! TARGET="$(find_project_root "$PWD")"; then
    echo "错误: --here 但未找到 Git 项目根" >&2
    exit 1
  fi
  echo "检测到 Git 项目根: $TARGET"
fi

case "$PROFILE" in
  full|lite|rules-only) ;;
  *)
    echo "错误: 无效 profile: $PROFILE（可选 full · lite · rules-only）" >&2
    exit 1
    ;;
esac

if [[ ! -d "$SOURCE/.cursor" ]]; then
  echo "错误: 未找到 $SOURCE/.cursor" >&2
  exit 1
fi

# shellcheck source=.cursor/lib/platform.sh
source "$SOURCE/.cursor/lib/platform.sh"

mkdir -p "$TARGET"
if [[ "$REPLACE" == "true" && -e "$TARGET/.cursor" ]]; then
  rm -rf "$TARGET/.cursor"
  echo "已删除旧 .cursor/（--replace 干净覆盖）"
fi
sc_copy_tree "$SOURCE/.cursor" "$TARGET/.cursor" "hooks/state/*"

if [[ -f "$TARGET/.gitignore" ]]; then
  grep -q '.cursorGrowth' "$TARGET/.gitignore" 2>/dev/null || echo '.cursorGrowth/' >> "$TARGET/.gitignore"
else
  printf '%s\n' '.cursorGrowth/' > "$TARGET/.gitignore"
fi

# .cursorignore — Agent 硬排除（与 .gitignore 互补；密钥须重复声明）
if [[ -f "$SOURCE/.cursorignore" ]]; then
  if [[ ! -f "$TARGET/.cursorignore" ]]; then
    cp "$SOURCE/.cursorignore" "$TARGET/.cursorignore"
  elif ! grep -qF '# Super Cursor' "$TARGET/.cursorignore" 2>/dev/null; then
    printf '\n# --- Super Cursor (install merge) ---\n' >> "$TARGET/.cursorignore"
    cat "$SOURCE/.cursorignore" >> "$TARGET/.cursorignore"
  fi
fi

# Merge workflow profile into config
if sc_has_json_tool; then
  profile_file="$TARGET/.cursor/config/profiles/${PROFILE}.json"
  if [[ -f "$profile_file" ]]; then
    tmp="$(mktemp)"
    sc_json_merge_files "$TARGET/.cursor/config/workflow.json" "$profile_file" > "$tmp"
    mv "$tmp" "$TARGET/.cursor/config/workflow.json"
  fi
else
  echo "WARN: jq/python 未安装，跳过 profile 合并（请手动编辑 workflow.json）" >&2
fi

sc_chmod_scripts "$TARGET/.cursor"

# Bootstrap .cursorGrowth (plan · archive · learn · rules — gitignored on target)
GROWTH_TEMPLATE="$SOURCE/.cursor/templates/cursorGrowth"
GROWTH_DIR="$TARGET/.cursorGrowth"
if [[ -d "$GROWTH_TEMPLATE" ]]; then
  if [[ ! -d "$GROWTH_DIR" ]]; then
    sc_copy_tree "$GROWTH_TEMPLATE" "$GROWTH_DIR"
    echo "已引导 .cursorGrowth/（项目特化与产出，git 忽略）"
  else
    mkdir -p "$GROWTH_DIR/learn" "$GROWTH_DIR/archive" "$GROWTH_DIR/rules/local" \
      "$GROWTH_DIR/logs" "$GROWTH_DIR/perception"
    [[ -f "$GROWTH_DIR/README.md" || ! -f "$GROWTH_TEMPLATE/README.md" ]] || \
      cp "$GROWTH_TEMPLATE/README.md" "$GROWTH_DIR/README.md"
    for stub in "$GROWTH_TEMPLATE/learn"/*.md; do
      [[ -f "$stub" ]] || continue
      dest="$GROWTH_DIR/learn/$(basename "$stub")"
      [[ -f "$dest" ]] || cp "$stub" "$dest"
    done
    if [[ -f "$GROWTH_TEMPLATE/rules/local/README.md" && ! -f "$GROWTH_DIR/rules/local/README.md" ]]; then
      cp "$GROWTH_TEMPLATE/rules/local/README.md" "$GROWTH_DIR/rules/local/README.md"
    fi
  fi
fi
mkdir -p "$GROWTH_DIR/archive" "$GROWTH_DIR/rules/local" 2>/dev/null || true

# Legacy: root plan.md / archive/ → .cursorGrowth/
if [[ -f "$TARGET/plan.md" && ! -f "$GROWTH_DIR/plan.md" ]]; then
  mv "$TARGET/plan.md" "$GROWTH_DIR/plan.md"
  echo "已迁移 plan.md → .cursorGrowth/plan.md"
fi
if [[ -d "$TARGET/archive" && ! -d "$GROWTH_DIR/archive" ]]; then
  mv "$TARGET/archive" "$GROWTH_DIR/archive"
  echo "已迁移 archive/ → .cursorGrowth/archive/"
fi

# Auto-copy plan into .cursorGrowth for full profile
if [[ "$COPY_PLAN" == "true" || ( "$PROFILE" == "full" && ! -f "$GROWTH_DIR/plan.md" ) ]]; then
  if [[ -f "$TARGET/.cursor/templates/plan.md" ]]; then
    cp "$TARGET/.cursor/templates/plan.md" "$GROWTH_DIR/plan.md"
    echo "已复制 .cursorGrowth/plan.md（profile=$PROFILE）"
  fi
fi

# Symlink .cursor/rules/local → .cursorGrowth/rules/local (Cursor glob 加载)
CURSOR_LOCAL="$TARGET/.cursor/rules/local"
if [[ -d "$GROWTH_DIR/rules/local" && ! -L "$CURSOR_LOCAL" ]]; then
  if [[ ! -e "$CURSOR_LOCAL" ]] || { [[ -d "$CURSOR_LOCAL" ]] && \
    [[ "$(find "$CURSOR_LOCAL" -maxdepth 1 -type f 2>/dev/null | wc -l | tr -d ' ')" -le 1 ]]; }; then
    rm -rf "$CURSOR_LOCAL"
    ln -sf "../../.cursorGrowth/rules/local" "$CURSOR_LOCAL"
    echo "已链接 .cursor/rules/local → .cursorGrowth/rules/local"
  fi
fi

# Detect empty-ish project for hints
file_count=0
if [[ -d "$TARGET" ]]; then
  file_count="$(find "$TARGET" -mindepth 1 -maxdepth 2 \
    ! -path "$TARGET/.cursor/*" ! -path "$TARGET/.git/*" ! -name .cursorGrowth \
    -type f 2>/dev/null | wc -l | tr -d ' ')"
fi

echo ""
echo "╔══════════════════════════════════════════════════╗"
echo "║  Super Cursor 已安装 → $TARGET"
echo "╚══════════════════════════════════════════════════╝"
echo "  profile: $PROFILE"
echo "  母版: $SOURCE"
echo ""
echo "  下一步（推荐顺序）:"
echo "  1. 不确定从哪开始 → 对 Agent 说 /master"
if [[ "$file_count" -le 3 ]]; then
  echo "  2. 空仓库 → /scaffold 选技术栈并创建骨架"
else
  echo "  2. 了解项目 → /learn"
fi
echo "  3. 拆需求 → /plan   4. 实现 → /run"
echo "  5. 验收 → ./scripts/verify.sh（scaffold 后会生成）"
echo ""
echo "  环境自检: bash .cursor/bin/platform-check.sh"
echo "  文档: .cursor/docs/quickstart.md · .cursor/docs/platforms.md"
echo "  注意: Agent 默认不得修改 .cursor/；完善模板须你明确要求"
