#!/usr/bin/env bash
# install-super-cursor.sh — copy universal Super Cursor template to any project
set -euo pipefail

usage() {
  cat <<EOF
用法: $0 <目标项目路径> [选项]

选项:
  --profile full|lite|rules-only   工作流配置（默认 full）
  --copy-plan                      复制 templates/plan.md → plan.md
  -h, --help                       显示帮助

示例:
  $0 /path/to/my-app
  $0 /path/to/my-app --profile lite --copy-plan

项目认知 → .cursorGrowth/ · 私有规则 → .cursor/rules/local/
EOF
}

SOURCE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET=""
PROFILE="full"
COPY_PLAN="false"

while [[ $# -gt 0 ]]; do
  case "$1" in
    -h|--help) usage; exit 0 ;;
    --profile)
      PROFILE="${2:-}"
      shift 2
      ;;
    --copy-plan)
      COPY_PLAN="true"
      shift
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

if [[ -z "$TARGET" ]]; then
  usage
  exit 1
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
jw_copy_tree "$SOURCE/.cursor" "$TARGET/.cursor" "hooks/state/*"

if [[ -f "$TARGET/.gitignore" ]]; then
  grep -q '.cursorGrowth' "$TARGET/.gitignore" 2>/dev/null || echo '.cursorGrowth/' >> "$TARGET/.gitignore"
  grep -qE '^plan\.md$' "$TARGET/.gitignore" 2>/dev/null || echo 'plan.md' >> "$TARGET/.gitignore"
else
  printf '%s\n' '.cursorGrowth/' 'plan.md' > "$TARGET/.gitignore"
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
if jw_has_json_tool; then
  profile_file="$TARGET/.cursor/config/profiles/${PROFILE}.json"
  if [[ -f "$profile_file" ]]; then
    tmp="$(mktemp)"
    jw_json_merge_files "$TARGET/.cursor/config/workflow.json" "$profile_file" > "$tmp"
    mv "$tmp" "$TARGET/.cursor/config/workflow.json"
  fi
else
  echo "WARN: jq/python 未安装，跳过 profile 合并（请手动编辑 workflow.json）" >&2
fi

jw_chmod_scripts "$TARGET/.cursor"

# Auto-copy plan for full profile when repo has no plan.md
if [[ "$COPY_PLAN" == "true" || ( "$PROFILE" == "full" && ! -f "$TARGET/plan.md" ) ]]; then
  if [[ -f "$TARGET/.cursor/templates/plan.md" ]]; then
    cp "$TARGET/.cursor/templates/plan.md" "$TARGET/plan.md"
    echo "已复制 plan.md（profile=$PROFILE）"
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
