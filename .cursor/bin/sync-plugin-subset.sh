#!/usr/bin/env bash
# Copy Super Cursor MVP subset from .cursor/ → .cursor-plugin/ (SSOT: SPIKE-002 scope matrix).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$ROOT/.cursor"
DEST="$ROOT/.cursor-plugin"

RULES=(
  rules/core.mdc
  rules/workflow.mdc
  rules/communication/constitution.mdc
  rules/communication/agent-discipline.mdc
  rules/communication/cursor-standalone.mdc
  rules/communication/super-cursor-persona.mdc
  rules/communication/collaboration.mdc
  rules/feedback/verify.mdc
  rules/feedback/changelog.mdc
  rules/execution/commit.mdc
  rules/execution/docs.mdc
)

SKILLS=(master plan run learn scaffold)

AGENTS=(ship review spike)

HOOK_SCRIPTS=(
  hooks/growth-init.sh
  hooks/run-start.sh
  hooks/run-stop.sh
)

# hooks/lib/*.sh 通过 source "$_LIB_DIR/../../lib/platform.sh" 依赖母版 lib/。
# 插件轨必须自带一份，否则三个 hook 在 source 阶段即 exit 1（2026-10-14 修）。
# 只带 hook 运行期真需要的；verify-common/growth-archive 属母版门禁，不入插件。
LIB_SCRIPTS=(
  lib/platform.sh
)

copy_file() {
  local rel="$1"
  local out="$DEST/$rel"
  mkdir -p "$(dirname "$out")"
  cp "$SRC/$rel" "$out"
}

rm -rf "$DEST/rules" "$DEST/skills" "$DEST/agents" "$DEST/lib"
mkdir -p "$DEST/rules" "$DEST/skills" "$DEST/agents"

for rel in "${RULES[@]}"; do
  [[ -f "$SRC/$rel" ]] || { echo "FAIL: missing $SRC/$rel" >&2; exit 1; }
  copy_file "$rel"
done

for name in "${SKILLS[@]}"; do
  [[ -d "$SRC/skills/$name" ]] || { echo "FAIL: missing skill $name" >&2; exit 1; }
  mkdir -p "$DEST/skills/$name"
  cp -a "$SRC/skills/$name/." "$DEST/skills/$name/"
done

for name in "${AGENTS[@]}"; do
  [[ -f "$SRC/agents/$name.md" ]] || { echo "FAIL: missing agent $SRC/agents/$name.md" >&2; exit 1; }
  cp "$SRC/agents/$name.md" "$DEST/agents/$name.md"
done

mkdir -p "$DEST/hooks/lib" "$DEST/lib"
for rel in "${HOOK_SCRIPTS[@]}"; do
  copy_file "$rel"
done
cp -a "$SRC/hooks/lib/." "$DEST/hooks/lib/"

for rel in "${LIB_SCRIPTS[@]}"; do
  [[ -f "$SRC/$rel" ]] || { echo "FAIL: missing $SRC/$rel" >&2; exit 1; }
  copy_file "$rel"
done

# Plugin-local hooks.json (paths relative to repo / plugin root)
cat > "$DEST/hooks/hooks.json" <<'EOF'
{
  "version": 1,
  "hooks": {
    "beforeSubmitPrompt": [
      {
        "command": "hooks/growth-init.sh"
      }
    ],
    "sessionStart": [
      {
        "command": "hooks/run-start.sh",
        "timeout": 5
      }
    ],
    "stop": [
      {
        "command": "hooks/run-stop.sh",
        "timeout": 5,
        "loop_limit": 15
      }
    ]
  }
}
EOF

echo "sync-plugin-subset: rules=${#RULES[@]} skills=${#SKILLS[@]} agents=${#AGENTS[@]} lib=${#LIB_SCRIPTS[@]} hooks+lib → $DEST"
