#!/usr/bin/env bash
# Mother repo: harness/core + adaptors layout (SPRINT-HARNESS-LAYOUT).
set -euo pipefail

CUR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ROOT="$(cd "$CUR/.." && pwd)"
HARNESS="$ROOT/harness"
MANIFEST="$HARNESS/layout-manifest.json"

# shellcheck source=../lib/verify-common.sh
source "$CUR/lib/verify-common.sh" "verify-harness-layout"

echo "=== verify-harness-layout ==="

[[ -f "$HARNESS/README.md" ]] && grep -q 'assemble' "$HARNESS/README.md" \
  && vc_ok "harness/README.md" || vc_fail "harness/README.md missing or no assemble section"
[[ -f "$MANIFEST" ]] && vc_ok "layout-manifest.json" || vc_fail "missing $MANIFEST"
[[ -f "$HARNESS/assemble.sh" ]] && vc_ok "harness/assemble.sh present" || vc_fail "harness/assemble.sh missing"

if [[ ! -f "$MANIFEST" ]]; then
  vc_summary "verify-harness-layout failed."
  exit 1
fi

mkdir -p "$HARNESS/core" "$ROOT/adaptors/cursor" "$ROOT/adaptors/dsh" "$ROOT/adaptors/kiro" \
  "$ROOT/adaptors/trae" "$ROOT/adaptors/opencode"
for d in harness/core adaptors/cursor adaptors/dsh adaptors/kiro adaptors/trae adaptors/opencode; do
  [[ -d "$ROOT/$d" ]] && vc_ok "skeleton $d" || vc_fail "skeleton $d"
done

# Contract-only: core 尚未搬迁时（TASK-001）
if [[ ! -d "$HARNESS/core/skills" ]]; then
  vc_summary "verify-harness-layout passed (contract-only)."
  exit 0
fi

# shellcheck source=../lib/platform.sh
source "$CUR/lib/platform.sh"
if ! sc_has_json_tool; then
  vc_fail "need jq or python for layout-manifest.json"
else
  vc_ok "json tool for manifest"
fi

# --- core tree ---
core="$HARNESS/core"
if [[ ! -d "$core" ]]; then
  vc_fail "harness/core/ missing"
else
  vc_ok "harness/core/ exists"
  for d in agents bin config docs lib rules skills templates; do
    [[ -d "$core/$d" ]] && vc_ok "core/$d" || vc_fail "missing core/$d"
  done

  for f in AGENTS.md README.md verify-super-cursor.sh verify-system.sh; do
    [[ -f "$core/$f" ]] && vc_ok "core/$f" || vc_fail "missing core/$f"
  done

  for f in verify-cursor-plugin-mvp.sh verify-cursor-plugin-manifest.sh verify-cursor-platform-contract.sh \
    verify-spike-plugin-mvp-scope.sh verify-spike-plugin-agents-scope.sh verify-spike-plugin-phase2-scope.sh; do
    [[ ! -f "$core/bin/$f" ]] && vc_ok "core/bin lacks adaptor-only $f" || vc_fail "cursor-only bin still in core: $f"
  done
  for f in cursor-cloud.md plan-run.md; do
    [[ ! -f "$core/docs/$f" ]] && vc_ok "core/docs lacks adaptor-only $f" || vc_fail "cursor-only doc still in core: $f"
  done
fi

# --- cursor adaptor ---
ac="$ROOT/adaptors/cursor"
[[ -d "$ac/hooks" ]] && vc_ok "adaptors/cursor/hooks" || vc_fail "adaptors/cursor/hooks"
[[ -f "$ac/hooks.json" ]] && vc_ok "adaptors/cursor/hooks.json" || vc_fail "adaptors/cursor/hooks.json"
for f in verify-cursor-plugin-mvp.sh verify-cursor-platform-contract.sh verify-spike-plugin-mvp-scope.sh; do
  [[ -f "$ac/bin/$f" ]] && vc_ok "adaptors/cursor/bin/$f" || vc_fail "missing adaptors/cursor/bin/$f"
done
[[ -f "$ac/docs/cursor-cloud.md" ]] && vc_ok "adaptors/cursor/docs/cursor-cloud.md" || vc_fail "missing adaptors/cursor/docs/cursor-cloud.md"

# --- placeholder adaptors ---
for id in dsh kiro trae opencode; do
  [[ -f "$ROOT/adaptors/$id/README.md" ]] && vc_ok "adaptors/$id/README.md" || vc_fail "missing adaptors/$id/README.md"
done

# --- assembled .cursor matches dev expectation ---
[[ -f "$ROOT/.cursor/rules/core.mdc" ]] && vc_ok ".cursor assembled (core.mdc)" || vc_fail ".cursor missing — run harness/assemble.sh"

vc_summary "verify-harness-layout passed."
