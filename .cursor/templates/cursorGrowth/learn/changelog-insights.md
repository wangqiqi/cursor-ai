# Changelog insights（项目特化）

> 由 **`/learn`** 从 `CHANGELOG.md` 增量摘要。对外行为变更的**项目视角**解读 + **重复工作模式**（防回归）。

## 当前版本

| 项 | 值 |
|---|---|
| 最新 tag | （待填） |
| 闭合 Sprint | （待填） |

## 近期要点

（`/learn` 每次发版或 Sprint 后更新）

## 重复工作模式（可选 · `/learn` 全量/增量审计时填）

> 定义：同症状/域多版本反复出现。通用防重复 rule 见 `i18n-copy.mdc` · `data-list.mdc` · `verify.mdc` §新增脚本门禁 · `async-progress.mdc` 等；**本节只写本项目符号与版本号**。

| 症状簇 | 出现版本 | 根因类型 | 状态 |
|--------|----------|----------|------|
| verify 脚本同断言重复（示例） | v1.2 · v1.3 | 未抽 `scripts/lib/` | open |
| 改菜单文案 E2E 挂（示例） | v2.0 follow-up | i18n 与 aria 未同步 | closed |

**填写提示**：

- **症状簇**：用户可见现象或 CHANGELOG 反复出现的动词（对齐/统一/verify 冗余）
- **根因类型**：对照 **learn** skill §症状簇→母版 rule 映射
- **状态**：`open` 待合并 Sprint / SPIKE；`closed` 已抽 rule 或合并脚本

## 建议下一 Sprint

（来自重复模式 + plan 候选，待用户确认）
