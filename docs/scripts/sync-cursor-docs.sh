#!/usr/bin/env bash
# Mirror .cursor/docs → docs/{guide,reference,training} for VitePress (SSOT stays in .cursor/docs).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$ROOT/.cursor/docs"
DEST="$ROOT/docs"

# --- Sync layout (edit here; new root *.md → guide/ unless listed in REFERENCE_DOCS) ---
REFERENCE_DOCS=(
  migration-catalog.md
  rules-catalog.md
  library-index.md
)
# Subpaths under .cursor/docs mirrored to docs/training/ (basename preserved)
TRAINING_GLOB="training/*.md"

is_reference_doc() {
  local base="$1"
  local r
  for r in "${REFERENCE_DOCS[@]}"; do
    [[ "$base" == "$r" ]] && return 0
  done
  return 1
}

copy() {
  local rel="$1"
  local out="$2"
  mkdir -p "$(dirname "$DEST/$out")"
  cp "$SRC/$rel" "$DEST/$out"
}

# 就地重写；不用 `sed -i`（GNU 无后缀 / BSD 需 `-i ''`，跨平台不一致）
sed_rewrite() {
  local file="$1"
  shift
  local tmp
  tmp="$(mktemp)"
  sed "$@" "$file" > "$tmp"
  mv "$tmp" "$file"
}

rm -rf "$DEST/guide" "$DEST/reference" "$DEST/training"
mkdir -p "$DEST/guide" "$DEST/reference" "$DEST/training"

SYNC_COUNT=0
shopt -s nullglob
for src_path in "$SRC"/*.md; do
  base="$(basename "$src_path")"
  if is_reference_doc "$base"; then
    copy "$base" "reference/$base"
  else
    copy "$base" "guide/$base"
  fi
  SYNC_COUNT=$((SYNC_COUNT + 1))
done

for src_path in "$SRC"/$TRAINING_GLOB; do
  [[ -f "$src_path" ]] || continue
  rel="${src_path#"$SRC"/}"
  copy "$rel" "$rel"
  SYNC_COUNT=$((SYNC_COUNT + 1))
done

[[ -f "$DEST/guide/cursor-cloud.md" ]] || {
  echo "sync-cursor-docs: FAIL missing guide/cursor-cloud.md (expected from .cursor/docs/cursor-cloud.md)" >&2
  exit 1
}

# 站内绝对路径必须写成 [text](/guide/x)，多一个 '(' 会让 markdown-it 解析失败并渲染成纯文本
rewrite_guide_links() {
  local file="$1"
  sed_rewrite "$file" \
    -e 's](\([a-z0-9_-]*\)\.md)](/guide/\1)]g' \
    -e 's](rules-catalog\.md)](/reference/rules-catalog)]g' \
    -e 's](rules-catalog)](/reference/rules-catalog)]g'
}

for f in "$DEST/guide"/*.md; do
  rewrite_guide_links "$f"
done

sed_rewrite "$DEST/guide/walkthrough.md" \
  -e 's](\.\./\.\./README\.md)](https://github.com/wangqiqi/cursor-ai)]g' \
  -e 's](\.\./README\.md)](https://github.com/wangqiqi/cursor-ai/blob/master/.cursor/README.md)]g'

# rules/local 为 gitignore 的符号链接，指向母版会 404；改指已跟踪的模板
sed_rewrite "$DEST/reference/rules-catalog.md" \
  -e 's](\.\./templates/cursorGrowth/rules/local/README\.md)](https://github.com/wangqiqi/cursor-ai/blob/master/.cursor/templates/cursorGrowth/rules/local/README.md)]g'

sed_rewrite "$DEST/training/skills.md" \
  -e 's](\.\./\.\./skills/master/routes\.md)](https://github.com/wangqiqi/cursor-ai/blob/master/.cursor/skills/master/routes.md)]g' \
  -e 's](\.\./quickstart\.md)](/guide/quickstart)]g' \
  -e 's](\.\./walkthrough\.md)](/guide/walkthrough)]g'

sed_rewrite "$DEST/reference/library-index.md" \
  -e 's](rules-catalog\.md)](/reference/rules-catalog)]g' \
  -e 's](rules-catalog)](/reference/rules-catalog)]g'

sed_rewrite "$DEST/reference/migration-catalog.md" \
  -e 's](consumer-refresh\.md)](/guide/consumer-refresh)]g'

echo "sync-cursor-docs: mirrored ${SYNC_COUNT} files from .cursor/docs/ (guide glob + reference list + ${TRAINING_GLOB})"
