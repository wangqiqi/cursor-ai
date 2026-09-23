#!/usr/bin/env bash
# Mirror .cursor/docs → docs/{guide,reference,training} for VitePress (SSOT stays in .cursor/docs).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$ROOT/.cursor/docs"
DEST="$ROOT/docs"

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

copy quickstart.md guide/quickstart.md
copy quickstart.en.md guide/quickstart.en.md
copy walkthrough.md guide/walkthrough.md
copy plan-run.md guide/plan-run.md
copy platforms.md guide/platforms.md
copy effective-collaboration.md guide/effective-collaboration.md
copy building-super-cursor.md guide/building-super-cursor.md
copy scaffold.md guide/scaffold.md
copy naming.md guide/naming.md
copy rules-catalog.md reference/rules-catalog.md
copy migration-catalog.md reference/migration-catalog.md
copy library-index.md reference/library-index.md
copy training/skills.md training/skills.md

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

echo "sync-cursor-docs: mirrored 13 files from .cursor/docs/"
