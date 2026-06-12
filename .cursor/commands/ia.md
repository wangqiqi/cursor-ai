---
description: 信息架构（IA）规划与审查 — 工作流正交、角色入口、分支点（加载 ia skill）
---

加载 skill **ia**：

1. 读 `rules/execution/ia.mdc`（R1–R4 · C1–C4 · 反模式）
2. 读项目实例（若有）：`docs/design/*信息架构*` · `docs/design/*-ia.md`
3. 只读摸清：路由/侧栏 · 默认着陆 · RBAC · 用户抱怨（迷路 / 拼凑 / 非最短路径）
4. 产出或更新 `docs/design/<产品>-ia.md`（工作流 · 角色矩阵 · 分支点 · ASCII）
5. 实现 TASK → 须用户确认后 **`/plan`**；**ia 默认不写业务代码**

**衔接**：表现层 / i18n 验收 → **delivery** §5；体验类型不明 → **`/ux`** 先分流。
