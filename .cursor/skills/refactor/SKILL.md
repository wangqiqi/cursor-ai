---
name: refactor
description: 安全重构 — 小步、可验证、最小 diff。
---

# refactor

## 原则

- 行为不变 refactor 与功能变更分 commit
- 每步后 `task-verify` / test 绿
- 匹配 `plan` 中 `REV-*` 或用户明确范围

## 常见动作

- 提取函数/模块；重命名用 IDE/工具链
- 去重复；缩小 public API

## 禁止

- 顺手改无关文件
- 无测试的大范围重写（先 `/plan`）
