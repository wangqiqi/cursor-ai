---
name: finish
description: 分支收尾（/finish）：Sprint/Task 完成后 merge/PR/保留/丢弃 4 选 1。说「收尾」「merge」「开 PR」「分支怎么办」时用。衔接 run Sprint 归档与 git skill。
disable-model-invocation: true
---

# finish

Sprint/Task 代码已绿、**run** 审计通过后，决定 **如何汇入主轨**。不替代 **git** · **release** · **ship**。

```bash
./.cursor/bin/runner.sh task-verify   # 或 verify（Sprint 收尾）
git status && git diff --stat
```

## 前置

- [ ] 当前 ACTIVE 或 Sprint P0 已 ✅（或用户明确只做分支收尾）
- [ ] 验收命令已实际执行
- [ ] 无意外脏文件 · 无密钥
- [ ] **UI/功能 Sprint**：**建议**先 **`/delivery`**（见 **delivery** skill）；有 **Blocker** 须在 AskQuestion 前报告，不静默 merge/PR

## 流程

**Verify** → **（建议）delivery 走查** → **AskQuestion（4 选 1）** → **执行** → 可选 **worktree 清理**（见 **git** skill）

delivery 为 **推荐**非强制；plan **Done when** 含 `delivery 无 Blocker` 时视为必须满足。

### 选项（正常 feature 分支）

| # | 选项 | 动作 |
|---|------|------|
| 1 | 本地 merge | checkout 基线分支 · merge feature · 跑 verify · 删本地 feature（用户确认后） |
| 2 | Push + PR | `git push -u origin HEAD` · `gh pr create`（Summary + Test plan · 含 TASK ID） |
| 3 | 保留分支 | 仅 push 或保持现状；不 merge、不删 worktree |
| 4 | 丢弃 | **须用户明确打字确认**；禁止静默 force/reset |

Detached HEAD / 无名分支：仅呈现选项 2–4 或等价说明。

### 与 run 分工

| 时机 | run | finish |
|------|-----|--------|
| 单 TASK ✅ · 更新 plan | ✅ | |
| Sprint 全 ✅ · archive | ✅ | 可选接着 **finish** |
| merge / PR / 丢弃决策 | | ✅ |

PR 生命周期（评论、CI、拆 PR）：`babysit` · `split-to-prs`（经 **master** → `more` → `git`）。

## 禁止

- 共享/默认分支 `push --force`（除非用户明确）
- `reset --hard` · `clean -fdx` 无确认
- 跳过 verify 直接 merge
