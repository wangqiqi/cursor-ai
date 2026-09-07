# Plan & archive conventions（项目特化）

> 由 **`/learn`** 维护 · 供 **plan** · **run** · `runner.sh plan-check` 参考。  
> **勿**写入 `.cursor/rules` 或 skills 正文 — 团队差异只放本文件。

## Archive 命名与分级

| 项 | 本项目 |
|----|--------|
| 目录 | `.cursorGrowth/archive/{domain}/` — **禁止**长期 flat 堆根目录 |
| 格式 | `YYYYMMDD_HHMMSS_<topic>_<module>.md` |
| 说明 | `<topic>` / `<module>` 用英文或拼音缩写，避免空格 |
| 域表 SSOT | 母版推荐桶见 **plan** `reference/growth-layout.md`；团队增量填下表 |

### 本项目 archive 域（在母版推荐表上增删）

| `domain` | 用途 |
|----------|------|
| `sprint` | Sprint 闭合摘要 |
| `spike` | SPIKE / 调研 |
| `release` | 发版笔记 |
| `doc` | 文档 Sprint |
| （待填） | … |

## Plan 可选段落（若有）

团队在 plan 中使用的**额外**基线段落（差距表、审查笔记等）在此登记；Sprint 收尾须与 `.cursorGrowth/archive/{domain}/` 对齐：

| 段落类型（团队自定） | 收尾动作 |
|----------------------|----------|
| （待填） | 改 **交付态**，或链 `.cursorGrowth/archive/{domain}/...` 作历史快照 |

## Sprint 区块标题

`runner.sh plan-check` 在 Sprint 闭合时会 WARN 仍为「进行中」标题的区块：

| 状态 | 标题示例（任选一种语言，团队统一即可） |
|------|----------------------------------------|
| 进行中 | `Active sprint` · `活跃 Sprint` |
| 已闭合 | `Completed sprint` · `已完成 Sprint` |

## 与母版分工

| 层 | 内容 |
|----|------|
| `.cursor/` | 通用机制：`SPRINT_STATUS` · Done when · TASK ✅ · reconciliation 清单 · **growth-layout** SSOT |
| 本文件 | 归档命名 · **团队域表** · 可选段落类型 · 标题用语 |
