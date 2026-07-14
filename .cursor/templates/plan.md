<!-- 工作副本：.cursorGrowth/plan.md（gitignore）· 模板 .cursor/templates/plan.md -->
<!-- PLANNING: false -->
<!-- SPRINT: (none) -->
<!-- PLAN_APPROVED: (none) -->
<!-- AUTONOMOUS: false -->
<!-- SPRINT_STATUS: closed -->
<!-- ACTIVE: (none) -->
<!-- NEXT: (none) -->
<!-- LAST_DONE: (none) -->
<!-- VERIFY: ./scripts/verify.sh -->
<!-- 禁止写 runner.sh verify — CLI 入口会读本行；指回自身会无限递归 -->
<!-- MAX_LOOPS: 15 -->
<!-- VERSION_LINE: (optional · major.minor，如 4.22；省略则 release-tag 读最新 v* tag) -->
<!-- VERSION_TARGET: (optional) -->

# Plan

无 Active Sprint / 未完成任务。新开 → `/plan`。Sprint 闭合后：**`CHANGELOG.md`**（git）为可移植记录；Sprint 笔记仅**写入**本地 `.cursorGrowth/archive/`（母版/培训文档**不得**链具体 archive 文件名）。

---

## Active sprint · SPRINT-01 Example

（有进行中 Sprint 时保留本区块；**全部 ✅ 后整段删除**，勿留「已闭合」正文。）

**Goal**: …

**Done when**（示例 — 勾选适用项）:

- P0 tasks ✅ · `bash ./scripts/verify.sh`（或 plan `VERIFY`）
- （可选）交付走查无 Blocker
- （可选）`/release` §分支 · `/release` §打版

**Out of scope**（可选）: …

| ID | Task | Priority | Status | Acceptance | Target |
|----|------|----------|--------|------------|--------|
| TASK-001 | Example feature | P0 | ⬜ | `./scripts/test.sh` | `src/` |

**执行顺序**: `TASK-001` → …

---

## 下一 Sprint · （候选 · 待 `/plan`）

| 候选 | Goal | 依赖 |
|------|------|------|
| SPRINT-02 | … | … |
