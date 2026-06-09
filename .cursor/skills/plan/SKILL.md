---
name: plan
description: 规划（/plan）：需求→先总后分→Sprint→plan.md→/run。说「规划」「拆任务」时用。禁止写业务代码。≠ IDE Plan 模式。
disable-model-invocation: true
---

# plan

闸门见 `rules/workflow.mdc`。配置：`config/workflow.json`

## 必读

`plan.md` 元数据/Sprint/ROADMAP · `archive/` · 匹配 rules · `learn/`（若有）· grep 落点（**不写代码**）

**`plan.md` 不纳入 git**：根目录为本地工作副本（`.gitignore`）；安装时由 `templates/plan.md` 复制；可提交进度在 `archive/` + CHANGELOG。

空仓库 / 用户要「新建项目」：在 `PLANNING:true` 用 **AskQuestion** 确认栈 → 预览 `scaffold.sh apply --dry-run` → 用户确认后 apply 或写入 `TASK-001`（见 **scaffold** skill）。**不写业务代码**直至用户确认脚手架范围。

## 规划粒度 · 先总后分

**禁止**在 `PLANNING:true` 阶段直接列一长串 `TASK-*` 而不先对齐全局。两层结构已够用，**不必**引入 Epic/Story 嵌套 ID 或 A1/A2 子编号：

| 层 | 载体 | 作用 |
|----|------|------|
| **总** | ROADMAP Theme · Sprint **Goal** · **Done when** | 主题边界、全局验收、与 ROADMAP 对齐 |
| **分** | 扁平 `TASK-*` 表 · **执行顺序** | `/run` 一次一个 `ACTIVE`；`next-task` 解析顺序 |

大改动 / 跨模块 / 前后端并行：额外读 `rules/execution/vibe.mdc`（API 契约、层序）· `rules/feedback/evolution.mdc`（小步可回滚）。

### 阶段 1 · 总（先不写 TASK 表）

在 `PLANNING:true` 完成后再进入阶段 2。用 **AskQuestion** 与用户确认：

- [ ] **Goal** — 本 Sprint 要交付什么（一句话）
- [ ] **Done when** — 怎样算 Sprint 完成（可执行 verify 命令 + P0 全 ✅）
- [ ] **ROADMAP** — 对应 Theme；新主题则先加一行 `planned`
- [ ] **Scope / 非目标** — 本轮明确不做什么（防 scope creep）
- [ ] **风险与依赖** — 跨模块顺序、需先定的契约或接口
- [ ] **SPIKE 门禁** — 选型/方案/范围仍不确定 → 先列 `SPIKE-*`，结论归档后再拆 `TASK-*`（见 **scaffold** · **spike** agent）
- [ ] **PRD 输入（可选）** — 已有 ChatPRD 规格时：读 **implement-from-prd** / **write-prd** 提炼 Goal；交付前 **check-prd-alignment**（ChatPRD 插件 skills）
- [ ] **对外门面** — 本 Sprint 是否新增/改名 skill、command、agent、hooks 或安装路径？**是** → Done when **必须**含 `bash .cursor/bin/cursor-coherence.sh`（README 与磁盘一致）；**否** → 可省略
- [ ] **交付验收（可选）** — UI/功能/对外交付 Sprint → Done when 可加 **`/delivery` 无 Blocker**（见 **delivery** skill）；纯内部/refactor 可省略

阶段 1 产出写入 Sprint 区块头部（**Goal** · **Done when** · 可选 **Out of scope**），**此时仍不写** TASK 表。

### 对外门面 · README（禁止事后补 DOC Sprint）

根目录 `README.md` 是 Super Cursor **产品首页**。凡 Sprint 改变用户可见能力，**须在同一 Sprint 内**同步 README，**禁止**「功能 Sprint ✅ → 另开 SPRINT 专补 README」。

| 变更类型 | 规划要求 |
|----------|----------|
| 新增/改名 skill · agent · `/` 指令 | Done when 含 `cursor-coherence.sh`；最后一项 P0 或各 TASK 的 Target 含 `README.md` |
| 仅内部 refactor · archive · 无对外行为 | README 可不碰 |
| 用户抱怨「文档滞后」 | 回流阶段 1：把 README 写进 **Done when**，勿只加 `DOC-*` |

阶段 2 拆 TASK 时：

- **推荐**：末位 P0 · Target `README.md` · Acceptance `bash .cursor/bin/cursor-coherence.sh`（与功能 TASK **同 Sprint**）
- **或**：每个改 `.cursor/skills/` · `agents/` · `master/` 的 TASK，Target 列 **同时** 写 `README.md`（同 commit 增量同步）
- **勿** 为补 README 单独开 Sprint，除非 Sprint Goal 本身就是文档重写

### 阶段 2 · 分（再写 TASK 表）

全局对齐后再拆任务。每条 `TASK-*` 宜满足：

- **一个可执行验收命令**（`task-verify` 能判绿/红；见 `rules/feedback/verify.mdc`）
- **一次 commit 能讲完**（一逻辑一 commit · `rules/execution/commit.mdc`）
- **Target 列框住落点**（防 drive-by；`/run` 审计对照）
- **依赖显式出现在执行顺序**（B 依赖 A → 顺序里 A 在前）

粒度自检：

| 过粗 | 合适 | 过细 |
|------|------|------|
| 一条 TASK 跨多个 Theme / 无单一验收 | 一 TASK ≈ 一可验证增量 | 改一行文案、单文件 typo 单独成 TASK |
| Sprint 内 >15 条且难排顺序 | Task 列可用 `[主题]` 前缀分组，**ID 仍扁平** | 每个子步骤都占一个 ID |

Sprint 表 + **执行顺序** 行：`TASK-001` → `TASK-002` → …

### 基线分析 · 与闭环对齐（防 plan 头身不一致）

Sprint 内若含 **触点矩阵**、**现状 vs 目标**、**差距列表** 等「规划基线」段落：

| 阶段 | 要求 |
|------|------|
| **规划（/plan）** | 标题或段首标明 **审查基线 / vX 快照**；链 `archive/...审查清单.md` 若已归档 |
| **执行（/run）** | 单任务 ✅ 时同步 TASK 表 **✅**；**不得**只改 `LAST_DONE` |
| **Sprint 收尾** | 按 **run** skill **plan 正文 reconciliation** 清单：Done when 全 `[x]` · 矩阵改 **交付态** 或保留快照链 · 标题改 **已完成 Sprint** |

`runner.sh plan-check` 在 Sprint 已闭合（`ACTIVE=(none)` + `LAST_DONE` 有值）时会 **WARN** 未 reconciliation 的正文。

### 阶段 3 · handoff

用户确认后设 `PLANNING:false` · `PLAN_APPROVED` · `ACTIVE`/`NEXT`：

```markdown
<!-- PLANNING: false -->
<!-- PLAN_APPROVED: YYYY-MM-DD -->
<!-- SPRINT_STATUS: active -->
<!-- ACTIVE: TASK-001 -->
<!-- NEXT: TASK-001 -->
```

```bash
./.cursor/bin/runner.sh plan-check && ./.cursor/bin/runner.sh gate-check
```

完成后建议 `/run`

## 任务 ID

| 前缀 | 用途 |
|------|------|
| `TASK-*` | 实现任务（默认） |
| `SPIKE-` / `REV-` / `DOC-` | 调研 / 回顾 / 文档；`next-task` 自动推进时跳过，**仍需** `PLAN_APPROVED` 才能 `/run` 编码 |

配置：`workflow.json` → `task_id.prefixes_skip` · `prefixes_autonomous`
