#!/usr/bin/env bash
# resolve-role.sh — resolve persona by id / role_name / nickname / given_name
# Usage: resolve-role.sh <roles.json> <query>
# Exit 0 + JSON persona on unique match; exit 2 on ambiguous; exit 1 on miss
set -euo pipefail
roles_file="${1:?roles.json}"
query="${2:?query}"
py="$(command -v python3 || command -v python || true)"
[[ -n "$py" ]] || { echo "FAIL: no python" >&2; exit 1; }
"$py" - "$roles_file" "$query" <<'PY'
import json, sys
path, q = sys.argv[1], sys.argv[2].strip().lower()
data = json.load(open(path, encoding="utf-8"))
hits = []
for p in data.get("personas", []):
    keys = {str(p.get("id", "")).lower(), str(p.get("role_name", "")).lower(), str(p.get("given_name", "")).lower()}
    # backward compat: name == role_name if present
    if p.get("name"):
        keys.add(str(p["name"]).lower())
    for n in p.get("nicknames") or []:
        keys.add(str(n).lower())
    if q in keys:
        hits.append(p)
if len(hits) == 1:
    print(json.dumps(hits[0], ensure_ascii=False))
    sys.exit(0)
if len(hits) > 1:
    print(json.dumps({"ambiguous": True, "ids": [h.get("id") for h in hits]}, ensure_ascii=False), file=sys.stderr)
    sys.exit(2)
sys.exit(1)
PY
