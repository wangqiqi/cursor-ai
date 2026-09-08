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

rm -rf "$DEST/guide" "$DEST/reference" "$DEST/training"
mkdir -p "$DEST/guide" "$DEST/reference" "$DEST/training"

copy quickstart.md guide/quickstart.md
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

rewrite_guide_links() {
  local file="$1"
  sed -i \
    -e 's](\([a-z0-9_-]*\)\.md)]((/guide/\1)]g' \
    -e 's](rules-catalog\.md)]((/reference/rules-catalog)]g' \
    -e 's](rules-catalog)]((/reference/rules-catalog)]g' \
    "$file"
}

for f in "$DEST/guide"/*.md; do
  rewrite_guide_links "$f"
done

sed -i \
  -e 's](\.\./\.\./README\.md)](https://github.com/wangqiqi/cursor-ai)]g' \
  -e 's](\.\./README\.md)](https://github.com/wangqiqi/cursor-ai/blob/master/.cursor/README.md)]g' \
  "$DEST/guide/walkthrough.md"

sed -i \
  -e 's](\.\./rules/local/README\.md)](https://github.com/wangqiqi/cursor-ai/blob/master/.cursor/rules/local/README.md)]g' \
  "$DEST/reference/rules-catalog.md"

sed -i \
  -e 's](\.\./\.\./skills/master/routes\.md)](https://github.com/wangqiqi/cursor-ai/blob/master/.cursor/skills/master/routes.md)]g' \
  -e 's](\.\./quickstart\.md)]((/guide/quickstart)]g' \
  -e 's](\.\./walkthrough\.md)]((/guide/walkthrough)]g' \
  "$DEST/training/skills.md"

sed -i \
  -e 's](rules-catalog\.md)]((/reference/rules-catalog)]g' \
  -e 's](rules-catalog)]((/reference/rules-catalog)]g' \
  "$DEST/reference/library-index.md"

echo "sync-cursor-docs: mirrored 12 files from .cursor/docs/"
