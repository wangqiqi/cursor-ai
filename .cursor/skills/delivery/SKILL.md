---
name: delivery
description: 交付验收（/delivery）：视觉 · i18n · 文档对齐 · 后端对接 · 组件完整度 · 可维护性 · 生产就绪。Sprint 收尾或 /release 分支前走查。说「交付验收」「上线前检查」「生产就绪」时用。
---

# delivery · 交付验收

**用这个**：功能已绿、要上线前 7 维走查。**不是那个**：还在规划导航结构 → **`/ia`** / **`/ux`**；自动化脚本绿/红 → **verify** / **run**（本 skill 不替代）。

功能已实现、**task-verify** 已绿之后，在 **`/release`**（merge/PR）或 Sprint **Done when** 要求时，做 **7 维度**走查。不替代 **run** 三公理审计或自动化 **verify**。

项目特化路径（design tokens、i18n 库、OpenAPI 位置）→ `.cursorGrowth/learn/acceptance.md`（若无则 **AskQuestion** 或 grep 惯例）。

## 何时进入

- 用户说 **`/delivery`** · 「交付验收」「上线前检查」「生产就绪」
- **release** §分支前：UI/功能 Sprint **建议**先走一遍（见 **release** skill）
- plan **Done when** 含 `delivery 无 Blocker`
- `REV-*` 任务范围含交付走查 → 可委派 **review** agent（只读）+ 本清单

## 流程

1. 读 `learn/acceptance.md`（若有）· 扫 `plan.md` Sprint Goal / Done when
2. 按下方 **7 条**逐项检查（grep · Read · 对照 docs/OpenAPI）
3. 第 4 条 API 子集 → 对照 **api** skill
4. 第 7 条 → 对照 **security** skill · `security-sdlc.mdc`
5. 输出报告；**Blocker** 须用户决策后再 **release**

## 输出格式

与 **review** 一致，每条一行：

```text
严重度 · file:line · 发现 · 建议
```

| 严重度 | 含义 |
|--------|------|
| **Blocker** | 不可 merge/上线；须修或用户明确接受风险 |
| **High** | 应在本 Sprint 内修 |
| **Medium** | 可跟 issue；不挡 release |
| **Low** | 风格/ nit |

**文档 ↔ 实现冲突**（第 3、4 条）须标 **`Decision needed`**，列：

- 文档说法 · 实现现状 · 建议 · **等你决策**（Agent 不擅自改 spec）

## 清单（7 维）

### 1. 视觉一致性

- [ ] 字体大小、字重、行高与 design system / 邻近页面一致
- [ ] 颜色来自 token/变量，非 scattered 硬编码（grep `#` · `rgb(` · 魔法数 px 字号）
- [ ] 间距、圆角、阴影与组件库或现有页面一致
- [ ] 响应式/暗色（若项目有）未遗漏

### 2. 国际化（i18n）

> 项目路径/库名 → `.cursorGrowth/learn/acceptance.md`（模板见 `templates/cursorGrowth/learn/acceptance.md`）。

**何时跳过（须在走查报告写明）**：纯内部 CLI/库、无用户可见 UI、或团队书面确认「本版不交付多语言」。跳过 ≠ 忽略：单语产品仍检查**无硬编码散落**与术语一致。

- [ ] 用户可见文案均走 i18n API（`t` / `$t` / `useTranslation` 等）— 有 i18n 栈时
- [ ] 无遗漏字面量（grep 中文/英文 UI 字符串 vs key 文件）
- [ ] 新增 key 在各 locale 文件齐全；无空翻译
- [ ] 日期/数字/复数格式符合 locale
- [ ] 错误/toast/空态文案同样走 i18n（与 `error-context.mdc` 用户可见句对齐）
- [ ] **Acceptance 指针**：改 i18n 库或 locale 目录时，同步更新 `learn/acceptance.md`

### 3. 文档 ↔ 实现（双向）

- [ ] 规格/README/用户文档描述的行为，代码已实现
- [ ] 已实现能力在文档中有对应说明（非仅代码自解释）
- [ ] 冲突 → **`Decision needed`**，等你拍板后再改文档或代码

#### 脚本化 vs 人工（doc-coherence）

| 手段 | 用途 |
|------|------|
| **`docs/scripts/verify_doc_*.sh`**（见 `rules/execution/docs.mdc`） | 断链 · 版本锚点 · 防回退 grep — **可写进 plan 验收列** |
| **本 §3 清单** | 语义完整 · 读者可读 · 冲突上报 |

DOC Sprint 的 Done when：**脚本绿** + delivery §3 **无 Blocker**（若用户可见）。

### 4. 后端对接 · API · 数据

- [ ] 接口文档（OpenAPI/README）**便于后端/前端并行对接**：示例请求/响应、错误码表、鉴权说明齐全
- [ ] 字段、类型、枚举、分页风格完整无歧义
- [ ] 实现与文档一致（跑 **api** skill 子集）
- [ ] DB/schema/migration 与文档一致；**最佳实践**：命名一致、合理范式、必要索引、FK 有意图、nullable 有说明、避免无界 JSON  blob
- [ ] Mock/fixture 与生产 schema 一致
- [ ] 冲突 → **`Decision needed`**

### 5. 组件与交互完整度

#### 导航与 IA（结构层 UX）

> 原则：`rules/execution/ia.mdc` R1–R4 · 项目 `docs/design/*-ia*`（若有）。规划阶段应已走 **ia** skill。

- [ ] 主要页面可一句话说出 **主工作流意图**（无 Dashboard 多工作流并列主 CTA）
- [ ] 角色若有差异：**默认着陆** / 侧栏权重与 RBAC 一致（非人人同一首页叙事）
- [ ] 跨页协作经 **分支点**（深链 / `from` / 来源条），不在 drawer 内嵌无关工作流表单
- [ ] 多步交付类具备可辨识的 **实体上下文**（顶栏或面包屑中的当前对象）

#### 组件与状态

- [ ] 无 TODO/FIXME/placeholder 交互留于生产路径
- [ ] **真实交互感**：操作有即时反馈（hover/focus/disabled/loading）；非静态假按钮
- [ ] 加载/空态/错误态有 UI，非白屏或 `console.log`
- [ ] 表单校验、禁用态、提交反馈完整
- [ ] Dialog/Drawer 非 demo 级（标题、确认、取消、遮罩/ESC 行为符合产品预期）

### 6. 扩展性与维护性

- [ ] 新功能落在正确模块层；未破坏现有分层
- [ ] 改动能用最小 diff 描述；无无关 drive-by 重构（对照 **scope** · **review**）
- [ ] 配置/特性开关（若有）便于扩展

### 7. 生产就绪

- [ ] 无 debug 开关、mock 数据、测试账号残留于生产路径
- [ ] 权限/鉴权与 **security** 要点一致
- [ ] 日志不含 PII/密钥；错误信息对用户友好
- [ ] 与 `./scripts/verify.sh` / 项目 verify 结果一致（已绿）

### 8. 长任务闭环（可选 · 含上传/导入/向导）

> 规则：`long-running-ui.mdc` · `async-progress.mdc` · `modal-layering.mdc`

- [ ] **完成态可见** — 100% 后用户能看到结果/「确定」，非 `loading=false` 即卸载
- [ ] **列表刷新** — 成功后目标列表/网格含新数据
- [ ] **决策层可操作** — 治理/确认弹窗不被进度层挡住
- [ ] **失败可理解** — `error_message`/`detail` 可见，非假死 0%（`error-context.mdc`）
- [ ] **可取消 / 可重试** — 长操作有出口；失败可重试或说明原因

### 9. 导入与破坏性操作（可选 · 含 restore / bulk import）

> 规则：`input-bounds.mdc`

- [ ] **预览 / dry-run** — 覆盖或合并前可看摘要（条数、冲突、将丢失项）
- [ ] **二次确认** — 破坏性 overwrite 须明确确认，非一键静默
- [ ] **事务或可回滚** — 写失败不留下半导入状态（存储层能力范围内）
- [ ] **冲突模式白名单** — 仅文档化策略（如 skip / overwrite / merge）

### 10. 浏览器走查（可选 · UI/功能 Sprint）

> 蒸馏自社区 visual QA / verifying-in-browser 思路；**不新建** skill。无障碍深挖 → **§11**。

**何时做**：UI/功能 Sprint、用户可见页面变更、**`/release`** 前建议。  
**何时跳过（须在报告写明）**：纯后端/库、无本地可开 URL、当前会话无浏览器/自动化能力。

**工具（有则用，无则跳过）**：Cursor 内置浏览器、或已配置且经用户批准的 browse 类 MCP（先 `GetMcpTools` 再调用；**禁止**擅自安装 MCP）。

- [ ] **打开目标** — 读 `learn/acceptance.md` 默认 URL（若有）或 AskQuestion；页面可达（非连接拒绝）
- [ ] **结构可见** — snapshot / 无障碍树或截图能辨认主 CTA、关键表单/列表（对照 §1 · §5）
- [ ] **控制台** — 无未处理 `error` / 未捕获异常（允许已知第三方噪声并注明）
- [ ] **网络** — 无关键失败的关键 API（4xx/5xx / failed）；重复请求异常须注明
- [ ] **轻量 a11y** — 主流程可键盘到达主按钮；明显缺 label → 记 Medium+，并建议跑 **§11**（完整清单见 §11）
- [ ] **跳过声明** — 若未跑本节：报告写「§10 skipped: …」

### 11. 无障碍（可选 · UI Sprint）

> 从 §10 轻量勾选加深；仍**不强制** axe / MCP / 第三方审计工具。

**何时做**：用户可见 UI 变更、Done when 要求 a11y、或 §10 已标出 label/键盘问题。  
**何时跳过（须写明）**：纯后端/库、无渲染 UI、团队书面确认本版不做 a11y。

- [ ] **键盘** — Tab 可达主流程控件；无键盘陷阱；焦点顺序合理
- [ ] **焦点可见** — 聚焦态可辨（非仅靠 hover 色）
- [ ] **语义 / label** — 按钮/输入有可访问名；图标按钮有 aria-label 或可见文本
- [ ] **对比度提示** — 正文/主 CTA 与背景目测可读；可疑低对比记 Medium+（不强制测工具）
- [ ] **跳过声明** — 「§11 skipped: …」

UI/功能 Sprint **建议** 在 **`/release`** 前勾选 §8；含导入/恢复时勾选 §9；有可开页面时勾选 §10；UI 变更建议 §11；纯后端可省略并声明。

## 与下游分工

| 阶段 | delivery | 不做 |
|------|----------|------|
| **ia** | — | 结构规划 · `docs/design/*-ia*`（先于大改） |
| **run** | — | 实现 · task-verify · 三公理审计 |
| **delivery** | 7 维走查 · 可选 §8–§11 · 冲突上报 | 不写业务代码（除非用户 steering 修 Blocker） |
| **release** | Blocker 须先报告 | 不跳过 verify |

UX 分流不明时 → **ux** skill；结构问题回流 **ia**，非结构抛光留在本 skill。

## 禁止

- 有 **Blocker** 仍建议 silent merge
- 文档冲突时擅自改 spec 或改实现而不 **`Decision needed`**
- 用 delivery 替代 **task-verify** 或跳过 **security** 对高风险 diff
