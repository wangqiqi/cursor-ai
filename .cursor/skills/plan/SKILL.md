---
name: plan
description: 规划（/plan）：需求→先总后分→Sprint→plan.md→/run。说「规划」「拆任务」时用。禁止写业务代码。≠ IDE Plan 模式。
disable-model-invocation: true
---

# plan

闸门见 `rules/workflow.mdc`。配置：`config/workflow.json`

**详文**：`reference/phases.md`（阶段 1/2/3 · 头身一致）· `reference/followup-facade.md`（Follow-up · README 门面）

## 规模门禁 · plan≥5

| 条件 | 动作 |
|------|------|
| 预估 / 已列 **todolist 或 TASK 超过 5 条** | **先**写入 / 更新 `.cursorGrowth/plan.md`（Goal · Done when · TASK 表），**等用户确认**后再 `/run` 编码 |
| 大改动、跨模块、不确定选型 | 同上；必要时先 `SPIKE-*` |
| ≤5 且范围清晰的小修 | 可直述执行；仍建议 gate-check |

禁止：脑内排 6+ 步却只在聊天里列 checklist、不落 plan。与用户规则「>5 todolist → plan.md」对齐；可观测落点为本节 + `workflow.mdc`。

## 必读

`.cursorGrowth/plan.md` 元数据 · **未完成** Sprint/TASK · `.cursorGrowth/archive/` · `learn/plan-conventions.md` · grep 落点（**不写代码**）

**`.cursorGrowth/` 不纳入 git**：`plan.md` · `archive/` · `learn/` · `rules/local` 均在此；安装时由 `templates/plan.md` 复制到 `.cursorGrowth/plan.md`。

空仓库 / 用户要「新建项目」：在 `PLANNING:true` 用 **AskQuestion** 确认栈 → 预览 `scaffold.sh apply --dry-run` → 用户确认后 apply 或写入 `TASK-001`（见 **scaffold** skill）。**不写业务代码**直至用户确认脚手架范围。

## plan.md 正文卫生（未完成优先）

**目标**：`plan.md` 是**执行面板**，不是历史档案。团队细则 → `.cursorGrowth/learn/plan-conventions.md`。

### 保留在 plan.md

| 区块 | 说明 |
|------|------|
| **HTML 注释** | `PLANNING` · `SPRINT` · `ACTIVE` · `NEXT` · `VERIFY` 等（`runner.sh` 解析） |
| **执行原则** | 一两行指针（archive/CHANGELOG 在哪），**勿**堆归档链接表 |
| **Active sprint** | 当前 Sprint：`Goal` · `Done when` · `Out of scope` · TASK 表（`⬜`/`🔧`/`⚠️`）· **执行顺序** |
| **下一 Sprint 候选** | 未立项 Sprint 简表（Goal · 依赖）；**保留在 plan** |

### 禁止堆进 plan.md

| 不放 | 放哪里 |
|------|--------|
| 已闭合 Sprint 全文（Done when · TASK ✅） | `.cursorGrowth/archive/` 一篇摘要 |
| ROADMAP 全表（含大量 `done` 行） | `archive/` · `CHANGELOG.md` · 项目 `docs/ROADMAP.md` |
| **历史 Sprint** 长链接列表 | `archive/` 目录即可 |
| 设计拍板长文 · 多段 archive 互链 | `learn/` · `docs/` |

Sprint **全部 TASK ✅** 后：**从 plan 删除整个 Active 区块**（不只改标题）；细节只留 archive + CHANGELOG。

### 新开 / 续开 Sprint（累加，不覆盖）

| 场景 | 动作 |
|------|------|
| **仍有** `⬜`/`🔧` TASK 或 Active Sprint | **禁止**清空 plan；先收尾或继续在现有 Sprint 排期 |
| **新开** Sprint（上一 Sprint 已归档并删正文） | 从候选表**删掉已立项行**；新增 `## Active sprint · …`；`SPRINT_STATUS: active` |
| **候选表有剩余** | 未选中行**保留**；与用户确认下一项，**累加**不重复造 ID |
| **全部完成** | plan 无 Active · 仅候选表 + 可选阻塞一行；`SPRINT_STATUS: closed` |

### 推荐结构

有 Active：**Active 置顶** → 分隔线 → **下一 Sprint 候选**。无 Active：一行空状态说明 → 候选表。勿加「历史 Sprint」列表。

## 先总后分（摘要）

| 层 | 载体 | 作用 |
|----|------|------|
| **总** | Sprint **Goal** · **Done when** · 候选表对齐 | 主题边界、全局验收 |
| **分** | 扁平 `TASK-*` 表 · **执行顺序** | `/run` 一次一个 `ACTIVE` |

1. **阶段 1** — Goal / Done when / Out of scope（**不写** TASK 表）→ 详 `reference/phases.md`
2. **Follow-up / 门面** — 见 `reference/followup-facade.md`
3. **阶段 2** — 拆 TASK + 执行顺序 → 详 `reference/phases.md`
4. **阶段 3 · handoff** — `PLANNING:false` · `PLAN_APPROVED` · `ACTIVE`/`NEXT` → `plan-check` && `gate-check` → `/run`

大改动 / 跨模块：读 `rules/execution/vibe.mdc` · `rules/feedback/evolution.mdc`。

## 任务 ID

| 前缀 | 用途 |
|------|------|
| `TASK-*` | 实现任务（默认） |
| `SPIKE-` / `REV-` / `DOC-` | 调研 / 回顾 / 文档；`next-task` 自动推进时跳过，**仍需** `PLAN_APPROVED` 才能 `/run` 编码 |

配置：`workflow.json` → `task_id.prefixes_skip` · `prefixes_autonomous`
