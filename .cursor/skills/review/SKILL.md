---
name: review
description: >-
  代码/PR 结构化回顾（/review · REV-*）— 范围·正确性·安全/API·可测性·可维护性。
  可委派 review agent（只读）。≠ 全局 skills-cursor/review（Bugbot/Security）；安全专项用 security。
---

# review

**用这个**：`REV-*`、合并前结构化回顾、坏味道/复杂度扫读。**不是那个**：只跑 Bugbot/Security → 全局 `~/.cursor/skills-cursor/review`；安全深挖 → **security**；上线 7 维走查 → **delivery**；找根因修 bug → **debug**。

可委派 **review** agent（只读）。本 skill 管清单与输出格式。

## 输出格式

严重度（Blocker / High / Medium / Low）· `file:line` · 发现 · 建议

## 结构化清单

### 范围

- [ ] 符合 PR / REV 描述；无 drive-by 重构
- [ ] 落点与 plan Target 一致（若有）

### 正确性

- [ ] 边界与失败路径清楚；无吞异常 / 空 catch
- [ ] 并发、幂等、空值等与域相关的陷阱已考虑（有则查）

### 安全 / API（触发再扫）

- [ ] 高风险 diff（auth、密钥、对外 API、注入面）→ 叠加 **security** · **api** skills
- [ ] 无硬编码密钥；对外契约变更有文档/兼容说明

### 可测性

- [ ] 行为变更有对应测试或明确验收命令
- [ ] 纯 UI/文案可注明「手工/delivery」覆盖

### 可维护性

- [ ] 命名与模块边界清晰
- [ ] 重复逻辑 / 过长函数 / 深嵌套
- [ ] 复杂度与注释匹配意图（非噪声注释）

### 交付叠加（可选）

- [ ] `REV-*` 含交付/上线 → 叠加 **delivery** 7 维（+ 可选 §8–§11）（只读）

## 与 plan

- 纯回顾不写代码 → `REV-*`；`next-task` 跳过但 gate 仍适用编码任务
- 交付走查 REV → 输出含 **`Decision needed`** 的文档冲突项（见 **delivery**）
