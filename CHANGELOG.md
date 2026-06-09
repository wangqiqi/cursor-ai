# Changelog

All notable changes to Super Cursor are documented here.

## [Unreleased]

## [4.12.0] - 2026-06-09

### Added

- **plan-parse.sh** — `plan_sprint_status` · `plan_sprint_appears_closed` · `plan_done_when_unchecked` 供 Sprint 闭合检测
- **plan** skill — 基线分析 / 审查快照与闭环对齐表（防 plan 头身不一致）
- **templates/plan.md** — `SPRINT_STATUS` · `LAST_DONE` · `VERSION_TARGET` 元数据 · plan 双态说明

### Changed

- **run** skill — Sprint 收尾 **plan 正文 reconciliation** 清单（Done when · TASK ✅ · 基线矩阵 · 标题改「已完成 Sprint」）
- **runner.sh** `plan-check` — Sprint 已闭合时 WARN 未 reconciliation 的正文；无活跃任务时跳过误报

### Fixed

- **README.md** — GitHub 链接 owner 与 remote 对齐（`wangqiqi/cursor-ai`）
- **.gitignore** — `plan.md` 改为 `/plan.md`，避免误忽略 `.cursor/templates/plan.md` 导致 CI verify 失败

## [4.11.0] - 2026-06-09

### Added

- **delivery** skill — `/delivery` 7 维交付验收（视觉 · i18n · 文档对齐 · 后端对接 · 组件 · 可维护性 · 生产就绪）；**finish** 前建议走查
- **delivery.mdc** — 执行规则 · glob 触发 · 与 verify/run 分工
- **acceptance.md** 模板 — `templates/cursorGrowth/learn/acceptance.md` 供项目 `/learn` 特化
- **install-smoke.sh** — `install-super-cursor.sh` 回归；挂入 `template-verify.sh`
- **bugfix-smoke.sh** — bugfix 流程最小 smoke 脚本

### Changed

- **finish** · **plan** · **review** · **master** · **core** · **git** · **release** · **ship** — delivery 闭环链
- **vibe** · **docs** · **api** · **security-sdlc** — 互链 delivery
- **quickstart** · **walkthrough** · **building** · **migration-catalog** · **learn** — 文档与模板同步
- **verify-super-cursor.sh** — 显式 check `delivery/SKILL.md`；30 rules 注册
- **README.md** — 18 skills · `/delivery` · 工作流 mermaid
- **plan** · **run** · **docs.mdc** — 对外门面与同 Sprint README 同步
- **cursor-coherence.sh** — README 须提及每个 disk skill 与 agent
- **run** · **git** · **commit.mdc** — 每 TASK ✅ 与 Sprint 收尾必须自动 commit

### Fixed

- **bugfix-smoke.sh** — `count_chars` off-by-one

## [4.10.0] - 2026-06-09

### Added

- **finish** skill — Sprint/Task 后 merge/PR/保留/丢弃 4 选 1
- **rules** — `scope.mdc` · `agent-discipline.mdc` · `testing.mdc` · `tech/svelte.mdc`
- **docs/rules-catalog.md** — 社区 rules 索引与 `rules/local/` 引用指引
- **archive** — SPIKE-002/003 · SPRINT-07 总结

### Changed

- **plan** · **run** · **test** · **git** · **master/routes** — 先总后分 · TDD · worktree · finish/`babysit`/`split-to-prs` 路由
- **plan** — 阶段 1 可选 ChatPRD 输入
- **collaboration.mdc** — PR review 四角度（security/perf/tests/arch）
- **nextjs.mdc** — Auth/Supabase 反模式精选
- **verify-super-cursor.sh** · **training/skills.md** · **AGENTS.md** — 注册 finish 与新 rules

## [4.9.0] - 2026-06-08

### Changed

- **verify-super-cursor.sh** — 补全全部 29 rules（含 `verify.mdc`）
- **template-verify.sh** — 串联 coherence
- **core.mdc** · **workflow.mdc** — debug/test/review/study 入口 · REV-/SPIKE- agent 链
- **master** routes/SKILL · **AGENTS.md** · **.cursor/README** · **config/README**（人格切换）
- **migration-catalog.md** — 完整性边界（旧版非 1:1 为产品边界）
- **README.md** — skills/agents 结构 · coherence 验收命令

## [4.8.0] - 2026-06-08

### Added

- **Tech**: `c.mdc` · `eslint.mdc` · `javascript.mdc` · deepened ts/react/vue/go/rust/java/python · C++-only `cpp.mdc` · `nextjs.mdc` SSR/CWV/缓存
- **Execution**: `cli-python.mdc` · `vibe.mdc` · `security-sdlc.mdc` · docs API/VIBE alignment
- **Communication/feedback**: `constitution.mdc` · `evolution.mdc`
- **Personas**: `config/roles.json`（12 archetype，仅语气、全能）· `workflow.json` `role` · `run-start` hint
- **Skills**: debug · test（E2E/Playwright）· mcp · refactor · perf · **review** · **study** · api testing · security audit/依赖 · scaffold audit 维度
- **Agents**: **review** · **spike**（readonly）
- **Tooling**: `bin/validate-commit-msg.sh`（optional Conventional Commits check）
- **Docs**: `migration-catalog.md` · `platforms.md` WSL 节

### Changed

- **master** routes: debug/test/mcp/refactor/perf/review/study · `more→style` 人格两轮
- **verify-super-cursor.sh**: register SPRINT-01/02 enrich artifacts
- **AGENTS.md** · **config/README.md** · **learn** skill evolution loop · **training/skills.md**

## [4.7.0] - 2026-06-08

### Changed

- **master** 路由：主菜单收敛为 7 项（`fix` · `more`）；`more` 子路由覆盖 PR/文档/submodule/verify 配置；`routes.md` 对齐 README 场景速查

## [4.6.0] - 2026-06-08

### Added

- **`.github/workflows/verify.yml`** — PR/push 跑 `.cursor/bin/template-verify.sh`
- Rules **globs**：`collaboration.mdc` · `commit.mdc` · `verify.mdc` — 编辑相关文件时自动挂载
- **git** · **security** · **api** skills 审查清单；**ship** agent 五步发版流程与失败回滚

### Changed

- `task_verify_heuristics.enabled` 默认 **false**（与 `verify.mdc` · runner 代码回退一致）
- `verify-super-cursor.sh` 改为检查 `.github/workflows/verify.yml` 存在（不再禁止根 `.github`）

## [4.5.0] - 2026-06-08

### Changed

- 根目录精简为 `.cursor/` · `install-super-cursor.sh` · `README.md` · `CHANGELOG.md` · `.gitignore` · `.cursorignore` — 可直接 clone/复制使用
- 移除根 `scripts/` · `examples/` · `.github/workflows/`；walkthrough 迁至 `.cursor/docs/walkthrough.md`；母版自测迁至 `.cursor/bin/template-verify.sh`
- `.cursor/README.md` 扩充使用场景与速查表

## [4.4.0] - 2026-06-08

### Added

- **`.cursor/bin/platform-check.sh`** — 一键环境自检（bash · git · jq/python · rsync · JSON smoke）
- **`jw_python`** · **`jw_detect_node_stack`** · **`jw_chmod_scripts`** — Git Bash `python` 回退 · 无 jq 栈检测 · install 统一 chmod

### Fixed

- **`platform.sh`** jq 点路径缺少 `.` 前缀 — 有 jq 时 `workflow.json` 读取静默失败、仅靠默认值

### Changed

- `platform.sh` 幂等加载 · manifest/JSON helpers 合并 · `python3`/`python` 统一回退
- `json-utils.sh` · hooks · `scaffold detect` · `install-super-cursor.sh` · verify 接入 platform 增强
- README · `platforms.md` · `config/README` — 跨平台说明与 profile 表

## [4.3.0] - 2026-06-08

### Added

- Root **`.cursorignore`** · scaffold **`_shared.cursorignore`** — Node/Python/Go/Rust/Java/C++ 依赖与临时文件；install 合并 · scaffold apply 写入
- **`.cursor/lib/platform.sh`** — 跨平台 JSON（jq/python3 回退）、目录复制（rsync→cp）、ISO8601 时间戳
- **`docs/platforms.md`** — Linux · macOS · Git Bash 支持说明

### Changed

- Docs sync: 8-stack scaffold（skill · scaffold.md · catalog）· `core.mdc` 补 security/api · README §10 nextjs/rust
- **master** description · `building-super-cursor.md` · `plan-run.md` · `cursorGrowth/README` 补 `/master` 与 cursorignore 说明
- `runner.sh` · `scaffold.sh` · `scaffold-integrity.sh` · hooks · `install-super-cursor.sh` — 统一 `platform.sh`
- `verify-super-cursor.sh` — platform.sh · platforms.md · git/security/api · nextjs.mdc · AGENTS.md · cursorignore；禁止 `date -Iseconds`

## [4.2.0] - 2026-06-08

### Added

- Scaffolds **rust-axum** · **nextjs-ts**（8 栈）· `rules/tech/rust.mdc` · `nextjs.mdc`
- Java **Gradle Wrapper** 内置（`gradlew` + `gradle-wrapper.jar`）
- Install profiles `full` / `lite` / `rules-only` · auto `plan.md` · 下一步清单
- `examples/README.md` · `runner-smoke.sh` · `config/profiles/*.json`

### Changed

- **master** skill 纳入文档索引 · `manifest.json` v2 + categories
- `scaffold-integrity` 校验 gradlew · `scripts/verify.sh` 增加 runner smoke

## [4.1.0] - 2026-06-08

### Added

- Mother repo `scripts/verify.sh` + `.github/workflows/verify.yml` + `scaffold-integrity.sh`
- Scaffold **standard+** tier: per-stack CI · `.env.example` · independent `tests/` · `scripts/test.sh`
- Go `tests/integration/` · Python `tests/unit|integration` · C++ GoogleTest · Java unit/integration packages
- `docs/quickstart.md` · `docs/training/skills.md`

### Changed

- `task_verify_heuristics.enabled: true` · fallback `scripts/test.sh` / `verify.sh` · monorepo dirs default `.`
- `runner.sh` heuristics fallback · React/Vue tests → `tests/` · `test:watch`
- `plan.md` template: dev → `test.sh` · hardening → `verify.sh`
- **learn** / **run** / **scaffold** skills expanded

## [4.0.4] - 2026-06-08

### Added

- **scaffold** skill + `/scaffold` — empty-repo stack templates with AskQuestion + dry-run confirm flow
- `.cursor/bin/scaffold.sh` — `list` · `info` · `detect` · `apply` · `audit`
- `.cursor/templates/scaffold/` — react-vite-ts · vue-vite-ts · go-api · python-fastapi · java-gradle · cpp-cmake
- `docs/scaffold.md` · README scenario §2 + quick-reference entries
- Tech stack rules: `go.mdc` · `java.mdc` · `react.mdc` · `cpp.mdc`

### Changed

- `plan` skill · `core.mdc` · `AGENTS.md` · `naming.md` · `install-super-cursor.sh` — scaffold integration
- README renumbered scenarios §3–§20 after new scaffold section
- Scaffold templates upgraded to **standard** tier: ESLint+Vitest (react/vue), ruff+mypy (python), Go `internal/handler` + real tests, C++ warnings, per-stack README
- `java-gradle`: `bootstrap-gradle-wrapper.sh` + `gradle-wrapper.properties`
- `manifest.json` tier field · `catalog.md` · `scaffold.md` clarify skill vs templates vs rules

## [4.0.3] - 2026-06-08

### Added

- README: 19 usage scenarios + quick-reference table
- `.cursor/rules/local/README.md` — project-local rules guide
- `core.mdc`: `.cursor/` immutability after install; language matches user
- `collaboration.mdc`: language section (references core)
- `verify-super-cursor.sh`: execution-order line check + key execution/communication rules

### Changed

- `config/README.md`: document `prefixes_skip`, `verify_default`, `release.mode`, etc.
- `workflow.mdc` · `plan` skill · `plan-run.md`: task ID prefixes + **执行顺序** requirements
- `plan-parse.sh` · `runner.sh`: accept legacy `**Order**` alias alongside **执行顺序**
- `AGENTS.md`: rules directory index
- `building-super-cursor.md`: principle #6 immutable after install
- `install-super-cursor.sh`: post-install immutability notice
- `learn` skill: references immutable `.cursor/` boundary

### Fixed

- `templates/plan.md` used `**Order**` while runner expected **执行顺序**, breaking `next-task` on fresh installs

## [4.0.2] - 2026-06-08

### Changed

- Merge 5 alwaysApply rules → `core.mdc` + `workflow.mdc` (~68% session token reduction)
- Slim skills, glob rules, docs; remove duplicate `docs/training/`

## [4.0.1] - 2026-06-08

### Changed

- Release subagent **`release` → `ship`** to avoid Cursor built-in `release` subagent conflict
- **release** skill remains the release checklist; **ship** agent handles autonomous shipping

### Added

- `docs/naming.md` — official naming对照与禁用名列表
- Verify: require `agents/ship.md`, forbid `agents/release.md`

## [4.0.0] - 2026-06-08

### Breaking changes

- Rename workflow from **jwplan/jwrun** to **plan/run** (`/plan`, `/run`, `/learn`)
- Replace `dev_runner.sh` with unified `runner.sh` CLI
- Reorganize rules into `communication/`, `execution/`, `feedback/` (replaces `core/`, `team/`, `workflow/`)
- Rename skills to short verbs: `plan`, `run`, `learn`, `git`, `release`, `security`, `api`

### Added

- `config/workflow.json` and `config/release.json` for workflow and release settings
- Hooks: `growth-init.sh`, `run-start.sh`, `run-stop.sh`
- Templates: `plan.md`, `.cursorGrowth/README.md`
- Docs: `plan-run.md`; updated training guides for agents, rules, skills
- `verify-super-cursor.sh` layout checks for new structure

### Removed

- Legacy jwplan/jwrun skills, hooks, rules, and `jw-workflow.json`
- `domain-packages` and `profiles` references

## [3.0.0] - 2026-06-08

Universal portable SOP template — single `.cursor/` layer, no domain-packages or profiles.

## [2.0.0]

Migrate Super Cursor to official Cursor standard layout.

## [1.0.0]

Initial Super Cursor template with rules, skills, hooks, and workflow.
