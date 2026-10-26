#!/usr/bin/env bash
# VitePress production build: sync SSOT → docs/ then build; fail on dead links (warn-only in upstream).
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"

bash "$ROOT/docs/scripts/sync-cursor-docs.sh"

log="$(mktemp)"
trap 'rm -f "$log"' EXIT

set +e
vitepress build docs 2>&1 | tee "$log"
vp_exit=$?
set -e

if [[ "$vp_exit" -ne 0 ]]; then
  echo "vitepress-build: FAIL vitepress exited $vp_exit" >&2
  exit "$vp_exit"
fi

if grep -qiE 'dead link|Found dead link' "$log"; then
  echo "vitepress-build: FAIL dead links in VitePress output (see log above)" >&2
  exit 1
fi

echo "vitepress-build: OK"
