<!-- 工作副本：.cursorGrowth/plan.md（gitignore）· 模板 .cursor/templates/plan.md -->
<!-- PLANNING: false -->
<!-- SPRINT: SPRINT-01 -->
<!-- PLAN_APPROVED: YYYY-MM-DD -->
<!-- AUTONOMOUS: false -->
<!-- SPRINT_STATUS: active -->
<!-- ACTIVE: TASK-001 -->
<!-- NEXT: TASK-001 -->
<!-- LAST_DONE: (none) -->
<!-- VERIFY: ./scripts/verify.sh -->
<!-- 禁止写 runner.sh verify — CLI 入口会读本行；指回自身会无限递归 -->
<!-- MAX_LOOPS: 15 -->
<!-- VERSION_TARGET: (optional) -->

# Plan

> **plan 双态**：HTML 注释供 `runner.sh` 解析；**Done when**、TASK ✅ 等正文须在 Sprint 收尾与 `.cursorGrowth/archive/` 对齐（**run** skill · reconciliation）。团队约定 → `.cursorGrowth/learn/plan-conventions.md`。

## Active sprint · SPRINT-01 Example

**Goal**: （本 Sprint 交付什么 — 阶段 1 先写此项，再拆 TASK）

**Done when**: P0 tasks ✅ · `./scripts/verify.sh` passes · （UI/功能 Sprint 可选）`/delivery` 无 Blocker · （若改 skills/agents/指令）`bash .cursor/bin/cursor-coherence.sh` · README 已同步

**Out of scope**（可选）: …

| ID | Task | Priority | Status | Acceptance | Target |
|----|------|----------|--------|------------|--------|
| TASK-001 | Example feature | P0 | ⬜ | `./scripts/test.sh` | `src/` |
| TASK-002 | Sprint hardening | P0 | ⬜ | `./scripts/verify.sh` | `scripts/` |

**执行顺序**: `TASK-001` → `TASK-002`

> 验收列约定：开发任务用 `./scripts/test.sh` · 收尾/合并前用 `./scripts/verify.sh`

## ROADMAP

| Theme | Status | Notes |
|-------|--------|-------|
| Example epic | planned | |

## Changelog index

- Sprint notes → `.cursorGrowth/archive/`（命名见 `learn/plan-conventions.md`）。
- Sprint 收尾：`SPRINT_STATUS: closed` · Done when 全 `[x]` · TASK 全 ✅ · 标题改已闭合 · 历史表补归档链（**run** skill reconciliation）。
