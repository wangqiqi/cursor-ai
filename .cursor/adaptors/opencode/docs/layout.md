# OpenCode `.opencode/` 布局（Super Cursor · `includes: core`）

> ⚠️ **本布局为 Super Cursor 自创假设，与官方机制方向性错位**，见下方「官方对照」。

## 官方对照（2026-11 核实）

| 项 | 官方 OpenCode | 本 adaptor 现状 |
|----|------|------|
| 项目规则 | 项目根 `AGENTS.md`（`/init` 生成或手写） | `.opencode/AGENTS.md` ✗ |
| 全局规则 | `~/.config/opencode/AGENTS.md` | 未覆盖 ✗ |
| 配置 | `opencode.json`（`instructions` 数组可引用 `.cursor/rules/*.md` 或远程 URL） | 无 ✗ |
| 兼容回退 | `CLAUDE.md`（Claude Code 约定） | 无 ✗ |

结论：OpenCode **没有 `.opencode/` 目录约定**，规则走 `AGENTS.md` + `opencode.json`。当前 `install-adaptor-opencode.sh` 平铺到 `.opencode/` 不会被 OpenCode 读取。重做方向见 `## Next sprint`。

## 目标路径

| 项 | 值 |
|----|-----|
| 安装根 | **`.opencode/`** |
| Growth | **`.growing/`**（共享） |
| hooks | **无**（`hooks_manifest`: null） |

## 目录树（安装后）

与 [dsh layout](../../dsh/docs/layout.md) 同构（将 `.dsh` 换为 `.opencode`）：

```text
.opencode/
├── README.md
├── AGENTS.md
├── skills/
├── rules/
├── bin/
├── config/
├── templates/
├── docs/
├── agents/
└── lib/
```

**刻意不含**：`harness/` · `adaptors/` · cursor-only 切片。母版聚合校验脚本 `verify-super-cursor.sh` / `verify-system.sh` 随 core 树一并复制，但非 adaptor 验收范围。

## `core` 包映射

| 源（母版） | 目标 |
|------------|------|
| `.cursor/harness/core/*` | `.opencode/*` |
| 排除 `harness/core/rules/local` | — |
| `.cursor/adaptors/opencode/README.md` | `.opencode/README.md` |

## 安装

```bash
bash .cursor/harness/core/bin/install-adaptor-opencode.sh /path/to/project
install-super-cursor /path/to/project --adaptor opencode
```

## 验收

`bash .cursor/bin/verify-install-opencode.sh`
