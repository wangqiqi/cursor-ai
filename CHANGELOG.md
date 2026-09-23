# Changelog

All notable changes to Super Cursor are documented here.

## [Unreleased]

### Added

- **`bin/verify-portability.sh`（A3）** — 发布脚本可移植性静态门禁：GNU-only 构造（`sed -i` 无后缀 · `find -printf` · `stat -c` · `sort -h` · `du --max-depth` · `date -d/-Iseconds` · `grep -P` · `xargs -r` · `tac`）· 非 POSIX `\s` 正则 · `readlink -f` 缺回退 · 硬编码 `python3` · shebang 非 `env bash`；扫描 57 个脚本，已纳入 `verify-super-cursor.sh` 与接线自检（含 `portability-allow` 单行豁免机制）
- **`config/denylist.txt`** — 「母版独立」单一禁用词表（作者/维护者标识 · 机器绝对路径 · 公司代号占位 · 凭据痕迹），由 `verify-super-cursor.sh` 逐行 ERE 扫描 `.cursor/` 全树；名单文件缺失即 FAIL，防止守卫被静默关闭（SPRINT-AGNOSTIC · A1）

### Fixed

- **系统无关（A3）** — `maintain` 技能显式声明 Linux 作用域：新增 `require_linux`（非 Linux 退出 3 并给出替代路径）与 `--help`；`du --max-depth`/`sort -h` 改为 `du -m` + `awk` + `sort -rn`（POSIX）并保留 GNU 能力探测；`load-config`/`disk` 等 6 处 `python3` 调用改经 `PYTHON_BIN` 解析（Git Bash 可能只有 `python`）
- **shebang 归一** — 12 个脚本由 `#!/bin/bash` 改为 `#!/usr/bin/env bash`（含 `verify-system.sh` 与 5 个 scaffold bundle 脚本），修复 Git Bash / 非 FHS 系统下的可移植性
- **默认人格去作者化（A2）** — `role.default` 由 `dashu`（油腻大叔）改为 `professional`（中性「专业搭档」）；`dashu` 人设的 `given_name` / `nicknames` 由作者真人称呼（`老周`）改为虚构 `老哥` / `大叔`，两词已入 `denylist.txt`。12 人格全部保留，仅换默认；**已安装项目不受影响**（其 `config/workflow.json` 是自己的副本）
- **standalone 扫描过度豁免** — `maintain/scripts/dev-maintain.sh` 与 `skills/disk/*` 此前被排除在用户/机器路径扫描之外，实测两者**并不命中**该规则；豁免已删除，扫描面恢复完整（A1）
- **A1 门禁落地时发现并修正一处过宽规则** — 凭据规则最初写成 `\.pem$`，会误命中 `templates/scaffold/_shared.cursorignore` 的合法 ignore 模式；改为只匹配密钥材料本体（`-----BEGIN … PRIVATE KEY-----` / AKIA key id）

## [4.29.7] - 2026-09-23

### Added

- **scaffold bundles** — `apply-bundle verify-layers`（L1–L3 · slice 注册表 · flock）· `design-system`（中性 token · PageShell · ListLoadErrorAlert）· `doc-coherence`（doc-anchors · openapi sync 模板）
- **templates/learn/skill-distillation-playbook.md** — 母版 Skill → 产品 bundled 蒸馏流程（通用 tier · 占位 verify）

### Changed

- **debug** skill — 路径型健康三角验证 · stale 单例失效 · dev 反代多传输路径
- **test** skill — 有界长测 · 并行 verify flock · slice 注册表纪律 · `verify-layers` bundle 入口
- **scaffold** `manifest.json` · `catalog.md` — 登记三 bundle
- 多 skill/rules 文档与 hybrid 仓演进对齐；母版门面去除 `rdm-week` 引用

### Fixed

- **docs:build** — `training/skills.md` 的 `routes.md` 相对链接由 `../` 恢复为 `../../`；`ef5521b` 误改导致 VitePress dead-link 检查失败，CI 与 GitHub Pages 长期为红
- **hooks** — 项目级 hook 路径 `./hooks/*.sh` → `.cursor/hooks/*.sh`。Cursor 项目级 hook 从 **project root** 运行（官方约定），原路径解析为 `<root>/hooks/*.sh`（不存在）→ growth 引导 · 会话上下文注入 · 自治 Sprint 连跑**静默从未执行**
- **plan-parse** — `(none)`/`null` 模板占位归一化为「未设置」并让 `plan_task_row_field` 不再因 `pipefail` 中止 `set -e` 的 hook；修复全新安装下 `run-start`/`run-stop` 直接 exit 1
- **gitignore** — `.cursor/hooks/state/*`（保留 `state/README.md`）；此前 `run-start` 写出的 `run.json` 会脏化工作区
- **run 硬闸门 fail-closed** — `PLAN_APPROVED: (none)` 不再被当作已批准。全新安装 `gate-check` 现在正确 `BLOCK` + exit 1（此前模板默认值直接放行，"无 `PLAN_APPROVED` 不写业务代码"形同虚设）；`install-smoke` 断言由"闸门通过"反转为"闸门必须 BLOCK"
- **install `--replace` 自毁** — 目标与母版为同一仓库时直接拒绝（此前先 `rm -rf` 源 `.cursor/`、再自拷空目录，实测母版 `.cursor/` 373 → 0 文件；README 推荐的 `super-cursor-sync --replace` 在母版仓库内执行即命中）；`install-smoke` 增加回归断言
- **验证器接线** — `verify-doc-super-cursor.sh` 与 `verify-growth-layout.sh` 此前**从未被任何验证器或 CI 调用**（`doc-hygiene.mdc`、CHANGELOG 4.29.0/4.29.5 均声称已聚合），doc 坏链与计数漂移因此长期无人发现；现已接入 `verify-super-cursor.sh`，并新增**接线自检**：任何 `bin/verify-*.sh` 未被聚合即 FAIL
- **文档** — `migration-catalog.md` 结构计数 `27 skills · 46 rules` → `28 skills · 53 rules`；补齐 4 处 `growth-layout` 交叉引用（`verify.mdc` · **run** · **scaffold** · `plan-conventions` 模板 `archive/{domain}/`）
- **文档站链接** — `sync-cursor-docs.sh` 替换串多写一个 `(`（`]((/guide/x)`），markdown-it 判为非法链接并**渲染成纯文本**，且 VitePress 不报错：**12 处站内链接（5 个镜像页）**失效；同时改为「临时文件就地重写」以兼容 BSD/macOS `sed`（原 `sed -i` 无后缀为 GNU only）
- **rules/local 链接** — `rules-catalog.md` 原链指向 gitignore 的符号链接，镜像后改写出的 GitHub URL **404**；改指已跟踪的 `templates/cursorGrowth/rules/local/README.md`
- **runner.sh help** — heredoc 未转义反引号触发命令替换：stderr 输出 `version_*_env: 未找到命令`、帮助文本被污染；`runner-smoke` 增加 help 干净度与「模板闸门必须 BLOCK」回归
- **rules glob 校准** — 5 条 plan 闸门规则（`verify` · `changelog` · `ia` · `delivery` · `ux`）glob `plan.md`，但真 plan 在 `.cursorGrowth/plan.md`（Cursor glob 无斜杠模式**仅匹配根目录**）→ 编辑真 plan 时**永不加载**，闸门规则形同不存在；现同时 glob 两处，`archive/**/*` 同理补 `.cursorGrowth/archive/**/*`
- **rules glob 误命中** — `tech/nextjs.mdc` `**/app/**` 命中 python-fastapi `src/app/main.py` 与 cpp-cmake `include/app/greet.hpp`；`ux.mdc`/`delivery.mdc` `**/src/**` 命中 rust-axum/cpp-cmake；`data-list.mdc` `**/*List*` 命中 `CMakeLists.txt`；`eslint.mdc` 挂到所有 JS/TS 源文件 → 全部收窄为语言/框架专属模式
- **rules glob 零命中** — `api.mdc` · `error-context.mdc` 在自带后端栈命中为 0（go-api 用 `internal/handler/` 单数）· `cpp.mdc` 不覆盖 `.h` 头文件 → 补齐；brace glob（`**/*.{ts,tsx}`）为 Cursor 未文档化写法，展开为逐扩展名
- **新增 `bin/verify-rules-globs.sh`** — frontmatter/键校验 · 禁 brace glob · plan 闸门 glob 断言 · 7 栈真实文件命中/误命中回归；已纳入聚合与接线自检
- **alwaysApply 口径** — 常驻规则实为 **4** 条（`core` · `workflow` · `communication/cursor-standalone` · `communication/super-cursor-persona`），`AGENTS.md` 与 `.cursor/README.md` 此前写 2 条，常驻上下文被少算约 1.75×；`cursor-coherence.sh` 注释同步，`AGENTS.md` 补 `release.json` · `profiles/`
- **CI 触发面** — `verify.yml` 的 `config/**` 在根目录不存在（真身 `.cursor/config/`），且漏 `install-super-cursor.sh` · `README.md` · `CHANGELOG.md` · `.github/workflows/**` → 改安装脚本或门面文档**不触发 CI**
- **人格默认值** — `roles.json` 顶层 `default` 与 `workflow.json` `role.default` 互相矛盾（前者无人读取）；对齐为 `dashu` 并标注 SSOT
- **skill metadata 契约恢复** — `ef5521b` 曾**静默删除** `training/skills.md` 的 `## disable-model-invocation 策略` 一节与 `description ≤85 字` 规则（4.29.1 SPRINT-SKILL-META 交付物），因验证器未接线而无人发现；现已恢复，并在 `verify-doc-super-cursor.sh` 增加断言：该节存在 · 28 个 `description` 全 ≤85 字 · `disable-model-invocation` 分桶与策略表一致
- **description 收敛** — 13/28 个 skill 的 `description` 超 85 字（最长 131）→ 全部收敛至 ≤85（最长 84）；常驻可见元数据合计 **2176 → 1702** 字符
- **口径统一：关键词 ≠ 自动选用** — `README.md` · `.cursor/README.md` · `docs/naming.md` · `master/routes.md` 此前把 **week · disk · maintain · ops-deploy · code-stats-viz** 列为「Agent 按意图自动选用 / 关键词触发」，但这 5 个是 `disable-model-invocation: true`（只可 `/skill` 显式调用）；四处改为显式调用口径并在 `routes.md` 顶部加约束（Agent 不得据关键词自动加载）
- **内置 slash 漂移** — 9 处路由 `babysit`（Cursor 已下线，现由 `autopilot` 承担 PR 跟进）→ 改指 `autopilot`；`naming.md` 的「勿占用」清单更新为官方当前内置名并注明会随版本增删
- **ship agent 漂移** — `agents/ship.md` 的 §前置检查 漏了 **release** §打版 的强制 `release-check`（可打未校验版本）；已补并以 `next_version` 异常即停为断言
- **`plan-check` 退出码** — 打印 `FAIL` 却 `return 0`，`plan-check && gate-check` 与 `install-smoke` 依赖退出码会误判；改为 `issues>0` 时 `return 1`，并在 Sprint 已闭合时不再报「缺 `**执行顺序**`」假告警
- **install 参数校验** — `--profile` 缺值/吞掉 `--replace` 无提示 · `--here` 与显式路径同时给出时静默忽略路径 · 无母版时 `--help` 直接报错；均已改为明确报错
- **`validate-commit-msg.sh`** — 拒绝 Conventional Commits breaking 形式（`feat!: x` / `feat(api)!: x`）→ 已支持
- **`verify-super-cursor.sh` 模式判定** — 母版专属项（`install-super-cursor.sh` · 禁止根 `scripts/` · `.github/workflows/verify.yml` · 母版门面 doc/layout 校验）此前只按「是否 hybrid」跳过，导致**安装到普通目标项目**时被误判为母版、报一堆无关 FAIL；现以「根目录是否有 `install-super-cursor.sh`」判定母版，目标项目也能得到有意义的全绿结果。`.cursorignore` 改为通用检查（安装后会随 `.cursor/` 复制）
- **macOS/BSD 可移植性** — `cursor-coherence.sh` 的 `find -printf`（GNU only）与 `grep/sed '\s'`（非 POSIX ERE）→ 改为 `-exec basename` 与 `[[:space:]]`；此前声称支持的 macOS 上 `template-verify` 会直接中止

## [4.29.6] - 2026-09-08

### Added

- **VitePress 文档站** — `docs/` · `npm run docs:dev|build` · 镜像 `.cursor/docs/` 12 篇（guide · reference · training）
- **GitHub Pages** — `.github/workflows/pages.yml` · `https://wangqiqi.github.io/cursor-ai/`

### Changed

- **README.md** — 在线文档入口 · Docs badge
- **verify.yml** — `docs/**` · `package.json` 变更时跑 `npm run docs:build`

## [4.29.5] - 2026-09-07

### Added

- **plan** `reference/growth-layout.md` — `.cursorGrowth/archive/{domain}/` 与 `scripts/` 一级功能分级 SSOT（archive 域表 · verify/domain · lib · ops · dev）
- **verify-growth-layout.sh** — 母版 SOP 引用与布局文档自检（纳入 `verify-super-cursor.sh`）

### Changed

- **doc-hygiene.mdc** · **verify.mdc** · **docs.mdc** — archive 禁 flat 膨胀；域脚本默认 `scripts/verify/domain/`
- **run** · **scaffold** · **test** · **learn** · **ops-deploy** `layout.md` — 链 growth-layout；plan-conventions 模板含 `{domain}/`

## [4.29.4] - 2026-09-07

### Added

- **`workflow.json`** — `confirm_before`: `verify_l2` · `verify_l3` · `background_heavy_job`；`interrupt_on`: `heavy_verify`

### Changed

- **verify.mdc** — 重任务触发门禁：单 TASK 用 `task-verify`；L2/L3 须用户确认；禁止叠跑 verify
- **agent-discipline.mdc** — 禁止静默后台起重任务 / 重复起全量验收
- **run** skill · **autonomy-chain.md** — Sprint 收尾 L2 须 AskQuestion；移除单轮默认 `runner.sh verify`

## [4.29.3] - 2026-09-01

### Added

- **multi-session-edits.mdc** — 多 Cursor 会话并行时禁止覆盖/restore 外来磁盘改动；外来 diff 停手 AskQuestion（`alwaysApply`）

### Changed

- **plan** skill · **phases.md** · **templates/plan.md** — TASK 表 `Owns` 列与多会话独占路径
- **git** skill · **run** skill — worktree / commit 前交叉引用 multi-session-edits
- **workflow.mdc** · **agent-discipline.mdc** · **cursor-coherence.sh** — 并行编辑主权指针与白名单

## [4.29.2] - 2026-08-28

### Changed

- **eslint.mdc** — §Pre-release FE gate（tsc · lint · CI 镜像 · suppressions）；与 task-verify/verify L1 分工（SPRINT-LINT-TSC）
- **release** skill — §分支/打版 checklist 链 eslint §Pre-release FE gate
- **delivery** skill · **typescript.mdc** — lint/tsc 交叉引用（详单 SSOT 在 eslint.mdc）

## [4.29.1] - 2026-08-28

### Changed

- **skills/** — 28 个 SKILL `description` cap ≤85 字；`disable-model-invocation` 主路径/工具 vs 分流分桶（SPRINT-SKILL-META）
- **training/skills.md** — §disable-model-invocation 策略脚注
- **templates/cursorGrowth/learn/dev-conventions.md** — Skill 元数据指针
- **core.mdc** — 入口表瘦身至 9 行 + 外链 `routes.md` · `training/skills.md`（SPRINT-RULE-SLIM）
- **routes.md** — LIBRARY 大表外链 `library-index.md`；删「扩展 skill 路由」重复节；关键词索引 canonical；注册 **doc-hygiene**；~288→~180 行
- **building-super-cursor.md** — alwaysApply 更正为四件（~244 行）及 token 说明
- **ia.mdc** — 薄化：原则 SSOT 在 **ia** skill；rule 仅触发与分工

## [4.29.0] - 2026-08-28

### Added

- **rules/execution/doc-hygiene.mdc** — ROADMAP/archive/CHANGELOG 职责 · doc-coherence · 断链 · 门面计数（吸收自 workspace CHANGELOG 文档卫生审计）
- **verify-doc-super-cursor.sh** — README skills 计数 · migration-catalog 计数 · `.cursor/docs` 相对链接；聚合于 `verify-super-cursor.sh`

### Changed

- **docs.mdc** — §doc-coherence 链 doc-hygiene · 母版 verify 指针
- **learn** skill — 症状簇→doc-hygiene 映射 · changelog-insights 文档卫生示例
- **delivery** checklist — doc-coherence 链 doc-hygiene
- **training/skills.md** — 修复 routes 相对链接
- **migration-catalog** — 28 skills · 52 rules
- **bugfix** · **core** · **AGENTS** · **rules-catalog** · **verify-super-cursor** · **.cursor/README** · **README** — 注册 doc-hygiene

## [4.28.0] - 2026-08-28

### Added

- **ops-deploy** skill（无 slash）：docker-compose · `.env.example` · nginx · verify 注册 SOP；`reference/` 五篇
- **rules/execution/deploy-ops.mdc** — compose/env/nginx 二级 rule

### Changed

- **scaffold** — `reference/ops-env-contract.md` · catalog 链 ops-deploy；修复 catalog 合并冲突残留
- **learn** 模板 `dev-conventions.md` — §Deploy 字段
- **scaffold/react-vite-ts** `.env.example` — exemplar 分段注释
- **bugfix** · **core** · **AGENTS** · **rules-catalog** · **verify-super-cursor** · **.cursor/README** · **routes** · **training/skills** — 注册 ops-deploy · deploy-ops

## [4.27.0] - 2026-08-28

### Added

- **rules/execution/i18n-copy.mdc** — 文案/i18n/禁词/E2E 锚点三联（吸收自 workspace CHANGELOG 重复劳动审计）
- **rules/execution/data-list.mdc** — 分页/cursor pager/render reset/limit 与 API 对齐

### Changed

- **verify.mdc** — §新增 verify 脚本门禁（复用优先 · `scripts/lib/` 公因子 · 禁重复聚合）
- **learn** skill — CHANGELOG 重复模式审计：增量/全量/workspace 扫描 · 症状簇→rule 映射
- **test** skill — 引用 verify §新增脚本门禁
- **changelog-insights** 模板 — 重复工作模式示例行（含 verify 冗余）
- **bugfix** · **core** · **AGENTS** · **rules-catalog** · **verify-super-cursor** · **.cursor/README** — 注册 i18n-copy · data-list · verify 复用 SOP

## [4.26.4] - 2026-08-05

### Added

- **code-stats-viz** skill（无 slash）：Git 代码行数/语言分布/提交日历 → 交互式 HTML 仪表板；`scripts/code_stats_viz.py` · 产出 `.cursorGrowth/code-stats/`
- **master/routes** · **AGENTS** · **training/skills** · **README** — 注册 code-stats-viz 工具技能（27 skills）

## [4.26.3] - 2026-08-04

### Changed

- **docs** — `naming` · `quickstart` · `plan-run` · `walkthrough` · `migration-catalog`：slash 三层与 `/long` `/manual` `/report` 对齐；skills 计数 26 · 10 commands
- **verify-super-cursor.sh** — 注册 `skills/long` · `commands/long.md`

## [4.26.2] - 2026-08-04

### Added

- **install-super-cursor.sh --setup-shell** — 母版目录执行一次，写入 `~/.bashrc` / `~/.zshrc`（`SUPER_CURSOR_HOME` · PATH · `install-super-cursor` 别名）；之后在任意项目目录用 `install-super-cursor --replace` 同步

## [4.26.1] - 2026-08-04

### Added

- **install-super-cursor.sh** — 无目标路径时从当前目录向上解析 Git 项目根；`SUPER_CURSOR_HOME` / `CURSOR_AI_HOME` 指定母版路径；`--here` 显式选项
- **bin/super-cursor-sync** — PATH 包装脚本，任意子目录一键同步母版 `.cursor/`

## [4.26.0] - 2026-08-04

### Added

- **long** skill（`/long`）：Epic 级长程调度 — Epic→Sprint→Task 三层收敛、Sprint 间 checkpoint、与 plan/run/系统 loop 分工；`reference/hierarchy.md` · `pacing-checkpoint.md`
- **commands/long.md** — 生命周期 slash 薄入口
- **plan** `reference/sprint-goal-gate.md` — Sprint Goal 合格性；禁止将打 tag/merge/专归档立项为 Sprint

### Changed

- **plan** — 阶段 1 Goal 类型门禁；Done when 与 Goal 分工澄清；`plan-check` 对仪式型 Goal 发出 WARN（`plan-parse.sh` · `runner.sh`）
- **release** · **followup-facade** · **workflow** · **templates/plan.md** — 与 sprint-goal-gate 交叉引用
- **master/routes** · **core** · **AGENTS** · **training/skills** · **.cursor/README** — 注册 `/long` 与 long skill；修复 routes 合并冲突残留

## [4.25.0] - 2026-08-04

### Changed

- **slash 瘦身** — 保留 `/run` `/plan` `/master` `/scaffold` `/learn` `/release` `/delivery` `/manual` `/report`；ux · ia · debug · review · week · disk · maintain · pencil-design **退为 skill-only**
- **scaffold** — 删除易坏的 `java-gradle`；现为 **7 栈** + 可选 bundles；保留 `rules/tech/java.mdc` 供 brownfield
- **验收** — 继承 4.24.9 hybrid layout；slash/command 清单与瘦身后门面对齐
- **naming / README / routes / core** — 五层关系与 slash 表对齐「slash = command 薄入口 · skill = SOP 正文」
- **递归任务分解** — plan/run/workflow 同步先总后分 · ACTIVE 分支边界

## [4.24.9] - 2026-07-16

### Changed

- **verify-super-cursor**：混合仓自动 `hybrid` 模式 — 纯母版 layout 项改 **SKIP**（不再误 FAIL）；文档同步 `verify.mdc` · `platforms` · `naming` · `building-super-cursor` · `master/routes` · `quickstart` · `migration-catalog` · `template-verify.sh`

## [4.24.8] - 2026-07-16

### Added

- **test-report** skill（`/report`）：可发布测试报告 SOP — verify 后汇总 · Report Contract · 日志解析 · benchmark 文档 · regen 门禁
- **scaffold `apply-bundle test-report`**：可选附加包 — Report Contract · test-report doc · collect/verify 脚本
- **commands/report.md** · **templates/test-report-contract.example.yaml** · **test-report-outline.md** · **reference/scaffold-bundle.md**

### Changed

- **verify-super-cursor** — 注册 `commands/report.md` · `skills/test-report/SKILL.md`
- **README** · **.cursor/README** · **core** · **docs** · **plan/run/test/delivery/release** · **routes** · **library-index** — 注册 `/report` 与 test-report 分流
- **ship** · **run** Sprint 收尾 — 发版/Sprint 档可选 **`/report`**（verify 绿后 · from-logs）
- **plan-run** — 补 `/report` 链路说明 · mermaid 可选节点
- **scaffold** — AskQuestion 可选 `apply-bundle test-report`

## [4.24.7] - 2026-07-16

### Changed

- **verify-super-cursor** — 注册 `commands/manual.md` · `skills/user-manual/SKILL.md`；新增 standalone 门禁（本机绝对路径 · 用户名标识）

## [4.24.6] - 2026-07-16

### Added

- **user-manual** skill（`/manual`）：可发布软件使用说明书 SOP — 五段流水线 · Manual Contract · 5 种 Capture Profile · regen 门禁 · Reader Test
- **scaffold `apply-bundle user-manual`**：可选附加包 — Manual Contract · user-guide · sync/verify 脚本 · Playwright walkthrough 占位
- **commands/manual.md** · **templates/manual-contract.example.yaml** · **user-manual-outline.md**

### Changed

- **README** · **.cursor/README** · **core** · **docs** · **plan/run/scaffold/test/delivery** · **routes** · **library-index** — 注册 `/manual` 与 user-manual 分流

## [4.24.5] - 2026-07-15

### Added

- **pencil-design** — 收录 `@pencil.dev/cli@0.2.8` SKILL；`/pencil-design` slash · **library-index** · **routes** 关键词

## [4.24.4] - 2026-07-15

### Added

- **roles.json** — `speech_rules` · 12 人格 `voice_cues` · `emotion_cues`（成功/卡住/决策/长跑）· `speech_examples` ≥4

### Changed

- **super-cursor-persona** — `given_name` 仅供用户点名；禁止开场自报；落地语气清单
- **run-start** — Persona hint 注入 `tone`/`voice_cues`/`emotion_cues`/examples，去掉 `（given_name）` 置顶
- **master/routes** · **config/README** · **autonomy-chain** — 人格字段语义对齐
- **cursor-coherence** · **verify-super-cursor** — 人格语气验收（voice_cues · 禁自报开场）
- **母版洁净化** — migration-catalog · disk/week/maintain 默认路径等去除本机/用户专属痕迹
- **migration-catalog** — 工作区升级指引泛化（install 验收步骤）
- **README** — 安装选项 · 任务 ID / `release.mode` / SDD · `/debug` `/review` · bin/hooks 树修正

## [4.24.3] - 2026-07-15

### Changed

- **release.mdc** · **tag.mdc** · **evolution.mdc** — frontmatter 补触发语义（REV P3）

## [4.24.2] - 2026-07-15

### Added

- **plan** `reference/prioritization.md` — RICE/ICE/Kano/MoSCoW backlog 排序（吸收 pm-prioritization-engine 协议）

### Changed

- **library-index** · **routes.md** — pm-prioritization-engine 落点更新

## [4.24.1] - 2026-07-15

### Added

- **commands/debug.md** · **commands/review.md** — 薄 slash 入口，对齐 skill 与场景表

### Changed

- **core.mdc** — 横切 rule 路径统一 `.mdc` 后缀
- **collaboration.mdc** — PR 评审单表（去重分角+清单）
- **commit.mdc** · **verify.mdc** — frontmatter 补触发语义
- **master** · **review** skill — description 压缩
- **verify-super-cursor.sh** — 注册 week/disk/maintain SKILL · debug/review command
- **rules-catalog.md** — `ia.mdc` 全路径

## [4.24.0] - 2026-07-15

### Added

- **awesome-cursorrules-zh**（LessUp · PatrickJS 中文镜像）通用蒸馏：**testing** BDD/Gherkin · **collaboration** 评审清单 · **bugfix** Issue 模板 · **scope** 命名常量 · **git** Conventional Commits 速查
- **rules-catalog** · **README** 致谢 — zh 中文镜像策展 + `rules/local/` 引用示例
- **README** 致谢 — [wangqiqi/cursor-ai-rules](https://github.com/wangqiqi/cursor-ai-rules) 前身项目

### Changed

- **library-index** § awesome-cursorrules-zh 落点映射

## [4.23.2] - 2026-07-15

### Added

- **pm-skills**（SpaceZephyr/pm-skills · MIT）协议吸收：**plan** `doc-prd-enrich.md` · **review** §文档预审 · **delivery** §埋点 · **master** LIBRARY 产品工作流
- **README**「致谢与协议出处」— 集中列出 anthropics · spec-kit · SkillsMP · pm-skills 等上游

### Changed

- **library-index** § pm-skills + 泛化命名纪律（母版正文禁止专家人名）

## [4.23.1] - 2026-07-15

### Added

- **cursor-standalone**：母版独立引用纪律 + 文风 SSOT（`rules/communication/cursor-standalone.mdc` · `alwaysApply`）
- **library-index**：外网吸收母版内索引（`docs/library-index.md`）
- **standalone-map**：引用审计矩阵（`plan/reference/standalone-map.md`）
- **verify**：skills 禁止 `github.com` 作 SSOT 门禁

### Changed

- **core** · **workflow**：母版可演进 vs 安装后只读；Growth 坐标统一
- **plan** · **templates** · **docs/training** · **building-super-cursor**：去根 CHANGELOG/README 叙事依赖
- **source-map** · **mcp/evaluation** · **delivery/pdf**：外网链改指 library-index
- **coherence**：允许 `cursor-standalone.mdc` `alwaysApply`；SDD twin 同步

## [4.23.0] - 2026-07-15

### Added

- **SDD**（github/spec-kit）：Greenfield/Brownfield · `reference/sdd/` · `templates/sdd/` · **review** analyze · **run** converge
- **anthropics/skills** 协议吸收：mcp Eval · test E2E/`with_server.py` · delivery 反模板/PDF · plan/run 协作文档与 Reader Testing
- **autonomy**：Sprint 连跑（一次 `/plan` + 一次 `/run`）· `reference/autonomy-chain.md` · `autonomy.interrupt_on`
- **super-cursor-persona**：行为 SOP + 语气品牌（默认 **dashu** / 老周）
- **coherence**：SDD 安装种子 ↔ reference 四模板 twin diff 门禁

### Changed

- **workflow.json**：`role.default` → `dashu` · `autonomous.default` → `true`
- **plan** · **run** · **hooks** · **master** · **workflow** · **core**：自治协议与冗余合并（SSOT 索引）
- **platform.sh** · **verify** · **bootstrap-growth**：Windows UTF-8 / `sc_python` · 本机验收绿 · `rules/local` 修复
- **templates/plan.md**：默认 `AUTONOMOUS: true`
- **learn**（Growth）：skill-creator 渐进披露
## [4.22.4] - 2026-07-14

### Changed

- **maintain**：Playwright 浏览器缓存（`~/.cache/ms-playwright*`）默认列入 `protected_dirs`，清理时保留
- **maintain** `dev-maintain.sh`：支持 `MAINTAIN_BUILTIN_PROTECTED` 环境变量注入白名单（`ubuntu-ai-maintenance.sh` 薄封装）

## [4.22.3] - 2026-07-14

### Changed

- **templates/plan.md**：Sprint 闭合指引 — **CHANGELOG** 优先 · archive 仅本地写入
- **docs/building-super-cursor.md** · **learn**：Growth 产出边界 — 母版不得链 archive 文件名 · **CHANGELOG** 为可移植 SSOT
- **docs/training/skills.md**：Growth 边界纠正 · SkillsMP/git-security 吸收速查（改指 skill + **CHANGELOG**）
- **security**：支付/webhook/敏感交易触发词与清单（ECC `security-review` diff）
- **git**：GitHub 运维 `github-ops` 短节（issue triage · stale · release · CI；`gh` 有则用）
- **docs/effective-collaboration.md**：效果型效率 — 少拉扯才是真省
- **README** · **plan-run** · **quickstart** · **.cursor/README**：交叉引用效果型效率
- **test**：factory / mock / stub 策略短节（SkillsMP `testing-patterns`）
- **run**：closeout review 协议（SkillsMP `autoreview`）
- **debug**：Agent 内省调试（SkillsMP `agent-introspection-debugging`）
- **master** `deps` · **scaffold**：DAILY/LIBRARY 裁剪协议（SkillsMP `agent-sort`）
- **review**：Standards/Spec 双轴回顾 · 人类 reviewer 优先级（SkillsMP `code-review`）
- **命名规范**：移除 `JW_`/`jw_` 前缀；发版 env `VERSION_TAG_GLOB` · `RELEASE_*`；内部 `SC_`/`sc_`

## [4.22.2] - 2026-07-14

### Added

- **learn** §经验捕获：ERRORS/LEARNINGS 分类 · 晋升门禁 · 任务中触发
- **security** §外部 Agent Skill：安装前审计 · LOW–EXTREME · 与 prompt-security 边界
- **master** `deps`：外网 skill 发现路由 · 关键词索引
- **debug** §网络与抓取：WebFetch/WebSearch 选型与失败处理
- **docs/training/skills.md** §可选能力（无新增 skill）
- **release** §版本解析：`release-check` 输出 `latest_tag` · 无 `VERSION_LINE` 时读最新 `v*` tag

### Changed

- **run**：用户纠正或 `⚠️` 时提议 `/learn` 记经验
- **delivery** §10：可选 `agent-browser` CLI（检测到有则用）
- **runner** `release-tag`：去掉 `VERSION_LINE` 默认 `1.0`；优先最新 semver tag

## [4.22.1] - 2026-07-12

### Added

- **roles Growth aliases**：`.cursorGrowth/session/aliases.json`（称呼→persona_id，优先于母版 nicknames）
- **roles 会话态**：`.cursorGrowth/session/persona.json`（模板 + growth-init 种子）；`run-start` 优先注入
- **roles**：每人补齐 `role_name` · `nicknames[]` · `given_name` · `personality` · `skills: full`；`bin/resolve-role.sh` 按称呼解析
- **roles speech_examples**：12 人各 ≥2 句口吻样例（coherence 校验）
- **呼叫约定**：id / 角色名 / 昵称 / 具体名字均可切换；多命中须消歧（见 master routes）

### Changed

- **resolve-role**：可选项目根 / 自动发现 Growth aliases；返回 `_resolved_via`
- **master**：显式「呼叫/切换」→ resolve-role → 写会话态 → 改语气
- **run-start / coherence / config README**：人格摘要与别名唯一性校验

## [4.22.0] - 2026-07-12

### Added

- **learn**：建议约定（证据→条文→落点；默认 Growth / local；禁止擅自写 `.cursor/`）
- **delivery §11**：可选无障碍清单（键盘 · 焦点 · 语义/label · 对比度提示；可跳过；不强制 axe/MCP）
- **debug**：系统调试循环（复现→假设→隔离→验证→记录）·「用这个/不是那个」· 铁律禁止无复现盲改
- **delivery §10**：可选浏览器走查清单（URL / snapshot / console / network / 轻量 a11y；可声明跳过，不强制 MCP）
- **acceptance 模板**：浏览器走查字段（默认验收 URL · 是否执行）

### Changed

- **delivery / plan**：长清单与阶段细则外置 `skills/*/reference/`（对齐 mcp）；SKILL 为薄索引
- **README**：§10/§11 与 delivery/plan reference 指针
- **dev-conventions 模板**：增加「建议约定」待填表
- **README**：`/learn` 行注明可建议约定
- **review**：结构化清单（范围·正确性·安全/API·可测性·可维护性）·「用这个/不是那个」
- **delivery §10**：轻量 a11y 指向 §11；分工表含 §8–§11
- **delivery.mdc / README**：索引 §11 与 `/review` 场景
- **run / bugfix**：自修≤2 对齐 debug 循环；`⚠️`→`/plan` 交叉指针
- **README**：重复劳动 SOP + 场景速查索引 debug
- **delivery.mdc / README**：分工与可选节索引指向 §10；无新 slash
- **入口消歧（SPRINT-lean-disambiguate）** — ux/ia/delivery · release/ship · security 三件套 · study/learn 各加「用这个 / 不是那个」
- **week / disk / maintain** — 标明工具技能（非 plan/run 主路径）；lite/full 口径见 `config/README`
- **rules-catalog** — 外链 agentic-awesome-skills · awesome-cursor-skills；吸收门禁「只链不拷」

## [4.21.1] - 2026-07-12

### Changed

- **master** — **AskQuestion 约定（SSOT）**：无该工具时正文编号选项（对齐官方 Grok/部分模型限制）
- **plan · scaffold · ux · release · commands/master · core · constitution · agent-discipline · routes · README · building-super-cursor** — AskQuestion 不可用兜底
- **mcp** — Agent 调用序：`GetMcpTools` → `CallMcpTool`；鉴权 `mcp_auth` 指引
- **docs/naming** — 官方 skill 保留名（`onboard` · `review-bugbot` · `review-security`）；`/week` `/disk` `/maintain` slash；**官方工具与模型差异**表

## [4.21.0] - 2026-07-12

### Added

- **verify-super-cursor** — CHANGELOG `## [x.y.z]` **newest_first** 序自检（破例 FAIL）
- **rules/execution/prompt-security.mdc** — Prompt/Agent 安全（拒越权 · 防注入 · 不泄密）
- **rules/execution/oss-first.mdc** — 开源优先选型（宽松授权 → vendor → 自研；授权口径）
- **rules/execution/input-bounds.mdc** — 输入边界与安全默认（clamp · 白名单 · deny-by-default）
- **rules/execution/extensibility.mdc** — 可选扩展宿主（能力白名单 · 槽位隔离 · Manifest）
- **commands** — `/week` · `/disk` · `/maintain` slash 入口

### Changed

- **changelog.mdc** — 登记序自检与 `release.json` `order: newest_first` 对齐
- **security** skill — Prompt/Agent 清单对齐 `prompt-security.mdc`
- **delivery** §2 i18n — 可跳过声明 · `learn/acceptance.md` 指针；**ux** 内容层对齐
- **plan** skill · **workflow.mdc** — plan≥5 规模门禁（>5 todolist 须先写 plan）
- **ship** agent — 打版 SSOT 指向 **release** §打版；**error-context** glob 收窄（告别 `**/*`）
- **submodule** — vendor 溯源（LICENSE · ORIGIN.md）与 oss-first 配套
- **scope · vibe · security-sdlc · api** — 对齐开源优先 / 输入边界
- **async-progress** — 持久化重试队列（outbox）护栏
- **long-running-ui** — 可取消 · 可重试 · 速率反馈
- **docs** — ROADMAP / archive / CHANGELOG 职责分工
- **delivery** rule — 索引 §8 长任务 · §9 导入
- **api / security / delivery / plan / release / master** skills — 清单与 deps 路由对齐新二级规范
- **core · AGENTS · .cursor/README · rules-catalog · migration-catalog · verify-super-cursor** — 门面与验收登记 **46 rules**
- **根 README** — rules 树摘要含 oss-first / input-bounds / extensibility

## [4.20.0] - 2026-07-09

### Added

- **rules/execution/data-batch.mdc** — 数据访问批处理护栏（IN 分块 · 列表参数上限 · 多阶段范围一致）
- **skills/mcp** — 扩写建服四阶段 + `reference/`（best-practices · TS/Python 骨架；去旧 `@master` 路由）

### Changed

- **README** · **.cursor/README** · **rules-catalog** · **training/skills** — 门面同步 data-batch 与 mcp reference
- **docs/plan-run · walkthrough** — plan 工作副本改为 `workflow.json` → `plan_file`（Growth），去掉「根目录 plan」误导
- **verify.mdc / test skill** — L0–L3 真源收敛到 verify.mdc；test 只引用
- **modal-layering** — 叠层编号 L1–L3 → Z1–Z3，避免与验收层混淆；示例去项目化命名
- **.cursor/README · training/skills · migration-catalog** — 路由详表指向 `routes.md`；计数 22 skills / 42 rules

## [4.19.0] - 2026-07-01

### Added

- **rules/execution/** — 5 条通用 SOP：`async-progress` · `long-running-ui` · `modal-layering` · `error-context` · `single-detector`（长任务/弹窗/重复 patch 防回归）
- **templates/spike-regression-cluster.md** — 同症状簇 ≥2 patch 时的 SPIKE 模板
- **workflow.json** — `followup_gate`（软闸门 · 症状簇规则列表 · `require_spike_after_patches`）
- **delivery** skill §8 — 长任务闭环走查（上传/导入/向导）
- **learn** skill — CHANGELOG 重复模式审计流程
- **plan** skill — Follow-up 立项闸门（禁止第三个 symptomatic patch）
- **refactor** skill — 死代码删除协议

### Changed

- **bugfix** · **vibe** · **changelog** · **release** · **core** · **AGENTS** · **verify-super-cursor** — 对齐 follow-up 闸门与 5 条 execution rules
- **templates/cursorGrowth/learn/changelog-insights.md** — 重复工作模式表 + 建议下一 Sprint
- **.cursor/README.md** — 扩展 skills 列表（disk · maintain · week）

### Fixed

- **hooks/lib/config-load.sh** · **json-utils.sh** — 修正 `platform.sh` 引用路径（`../lib` → `../../lib`）

## [4.18.1] - 2026-06-23

### Added

- **README** — **兼容 Roo Code** 章节：`.cursor/` 整体可复制到 `.roo/`，共享 `.cursorGrowth/`，双方都用开放 skills/rules 协议
- **commands/plan.md** — 补回 verify 注册的 `/plan` command 占位（与 `plan` skill 配套）

### Fixed

- **.gitignore** — `plan.md` · `learn/` 加 `/` 锚定，避免误忽略 `.cursor/commands/plan.md` 等 command 文件

## [4.18.0] - 2026-06-23

### Added

- **commands** — 9 个 slash 入口：`run` · `plan` · `master` · `scaffold` · `learn` · `release` · `delivery` · `ux` · `ia`；description 标注 **【日常】/【生命周期】/【高级】**
- **release** skill — 吸收原 **finish**（§分支 4 选 1 + §打版）；`/release` command
- **bootstrap-growth.sh** — 母版 dev 补全 `.cursorGrowth/rules/local`；`template-verify` 验收前自动调用

### Changed

- **master** · **run** · **plan** · **routes** — slash 三层 UX；`/run` 为默认做事入口；master 勿滥用
- **plan** · **run** · **git** · **delivery** · **walkthrough** · **collaboration** · rules — `finish` → **release** 全链对齐
- **rules/local** — 安装后 symlink → `.cursorGrowth/rules/local/`（删除母版内静态 README）
- **cursor-coherence.sh** — 校验 `rules/local` symlink 可解析
- **runner-smoke.sh** — 与 plan 模板默认空 ACTIVE 对齐（smoke fixture）
- **review** skill · **naming.md** — 与全局 `skills-cursor/review`（Bugbot/Security）区分
- **docs** — naming · quickstart · plan-run · training · migration-catalog · building-super-cursor · README 门面同步
- **verify-super-cursor.sh** — 注册 learn/scaffold commands · bootstrap-growth
- **week** skill — `collect-week.py` 兼容 CHANGELOG 版本节分隔符 `-` / `–` / `—`；新增 `verify_collect_week.sh` fixture 验收

### Removed

- **finish** skill — 合并进 **release**（`/finish` → `/release`）

## [4.17.1] - 2026-06-15

### Added

- **install-super-cursor.sh `--replace`** — 安装前删除目标 `.cursor/`，避免 rsync 残留旧版文件

## [4.17.0] - 2026-06-15

### Added

- **runner.sh `release-tag`** — semver bump + annotated tag；`bump_version` 支持 patch/minor/major 闸门
- **release.json** 扩展 — `tag_per_commit` · `bump` · `version_source`
- **templates/workflow.tag-per-commit.json** — 高频交付项目可选 `tag-per-commit` 模式

### Changed

- **release** · **run** · **git** skills · **ship** agent — 双发版模式文档（`patch-per-task` 默认 · `tag-per-commit` 可选）
- **commit** · **release** · **changelog** · **tag** rules — 对齐 `release-tag` CLI
- **config/README.md** — 新 release 键与 `release.mode` 说明
- **runner-smoke** · **install-smoke** — 覆盖 `release-tag`

## [4.16.0] - 2026-06-15

### Added

- **maintain** skill — `/maintain` Linux 开发环境诊断与安全清理；`dev-maintain.sh` · `load-config.py` · 可配置受保护目录
- **templates/cursorGrowth/maintain-config.example.json** — 本机覆盖模板

### Changed

- **disk** skill — 与 maintain 分工说明；快照目录统一 `.cursorGrowth/disk-snapshots/`
- **master** routes · **AGENTS.md** · **docs/training/skills.md** · **README** — 注册 maintain（23 skills）

## [4.15.0] - 2026-06-15

### Added

- **week** skill — `/week` 跨仓 CHANGELOG 周报；`collect-week.py` 采集 · 写入 `.cursorGrowth/week-report/`
- **disk** skill — `/disk` 磁盘快照与历史 diff；`collect-disk.py` · `config/default-paths.json` · `templates/cursorGrowth/disk-paths.example.json`

### Changed

- **master** routes · **AGENTS.md** · **docs/training/skills.md** · **README** — 注册 week · disk（22 skills）
- **templates/cursorGrowth/README.md** — 说明 `week-report/` · `disk-snapshots/` · 可选 `disk-paths.json`

## [4.14.0] - 2026-06-12

### Added

- **templates/cursorGrowth/learn/** — `plan-conventions.md` 等 7 个种子文件；项目特化**不再写进 rules/skills 正文**
- **templates/cursorGrowth/rules/local/** — 团队 rules canonical 路径；安装后链 `.cursor/rules/local`
- **install-super-cursor.sh** · **growth-init.sh** — 自动引导 `.cursorGrowth/`（plan · archive · learn · rules）

### Changed

- **Breaking（路径）** — `plan.md` · `archive/` · `rules/local` 统一迁入 **`.cursorGrowth/`**；`workflow.json` `plan_file` → `.cursorGrowth/plan.md`
- **plan** · **run** · **core** · **commit** · **changelog** — 对齐新路径；遗留根 `plan.md` 自动迁移
- **scaffold** `.gitignore` — 仅 `.cursorGrowth/`（移除独立 `plan.md` 行）
- **learn** skill — Sprint 收尾建议 `/learn`；团队约定读 `learn/plan-conventions.md`

## [4.13.0] - 2026-06-12

### Added

- **ux** skill · **ia** skill — UX 体验分流与信息架构（IA ⊂ UX · Garrett 结构层）；`rules/execution/ux.mdc` · `ia.mdc`（R1–R4 · C1–C4 · 反模式）
- **commands/** — `/ux` · `/ia` · `/delivery` slash 入口（此前 delivery 仅有 skill）

### Changed

- **delivery** skill · **delivery.mdc** — §5 **导航与 IA** 验收清单；与 ia/ux 分工（规划 vs 抽检）
- **master** · **core** · **AGENTS** · **walkthrough** · **plan-run** · **rules-catalog** · **training/skills** — 注册 ux/ia 路由
- **verify-super-cursor.sh** — check ux/ia rules · skills · commands
- **migration-catalog** — 完整性边界 20 skills · 32 rules

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
