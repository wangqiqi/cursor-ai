#!/usr/bin/env bash
# 按 manifest.tsv 运行指定 tier（累积：l2-standard ⊇ l2-core ⊇ …）
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$ROOT"
TIER="${1:?usage: run-manifest-tier.sh l2-core|l2-standard|l3}"
MANIFEST="${VERIFY_MANIFEST:-$ROOT/scripts/verify/manifest.tsv}"
PARALLEL="${VERIFY_SLICE_PARALLEL:-4}"

tier_rank() {
  case "$1" in
    l2-core) echo 1 ;;
    l2-standard) echo 2 ;;
    l3) echo 3 ;;
    *) echo 0 ;;
  esac
}

want_rank="$(tier_rank "$TIER")"
[[ "$want_rank" -gt 0 ]] || { echo "FAIL: unknown tier=$TIER" >&2; exit 1; }

[[ -f "$MANIFEST" ]] || { echo "FAIL: missing manifest $MANIFEST" >&2; exit 1; }

load_bundle_commands() {
  local rel="$1"
  local full="$ROOT/scripts/verify/$rel"
  [[ -f "$full" ]] || full="$ROOT/$rel"
  [[ -f "$full" ]] || { echo "FAIL: missing bundle-commands file $rel" >&2; exit 1; }
  mapfile -t _lines < <(grep -v '^[[:space:]]*#' "$full" | grep -v '^[[:space:]]*$' || true)
  if [[ ${#_lines[@]} -eq 0 ]]; then
    echo "FAIL: empty bundle-commands $rel (tier=$TIER)" >&2
    exit 1
  fi
  BUNDLE_CMDS+=("${_lines[@]}")
}

mapfile -t ROWS < <(awk -F'\t' 'NF>=3 && $0 !~ /^#/ { print }' "$MANIFEST")
if [[ ${#ROWS[@]} -eq 0 ]]; then
  echo "FAIL: manifest has no data rows: $MANIFEST" >&2
  exit 1
fi

BASH_CMDS=()
BUNDLE_CMDS=()
matched=0

for row in "${ROWS[@]}"; do
  IFS=$'\t' read -r row_tier type target <<< "$row"
  row_tier="${row_tier//$'\r'/}"
  type="${type//$'\r'/}"
  target="${target//$'\r'/}"
  r="$(tier_rank "$row_tier")"
  [[ "$r" -gt 0 && "$r" -le "$want_rank" ]] || continue
  matched=$((matched + 1))
  case "$type" in
    bash)
      BASH_CMDS+=("bash scripts/verify/$target")
      ;;
    command)
      BASH_CMDS+=("$target")
      ;;
    bundle-commands)
      load_bundle_commands "$target"
      ;;
    *)
      echo "FAIL: unknown manifest type=$type (row: $row)" >&2
      exit 1
      ;;
  esac
done

if [[ "$matched" -eq 0 ]]; then
  echo "FAIL: no manifest rows for tier=$TIER (cumulative) in $MANIFEST" >&2
  exit 1
fi

run_one() {
  echo "[verify] manifest: $*"
  eval "$@"
}

ALL_CMDS=("${BASH_CMDS[@]}" "${BUNDLE_CMDS[@]}")
if [[ ${#ALL_CMDS[@]} -eq 0 ]]; then
  echo "FAIL: no commands collected for tier=$TIER" >&2
  exit 1
fi

if [[ "$PARALLEL" -gt 1 && ${#ALL_CMDS[@]} -gt 1 ]]; then
  export -f run_one
  printf '%s\0' "${ALL_CMDS[@]}" | xargs -0 -P "$PARALLEL" -I{} bash -c 'run_one "$@"' _ {}
else
  for cmd in "${ALL_CMDS[@]}"; do
    run_one "$cmd"
  done
fi

echo "[verify] manifest tier=$TIER OK ($matched rows)"
