#!/usr/bin/env bash
# Mother repo CI entry: assemble flat .cursor/ then run full template verify.
set -euo pipefail
PACK="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
bash "$PACK/harness/assemble.sh"
exec bash "$PACK/harness/core/bin/template-verify.sh"
