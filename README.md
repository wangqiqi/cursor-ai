# Super Cursor

[![Version](https://img.shields.io/badge/version-5.1.15-blue.svg)](CHANGELOG.md)
[![Scaffolds](https://img.shields.io/badge/scaffolds-8%20stacks-green.svg)](.cursor/templates/scaffold/manifest.json)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

> **把 Cursor Agent 从「聊完就散」变成「先规划、可验收、能连跑」的团队级工作流。**

安装一套 `.cursor/` SOP 到你的仓库；Sprint 计划、归档与学习笔记落在 `.growing/`（见 `config/workflow.json`），母版模板与项目产出分离，升级模板不必丢本地 plan。

**English:** [README.en.md](README.en.md) · [Quick start (EN)](.cursor/docs/quickstart.en.md)

> **Windows 用户注意**：本仓 `.cursor/` 顶层是**门面指针**（非 `harness/` 实体）。**Verify** 走 `harness/core/bin` 或 `template-verify` 即可。**IDE 读 rules**：重克隆 + 开发人员模式（推荐），或 `bash .cursor/harness/core/bin/prepare-mother-ide-local.sh`（含 skip-worktree；**Trae 仍可能显示上万变更，勿全选提交**）。消费方用 `install-super-cursor.sh --replace`。详见 [platforms.md](.cursor/docs/platforms.md)。

---

## 适合谁

| 你现在的痛点 | Super Cursor 怎么帮 |
|--------------|---------------------|
| Agent 直接改代码、范围漂移 | **`/plan`** 冻结 Goal · **`gate-check`** 未批准不写业务 |
| 「好了」但测不过 | 每任务 **`task-verify`**，Sprint 前 **`verify`**（fail-closed） |
| 长需求要反复催 | **`/run`** + 自治链：一次批准，连跑多个 TASK，只在决策点停 |
| 规则写进模板、难升级 | 项目特化进 **`.growing/`**；安装后 **`.cursor/` 只读** |

---

## 三条指令走天下

```text
/master  →  迷路？先路由
/plan    →  拆 Sprint，等人点头
/run     →  开跑；AUTONOMOUS 时同一轮连完 ACTIVE 链
```

| 场景 | 命令 |
|------|------|
| 安装到目标项目 | `bash install-super-cursor.sh /path/to/project` |
| 本仓认知 / 改 SOP | **`/learn`** |
| 发版 | **`/release`**（无 `/ship` slash；**ship** agent 负责自治发版） |

口诀：**一次 plan 批准 · 一次 run 开跑 · 决策才停 · verify 才勾 ✅**

Slash 与 skill 详表 → `.cursor/skills/master/routes.md`（根 README 不重复整表）。

```mermaid
flowchart LR
  A["/master"] --> B["/plan"]
  B --> C["PLAN_APPROVED"]
  C --> D["/run"]
  D --> E["task-verify"]
  E --> F["/release"]
```

---

## 安装

**双轨并列**（IDE 均可加载 rules · skills · hooks；详表 → [install-paths.md](.cursor/docs/reference/install-paths.md)）：

| 轨 | 做法 | 适合 |
|----|------|------|
| **CLI** | `bash install-super-cursor.sh /path/to/project --replace --copy-plan` | 团队仓库 · `.growing/` · adaptor · gitignore |
| **复制 / 拖放** | 母版 `bash install-super-cursor.sh --pack-dropin` → 解压或**把整个 `.cursor` 拖进项目根** → Reload Window | 无 Git · 内网分发 · 先试用规则 |

```bash
# CLI
bash install-super-cursor.sh /path/to/your-project --replace --copy-plan
cd /path/to/your-project && bash onekey_start.sh   # growth 生成；母版根不应提交 onekey

# 拖放（母版打一次包，可发给多个项目）
bash install-super-cursor.sh --pack-dropin
# tar -xzf .growing/offline-dist/super-cursor-dropin-*.tar.gz -C /path/to/your-project
bash .cursor/bin/verify-cursor-dropin.sh /path/to/your-project
```

| 选项 | 说明 |
|------|------|
| `--profile full\|lite\|rules-only` | 工作流配置（默认 `full`） |
| `--skills-bundle full\|core` | 技能包裁剪（默认 `full`=28；`core`=23，不含五工具 skill） |
| `--adaptor kiro\|trae\|opencode\|zcode\|workbuddy` | 额外安装 IDE adaptor（可重复传入；见 `adaptors/*/docs/layout.md`） |
| `--copy-plan` | 复制 `templates/plan.md` → `.growing/plan.md` |
| `--replace` | 先删除目标 `.cursor/` 再拷贝（推荐升级/迁移） |
| `--pack-dropin` | 母版：生成 **仅 `.cursor` 拖放包** → `.growing/offline-dist/*.tar.gz` |
| `--pack-offline` | 母版：离线全量包（含 `install-super-cursor.sh`，多次 CLI 安装） |

脚本 / 插件 / npm 三通道见 `install-super-cursor.sh` 与 adaptors 分发逻辑；迁移与边界 → [migration-catalog.md](.cursor/docs/migration-catalog.md)（**刻意不迁移** · **完整性边界**）

| 路径 | 角色 |
|------|------|
| `.cursor/` | 可安装 SOP（rules · skills · hooks · config · templates） |
| `.growing/` | 目标项目 plan · learn · archive · rules/local（git 忽略） |
| `.cursor/harness/` · adaptors | 运行时壳与 IDE 适配；消费方见 `.cursor/README.md` |

---

## 文档站

```bash
npm install && npm run docs:dev
npm run docs:build
```

`.cursor/docs/` · [library-index.md](.cursor/docs/library-index.md) · Roo / 其它 IDE 专题同目录。

---

## 贡献者 · 验收（母版）

PR 前建议跑通：

```bash
bash .cursor/bin/template-verify.sh    # 全量母版验收
bash .cursor/bin/cursor-coherence.sh   # 门面 README · skills/agents · migration-catalog
bash .cursor/bin/verify-doc-super-cursor.sh
```

含 **`verify-onekey-template`**（母版根不得有 `onekey_start.sh`）、**`verify-spike-mother-hygiene-scope`**（母版 **hygiene** 范围）；索引见 [migration-catalog.md](.cursor/docs/migration-catalog.md)。

`.cursor/skills/` 目录当前 **28 个** skill（磁盘为准；`template-verify` 校验计数）。子 agent：**ship** · **review** · **spike**（`.cursor/agents/`）。

<details>
<summary>Skill 名索引（coherence 维护用）</summary>

api · code-stats-viz · debug · delivery · disk · git · ia · learn · long · maintain · master · mcp · ops-deploy · pencil-design · perf · plan · refactor · release · review · run · scaffold · security · study · test · test-report · user-manual · ux · week

</details>

---

## 致谢

灵感与对照 → [library-index.md](.cursor/docs/library-index.md) 与各 skill `reference/`。
