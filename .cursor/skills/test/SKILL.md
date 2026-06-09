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

## Playwright / E2E（若栈具备）

- 测行为与可见结果，非 DOM 实现细节
- 本地：`npx playwright test` 或项目 script
- 先起 dev server 或使用 `webServer` 配置

## 纪律

- 红测不 ✅ task
- 新 bug 优先补回归
- 与 **debug** skill 配合：复现 → 绿测 → 提交
