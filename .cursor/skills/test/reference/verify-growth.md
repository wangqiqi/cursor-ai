# Verify / test 增长协议（通用）

真源分层：**verify.mdc** L0–L3 · 本页为 **如何加能力而不叠床架屋**。

## 三件套

| 件 | 路径 | 作用 |
|----|------|------|
| **manifest** | `scripts/verify/manifest.tsv` | 什么在 merge / release / nightly 跑 |
| **changed-map** | `scripts/verify/changed-map.json` | Agent 按 diff 抬层 + 挂域 slice |
| **audit-dedup** | `scripts/verify/audit-dedup.config.json` | 测例只登记一次 |

脚手架：`scaffold apply-bundle verify-layers` 一次铺齐；成熟仓从 Growth `learn/` 记栈专属 glob，**勿**写进 `.cursor/`。

## manifest 类型（栈无关）

| type | target | 何时用 |
|------|--------|--------|
| `bash` | `slices/verify_*.sh` | 域断言、组合检查、registry |
| `command` | 单行 shell（`npm run test:unit` · `go test ./pkg/...`） | 已有脚本即可 |
| `bundle-commands` | `bundles/*.txt` 每行一条命令 | 批量集成测、多包 |

## 反模式

- 新 slice 里再跑一遍 L1 全量（L2 已含 `sc_verify_l1_fast`）。
- 在 `verify-layers.sh` 数组 **与** manifest **双份**维护（数组已废弃，仅 manifest）。
- 为消 flake 连跑多轮 L2-standard（定向单测 + 最多一轮 core）。
- 项目专有路径写进母版 `default-protected` / `verify.mdc`（走 Growth local）。

## 与 test 文件

- 单测文件归属 **一个** manifest 入口（`command` / `bundle-commands` / 域 slice 内唯一引用）。
- E2E / Playwright 放 L3 或 `l3` tier 的 `bash` slice。
- 框架选型 → `rules/execution/testing.mdc`；**不**为同一层引入第二套 runner。
