# Growth 目录分级（archive · scripts）

**用这个**：`.cursorGrowth/archive/` 与项目 `scripts/` 的**一级功能分级** SSOT。**不是那个**：Growth 坐标键名 → `config/workflow.json` · `archive_dir` · `growth.*`；验收分层 L0–L3 → `rules/feedback/verify.mdc`。

## 原则

| 原则 | 说明 |
|------|------|
| **至少一级域目录** | 新产出不得长期堆在 `archive/` 或 `scripts/` 根目录 |
| **根目录只留入口** | `scripts/` 根：聚合 orchestrator · `test.sh` · 兼容转发；非新实现默认落子目录 |
| **项目可扩展** | 域表在 `.cursorGrowth/learn/plan-conventions.md` 登记团队增量；母版给推荐桶 |
| **命名不变** | archive 文件名仍 `YYYYMMDD_HHMMSS_<topic>_<module>.md`（见 plan-conventions 模板） |

## Archive 布局

路径：`{archive_dir}/{domain}/YYYYMMDD_HHMMSS_<topic>_<module>.md`

默认 `archive_dir` → `.cursorGrowth/archive/`（`workflow.json`）。

### 推荐域（`domain`）

| 域 | 放什么 | 示例 |
|----|--------|------|
| `sprint` | Sprint 闭合摘要 · TASK 汇总 | `sprint/20260907_153000_SPRINT-131_闭合.md` |
| `spike` | SPIKE 结论 · 调研 ADR | `spike/20260906_093000_harness_sdk_SPIKE-001.md` |
| `release` | 发版笔记 · tag 说明 | `release/20260907_152000_v0.82.4_发版.md` |
| `doc` | 文档 Sprint · doc 收敛 | `doc/20260906_130500_DOC-06_SPRINT-105.md` |
| `ops` | 运维 · 数据 · verify 分层 · 可观测 | `ops/20260906_183600_SPRINT-100-F3_Host_RSS可观测.md` |
| `web` | WebUI · 控制台 · 前端 Sprint | `web/20260906_101200_web_operator_panel_SPRINT-89.md` |
| `test` | 测试体系 · verify 编排 | `test/20260907_213800_SPRINT-INT-VERIFY-01_integration_orchestration.md` |
| `operator` | 操作员 · MCP · 工具链 | `operator/20260906_200500_guanfu_mcp_SPRINT-120.md` |
| `harness` | Harness · SDK · 插件宿主 | `harness/20260906_092000_harness_pluggable_SPRINT-83.md` |
| `viz` | 可视化 · 图表 Sprint | `viz/20260906_173700_可视化_L1_SPRINT-VIZ-L1.md` |
| `cv` / `cognition` / `society` | 领域模块（按项目自定） | 团队可在 plan-conventions 增删 |

**禁止**：Sprint 收尾把长叙事只写进 plan 而不归档；**禁止**无域前缀持续新增根目录 flat 文件（迁移期除外，须登记 plan-conventions）。

### Agent 写入

| 时机 | 路径 |
|------|------|
| Sprint 收尾（**run**） | `{archive_dir}/{domain}/` — `domain` 取 Sprint Theme 或 TASK 主域 |
| SPIKE 归档 | `spike/` |
| 发版叙事（非 CHANGELOG 条目） | `release/` |
| 不确定域 | AskQuestion 或暂 `doc/`，并在 plan-conventions 登记 |

## Scripts 布局

适用于安装后目标项目的 `scripts/`（混合仓）。纯母版仓无根 `scripts/`，纪律仍供 scaffold · verify 引用。

```text
scripts/
├── README.md              # SSOT：矩阵 · 分层 · 域表（项目必填，见 verify）
├── test.sh                # 开发中快速测试入口
├── verify.sh              # L2 聚合入口（可转发 verify/tier/）
├── verify-fast.sh         # 可选 · L0 转发
├── verify-nightly.sh      # 可选 · L3 转发
├── lib/                   # 公因子（source only，不直接 exec）
│   └── _*.sh
├── verify/
│   ├── tier/              # L0/L2/L3 orchestrator 实现
│   └── domain/            # L1 域脚本 verify_*.sh
├── ops/                   # 开发/运维工具（非 tier 门禁）
├── dev/                   # stub · fixture · SPIKE 一次性脚本
└── docs/                  # 可选 · collect/verify 文档类（manual · test-report）
```

### 新增脚本门禁

| 类型 | 落点 | 禁止 |
|------|------|------|
| L1 域验收 `verify_*.sh` | `verify/domain/` | 根目录新建域脚本 |
| tier orchestrator | `verify/tier/` | 根目录复制整套 tier 逻辑 |
| 共享断言/env | `lib/_*.sh` | 多脚本 copy-paste |
| bootstrap · seed · sync | `ops/` | 与 verify 域混放 |
| SPIKE · stub · 证书生成 | `dev/` | 根目录堆积 |
| 根目录新文件 | 仅 **转发** 或 **一行聚合注册** | 在根目录写 >20 行业务逻辑 |

聚合 `verify.sh` / `verify_all.sh` 注册新域时 **+1 行**，见 `verify.mdc` §新增 verify 脚本门禁。

## 交叉引用

| 消费方 | 动作 |
|--------|------|
| **run** §Sprint 收尾 | archive 写入 `{domain}/` |
| **doc-hygiene** | archive 职责 + 禁 flat 膨胀 |
| **verify.mdc** | scripts 分层 + 复用优先 |
| **scaffold** | 新仓 scripts 树与 README |
| **learn** | plan-conventions 登记团队域表 |
| **ops-deploy** `layout.md` | 与 deploy 目录并列的 scripts 节 |

## 验收（母版）

```bash
bash .cursor/bin/verify-growth-layout.sh
```

目标项目可选：在 `scripts/README.md` 声明布局，并在 `dev-conventions.md` 链本 SSOT 或 GuanFu 式矩阵。
