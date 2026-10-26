# Verify layers（scaffold bundle）

与 Super Cursor `rules/feedback/verify.mdc` · **test** skill `reference/verify-growth.md` 对齐。

## 分层

| 层 | 命令 | 用途 |
|----|------|------|
| **L1** | `./scripts/verify.sh` | 开发循环 · 每个 TASK |
| **L2-core** | `./scripts/verify-core.sh` | merge 前 P0 |
| **L2** | `./scripts/verify-release.sh` | Sprint 收尾 / 打版 |
| **L3** | `./scripts/verify.sh --full` | CI / nightly |

## 增长纪律（防重复劳动）

1. **SSOT**：`scripts/verify/manifest.tsv` — 每个 tier 一行一入口（`bash` · `command` · `bundle-commands`）。
2. **累积 tier**：`l2-standard` 自动包含 `l2-core` 行；`l3` 含全部 tier。勿在 L2 里再抄一遍 L1 命令。
3. **新能力**：优先 `command` 或 `bundle-commands` 登记已有测试命令；域断言才新建 `slices/verify_<feature>.sh` 并 **只加一行 manifest**。
4. **禁止双登记**：同一测例文件/命令不得在多个 slice 或 bundle 重复出现 — 复制 `audit-dedup.config.example.json` → `audit-dedup.config.json`，CI 设 `failOnDuplicate: true`。
5. **空即失败**：manifest 某 tier 无行、或 `bundle-commands` 空文件 → `run-manifest-tier.sh` / `verify_manifest_integrity.sh` FAIL（不静默跳过）。

## 扩展新 slice

```bash
#!/usr/bin/env bash
set -euo pipefail
source "$(dirname "$0")/../../lib/load.sh"
sc_cd_root
# … domain checks only; do not re-run whole test suite if already in manifest command/bundle …
sc_pass "verify_<feature>"
```

在 `manifest.tsv` 增加一行，例如：

```text
l2-standard	bash	slices/verify_<feature>.sh
```

登记检查：

```bash
bash scripts/verify/slices/verify_layers_registry.sh
VERIFY_REGISTRY_STRICT=1 bash scripts/verify/slices/verify_layers_registry.sh
```

## 增量验收（verify:changed）

1. 复制 `changed-map.example.json` → `changed-map.json` 并按路径改 `prefixRules`。
2. `VERIFY_CHANGED_DRY=1 ./scripts/verify.sh --changed`
3. `VERIFY_CHANGED_BASE=master`（无 `origin/main` 时）

## 并行

互不共享可变状态的条目由 `run-manifest-tier.sh` 并行（`VERIFY_SLICE_PARALLEL`）；共享 DB/seed 的 `command` 请合并为单条或设并行度为 1。
