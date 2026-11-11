# DeepSeek `.dsh/` 布局（Super Cursor · `includes: core`）

> ⚠️ **本布局为 Super Cursor 自创假设，与官方机制方向性错位**，见下方「官方对照」。

## 官方对照（2026-11 核实）

| 项 | 官方 DeepSeek Harness（dsh） | 本 adaptor 现状 |
|----|------|------|
| 配置根 | **用户级** `~/.dsh`（`$DSH_HOME`，含 `profiles/` · `cordis.patch.yml` · `.credentials.yaml`） | 项目内 `.dsh/` ✗ |
| 全局指令 | `~/.agents/AGENTS.md`（`$DSH_AGENTS_HOME`，默认 `~/.agents`） | 未覆盖 ✗ |
| skills | `~/.agents/skills/`（用户级扫描） | 项目内 `.dsh/skills/` ✗ |
| 架构 | everything-is-a-plugin（Cordis）；Developer Preview，允许 breaking changes | core 平铺 ✗ |

结论：dsh 是「用户级 harness」，不是「项目内目录」范式。当前 `install-adaptor-dsh.sh` 平铺到项目 `.dsh/` 不会被官方 dsh 读取。重做方向见 `## Next sprint`。

## 目标路径

| 项 | 值 |
|----|-----|
| 安装根 | 目标项目 **`.dsh/`** |
| Growth | **`.growing/`**（与 Cursor 安装共用，不复制进 `.dsh/`） |
| hooks | **无**（`hooks_manifest`: null） |

## 目录树（安装后）

```text
.dsh/
├── README.md              # 自 adaptors/dsh/README.md（安装时写入）
├── AGENTS.md
├── skills/
├── rules/                 # 不含 rules/local（消费方用 .growing/rules/local）
├── bin/
├── config/
├── templates/
├── docs/
├── agents/
├── lib/
└── hooks.json             # 不存在（core 包无 Cursor 生命周期 hooks）
```

**刻意不含**：`harness/` · `adaptors/` · `adaptors/cursor/**` · cursor-only `verify-*.sh`。母版聚合校验脚本 `verify-super-cursor.sh` / `verify-system.sh` 随 core 树一并复制，但非 adaptor 验收范围。

## `core` 包映射

| 源（母版） | 目标 |
|------------|------|
| `.cursor/harness/core/*` | `.dsh/*`（顶层目录与文件） |
| 排除 `harness/core/rules/local` | — |
| `.cursor/adaptors/dsh/README.md` | `.dsh/README.md` |

拷贝使用 `sc_copy_tree`（`rsync -aL` / `cp -aL`），与 `install-super-cursor.sh` 同可移植策略。

## 与 `.cursor/` 共存

同一仓库可同时存在 `.cursor/`（Cursor）与 `.dsh/`（DeepSeek）。二者 **不** 自动同步；升级各自重装对应入口。

## 安装命令

```bash
# 仅 .dsh（Harness Core）
bash .cursor/harness/core/bin/install-adaptor-dsh.sh /path/to/project

# 与 Cursor 一并安装
install-super-cursor /path/to/project --adaptor dsh
```

选项：`--dry-run` · `--skills-bundle full|core` · `--profile full|lite|rules-only`（合并 `config/profiles/*.json` → `.dsh/config/workflow.json`）。

## 验收

`bash .cursor/bin/verify-install-dsh.sh`
