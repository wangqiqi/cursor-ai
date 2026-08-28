# master · 路由表

AskQuestion 选项与关键词 → 下游 skill / agent / rules。  
无 AskQuestion 工具时：同表**正文编号选项**（见 **master**「AskQuestion 约定」）。  
与 `.cursor/README.md` **场景速查** 对齐；详表在本文件，README 为摘要链。

## 主路由（第 1 轮 · ≤7 项）

| 选项 id | 意图 | 入口 | 关键词（中英） |
|---------|------|------|----------------|
| `scaffold` | 新建 / 空项目 | **scaffold** `/scaffold` | 脚手架、初始化、空仓库、new project、bootstrap |
| `plan` | 规划 / Sprint / 调研 / 文档 | **plan** `/plan` | 规划、需求、Sprint、SPIKE、DOC、归档 |
| `run` | 继续开发 | **run** `/run` | 继续、做任务、ACTIVE、next task |
| `learn` | 了解本仓 | **learn** `/learn` | 本仓约定（**不是** study 学技术） |
| `fix` | bug / 验收 / 闸门 | bugfix · **run**/**plan** | bug、hotfix、verify 失败、gate-check、卡住 |
| `ship` | 发版 | **release** · **ship** | 打版、发版、CHANGELOG、tag、release |
| `more` | 审查 / 文档 / 依赖 / 配置 | 见下表 | commit、PR、security、api、submodule、config |

## `more` 子路由（第 2 轮 · ≤7 项）

| 子 id | 意图 | 入口 | rules / 命令 |
|-------|------|------|----------------|
| `git` | Git / PR / Review / 收尾 | **git** · **release** · **review** · `babysit` · `split-to-prs` | `commit.mdc` · collaboration |
| `pr` | PR 描述 / Review / babysit | **git** · **review** · `babysit` | collaboration |
| `security` | 安全审查 | **security** | — |
| `api` | API 设计 | **api** | `rules/execution/api.mdc` |
| `delivery` | 交付验收 / 上线前 | **delivery** · `/delivery` | **用这个**上线走查；**不是** ia 规划 |
| `manual` | 使用说明书 / 配图 regen | **user-manual** `/manual` | **用这个**可发布操作手册；**不是** delivery 走查 |
| `report` | 测试报告 / verify 汇总 | **test-report** `/report` | **用这个**可发布测试报告；**不是** test 写用例 |
| `ux` | UX / 体验不好 / 界面乱（未明 IA/交付） | **ux**（无 slash） | **用这个**分流；明导航→**ia** · 明上线→**delivery** |
| `ia` | 信息架构 / 导航迷路 / 角色首页 | **ia**（无 slash） | **用这个**结构层；**不是** delivery 视觉抛光 |
| `docs` | 文档同步 / 卫生 / ROADMAP | **plan** `DOC-*` 或直述 | `docs.mdc` · **`doc-hygiene.mdc`**（断链 · archive 分工 · 门面计数） |
| `deps` | 依赖 / 选型 / vendor / submodule / **外网 Agent Skill** | 直述 + 规范 | `oss-first.mdc` · `submodule.mdc` · **security** §外部 Agent Skill · §DAILY/LIBRARY |
| `config` | verify / 本地 rules / 母版自测 | 见 [扩展场景](#扩展场景) | `config/workflow.json` |
| `style` | 人格 / 沟通语气 | `config/roles.json` | 见 [人格预设](#人格预设-style) |

## 外网 skill · DAILY / LIBRARY（`deps`）

**用这个**：安装 Super Cursor 或外网 skill 后，按**本仓证据**裁剪默认加载面，避免全量噪音。**不是那个**：发现 skill 商店 → 上表 `deps` + **security** 审计；学本仓约定 → **learn**。

吸收自 SkillsMP `agent-sort`（协议 only，不装 ECC）。

| 桶 | 含义 |
|----|------|
| **DAILY** | 每会话强相关 — 与本仓语言/框架/workflow 明确匹配，值得默认启用 |
| **LIBRARY** | 保留可达、**不**默认全载 — 离栈、偶用、或上下文开销大于收益 |

**证据来源**（分类前必读仓库）：扩展名 · lockfile · `package.json` / `pyproject.toml` / `go.mod` · 框架配置 · CI · `scripts/test.sh` · `.cursorGrowth/learn/module-map.md`。

**分类规则**：

- 晋升 **DAILY**：栈在用 + 每任务都可能用到（如活跃栈的 `rules/tech/*`、**plan**/**run**/**learn**）
- 降级 **LIBRARY**：离栈 tech rules、未用的 **perf**/**mcp**、一次性 **study** 主题、外网 skill 仅偶发场景

**输出**（给用户或写入 `learn/dev-conventions.md` 一句）：

```text
DAILY   — 路径 + 证据
LIBRARY — 路径 + 何时手动选用
```

安装外网 skill 到 `~/.cursor/skills/` 前仍走 **security** §外部 Agent Skill；**禁止**引入第二套安装 CLI 作为母版必选路径。

### 外网 LIBRARY 详表（SSOT 外链）

**不默认加载**；用户意图命中 `deps` 或关键词时引用 — **勿在本文件双写大表**：

| 来源 | SSOT |
|------|------|
| anthropics/skills · SkillsMP | **`docs/library-index.md`** §anthropics |
| github/spec-kit（SDD） | **`docs/library-index.md`** §spec-kit · **`plan/reference/sdd/source-map.md`** |
| SpaceZephyr/pm-skills | **`docs/library-index.md`** §pm-skills |

**Office 深度编辑** — AskQuestion（≤3 项）：`装 upstream anthropics skill` · `用 MCP/飞书等` · `本轮不做`

**产品预置链路**（PRD → 预审 → 埋点）：**plan** §协作文档 · **review** §文档预审 · **delivery** §埋点 — 用户只要一步则只 handoff 对应 skill。

## 人格预设 (`style`)

> **仅改语气/性格，全员 `skills: full`（同等全能）**；默认 `dashu`。12 项分两轮 AskQuestion（每轮 ≤7）。

每人字段：`id` · `role_name` · `nicknames[]` · `given_name` · `voice_cues` · `personality` · `tone` · `attitude` · `intensity` · `speech_examples` · `skills`（全员 `full`）。

| 字段 | 用途 |
|------|------|
| `given_name` | 用户点名匹配 |
| `voice_cues` | 落地语气 |
| `speech_examples` | 句式锚点 |

全局 `speech_rules.forbid_self_name_opener` → **super-cursor-persona.mdc**。呼叫流程 → `resolve-role.sh` · `.cursorGrowth/session/persona.json` · `config/roles.json`。

**轮 1**：`professional` · `zhiyin` · `tough_guy` · `strict` · `old_master` · `dashu` · `pretty_boy` — **轮 2**：`loli` · `maid` · `tsundere` · `seductive` · `queen`

## 扩展场景

README 场景速查中无独立主菜单、经 `more` → `config` 或关键词命中：

| 我想… | 路由 |
|-------|------|
| 配置或排查 verify | `config/workflow.json` · `./.cursor/bin/runner.sh verify` · `rules/feedback/verify.mdc` |
| 加项目私有 rules | `.cursor/rules/local/`（目标项目自建，不 commit 进母版） |
| 验证 Super Cursor 母版 layout | `bash .cursor/verify-super-cursor.sh`（混合仓自动 hybrid · 纯空仓 mother） |
| 验证母版交叉自洽（安装后项目） | `bash .cursor/bin/cursor-coherence.sh` |
| 母版全量验收 | `bash .cursor/bin/template-verify.sh`（须用户明确授权才改母版 `.cursor/`） |
| 自治 Sprint 连跑 | **plan** handoff `AUTONOMOUS:true`（默认）→ **`/run` 一次** → 同会话连跑 TASK；决策清单见 `autonomy-chain.md` |
| Epic 长程 · 多 Sprint | **`/long`** → Epic 拆 Sprint → 每 Sprint **plan**+**run** → checkpoint；详 **long** skill |
| 仅要规范不要闸门 | `workflow.json` → `workflow.enabled: false`（`rules-only` profile） |
| 技术栈开发细则 | **run**/**plan** 执行时自动加载 `rules/tech/*` glob |

## 关键词索引

无 slash · LIBRARY 工具 skill 与扩展路由 — **本表为 canonical**（勿与已删「扩展 skill 路由」节双写）：

| 关键词 | 路由 |
|--------|------|
| 调试、隔离、根因 | **debug** |
| 测试、E2E、Playwright | **test** |
| MCP、工具服务器 | **mcp** |
| 重构 | **refactor** |
| UX、体验、不好用、界面乱 | **ux** |
| 信息架构、导航、迷路、Dashboard | **ia** |
| 性能、慢、瓶颈 | **perf** |
| 代码回顾、REV | **review** · **review** agent |
| 学新技术、study | **study**（≠ `/learn`） |
| 调研只读、SPIKE | **spike** · **plan** `SPIKE-*` |
| help、从哪开始、不知道、怎么用 | **master**（已在 master 内则继续子问） |
| 脚手架、空仓库、初始化 | **scaffold** |
| 规划、Sprint、拆任务、TASK | **plan** |
| 调研、POC、可行性、SPIKE | **plan** · `SPIKE-*` |
| 只写文档、README、DOC | **plan** · `DOC-*` · `docs.mdc` |
| doc 卫生、ROADMAP 膨胀、断链、门面计数 | **doc-hygiene.mdc** · `more` → docs |
| 使用说明书、配图、manual regen | **user-manual** `/manual` |
| 测试报告、QA 报告、全量回归报告 | **test-report** `/report` |
| 归档、ROADMAP、Sprint 做完 | **plan** · `archive/` |
| 继续、实现、ACTIVE | **run** |
| 长程、Epic、多 Sprint、全自动做到底、long resume | **long** `/long` |
| 了解项目、learn、模块地图 | **learn**（≠ study） |
| bug、hotfix、线上、报错 | **fix** → bugfix |
| 验收失败、verify 红、task-verify | **fix** → verify.mdc · **run**/**plan** |
| gate-check、PLAN_APPROVED、被挡 | **fix** → **plan** |
| 发版、CHANGELOG、tag | **ship** → release / ship |
| commit、push、分支 | **more** → **git** |
| PR、Review、合并请求 | **more** → **git** · **review** · **release** · `babysit` |
| 分支收尾、merge、发版 | **release** · **git** |
| 拆 PR、split | `split-to-prs` · **more** → **git** |
| 密钥、PII、鉴权、安全 | **more** → **security** |
| REST、OpenAPI、接口 | **more** → **api** |
| 交付验收、上线前、生产就绪、i18n、视觉一致性 | **more** → **delivery** · `/delivery` |
| 周报、本周总结、CHANGELOG 汇总 | **week**（无 slash · 关键词） |
| 磁盘快照、空间占用、哪个目录变大 | **disk**（无 slash · 关键词） |
| 环境维护、清理磁盘、dev maintenance | **maintain**（无 slash · 关键词） |
| docker compose、env 模板、nginx、部署 | **ops-deploy**（无 slash · 关键词） |
| 代码统计、代码量、语言分布、提交日历、仓库分析 | **code-stats-viz**（无 slash · 关键词） |
| 做设计、mockup、视觉稿、.pen、海报、banner、App 屏 | **pencil-design**（无 slash · 关键词） |
| submodule、vendor、依赖升级、开源选型、许可证、MIT、GPL | **more** → `deps`（`oss-first.mdc` · `submodule.mdc`） |
| 外网 skill、安装 skill、发现 skill、有没有能做 X 的 skill | **more** → `deps` → **security** §外部 Agent Skill；个人目录安装须用户确认 |
| DAILY、LIBRARY、裁剪 skill、精简规则、skill 太多、全量安装 | **more** → `deps` §DAILY/LIBRARY；结论可写入 **learn** |
| workflow.json、hooks、profile | **more** → config |
| 本地 rules、local | **more** → `.cursor/rules/local/` |

## 上下文捷径

| 检测信号 | 优先建议 |
|----------|----------|
| `scaffold.sh detect` → empty | **scaffold** |
| 无 `plan.md` 且要做功能 | **scaffold** 或 **plan**（AskQuestion） |
| `gate-check` OK 且有 ACTIVE | **run** |
| `gate-check` BLOCK | **plan** 或 **fix** → 闸门 |
| `PLANNING:true` | **plan**（继续规划） |
| `task-verify` / `verify` 失败 | **fix** → **run**；仍失败 **plan** `⚠️` |
| 用户贴 CHANGELOG / 说升版本 | **ship** |
| 母版仓库 / 改 `.cursor/` 验收 | `template-verify.sh` · 混合仓 layout 用 `verify-super-cursor.sh`（hybrid 自动） |

## 推荐路径

空仓库: `master → scaffold → learn → plan → run` · 迭代: `plan → run` · 卡住: `fix → run/plan` · 迷路: `master`（≤7 项）

## 文档

[quickstart](../../docs/quickstart.md) · [walkthrough](../../docs/walkthrough.md) · [training/skills](../../docs/training/skills.md) · [plan-run](../../docs/plan-run.md) · [README 场景速查](../../README.md)
