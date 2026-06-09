#!/usr/bin/env bash
# Smoke-test install-super-cursor.sh (temp dirs only; no side effects on repo)
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
INSTALL="$ROOT/install-super-cursor.sh"
TMP_ROOT="$(mktemp -d)"
FAIL=0

fail() { echo "FAIL $1"; FAIL=$((FAIL + 1)); }
ok() { echo "OK  $1"; }

cleanup() { rm -rf "$TMP_ROOT"; }
trap cleanup EXIT

assert_file() {
  local path="$1" label="$2"
  [[ -f "$path" ]] && ok "$label" || fail "$label (missing $path)"
}

assert_absent() {
  local path="$1" label="$2"
  [[ ! -e "$path" ]] && ok "$label" || fail "$label (unexpected $path)"
}

assert_grep() {
  local file="$1" pattern="$2" label="$3"
  grep -qE "$pattern" "$file" 2>/dev/null && ok "$label" || fail "$label ($file)"
}

assert_git_ignored() {
  local dir="$1" file="$2" label="$3"
  (
    cd "$dir"
    git init -q
    git add -A
    if git status --short | grep -qF "$file"; then
      echo "FAIL $label (would be tracked)"
      exit 1
    fi
    echo "OK  $label"
  ) || FAIL=$((FAIL + 1))
}

[[ -x "$INSTALL" ]] || { echo "FAIL install script not executable: $INSTALL"; exit 1; }

echo "=== install smoke ==="

# 1. full · empty target
FULL="$TMP_ROOT/full-empty"
"$INSTALL" "$FULL" --profile full >/dev/null
assert_file "$FULL/plan.md" "full: plan.md copied"
assert_grep "$FULL/.gitignore" '^plan\.md$' "full: gitignore plan.md"
assert_grep "$FULL/.gitignore" 'cursorGrowth' "full: gitignore .cursorGrowth/"
assert_grep "$FULL/plan.md" '执行顺序' "full: plan template 执行顺序"
(
  cd "$FULL"
  bash .cursor/bin/runner.sh plan-check >/dev/null
  bash .cursor/bin/runner.sh gate-check >/dev/null
) && ok "full: plan-check + gate-check" || fail "full: plan-check + gate-check"

# 2. lite · no --copy-plan
LITE="$TMP_ROOT/lite-no-plan"
"$INSTALL" "$LITE" --profile lite >/dev/null
assert_absent "$LITE/plan.md" "lite: no plan.md without --copy-plan"
assert_grep "$LITE/.gitignore" '^plan\.md$' "lite: gitignore still has plan.md"

# 3. lite · --copy-plan
LITE_COPY="$TMP_ROOT/lite-copy"
"$INSTALL" "$LITE_COPY" --profile lite --copy-plan >/dev/null
assert_file "$LITE_COPY/plan.md" "lite --copy-plan: plan.md copied"

# 4. merge existing .gitignore
EXISTING="$TMP_ROOT/existing"
mkdir -p "$EXISTING"
echo 'node_modules/' >"$EXISTING/.gitignore"
"$INSTALL" "$EXISTING" --profile full >/dev/null
assert_grep "$EXISTING/.gitignore" 'node_modules' "merge: keeps node_modules/"
assert_grep "$EXISTING/.gitignore" '^plan\.md$' "merge: adds plan.md"
assert_grep "$EXISTING/.gitignore" 'cursorGrowth' "merge: adds .cursorGrowth/"

# 5. plan.md not tracked after git init
assert_git_ignored "$FULL" "plan.md" "full: plan.md gitignored"

echo "---"
if [[ "$FAIL" -eq 0 ]]; then
  echo "install smoke passed."
  exit 0
fi
echo "$FAIL install smoke check(s) failed."
exit 1
