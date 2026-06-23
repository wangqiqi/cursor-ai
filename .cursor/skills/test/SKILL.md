---
name: test
description: 测试清单 — 单测、集成、E2E、TDD 红绿重构；衔接 verify。说「写测试」「TDD」「Playwright」时用。
---

# test

验收优先 plan 列命令；无列则用项目 `./scripts/test.sh` 或 stack 默认。测试文件细则 → `rules/execution/testing.mdc`。

## TDD 短环（功能 / bugfix）

1. **红** — 写失败测试（或复现用例），运行确认失败
2. **绿** — 最小实现使测试通过
3. **重构** — 在绿测保护下整理；不扩 scope

与 **run** 一致：红测不 ✅ task · 须实际运行 `task-verify`。

## 层级

| 类型 | 何时 |
|------|------|
| 单元 | 纯逻辑、utils、hooks |
| 集成 | API、DB、模块边界 |
| E2E | 关键用户路径（Playwright/Cypress 若项目已有） |

## 验收脚本分层（verify-layers）

与 `rules/feedback/verify.mdc` 对齐；**母版不写项目路径**，坐标记入 `.cursorGrowth/learn/dev-conventions.md`。

| 层 | 测试侧重 | plan 验收列示例 |
|----|----------|-----------------|
| L0 | 文件/配置存在 | `test -f path/to/module` |
| L1 | pytest / vitest / go test 单测+import | `bash scripts/verify_<feature>.sh` |
| L2 | migration head · schema 断言 | 同上脚本内（可选） |
| L3 | `--full` 集成 / curl 冒烟 | `bash scripts/verify_<feature>.sh --full` |

- 新功能域：**优先** L1 进 `task-verify`；L3 进 Sprint Done when 或 nightly
- 红测停在 L1 即可标 🔧；**勿**为 ✅ 跳过 L1 直接跑 L3
- 聚合脚本仅编排，不测业务逻辑（见 verify.mdc）

## Playwright / E2E（若栈具备）

- 测行为与可见结果，非 DOM 实现细节
- 本地：`npx playwright test` 或项目 script
- 先起 dev server 或使用 `webServer` 配置

## 纪律

- 红测不 ✅ task
- 新 bug 优先补回归
- 与 **debug** skill 配合：复现 → 绿测 → 提交
