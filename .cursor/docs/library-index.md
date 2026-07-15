# 外网协议吸收 · 母版内索引

**SSOT**：本文件 + 各 skill `reference/` 落点。**不是** GitHub 仓库链接的操作手册。

许可与出处仅作记录；实现、流程、模板均在 `.cursor/` 内。

## anthropics/skills（协议已吸收）

| 远端 skill | 母版落点 | 用户自然语言 |
|------------|----------|--------------|
| mcp-builder | **mcp** · `reference/evaluation.md` | 建 MCP · Eval |
| webapp-testing | **test** · **debug** · `scripts/with_server.py` | E2E · Playwright |
| frontend-design | **delivery** §1 · **ux** 分流 | UI 像 AI 模板 |
| doc-coauthoring | **plan** · **run** 三阶段 · Reader Testing | PRD · RFC · 提案 |
| pdf（轻量 scripts） | **delivery** `scripts/pdf/` | PDF 表单验收 |
| skill-creator | **learn** 写作纪律 | 写 skill 方法论 |
| docx · pptx · xlsx | **未纳入**整包 | 建议用户自行安装 upstream 或 MCP |
| 创意/企业类 | **master** `routes.md` §LIBRARY | 按需 |

运行时可选矩阵副本 → `.cursorGrowth/learn/`（`/learn` 吸收，非母版必读）。

## github/spec-kit（SDD · MIT）

| 能力 | 母版落点 |
|------|----------|
| specify · clarify · plan · tasks | **plan** §SDD · `reference/sdd/` · `templates/sdd/` |
| analyze | **review** §SDD analyze |
| implement · converge | **run** |
| principles（≠三公理） | `principles-template.md` · `workflow.json` `sdd` |
| specify-cli · extensions | **未纳入**；用户自选 CLI |

详映射 → `skills/plan/reference/sdd/source-map.md`。

## SkillsMP / 社区（协议已吸收）

| 参考名 | 母版落点 |
|--------|----------|
| code-review | **review** Standards/Spec 双轴 |
| autoreview | **run** closeout review |
| testing-patterns | **test** factory/mock |
| agent-introspection-debugging | **debug** 内省 |
| agent-sort | **master** / **scaffold** DAILY/LIBRARY |

版本记录：发版时写入仓库根发版日志（**release** skill；母版 skill 正文不链该文件）。

## 安装外网 skill 前

**security** §外部 Agent Skill · **master** → `deps` · 用户确认后装 `~/.cursor/skills/`。
