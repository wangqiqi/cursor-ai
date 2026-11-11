# Changelog

All notable changes to Super Cursor are documented here.

## [Unreleased]

## [5.1.2] - 2026-11-11

### Changed

- **opencode 重写（P1）** — 按官方机制重做：`install-adaptor-opencode.sh` 改为生成项目根 `AGENTS.md` + `opencode.json`（`instructions` 引用 `.cursor/rules/*.mdc`），废弃 `.opencode/` 目录平铺；`install_dir` 改为 `null`、`includes` 改为 `core_rules_export`；`verify-install-opencode.sh` 断言产物并验证无 `.opencode/` 目录。
- **dsh 降级（P1）** — DeepSeek Harness 是用户级 harness（`~/.dsh` + `~/.agents`），项目内无法安装：移除 `install-adaptor-dsh.sh` / `verify-install-dsh.sh`、`--adaptor dsh` 入口、install-map 的 dsh 条目；README/layout 改为「用户级配置指引」。

## [5.1.1] - 2026-11-11

### Changed

- **adaptor 诚实标注（P0）** — 联网核实各家官方规范后，将 `opencode` / `dsh` 的 `Status` 从「implemented」改为「misaligned」，并新增 layout §官方对照：
  - **opencode** 官方用项目根 `AGENTS.md` + `opencode.json`，无 `.opencode/` 目录 → 当前平铺不会被读取
  - **dsh** 官方配置在用户级 `~/.dsh`（`$DSH_HOME`）+ `~/.agents/`，非项目内目录 → 当前平铺方向性错位
  - `harness-ide-matrix.md` / `adaptor-contract.md` 同步修正「占位 / 待确认」表述，并注明契约校验只查结构、不校验官方符合度

## [5.1.0] - 2026-11-11

### Added

- **workbuddy adaptor** — `install-adaptor-workbuddy.sh` · `install-super-cursor.sh --adaptor workbuddy`：Harness Core 安装到 `.workbuddy/`（`includes: core`，无 hooks）；配套 `verify-install-workbuddy.sh` 冒烟校验 · `adaptors/workbuddy/`（README + layout）

### Changed

- **adaptor 文档** — 五 adaptor（dsh/kiro/trae/opencode/zcode）「占位」表述改为「已实现」，并补齐 zcode/workbuddy 遗漏（`harness/README.md` · `core/README.md` · `config/README.md` · `migration-catalog.md`）；`verify-adaptor-contract.sh` 的 `PLACEHOLDERS` 命名改为 `ADAPTORS`
- **link-cursor-ide.sh** — 复制回退改用 `cp -R src/. dst/` 消除 Windows 下 `bin/bin` 嵌套 bug
- **layout 文档** — dsh/opencode/workbuddy 修正「刻意不含 verify-super-cursor.sh」的不准确描述（实际随 core 复制）

### Fixed

- **死链** — `core/README.md` · `skills/master/routes.md` 的 `plan-run.md` 链接指向真实位置 `adaptors/cursor/docs/`；`.cursor-plugin/README.md` 的 `verify-cursor-plugin-*` 路径修正
- **README 安装选项** — 选项表对齐 `install-super-cursor.sh` 真实取值（`--profile full|lite|rules-only` · `--skills-bundle full|core` · `--adaptor ...` · `--copy-plan` · `--replace`），删除不存在的 `--no-growth`/`--dry-run`

### Hygiene

- **verify.yml** — CI `paths` 增加 `.cursor/harness/**` · `.cursor/adaptors/**` · `.gitattributes` 等，堵住改 SSOT 绕过验收的漏洞
- **CHANGELOG** — 5.0.0 及更早历史归档至 `CHANGELOG.archive.md`（主文件 1374 → 112 行）
- **`.cursorignore`** — Java 段去重 `build/`/`out/`；**`.cursor-plugin/README.md`** 加「禁止手改」警告

## [5.0.8] - 2026-11-01

### Added

- **offline-pack** — `pack-offline-dist.sh` · `install-super-cursor.sh --pack-offline`（消费端 tar + USAGE.md/html → `.growing/offline-dist/`；rsync 保留 symlink · prune 母版 verify/CI · 锚定 exclude 防误删 `skills/learn`）
- **install** — `--adaptor zcode` 聚合安装 `.zcode/`（与既有 `install-adaptor-zcode.sh` 对齐）

### Changed

- **README** · **README.en.md** — 门面精简、价值主张与冷启动结构；保留 verify-doc / coherence 门面字符串
- **gitignore** — 显式忽略 legacy `.cursorGrowth/`（Growth SSOT 为 `.growing/`）

## [5.0.7] - 2026-10-26

### Changed

- **adaptor-layout（SPRINT-ADAPTOR-LAYOUT）** — 四占位 adaptor `layout.md` / README · `install-map` `hooks_manifest: null` · `verify-adaptor-contract` 断言 layout 链接 · `harness-ide-matrix` · `walkthrough` · `building-super-cursor` · `migration-catalog` IDE adaptor 节 · `sync-cursor-docs` 镜像 `docs/reference/*` 并重写 adaptor 外链（VitePress）

## [5.0.6] - 2026-10-26

### Changed

- **ws-hygiene（SPRINT-WS-HYGIENE）** — `verify-mother-root-bin.sh`（`bin/super-cursor-sync`）· `scaffold-integrity` 断言 `java-gradle` wrapper 可读 · README §全局同步
- **doc-site（SPRINT-DOC-SITE）** — `training/skills` → `migration-catalog` 经 `sync-cursor-docs` 改写；`vitepress-build.sh` dead link 失败即红；`building-super-cursor` 触发表
- **doc-facade（SPRINT-DOC-FACADE）** — README 徽章与 8 stacks · `java-gradle`；§验证对齐 `migration-catalog` + `ci-preflight`；`.cursor/docs` quickstart/training/scaffold；`docs/index.md`；`README.en.md`；`verify-doc-super-cursor` 防版本/7 栈回退

## [5.0.5] - 2026-10-26

### Added

- **growth-meta-ci-dual** — `skills/plan/reference/growth-meta-ci-dual.md`：git SSOT vs `.growing/archive/meta` 双轨 · `sc_growth_archive_available` SKIP/FAIL · verify 脚本索引（`migration-catalog`）
- **adaptor-contract** — `docs/reference/adaptor-contract.md`：占位 adaptor（dsh · kiro · trae · opencode）README 章节与 `install-map.example.json` 映射
- **verify-adaptor-contract** — 机器验收四份 README + install-map；接入 `verify-super-cursor.sh`
- **install-adaptor-dsh** — 将 Harness Core 安装到目标 `.dsh/`；`install-super-cursor.sh --adaptor dsh` · `verify-install-dsh.sh`
- **core-rules-export** — Kiro/Trae `core_rules_export` SSOT · `install-adaptor-rules-export.sh` · `verify-install-rules-export.sh`
- **install-adaptor-opencode** — Harness Core → `.opencode/` · `verify-install-opencode.sh`

### Changed

- **growth-layout** — `meta/` 域行 · 链双轨 SSOT；`verify-growth-layout` 断言双轨文档
- **README** · **building-super-cursor** · **verify.mdc** — 一句指向 growth-meta-ci-dual
- **adaptors** — 四份占位 README 对齐契约 v1（`adaptor-contract:v1` 标记）
- **harness** — `README.md` · `harness-ide-matrix.md` 链到契约；`migration-catalog` · `verify.mdc` 索引更新
- **adaptors/dsh** — `docs/layout.md` · README **implemented（core install）**；`config/README.md` adaptor 安装表
- **platform** — `sc_apply_skills_bundle` 支持第三参数 pack 根（`.dsh` · `.opencode`）
- **adaptors/kiro · trae** — rules 导出至 `.kiro/` / `.trae/`；`install-super-cursor --adaptor kiro|trae`
- **adaptors/opencode** — core 安装至 `.opencode/`；`--adaptor opencode`

### 主题（adaptor · meta 双轨）

- **SPRINT-ADAPTOR-CONTRACT** · **SPRINT-SPIKE-CI-DUAL** · **SPRINT-ADAPTOR-DSH** · **SPRINT-ADAPTOR-KIRO-TRAE** · **SPRINT-ADAPTOR-OPENCODE**

## [5.0.4] - 2026-10-26

### Added

- **verify-skill-bundles-ssot** — `skill-bundles.json` 与母版 `skills/` 计数 · `tools_skills` ↔ `core.exclude_skills`；接入 `verify-super-cursor.sh`
- **plan** — `reference/task-retention.md`：禁止随意删除 `plan.md` 未完成任务与 `docs/ROADMAP.md` 进行中/计划行；已完项可归档或清理
- **ci-preflight.sh** — push 前本地跑齐三矩阵腿 + VitePress；`install-smoke` 增加 Windows 门面实体化后重装回归
- **install-smoke** — 门面重装验收：symlink 或 Windows 等价实体（与 `rules/local` 一致），避免 `-L` 误杀 Git Bash

### Changed

- **install 矩阵** — `config/README.md` §skill-bundles · 根 README profile×bundle×plugin 表；`verify-install-skills-bundle` 期望数来自 SSOT（`SPRINT-BUNDLE-GEN`）
- **文档 / harness** — README · AGENTS · harness core 文档与 `verify.mdc` 统一 **symlink** 叙事（`link-cursor-ide.sh`）；门禁与 `install-super-cursor.sh` 帮助文案不再推荐平铺 assemble（`SPRINT-HARNESS-DOC` · TASK-001–004）
- **跨平台健壮性** — `sc_find_packaged_rules_mdc`（packaged rules SSOT，排除 `rules/local`）；`cursor-coherence` 用 `mktemp` 替代 process substitution（Windows Git Bash）
- **verify-portability** — 禁止 `mapfile`；`cursor-coherence` 禁止 `< <(`；SSOT 回归自检
- **文档** — `platforms.md` 补充 mapfile / coherence / packaged rules 表；`verify.mdc` CI 矩阵与三平台阻塞一致

### 主题（SPRINT-CI-ROBUST）

- **CI** — Super Cursor Verify 三平台 success（`b2a6d6a` / run `40266427099`）；push 前 `ci-preflight.sh` 对齐 Actions 矩阵
- **install / harness** — 分区拷贝 · Windows 门面实体化冒烟 · packaged rules SSOT · 跨平台 portability 门禁
- **任务** — TASK-001 … TASK-008

### Fixed

- **Windows Git Bash** — `runner.sh` · `scaffold.sh` · `scaffold-integrity.sh` 去掉 `< <(`，改用 mktemp 重定向（`SPRINT-SHELL-HARDEN`）
- **CI / VitePress** — `sync-cursor-docs` 从 `adaptors/cursor/docs` 镜像 `cursor-cloud` · `plan-run`；`effective-collaboration` 站内链改为 `plan-run.md`
- **CI / Windows** — `verify-doc` pack 根回退；`sc_copy_cursor_pack` 跳过 `core/rules/local`；`rsync -aL` / `cp -L` 避免 install 拷贝 symlink 失败；`runner-smoke` 用 `sc_stage_cursor_pack`（`link-cursor-ide` 不污染 stdout）
- **install** — `rules/local` 相对路径按 `.cursor/rules` 是否为 symlink 分支（`harness/core/rules` 锚点用 4 层 `..`）；`link-cursor-ide` 重装可恢复目录副本；`bootstrap-growth` 修复错误链

## [5.0.3] - 2026-10-26

### Changed

- **Harness 布局（母版）** — SSOT 在 `.cursor/harness/core` + `.cursor/adaptors`；根下协议路径为 **相对 symlink**（`link-cursor-ide.sh`），整包 `.cursor/` 可拷贝；install 复制分区树后补链；消费方 `verify-super-cursor` · plugin 冒烟适配分区路径
- **文档与脚本** — 根/README.en · harness `docs/` · `migration-catalog` · `verify.mdc` · `master/routes` · CI 路径统一为 `template-verify.sh` + harness 编辑说明

## [5.0.2] - 2026-10-26

### Changed

- **`.growing` 卫生** — 历史 CHANGELOG 条目 `growing/README` 命名对齐；`verify-doc-super-cursor` 防旧运行时目录名 SSOT 回退（白名单：`install` 迁移 · v5 Breaking 说明）
- **SPIKE-HARNESS-IDE** — Harness Core 清点摘要 · `config/install-map.example.json` · IDE 对照摘要 · `walkthrough`「Harness Core」节（完整 SPIKE 表在本地 `.growing/archive/meta/`）；决策：`harness/core/` + `adaptors/*`

## [5.0.1] - 2026-10-26

### Fixed

- **cursor-coherence** — `alwaysApply` / verify 注册 / description 门禁跳过 `rules/local/**`（消费方示例 `.mdc` 不再误报）


---

更早的历史版本（5.0.0 及之前）已归档至 [CHANGELOG.archive.md](CHANGELOG.archive.md)。
