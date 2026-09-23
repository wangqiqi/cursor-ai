# Changelog

All notable changes to Super Cursor are documented here.

## [Unreleased]
### Added

- **脚手架 `_shared/` 共享层（E3）** — `templates/scaffold/_shared/scripts/` 提供项目脚本骨架：`README.md`（分层矩阵 SSOT）· `lib/_common.sh`（`sc_root`/`sc_step`/`sc_ok`/`sc_fail`/`sc_require_cmd`/`sc_summary`）· `lib/_frontend.sh`（`sc_frontend_verify`）· `verify/{domain,tier}` + `ops` + `dev` 占位。`scaffold.sh apply` 改为**先铺共享层再铺栈文件**（栈可覆盖）→ 新项目从第一天就是分层结构；7 栈 `test.sh`/`verify.sh` 的前导统一为 source 公因子
- **`bin/verify-scripts-layout.sh`（E4）** — 脚本分层与**重复块检测**门禁：≥4 行连续相同 → 要求提取到 `lib/_*.sh`；另查 `scripts/README.md` 矩阵 · 根脚本体量/数量 · shebang。有 `scripts/` 时按**项目模式**，母版无 `scripts/` 时按**模板模式**查 scaffold（因此自身也被 CI 覆盖）。该门禁首次运行即抓出前端三栈重复的 4 行验收逻辑 → 已提取为 `sc_frontend_verify`
- **archive 域分层骨架 + 门禁（F1/F2）** — `templates/cursorGrowth/archive/{sprint,spike,release,doc,ops}/` 骨架 + `archive/README.md` 域表；新增 `runner.sh archive-check`（根目录 flat 文件数 > `workflow.json` → `growth.archive_flat_max`（默认 5）即 FAIL，并列出应归入的域），已聚合进 `verify-growth-layout.sh`；`run` §Sprint 收尾 增一步。**本仓自己的 archive 同步分层**：23 个 flat 文件 → `sprint/`(12) · `doc/`(7) · `ops/`(5)，根目录 flat 归零
- **域表 + docs 编号约定（F3）** — `templates/cursorGrowth/learn/plan-conventions.md` 成为**项目侧唯一登记表**（archive/scripts/docs 三处共用）：域表 · 归档命名与门禁 · **docs `NN_中文功能.md` 硬上限 10** · 序号纪律（不重用/留空/追加）· `ROADMAP.md` **例外不加序号** · 预留 **`07_用户手册.md`（`/manual` 自动生成）** 与 **`08_测试报告.md`（`/report` 自动生成）** + 生成标记 `<!-- generated: … · regenerate: … -->` · docs ↔ Growth 边界判定
- **测试框架选型（优先成熟开源）（G1–G4）** — `rules/execution/testing.mdc` 新增**§框架选型**表：TS/JS **Vitest** · React/Next/Vue/Svelte **Vitest + Testing Library** · E2E **Playwright** · Python **pytest**（+hypothesis 按需）· Go **go test** · Rust **cargo test** · C/C++ **CTest + Catch2/GoogleTest** · Java **JUnit 5** · BDD **Cucumber**；并给出"何时不引入"。纪律：优先宽松许可的活跃开源 · **一套到底**不混两套 runner · 跟随既有 lockfile 不迁移。`javascript`/`typescript`/`react`/`nextjs`/`svelte` 五条 tech rule 补默认框架指向（此前只有 react/java/python/go/rust/c/cpp/vue 写了）；`oss-first.mdc` 增「测试框架选型」段。`manifest.json` 7 栈新增 `test_framework` 声明，`scaffold-integrity.sh` **校验脚本/依赖里确实调用了它**（`platform.sh` 另加 `sc_manifest_scaffold_field_join` 以正确解析数组字段）
- **项目文档体系（D · 瀑布式号位）** — `config/docs-layout.json` + `rules/execution/project-docs.mdc` + `templates/project-docs/`（10 号位骨架 + `ROADMAP.md` + 名称映射索引）+ `bin/verify-docs-layout.sh`：
  - **号位 = 瀑布阶段（不可变）**：`01` 需求 · `02` 架构 · `03` 数据/契约 · `04` 接口/算法 · `05` 详细设计 · `06` 工程规范 · `07` 使用⚙ · `08` 测试⚙ · `09` 发布 · `10` 调优；**名称按 profile 替换**，跨项目号位可对齐
  - **必选号位** `01` `02` `06` `08` `10` + **`ROADMAP.md`（例外·不加序号）**；带序号文档 **硬上限 10**
  - **5 个 profile**：`web-fullstack` · `api-service` · `frontend-app` · `library`（纯算法库/动态库：`03` 放 ABI 契约，**不写数据库设计**）· `cli-tool`
  - **序号纪律**：号不重用（删除留空号）· 新增追加 · 细则放**同号子目录**（不计入上限）· `docs/` 根只允许 `NN_*.md` + `allow_unnumbered`
  - **两份自动生成**（禁止手写）：`07` ← `/manual` · `08` ← `/report`，文件头须带 `<!-- generated: … · regenerate: … -->`；两份 contract 的 `doc_path` 已对齐到 `docs/07_用户手册.md` / `docs/08_测试报告.md`（配图落同号子目录）
  - **生态约定名不进编号**：`README` · `CHANGELOG` · `LICENSE` · `CONTRIBUTING` · `SECURITY`（GitHub/npm/crates 惯例）；安全威胁模型并入 `02`、性能基准并入 `08`/`10`，不额外占号
  - **渐进启用**：`docs/` 尚无编号文档时不 FAIL 只提示，并改验 `templates/project-docs` 骨架（母版与 CI 因此也被覆盖）；一旦有第 1 份编号文档，全部断言生效
  - 与 **SDD** 衔接：`01` ← `sdd/spec-template` · `02` ← `tech-plan-template` · `05` ← `tasks-template`，不另写一套
- **`verify-config.sh` 支持 `_comment` 注释键**（schema 与 config 均可带说明）
- **`runner.sh docs-init`（D 后续）** — 按 profile 一键铺 `docs/` 号位骨架，把"文档体系"从规则变成可执行：
  - 默认只铺**必选号位**（`01_需求规格` `02_架构设计` `06_开发规范` `08_测试报告` `10_调试调优`）+ `ROADMAP.md` + 自动生成的 `docs/README.md` 索引（避免一上来就 10 个空壳）
  - `--profile <p>` 覆盖并**写回** `config/docs-layout.json`；`--slots 03,04` 追加条件号位；`--all` 全 10 个；`--force` 覆盖；`--dry-run` 预演
  - **幂等**：已存在默认 skip，不破坏已有内容；未知 profile 报错退出 3
  - 名称按 profile 替换：`library` → `03_ABI契约` `04_算法设计` `05_性能与基准` `07_集成指南` `09_发布与版本兼容`（纯库不写数据库设计）
- **`platform.sh` docs-layout 助手（双路径）** — `sc_docs_get` · `sc_docs_plan` · `sc_docs_set_profile`，jq 快路径 + python 回退，输出经测试逐字节一致；未知 profile 退出码归一为 3
- **`consumer-smoke.sh` 增 docs 端到端腿** — install → `docs-init` → `verify-docs-layout` 必须绿，关闭"骨架存在但从没被真实消费"的盲区；消费方验证器列表补 `verify-docs-layout` · `verify-scripts-layout`
- **`/learn` 增 docs bootstrap** — 首次学习时据仓库证据建议 profile（web 全栈 / API / 前端 / library / CLI）并 `docs-init` 铺骨架

- **CHANGELOG 结构门禁 `bin/verify-changelog.sh`（第 11 道）** — 本次 Sprint 的 follow-up 以 per-commit 方式追加，导致 `[Unreleased]` 出现 **5×`### Added` / 2×`### Fixed` / 2×`### Changed`** 且顺序错乱（Added→Fixed→Changed→Fixed→Changed），违反 `changelog.mdc` 的"同版本不得双节"却**无任何门禁**。现新增门禁：必须存在 `[Unreleased]` · **同一版本节点内 `### X` 不得重复** · `[Unreleased]` 小节顺序固定 Added → Changed → Fixed（**已发布节点不重排**，避免无意义 diff）；CHANGELOG 不存在时**渐进跳过**（目标项目不会误报）。`[Unreleased]` 已合并为 3 个小节、19 条一条不少（主条目与续行数与合并前逐项一致，集合哈希相同）
### Changed

- **验证器公因子（E1/E2）** — 8 个 `verify-*.sh` 此前各写一套 `FAIL=0 / fail() / ok() / python 解析 / 汇总退出`，风格还不统一（4 个有 `fail()/ok()`，4 个没有）。新增 [`lib/verify-common.sh`](.cursor/lib/verify-common.sh)：`vc_title/vc_ok/vc_fail/vc_info/vc_skip/vc_py/vc_summary` + `sc_python` 统一解析，`vc_py` 保证在 `set -e` 下不中断。7 个子验证器 + 聚合器全部改经该骨架，**行为零变化**（逐脚本 `OK/FAIL/exit` 与重构前基线逐项一致：config 1 · doc 7 · growth-layout 10 · portability 1 · roo 1 · rules-globs 18 · secrets 1 · 聚合 202）。新增一门禁的成本从 ~90 行降到 ~20 行
- **文档同步（v4.29.8 后）** — 把本次 Sprint 新增的 8 道门禁与 4 处行为变更写进相应 SSOT：
  - `rules/feedback/verify.mdc`：新增 §task-verify 语义（fail-closed / `manual:` 豁免）、**§母版门禁清单**（8 道 · 各自守护什么 · 通用 vs 母版）、接线自检规则、跨平台与 CI 段
  - `rules/workflow.mdc` · `skills/run/SKILL.md`：任务闸门补 fail-closed 与 `manual:` 说明
  - `rules/execution/doc-hygiene.mdc` §门面计数：新增 config 键/文件、新增 `bin/verify-*.sh`、改 `bin/` 目录、新增对外文档四行同步义务
  - `config/README.md`：新增「本目录文件」表，说明 `schema.json`（防错键静默回退）与 `denylist.txt`（母版独立扫描）
  - `docs/building-super-cursor.md`：修正过期表述（alwaysApply 由"仅 2 个"改为**实际 4 个**）、补跨平台/配置守护、新增**贡献者门禁清单**（改什么 → 必须绿什么）；layout 模式说明补"已安装目标项目"第三种
  - `.cursor/README.md`：`bin/` 清单由 7/20 补全为分组全量、`config/` 补 `schema.json`·`denylist.txt`、自测命令补 consumer-smoke 与门禁清单链接、路由说明改为「主路由在 master/SKILL.md · routes.md 为扩展索引」
  - 根 `README.md`：§验证补 4 条命令 + 8 道门禁表；`.cursor/docs/quickstart.md` · `platforms.md`：自测补 consumer-smoke 与 `SC_FORCE_PYTHON=1`（含 CI 矩阵说明）；`skills/master/routes.md` 头部标注分层；`docs/training/skills.md` 可选能力补 3 行；`docs/index.md` 增「可守护」卡片 + 英文入口

### Fixed

- **Windows CI 抓到的 3 个真缺陷（跨平台）** — 这些在 Linux/macOS 下**永不出现**（Linux 用 `/`、符号链接把问题藏住），Windows 腿（非阻塞）把它们暴露出来：
  1. **`verify-rules-globs.sh` 路径分隔符泄漏** — `str(path.relative_to(cur))` 在 Windows 返回 `rules\tech\nextjs.mdc`，与 `rules/tech/nextjs.mdc` 字面量比较**全部不中** → 5 条 rule 的 plan 闸门断言 + 12 条栈 fixture 断言误报 FAIL（17 个）。改为 `.as_posix()`，并新增**回归护栏**（rule key 含反斜杠即 FAIL）
  2. **`verify-roo-compat.sh` 把项目私有 rules 当规则扫** — `.cursor/rules/local/` 是安装脚本链接到 gitignore Growth 的**项目私有**目录，按设计含 `README.md`（非规则）。Linux 下它是符号链接、`rglob` 不遍历（**假绿**），Windows 下实体化即 FAIL。现显式跳过 `rules/local/**`；用同一 fixture 对旧脚本复现出**与 CI 完全相同的报错**，新脚本 OK
  3. **裸 `ln -s` 在 `set -e` 下中止安装/自检** — `install-super-cursor.sh` 与 `install-smoke.sh` 的自安装 fixture 都无守卫；Windows/Git Bash 无符号链接权限时**直接中止**（日志表现为"无 FAIL 行、秒退"）。现均加守卫：安装脚本**降级为目录副本**（`mkdir` + README）保证安装成功，smoke 无符号链接权限时显式 `SKIP` 而非静默中止
- **`verify-portability.sh` 增两条静态护栏** — ① `relative_to(`/`os.path.relpath(` 必须同句 `.as_posix()`（防第 1 类复发）② 裸 `ln -s` 必须带 `2>/dev/null`/`||`/`if`（防第 3 类复发）。两者均有负向测试，且对现有守卫点**零误报**
- 展示用路径统一 `.as_posix()`（`verify-doc-super-cursor` · `verify-scripts-layout`），消息里不再混入反斜杠
- **`eol=lf` 行尾策略 + 门禁（Windows 第 4 个隐患）** — 仓库此前**没有 `.gitattributes`**：Git for Windows 默认 `core.autocrlf=true`，克隆会把 `*.sh` 检出为 CRLF，首行成 `#!/usr/bin/env bash\r` → 脚本**秒退且无报错**（与安装/自检"无 FAIL 行直接中止"的症状一致）。现新增仓库根 [`.gitattributes`](.gitattributes)：`* text=auto eol=lf` + 脚本/规则/配置显式 LF，`.bat`/`.cmd`/`.ps1` 反向 CRLF，二进制显式 `binary`；`verify-portability.sh` 断言其存在且真含 `eol=lf`（目标项目豁免）。`platforms.md` 增「Windows 的三个坑」对照表
- **示例去作者项目史（通用性收口 1）** — `growth-layout.md` 的域表示例此前带**真实时间戳与真实 sprint 号**（`20260906_093000` · `SPRINT-83/89/105/120/131` · `SPRINT-VIZ-L1` · `SPRINT-INT-VERIFY-01` · `v0.82.4` · `harness_sdk` · `web_operator_panel`），使用者会误以为模板自带这些编号；现一律改为占位令牌（`<YYYYMMDD>_<HHMMSS>` · `SPRINT-NN` · `<topic>`）。`sprint-goal-gate.md` · `ops-deploy/SKILL.md` · `test-report/contract-schema.md` 的同类具体编号一并占位化。`denylist.txt` 增 7 条规则（数字型时间戳 + 作者 sprint 号族 + 专有 topic 名）**防回填**，负向测试已验证会 FAIL
- **bundle 解析 jq 回退（通用性收口 2）** — `scaffold.sh` 的 `apply-bundle` 与 `scaffold-integrity.sh` 的 bundle 检查此前**直连 `jq`**，绕过 `lib/platform.sh`：无可用 jq 时 `apply-bundle` 直接 `FAIL: unknown bundle`，且 `SC_FORCE_PYTHON=1` 也救不了 → Windows/Git Bash 无 jq 环境不可用，而 CI 的"回退腿"仍走 jq（**表面绿**）。现新增 7 个 `sc_manifest_bundle_*` 助手（与 scaffolds 同策略：jq 快路径 / python 回退），9 处调用点全部改经助手；`template-verify.sh` 的 scaffold smoke 增跑一遍 `SC_FORCE_PYTHON=1`，使回退覆盖**真实**发生

## [4.29.8] - 2026-09-23

- **macOS 阻塞腿失败：bash 3.2 空数组（第 12 个真缺陷）** — `install-super-cursor.sh` 以**零 exclude** 调用 `sc_copy_tree`，而 `sc_copy_tree` 内 `for ex in "${excludes[@]}"` 在 **bash 3.2（macOS 系统 bash）+ `set -u`** 下报 `unbound variable` 直接中止（bash 4.4+ 才算空展开）→ 安装脚本退出非零 → `install-smoke` 因 `set -e` 静默中止（**日志零输出、0.5 秒退出**，无法定位）。现全部改用 `${arr[@]+"${arr[@]}"}`；`verify-portability` 新增静态护栏，**首次运行又抓出脚手架 bundle `verify-layers.sh` 的同类 bug**（会被装进目标项目）并一并修复
- **Windows 阻塞在 python 中文输出（第 13 个真缺陷）** — CI 精确定位到 `verify-docs-layout.sh` python 块第 81 行：Windows Python stdout 默认 **cp1252**，打印中文即 `UnicodeEncodeError` 崩溃。现 `platform.sh` 统一 `export PYTHONIOENCODING=utf-8` + `PYTHONUTF8=1`（对 3.7+ 生效），并给 4 个「用 python 却未 source 平台库」的脚本（`resolve-role` · `run-start` · `dev-maintain` · `verify_collect_week`）补上导出；`verify-portability` 静态断言「python 块必须有 UTF-8 保障」
- **`install-smoke` 失败可见化** — 此前安装失败在 `set -e` 下一行中止，输出还被重定向到临时文件 → 日志只剩 `exit code 1`。现加 `ERR` trap 打印中止行号，并改为 `run_install` 助手：**记录 FAIL + 回显安装输出尾部 + 继续跑完其余断言**（不再一行失败就停）
- **CI 双阻塞腿真因：`$VAR` 紧跟中文字符（multibyte 标识符）** — 上一轮把 `install-smoke` 改成失败可见后，macOS 日志给出确切错误：`line 327: PROFILE\uFFFD: unbound variable`。根因是 `echo "…（profile=$PROFILE）"` 里 `$PROFILE` **紧跟全角右括号 `）`**：bash 3.2（macOS 系统 bash）与 C locale 下的 Git Bash 会把多字节字符的字节**并入变量名**，`set -u` 下即 `unbound variable` 中止 —— 这一个缺陷同时解释 macOS 与 Windows 两条腿（也解释了为何"零输出、秒退"）。全仓 **10 处**（`install-super-cursor.sh` 5 · `runner.sh` 2 · `dev-maintain.sh` 2 · verify-layers bundle 1）改为花括号定界 `${VAR}`；`verify-portability` 新增静态护栏拦截该写法（负向/正向 fixture 均验证），并确认规则与文档的代码块内无同类写法
### Added

- **双语最低集（A5）** — 新增 `README.en.md` 与 `.cursor/docs/quickstart.en.md`（英文入门层：安装 · 三个日常指令 · 目录边界 · 自检 · 进阶表），主 `README.md` 顶部加入口；`quickstart.en.md` 同步进 VitePress 侧栏（`docs/guide/quickstart.en.md`，站点共 13 篇镜像），同步脚本与 `README.en.md` 一并镜像到 GitHub 绝对链接。`verify-doc-super-cursor.sh` 断言英文入口存在且被主 README 链接。**不**翻译 rules/skills 正文（成本高、收益低）
- **三平台 CI matrix（A6）** — `verify.yml` 由单 ubuntu job 扩为 `ubuntu（+jq，含文档构建）· macos（BSD 工具链 / bash 3.2）· windows（Git Bash，先非阻塞）`；`fail-fast: false`，矩阵项未通过不影响其它项
- **`SC_FORCE_PYTHON=1`（可测的 JSON 回退）** — `platform.sh` 新增该开关（`sc_has_json_tool` + 10 处 jq 分支），让「无 jq → python 回退」成为**可显式切换并验证**的路径。此前 CI 只在 ubuntu+jq 上跑，"回退"从未被覆盖（macOS runner 自带 jq，靠"恰好没装"不可行）
- **`bin/verify-secrets.sh`（C4）** — 只扫 **已跟踪** 文件（`git ls-files`）：AWS key · 私钥材料 · GitHub/Slack token · 硬编码凭据赋值 · 被跟踪的 `.env`；示例占位（`example`/`your_`/`xxx`/`<...>`）与 `.env.example` 豁免。`.cursorignore`/`.gitignore` 只防「被读」，这道门禁防「被提交」；已纳入 `verify-super-cursor.sh`
- **`bin/verify-roo-compat.sh`（C3）** — 把 README 的「Roo 兼容 / 协议无关」承诺变成可验证断言：`rules/*.mdc` · `skills/*/SKILL.md` · `agents/*.md` · `commands/*.md` 的 frontmatter 键必须 ⊆ 开放协议白名单（出现编辑器私有键即 FAIL），且 `rules/` 下不得用会被忽略的 `.md`。已纳入 `verify-super-cursor.sh` 与接线自检
- **根 `AGENTS.md`（C6）** — Cursor 官方支持项目根 `AGENTS.md`，此前只有 `.cursor/AGENTS.md`；新增母版根入口（指向 `.cursor/AGENTS.md` + 改仓纪律 + 验收命令），`verify-super-cursor.sh` 断言其存在且指向正确（母版专属，不随 `.cursor/` 复制）
- **`bin/consumer-smoke.sh`（C2）** — 目标项目**端到端**回归，补齐 CI 只验母版自身的盲区：临时 git 项目 → `install --profile full` → 未批准时 `gate-check`/`plan-check` 必须 BLOCK → 3 个 hook 均 exit 0 且 stderr 干净 → 批准后闸门放行且 `run-start` 注入自治上下文 → 5 个 universal 验证器在消费方仓库全绿 → 母版门面项正确 SKIP。已纳入 `template-verify.sh`
- **`config/schema.json` + `bin/verify-config.sh`（C1）** — 声明 6 个 config 文件的允许键与类型；未知键（如把 `release.mode` 误写成 `workflow.release.mode`）与类型错误现在**直接 FAIL**，不再静默回退默认值。已纳入 `verify-super-cursor.sh` 与接线自检
- **摩擦可观测（B5）** — `runner.sh friction-log --task --rounds --rework --verify --note` 追加一行到 `.cursorGrowth/logs/friction.jsonl`（自实现 JSON 转义，不依赖 jq），`friction-report` 聚合 `tasks · verify_pass/fail · avg_rounds · avg_rework`；**run** skill 每任务收尾记一行、**learn** skill 把趋势写进 `dev-conventions.md`。这是"少拉扯"是否真的改善的**唯一**可回归证据
- **首次闭环（B4）** — 安装输出把「首次必做 → `/learn`」提到第 0 步并说明"不做则闸门/验收会空转"；**learn** skill 新增「空模板最小采集」：`learn/` 全为待填时只问 3 个问题（开发/测试命令 · 代码分层与入口 · 发版节奏），其余按需补，**不通读全仓**
- **平台作用域单一真源（A4）** — `docs/platforms.md` 新增「技能平台作用域」表（技能层 ≠ 母版脚本层，不可互相推断）；`verify-portability.sh` 双向断言 **文档声明 ⇔ 代码实际**：含 `require_linux` 的技能必须登记为 Linux-only，登记为 Linux-only 的必须确有 `require_linux`
- **`bin/verify-portability.sh`（A3）** — 发布脚本可移植性静态门禁：GNU-only 构造（`sed -i` 无后缀 · `find -printf` · `stat -c` · `sort -h` · `du --max-depth` · `date -d/-Iseconds` · `grep -P` · `xargs -r` · `tac`）· 非 POSIX `\s` 正则 · `readlink -f` 缺回退 · 硬编码 `python3` · shebang 非 `env bash`；扫描 57 个脚本，已纳入 `verify-super-cursor.sh` 与接线自检（含 `portability-allow` 单行豁免机制）
- **`config/denylist.txt`** — 「母版独立」单一禁用词表（作者/维护者标识 · 机器绝对路径 · 公司代号占位 · 凭据痕迹），由 `verify-super-cursor.sh` 逐行 ERE 扫描 `.cursor/` 全树；名单文件缺失即 FAIL，防止守卫被静默关闭（SPRINT-AGNOSTIC · A1）

### Changed

- **`/master` 路由瘦身（B3）** — 主路由（7 项）与 `more` 子路由（7 项）此前只存在于 288 行的 `master/routes.md`，`/master` 实际 payload = SKILL + routes ≈ **6.5k token**，而 SKILL 内 6 处只写「见 routes.md」却不含选项表。现把两张表内联进 `master/SKILL.md`，`routes.md` 降为**按需二级索引**（关键词索引 · 上下文捷径 · 人格 · DAILY/LIBRARY · 上游对照）→ 默认路由 payload **≈1.0k token**。`verify-doc-super-cursor.sh` 新增断言：SKILL ≤3000 字符且含 7 个主路由 id（防再次把路由挪出默认 payload）
- **`plan-check` 验收列门禁（B2）** — 活跃任务的验收列若为描述性文字（`task-verify` 必 FAIL），`plan-check` 现在当场 WARN 并计入 issues、**退出 1**（开工前就暴露，而非等 `task-verify` 才发现）；判定逻辑抽为共享 `acceptance_kind()`（exec / manual / prose），`task-verify` 与 `plan-check` 单一真源。`runner-smoke` 增 4 条 plan-check 回归
- **`task-verify` fail-closed（B1）** — 描述性验收列此前打印 `SKIP` 却 `return 0`（"防假完成"形同虚设），现改为 **FAIL + 退出 1** 并给出两种修法；唯一合法豁免是显式 `manual: <步骤与证据要求>`。`task_verify_heuristics.enabled` 在 `full` profile 默认开启（`lite`/`rules-only` 关闭），兜底脚本仅在存在时才跑。plan 模板与 `config/README` 补「验收列规则」；`runner-smoke` 增 4 条回归（描述性 FAIL · manual PASS · 可执行 PASS · 可执行失败 FAIL）
- **去重：巨型 SKILL 瘦身 + 事实族收敛（C5）** — `run/SKILL.md` **8806 → 4080 字符（-53%）**，细节移入 `run/reference/{sprint-closeout,doc-sync,audit}.md`；`plan/SKILL.md` **7305 → 4408 字符（-40%）**，`先总后分`/`SDD`/`协作文档`/`Sprint 立项门禁` 四节改为指向既有 `reference/`（`phases.md` · `sdd/` · `doc-prd-enrich.md` · `prioritization.md` · `sprint-goal-gate.md`）。README 的三层 slash 表与 7 栈依赖表收敛为「名字 + 指向唯一真源」。`verify-doc-super-cursor.sh` 断言 run/plan SKILL ≤5000 字符且 `reference/` 必须存在

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
