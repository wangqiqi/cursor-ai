# Super Cursor — `.cursor/`

通用 SOP 目录。安装到目标项目后默认**只读**；项目认知 → `.cursorGrowth/learn/`（git 忽略）。

## 结构

| 始终加载 | `rules/core.mdc` · `rules/workflow.mdc` |
| 按需 | skills · glob rules · `learn/` |

```
rules/   communication · execution · feedback · tech
skills/  master plan run learn scaffold git release …（SOP 正文；日常只记 plan/run/master）
commands/ 三层 slash（薄入口 → 加载 skill；见下表）
agents/  ship review spike（子进程委派；日常不必记）
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

## Slash 入口（三层 · 记前两层即可）

slash 菜单按 **【日常】→【生命周期】→【高级】** 标注；Agent 可自动选用的 skill **不必死记 slash**。

### 【日常】80% 时间

| Command | 何时用 | Skill |
|---------|--------|-------|
| **`/run`** | 已有 TASK · 写代码 · 修 bug（**默认入口**） | run |
| **`/plan`** | 新开 Sprint · 拆 Goal/TASK（无 ACTIVE 时） | plan |
| **`/master`** | 真迷路 · 刚安装 · 不知 slash（**勿滥用**） | master |

### 【生命周期】Sprint 前后

| Command | 何时用 | Skill |
|---------|--------|-------|
| `/scaffold` | 空仓库建栈 · 已有项目 audit | scaffold |
| `/learn` | 让 Agent 了解本项目 | learn |
| `/release` | merge / PR / 打 tag（Sprint 出口） | release |

### 【高级】按需 · Agent 也常自动选用

| Command | 何时用 | Skill |
|---------|--------|-------|
| `/delivery` | UI/功能 Sprint 发版前 7 维走查 | delivery |
| `/ux` | 体验问题 · 类型不明先分流 | ux |
| `/ia` | 导航/角色/信息架构大改 | ia |

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

### 重复劳动 SOP（rules · 通用）

| 模式 | 位置 |
|------|------|
| 分层验收 verify-layers | `rules/feedback/verify.mdc` · **test** skill |
| 全栈垂直切片 | `rules/execution/vibe.mdc` · **api** skill |
| 文档自洽 doc-coherence | `rules/execution/docs.mdc` · **delivery** skill |
| 实验闭环 experiment-loop | **spike** agent · **learn** skill |

项目路径与聚合脚本名 → `.cursorGrowth/learn/dev-conventions.md`，不写进母版。

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
| 交付验收 / 上线前走查 | **delivery** · `/delivery` · **release** §分支前建议 |
| merge / PR / 打 tag | **`/release`** |
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
