# Super Cursor — `.cursor/`

通用 SOP 目录。安装到目标项目后默认**只读**；项目认知 → `.cursorGrowth/learn/`（git 忽略）。

## 结构

| 始终加载 | `rules/core.mdc` · `rules/workflow.mdc` |
| 按需 | skills · glob rules · `learn/` |

```
rules/   communication · execution · feedback · tech
skills/  master plan run learn scaffold git finish release security api ux ia debug test mcp refactor perf review study delivery
commands/ ux ia delivery
agents/  ship review spike
hooks/   growth-init run-start run-stop
config/  workflow.json release.json roles.json
bin/     runner.sh scaffold.sh install-smoke.sh cursor-coherence.sh platform-check.sh template-verify.sh
lib/     platform.sh（跨平台工具）
templates/scaffold/   manifest + stack templates
```

```bash
bash .cursor/bin/template-verify.sh          # 母版全量（推荐）
bash .cursor/verify-super-cursor.sh          # layout 存在性
bash .cursor/bin/cursor-coherence.sh         # 交叉自洽
bash .cursor/verify-system.sh                # 同上 layout（alias）
```

命名：[docs/naming.md](docs/naming.md)

## 入口

| Command | Skill / Agent |
|---------|---------------|
| `/master` | master（不确定时 — AskQuestion 路由） |
| `/plan` | plan（≠ IDE Plan 模式） |
| `/run` | run |
| `/learn` | learn |
| `/scaffold` | scaffold（8 栈 / audit） |
| `/ux` | ux（体验分流 → ia / delivery） |
| `/ia` | ia（信息架构 · UX 结构层） |
| `/delivery` | delivery（7 维交付验收） |
| Git 提交 | git skill |
| 安全审查 | security skill |
| API 设计 | api skill |
| UX / 体验分流 | **ux** skill · `rules/execution/ux.mdc` |
| 信息架构 / 导航 | **ia** skill（UX 结构层）· `rules/execution/ia.mdc` |
| 发版清单 | release skill |
| 自治发版 | **ship** agent |

## 使用场景

完整路由与关键词索引 → **`skills/master/routes.md`**（master AskQuestion 的 canonical 源）。  
培训速查 → [docs/training/skills.md](docs/training/skills.md) · 端到端示例 → [walkthrough.md](docs/walkthrough.md)。

### 推荐路径

```
空仓库:  /master → /scaffold → /learn → /plan → /run → verify
迭代:    /plan → /run（循环）
卡住:    /master → fix → /run 或 /plan
迷路:    /master（主菜单 7 项 → 子路由）
```

### 技术栈细则（glob 自动加载）

| 类别 | 规则 | 典型 glob |
|------|------|-----------|
| 前端 | `typescript` · `react` · `vue` · `nextjs` · `eslint` · `javascript` | `*.ts(x)` · `*.js(x)` · `*.vue` |
| 后端 / 系统 | `python` · `go` · `rust` · `java` · `cpp` · `c` | `*.py` · `*.go` · `*.rs` · `*.java` · `*.{c,cc,cpp,h,hpp}` |

治理：`constitution.mdc` · `evolution.mdc` · `config/roles.json`（12 人格，仅语气）。  
扩展 skills：**ux** · **ia** · **debug** · **test** · **review** · **study** · **delivery** · **mcp** · **refactor** · **perf**（入口见 `core.mdc`）。

### 场景速查

| 我想… | 推荐入口 |
|-------|----------|
| **不知道用什么 / 刚上手** | **`/master`** |
| 让 Agent 了解这个项目 | `/learn` |
| 空项目创建脚手架 | `/scaffold` |
| 已有项目改进建议 | `/scaffold` → audit |
| 拆需求、写 Sprint | `/plan` |
| 按任务实现并提交 | `/run` |
| 修线上 bug | 描述问题 + bugfix rules；复杂则 `/plan` |
| 任务卡住 / 验收失败 | `runner.sh gate-check` · 回流 `/plan` |
| 写 PR / 回应 Review | **git** · **review** · `collaboration.mdc` |
| 交付验收 / 上线前走查 | **delivery** · `/delivery` · **finish** 前建议 |
| 文档随代码一起改 | `docs.mdc`；术语地图 → `/learn` |
| 升级 submodule / vendor | `submodule.mdc` |
| 规范地 commit | **git** · `commit.mdc` |
| 做调研 / 只写文档 | `SPIKE-` / `DOC-` · **spike** agent |
| Sprint 做完归档 | `archive/` + ROADMAP · 见 **run** skill Sprint 收尾 |
| 配置或排查 verify | `workflow.json` · `runner.sh verify` · `verify.mdc` |
| 加项目私有规则 | `.cursor/rules/local/` |
| 写 CHANGELOG / 打 tag | **release** · `changelog.mdc` · `tag.mdc` |
| UX / 体验问题（分流） | **ux** |
| 信息架构 / 导航迷路 | **ia** · `docs/design/*-ia*` |
| 查 API / 安全 | **api** · **security** |
| 自治发版 | **ship** agent |
| 验证模板完整性 | `bash .cursor/bin/template-verify.sh` |

细节与关键词索引 → [skills/master/routes.md](skills/master/routes.md)。

## 更多文档

- [Naming](docs/naming.md) · [plan/run](docs/plan-run.md) · [Quickstart](docs/quickstart.md)
- [Skills 速查](docs/training/skills.md) · [跨平台](docs/platforms.md)
