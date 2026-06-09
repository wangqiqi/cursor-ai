<!-- 复制到仓库根 plan.md · 该文件在 .gitignore · 勿 git commit -->
<!-- PLANNING: false -->
<!-- SPRINT: SPRINT-01 -->
<!-- PLAN_APPROVED: YYYY-MM-DD -->
<!-- AUTONOMOUS: false -->
<!-- SPRINT_STATUS: active -->
<!-- ACTIVE: TASK-001 -->
<!-- NEXT: TASK-001 -->
<!-- LAST_DONE: (none) -->
<!-- VERIFY: ./scripts/verify.sh -->
<!-- MAX_LOOPS: 15 -->
<!-- VERSION_TARGET: (optional) -->

# Plan

> **plan 双态**：HTML 注释（`ACTIVE` / `LAST_DONE` / `SPRINT_STATUS`）供 `runner.sh` 解析；**Done when**、TASK ✅、基线矩阵等正文须在 Sprint 收尾时与 archive 对齐（见 **run** skill · plan 正文 reconciliation）。

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

- Move completed sprint notes to `archive/` with timestamped filenames (`YYYYMMDD_HHMMSS_功能_模块_sprint闭环.md`).
- Sprint 收尾：`SPRINT_STATUS: closed` · Done when 全 `[x]` · TASK 全 ✅ · 标题改「已完成 Sprint」· 历史表补归档链（**run** skill reconciliation 清单）。
